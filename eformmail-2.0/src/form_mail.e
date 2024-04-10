indexing

	description: "Secure and safe program to email contents of a form to an email address."

	author: "Berend de Boer"
	copyright:   "Copyright (c) 2004, Berend de Boer"
	license:     "Eiffel Forum Freeware License v2 (see forum.txt)"
	date: "$Date: 2007/03/02 $"
	revision: "$Revision: #2 $"


class

	FORM_MAIL


inherit

	EPX_CGI

	EPX_FILE_SYSTEM
		rename
			status as file_status
		export
			{NONE} all
		end

	EPX_MIME_ROUTINES
		export
			{NONE} all
		end

	KL_SHARED_ARGUMENTS
		export
			{NONE} all
		end


creation

	make,
	make_no_rescue


feature -- Output

	execute is
		local
			key: STRING
			fbody: STRING
			sig: STDC_SIGNAL
		do
			create sig.make (SIGTERM)
			sig.set_ignore_action
			sig.apply
			if not invalid_program_name then
				read_main_configuration
				key := value (main_configuration.key_field_name)
				key.left_adjust
				key.right_adjust
				if key.is_empty then
					stderr.put_string ("Key field '" + main_configuration.key_field_name + "' not found or is empty.%N")
					location (main_configuration.error_redirect)
					exit_with_success
				else
					read_key_configuration (key)
					validate_form_fields
					if not is_spam then
						if key_configuration.transform = Void then
							fbody := plain_text_body
						else
							fbody := xml_body
						end
						debug ("eformmail")
							stderr.put_string (fbody)
						end
						send_email (fbody)
					else
						stderr.put_string ("Rejected form submission that looked like spam.%N")
					end
					location (key_configuration.success_redirect)
				end
			else
				error_program_name_incorrect
			end
		end


feature -- Access

	version: STRING is "1.0"


feature {NONE} -- Main configuration file reading

	current_directory_configuration_filename: STRING is
		local
			path: STDC_PATH
		once
			create path.make_from_string (Arguments.program_name)
			path.parse (<<".cgi">>)
			Result := path.directory + "/" + path.basename + ".conf"
		ensure
			filename_not_empty: Result /= Void and then not Result.is_empty
		end

	etc_directory_configuration_filename: STRING is
		local
			path: STDC_PATH
		once
			create path.make_from_string (Arguments.program_name)
			path.parse (<<".cgi">>)
			Result := "/etc/" + path.basename + "/" + path.basename + ".conf"
		ensure
			filename_not_empty: Result /= Void and then not Result.is_empty
		end

	usr_local_etc_directory_configuration_filename: STRING is
		once
			Result := "/usr/local" + etc_directory_configuration_filename
		ensure
			filename_not_empty: Result /= Void and then not Result.is_empty
		end

	main_configuration: MAIN_CONFIGURATION
			-- Main configuration values

	read_main_configuration is
			-- Read the configuration file. File should be in either in
			-- the current directory or in /usr/local/etc or /etc.
		local
			configuration_filename: STRING
		do
			configuration_filename := current_directory_configuration_filename
			if not is_readable (configuration_filename) then
				configuration_filename := usr_local_etc_directory_configuration_filename
				if not is_readable (configuration_filename) then
					configuration_filename := etc_directory_configuration_filename
					if not is_readable (configuration_filename) then
						error_configuration_file_not_found
					end
				end
			end
			create main_configuration.make (configuration_filename)
			if not main_configuration.is_valid then
				error_configuration_file_invalid (main_configuration.diagnostic_message)
			end
		ensure
			main_configuration_read: main_configuration /= Void
			main_configuration_valid: main_configuration.is_valid
		end


feature {NONE} -- Key configuration

	key_configuration: KEY_CONFIGURATION
			-- Key configuration values

	read_key_configuration (a_key: STRING) is
		require
			main_configuration_set: main_configuration /= Void
			key_not_empty: a_key /= Void and then not a_key.is_empty
		local
			path: STDC_PATH
			key_file_name: STRING
		do
			create path.make_from_string (main_configuration.filename)
			path.parse (Void)
			key_file_name := path.directory + "/" + a_key + ".conf"
			if is_readable (key_file_name) then
				create key_configuration.make (key_file_name)
				if not key_configuration.is_valid then
					error_key_configuration_file_invalid (key_configuration.diagnostic_message)
				end
			else
				error_key_configuration_file_not_found (key_file_name)
			end
		end


feature {NONE} -- Body formatting

	formatted_body (a_body: STRING): STRING is
			-- The output as formatted by the specified transformation
			-- program, or `a_body' if no transformation is specified
		local
			formatter: EPX_EXEC_PROCESS
			save_directory: STRING
			dir: STDC_PATH
		do
			if key_configuration.transform = Void then
				Result := a_body
			else
				create dir.make_from_string (key_configuration.filename)
				dir.parse (Void)
				save_directory := current_directory
				change_directory (dir.directory)
				create formatter.make_from_command_line (key_configuration.transform)
				formatter.set_capture_input (True)
				formatter.set_capture_output (True)
				formatter.execute
				-- To fix: we might block here
				formatter.fd_stdin.put_string (a_body)
				formatter.fd_stdin.close
				create Result.make (a_body.count)
				from
					formatter.fd_stdout.read_string (16384)
				until
					formatter.fd_stdout.eof
				loop
					Result.append_string (formatter.fd_stdout.last_string)
					formatter.fd_stdout.read_string (16384)
				end
				formatter.wait_for (True)
				change_directory (save_directory)
				if formatter.exit_code /= EXIT_SUCCESS then
					error_formatting_failed (formatter.exit_code)
				end
			end
		ensure
			formatted_body_not_void: Result /= Void
		end

	plain_text_body: STRING is
			-- Contents of form as plain text
		do
			create Result.make (1024)
			from
				cgi_data.start
			until
				cgi_data.after
			loop
				Result.append_string (cgi_data.item_for_iteration.key)
				Result.append_string (": ")
				Result.append_string (cgi_data.item_for_iteration.value)
				Result.append_string ("%R%N")
				cgi_data.forth
			end
		ensure
			body_not_void: Result /= Void
		end

	is_spam: BOOLEAN is
			-- Test if any of the fields match our black hole regular
			-- expressions.
		do
			from
				cgi_data.start
			until
				Result or else cgi_data.after
			loop
				key_configuration.black_hole_fields.search (cgi_data.item_for_iteration.key)
				if key_configuration.black_hole_fields.found then
					key_configuration.black_hole_fields.found_item.match (cgi_data.item_for_iteration.value)
					Result := key_configuration.black_hole_fields.found_item.has_matched
					key_configuration.black_hole_fields.found_item.wipe_out
				end
				cgi_data.forth
			end
		end

	validate_form_fields is
			-- Make sure the form fields have a valid contents. They
			-- should not contain control characters. Optionally they are
			-- validated against a regexp if one is defined for that
			-- field in the key configuration file. Program exits when an
			-- error occurs.
		do
			from
				cgi_data.start
			until
				cgi_data.after
			loop
				if not has_invalid_control_characters (cgi_data.item_for_iteration.value) then
					-- Clean up value by stripping spaces
					cgi_data.item_for_iteration.value.left_adjust
					cgi_data.item_for_iteration.value.right_adjust
					-- If validated field, see if contents is valid
					key_configuration.validated_fields.search (cgi_data.item_for_iteration.key)
					if key_configuration.validated_fields.found then
						key_configuration.validated_fields.found_item.match (cgi_data.item_for_iteration.value)
						if not key_configuration.validated_fields.found_item.has_matched then
							error_form_field_not_valid (cgi_data.item_for_iteration)
						end
						key_configuration.validated_fields.found_item.wipe_out
					end
				else
					error_invalid_form_data (cgi_data.item_for_iteration.key)
				end
				cgi_data.forth
			end
		end

	xml_body: STRING is
			-- Contents of form as XML, or as formatted by the optional
			-- transform program
		local
			body: EPX_XML_WRITER
		do
			create body.make
			-- Probably should use encoding of form...
			body.add_header_iso_8859_1_encoding
			body.start_tag ("form")
			from
				cgi_data.start
			until
				cgi_data.after
			loop
				body.add_tag (as_valid_tag_name (cgi_data.item_for_iteration.key), cgi_data.item_for_iteration.value)
				cgi_data.forth
			end
			body.stop_tag
			debug ("eformmail")
				stderr.put_string (body.as_string)
			end
			Result := formatted_body (body.as_string)
		ensure
			body_not_void: Result /= Void
		end


feature {NONE} -- Sending email

	send_email (a_body: STRING) is
			-- Send mail using an MTA or through SMTP.
		require
			body_not_void: a_body /= Void
			key_configuration_not_void: key_configuration /= Void
		do
			if main_configuration.smart_host = Void  then
				send_email_using_sendmail (a_body)
			else
				send_email_using_smtp (a_body)
			end
		rescue
			if exceptions.is_developer_exception then
				error_sendmail_failed (exceptions.developer_exception_name)
			else
				error_sendmail_failed ("Exception: " + exceptions.exception.out + "%N")
			end
		end

	send_email_using_sendmail (a_body: STRING) is
			-- Send mail using sendmail or compatible program.
		require
			body_not_void: a_body /= Void
			key_configuration_not_void: key_configuration /= Void
		local
			sendmail: EPX_SENDMAIL
			bcc: EPX_MIME_UNSTRUCTURED_FIELD
			x_mailer: EPX_MIME_UNSTRUCTURED_FIELD
			mime_version: EPX_MIME_FIELD_MIME_VERSION
		do
			if main_configuration.sendmail = Void then
				create sendmail.make
			else
				create sendmail.make_from_command_line (main_configuration.sendmail)
			end
			set_to_from_and_subject (sendmail.message.header)
			create bcc.make ("Bcc", sendmail.message.header.to)
			sendmail.message.header.add_field (bcc)
			sendmail.message.header.delete_field (field_name_to)
			create x_mailer.make ("X-Mailer", "eformmail " + version)
			sendmail.message.header.add_field (x_mailer)
			create mime_version.make (1, 0)
			sendmail.message.header.add_field (mime_version)
			sendmail.message.create_singlepart_body
			sendmail.message.text_body.append_string (a_body)
			debug ("eformmail")
				stderr.put_string (sendmail.message.as_string)
			end
			sendmail.send
			if sendmail.exit_code /= 0 then
				error_sendmail_failed ("sendmail's exit code indicates there was an error sending the email. The exit code is: " + sendmail.exit_code.out)
			end
		end

	send_email_using_smtp (a_body: STRING) is
			-- Send mail using smtp to `main_configuration'.`smart_host'.
		require
			body_not_void: a_body /= Void
			smart_host_set: main_configuration.smart_host /= Void and then not main_configuration.smart_host.is_empty
			key_configuration_not_void: key_configuration /= Void
		local
			smtp: EPX_SMTP_CLIENT
			message: EPX_MIME_EMAIL
			mail: EPX_SMTP_MAIL
			from_: STRING
			msg: STRING
		do
			create smtp.make (main_configuration.smart_host)
			smtp.open
			smtp.ehlo ("test.test")
			debug ("eformmail")
				stderr.put_string ("EHLO reply code: " + smtp.last_reply_code.out + "%N")
			end
			create message.make
			set_to_from_and_subject (message.header)
			message.create_singlepart_body
			message.text_body.append_string (a_body)
			debug ("eformmail")
				stderr.put_string (message.as_string)
			end
			--create mail.make ("postmaster", message.header.to, message)
			create mail.make (message.header.from_, message.header.to, message)
			message.header.delete_field (field_name_to)
			smtp.mail (mail)
			debug ("eformmail")
				stderr.put_string ("smart host reply code: " + smtp.last_reply_code.out + "%N")
			end
			if not smtp.is_positive_completion_reply then
				msg := "SMTP smart host's exit code indicates there was an error sending the email. The exit code is: " + smtp.last_reply_code.out
			end
			smtp.quit
			smtp.close
			if msg /= Void then
				error_smtp_failed (msg)
			end
		end

	set_to_from_and_subject (a_header: EPX_MIME_EMAIL_HEADER) is
			-- Set header.
		require
			header_not_void: a_header /= Void
		local
			from_,
			subject: STRING
		do
			a_header.set_to (Void, key_configuration.to)
			if key_configuration.from_field_name /= Void then
				from_ := raw_value (key_configuration.from_field_name)
				from_.left_adjust
				from_.right_adjust
				if from_.is_empty or else not is_valid_field_body (from_) then
					from_ := Void
				end
			end
			if from_ = Void then
				from_ := key_configuration.from_
			end
			a_header.set_from (Void, from_)
			if key_configuration.subject_field_name /= Void then
				subject := raw_value (key_configuration.subject_field_name)
				subject.left_adjust
				subject.right_adjust
				if subject.is_empty or else not is_valid_field_body (subject) then
					subject := Void
				end
			end
			if subject = Void then
				subject := key_configuration.subject
			end
			if
				key_configuration.subject_prefix /= Void and then
				not key_configuration.subject_prefix.is_empty
			then
				subject.prepend (key_configuration.subject_prefix + " ")
			end
			a_header.set_subject (subject)
		end


feature {NONE} -- Error reporting

	error_configuration_file_not_found is
			-- Main configuration file could not be found.
		local
			msg: STRING
		do
			msg := "<h1>Main Configuration file not found</h1><p>Main configuration file not found or this process does not have permissions to read it. The configuration file should either be <tt>" + current_directory_configuration_filename + "</tt> or <tt>" + usr_local_etc_directory_configuration_filename + "</tt> or <tt>" + etc_directory_configuration_filename + "</tt>.</p><p>If this is a new installation, start by copying <tt>main.conf</tt> to the required file name.</p>"
			user_friendly_error (msg)
		end

	error_configuration_file_invalid (a_msg: STRING) is
		local
			msg: STRING
		do
			msg := "<h1>Configuration file invalid</h1><p>" + a_msg + "</p>"
			user_friendly_error (msg)
		end

	error_form_field_not_valid (a_key: EPX_KEY_VALUE) is
		require
			key_not_void: a_key /= Void
		local
			s: STRING
		do
			s := "Contents of form field '" + a_key.key + "' = '" + a_key.value + "'. This value does not match its specified regular expression.%N"
			stderr.put_string (s)
			stderr.flush
			location (key_configuration.error_redirect)
			exit_with_success
		end

	error_invalid_form_data (a_field: STRING) is
		require
			field_not_empty: a_field /= Void and then not a_field.is_empty
			key_configuration_not_void: key_configuration /= Void
		local
			s: STRING
		do
			s := "Form field '" + a_field + "' contains control characters (ascii codes lower than 32)%N"
			stderr.put_string (s)
			stderr.flush
			location (key_configuration.error_redirect)
			exit_with_success
		end

	error_formatting_failed (a_exit_code: INTEGER) is
			-- Transformation of form data failed.
		require
			key_configuration_not_void: key_configuration /= Void
		local
			s: STRING
		do
			s := "Transformation of body failed with exit code " + a_exit_code.out + ". Transformation command was: '" + key_configuration.transform + "'%N"
			stderr.put_string (s)
			stderr.flush
			location (key_configuration.error_redirect)
			-- We don't want to give anything away
			exit_with_success
		end

	error_key_configuration_file_not_found (a_key_file_name: STRING) is
		require
			main_configuration_not_void: main_configuration /= Void
		local
			s: STRING
		do
			s := "Key configuration file " + a_key_file_name + " not found.%N"
			stderr.put_string (s)
			stderr.flush
			location (main_configuration.error_redirect)
			exit_with_success
		end

	error_key_configuration_file_invalid (a_msg: STRING) is
		do
			stderr.put_string ("Key configuration file invalid: " + a_msg + "%N")
			stderr.flush
			location (main_configuration.error_redirect)
			exit_with_success
		end

	error_program_name_incorrect is
		local
			msg: STRING
		do
			msg := "<h1>Program name insecure</h1><p>The name of this program is insecure. Rename <tt>" + Arguments.program_name + "</tt> to something else. The current name can be used by people who scan for web pages that mail the contents of a form. They will try to abuse this program, even when that won't succeed.</p>"
			user_friendly_error (msg)
		end

	error_sendmail_failed (a_msg: STRING) is
		require
			msg_not_void: a_msg /= Void
			key_configuration_not_void: key_configuration /= Void
		do
			stderr.put_string (a_msg)
			location (key_configuration.error_redirect)
			exit_with_success
		end

	error_smtp_failed (a_msg: STRING) is
		require
			msg_not_void: a_msg /= Void
			key_configuration_not_void: key_configuration /= Void
		do
			stderr.put_string (a_msg)
			location (key_configuration.error_redirect)
			exit_with_success
		end

	user_friendly_error (a_msg: STRING) is
			-- Show `msg' to end-user, and exit. Use this for errors that
			-- help the administrator install the software
			-- correctly. Don't use it for errors an end-user might ever
			-- see.
		require
			msg_not_void: a_msg /= Void
		do
			stderr.put_string (a_msg)
			stderr.put_character ('%N')
			content_text_html
			add_header_iso_8859_1_encoding
			b_html
			b_head
			title ("Configuration Error")
			e_head
			b_body
			add_raw (a_msg)
			e_body
			e_html
			stdout.put_string (as_uc_string)
			exit_with_failure
		end


feature {NONE} -- Implementation

	invalid_program_name: BOOLEAN is
			-- Is the name of this considered insecure because it can be
			-- used for harvesting?
		do
			Result :=
				Arguments.program_name.has_substring ("mail") or else
				Arguments.program_name.has_substring ("form")
			debug ("ise-eformmail")
				Result := False
			end
		end


end
