# Filename: ./et_inheritance/circle.e
class
    CIRCLE

inherit
    POINT
        rename
            make as point_make
        redefine
            make_origin,
            out
        end
create
    make, make_origin, make_from_point

feature -- Initialization

    make (a_x, a_y, a_r: INTEGER)
            -- Create with values `a_x' and `a_y' and `a_r'
        require
            non_negative_radius_argument: a_r >= 0
        do
            point_make (a_x, a_y)
            set_r (a_r)
        ensure
            x_set: x = a_x
            y_set: y = a_y
            r_set: r = a_r
        end

    make_origin
            -- Create at origin with zero radius
        do
            Precursor
        ensure then
            r_set: r = 0
        end

    make_from_point (a_p: POINT; a_r: INTEGER)
            -- Initialize from `a_r' with radius `a_r'.
        require
            non_negative_radius_argument: a_r >= 0
        do
            set_x (a_p.x)
            set_y (a_p.y)
            set_r (a_r)
        ensure
            x_set: x = a_p.x
            y_set: y = a_p.y
            r_set: r = a_r
        end

feature -- Access

    r: INTEGER assign set_r
            -- Radius

feature -- Element change

    set_r (a_r: INTEGER)
            -- Set radius (`r') to `a_r'
        require
            non_negative_radius_argument: a_r >= 0
        do
            r := a_r
        ensure
            r_set: r = a_r
        end

feature -- Output

    out: STRING
            -- Display as string
        do
            Result := "Circle:  x = " + x.out + "   y = " + y.out + "   r = " + r.out
        end

invariant

    non_negative_radius: r >= 0

end

# Filename: ./et_inheritance/point.e
class
    POINT
inherit
    ANY
        redefine
            out
        end
create
    make, make_origin

feature -- Initialization

    make (a_x, a_y: INTEGER)
            -- Create with values `a_x' and `a_y'
        do
            set_x (a_x)
            set_y (a_y)
        ensure
            x_set: x = a_x
            y_set: y = a_y
        end

    make_origin
            -- Create at origin
        do
        ensure
            x_set: x = 0
            y_set: y = 0
        end

feature -- Access

    x: INTEGER assign set_x
            -- Horizontal axis coordinate

    y: INTEGER assign set_y
            -- Vertical axis coordinate

feature -- Element change

    set_x (a_x: INTEGER)
            -- Set `x' coordinate to `a_x'
        do
            x := a_x
        ensure
            x_set: x = a_x
        end

    set_y (a_y: INTEGER)
            -- Set `y' coordinate to `a_y'
        do
            y := a_y
        ensure
            y_set: y = a_y
        end

feature -- Output

    out: STRING
            -- Display as string
        do
            Result := "Point:   x = " + x.out + "   y = " + y.out
        end
end

# Filename: ./et_inheritance/application.e
class
    APPLICATION

create
    make

feature {NONE} -- Initialization

    make
            -- Run application.
        local
            my_point: POINT
            my_circle: CIRCLE
        do
            create my_point.make_origin
            print (my_point.out + "%N")

            create {CIRCLE} my_point.make_origin
            print (my_point.out + "%N")

            create my_point.make (10, 15)
            print (my_point.out + "%N")

            create {CIRCLE} my_point.make (20, 25, 5)
            print (my_point.out + "%N")

            create my_circle.make (30, 35, 10)
            print (my_circle.out + "%N")

            create my_circle.make_from_point (my_point, 35)
            print (my_circle.out + "%N")
        end

end

# Filename: ./ArchOrientedProgramming/polymorphicidentifiers/scheme.e
note
	description: "Summary description for {SCHEME}."
	author: "Alejandro Garcia Fernandez"
	date: "2024-apr-7"
	revision: "1"
	examples:"[
	person
	name
	var:person/name
	var:person/{attribute}
	file://tmp/button.png
	htttp://www.example.com/button.pngg
	file:{env:HOME}/rfcs/{rfcnName}
	]"

deferred class
	SCHEME

	create
		make

	feature --creation
		make alias ":"
		deferred
		end

	feature path_sections:TREE[STRING]
	feature add_root alias "//" (sever_name:STRING):like Current
		require
			server_name_is_valid_url: 

	feature
		add_to_path alias "/" (identifier:STRING):like Current
		require
			identifier_doesnt_have_spaces: not(identifer.has("/") ) and (not (identifier.has" "))
		deferred
		end

end

# Filename: ./ArchOrientedProgramming/application.e
note
	description: "ArchOrientedProgramming application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			--| Add your code here
			print ("Hello Eiffel World!%N")
		end

end

# Filename: ./eformmail-2.0.1/src/main_configuration.e
indexing

	description: "Reading and parsing of main configuration file."

	author: "Berend de Boer"
	copyright:   "Copyright (c) 2004, Berend de Boer"
	license:     "Eiffel Forum Freeware License v2 (see forum.txt)"
	date: "$Date: 2007/03/02 $"
	revision: "$Revision: #2 $"


class

	MAIN_CONFIGURATION


inherit

	ANY

	EPX_FACTORY
		export
			{NONE} all;
			{ANY} fs;
		end


creation

	make


feature {NONE} -- Initialization

	make (a_filename: STRING) is
		require
			readable: fs.is_readable (a_filename)
		local
			config: EPX_CONFIG_FILE
		do
			filename := a_filename
			create config.make (a_filename)
			from
				config.read_line
			until
				not is_valid or else
				config.eof
			loop
				if config.is_key_value_line then
					config.split_on_equal_sign
					if not config.value.is_empty then
						if config.key.is_equal (once_key_field_name) then
							key_field_name := config.value
						elseif config.key.is_equal (once_error_redirect) then
							error_redirect := config.value
						elseif config.key.is_equal (once_sendmail) then
							sendmail := config.value
						elseif config.key.is_equal (once_smart_host) then
							smart_host := config.value
						else
							diagnostic_message := "Unrecognized field '" + config.key + "' in main configuration file at line " + config.line_number.out + "."
						end
					else
						diagnostic_message := "Configuration file has invalid value for key '" + config.key + "' at line " + config.line_number.out + ": this field may not be empty."
					end
				else
					diagnostic_message := "Configuration file has invalid format at line " + config.line_number.out + "."
				end
				config.read_line
			end
			if diagnostic_message = Void then
				if key_field_name = Void then
					diagnostic_message := "Field 'key field name' must have a value."
				elseif error_redirect = Void then
					diagnostic_message := "Field 'error redirect' must have a value."
				end
			end
		end


feature -- Status

	is_valid: BOOLEAN is
			-- Set when configuration file has an incorrect format
		do
			Result := diagnostic_message = Void
		end


feature -- Access

	diagnostic_message: STRING
			-- Helpful message what's wrong if `invalid'

	filename: STRING
			-- Full path to configuration file

	key_field_name: STRING
			-- Name of field in form that contains the key

	error_redirect: STRING
			-- Redirect to this URL on failure

	sendmail: STRING
			-- Full path and options to sendmail binary

	smart_host: STRING
			-- Smart host for mail delivery


feature {NONE} -- Once strings

	once_key_field_name: STRING is "key field name"

	once_error_redirect: STRING is "error redirect"

	once_sendmail: STRING is "sendmail"

	once_smart_host: STRING is "smart host"


invariant

	filename_set: filename /= Void and then not filename.is_empty
	key_field_name_not_empty: is_valid implies key_field_name /= Void and then not key_field_name.is_empty
	sendmail_void_or_not_empty: is_valid implies sendmail = Void or else not sendmail.is_empty
	error_redirect_not_empty: is_valid implies error_redirect /= Void and then not error_redirect.is_empty

end

# Filename: ./eformmail-2.0.1/src/key_configuration.e
indexing

	description: "Reading and parsing of key configuration file."

	author: "Berend de Boer"
	copyright:   "Copyright (c) 2004, Berend de Boer"
	license:     "Eiffel Forum Freeware License v2 (see forum.txt)"
	date: "$Date: 2007/03/02 $"
	revision: "$Revision: #1 $"


class

	KEY_CONFIGURATION


inherit

	ANY

	EPX_FACTORY
		export
			{NONE} all;
			{ANY} fs;
		end

	KL_IMPORTED_STRING_ROUTINES
		export
			{NONE} all
		end


creation

	make


feature {NONE} -- Initialization

	make (a_filename: STRING) is
			-- Read and parse the given configuration file.
		require
			readable: fs.is_readable (a_filename)
		local
			config: EPX_CONFIG_FILE
			field_name: STRING
			reg_exp: STRING
			rx: RX_PCRE_REGULAR_EXPRESSION
			tester: KL_CASE_INSENSITIVE_STRING_EQUALITY_TESTER
			p: INTEGER
		do
			filename := a_filename
			create tester
			create validated_fields.make (16)
			validated_fields.set_key_equality_tester (tester)
			create black_hole_fields.make (16)
			black_hole_fields.set_key_equality_tester (tester)
			create config.make (a_filename)
			from
				config.read_line
			until
				not is_valid or else
				config.end_of_input
			loop
				if config.is_key_value_line then
					config.split_on_equal_sign
					if not config.value.is_empty then
						if config.key.is_equal (once_to) then
							to := config.value
						elseif config.key.is_equal (once_from_field_name) then
							from_field_name := config.value
						elseif config.key.is_equal (once_from) then
							from_ := config.value
						elseif config.key.is_equal (once_subject) then
							subject := config.value
						elseif config.key.is_equal (once_subject_field_name) then
							subject_field_name := config.value
						elseif config.key.is_equal (once_subject_prefix) then
							subject_prefix := config.value
						elseif config.key.is_equal (once_transform) then
							transform := config.value
						elseif config.key.is_equal (once_error_redirect) then
							error_redirect := config.value
						elseif config.key.is_equal (once_success_redirect) then
							success_redirect := config.value
						elseif
							config.key.substring_index (once_validate, 1) = 1 or else
							config.key.substring_index (once_spam, 1) = 1
						then
							p := config.key.index_of (' ', 1)
							field_name := config.key.substring (p + 1, config.key.count)
							field_name.left_adjust
							if config.value.item (1) = '/' then
								reg_exp := config.value.substring (2, config.value.count - 1)
							else
								standard_reg_exps.search (config.value)
								if standard_reg_exps.found then
									reg_exp := standard_reg_exps.found_item
								else
									diagnostic_message := "Field validation for field '" + field_name + "' at line " + config.line_number.out + " has the unrecognized type '" + config.value + "'. If you intended to write a regular expression instead of a type, make sure to start and stop it with a '/' character."
								end
							end
							if diagnostic_message = Void then
								create rx.make
								rx.compile (reg_exp)
								if rx.is_compiled then
									if config.key.substring_index (once_validate, 1) = 1 then
										validated_fields.force_last (rx, field_name)
									else
										black_hole_fields.force_last (rx, field_name)
									end
								else
									diagnostic_message := "Field validation at line " + config.line_number.out + " has an invalid regular expression: " + config.value + "."
								end
							end
						else
							diagnostic_message := "Unrecognized field '" + config.key + "' in main configuration file at line " + config.line_number.out + "."
						end
					else
						diagnostic_message := "Configuration file has invalid value for 'key field name' at line " + config.line_number.out + ": this field may not be empty."
					end
				else
					diagnostic_message := "Configuration file has invalid format at line " + config.line_number.out + "."
				end
				config.read_line
			end
			if diagnostic_message = Void then
				if from_ = Void then
					diagnostic_message := "Field 'from' must have a value."
				elseif subject = Void then
					diagnostic_message := "Field 'subject' must have a value."
				elseif to = Void then
				diagnostic_message := "Field 'to' must have a value."
				elseif error_redirect = Void then
					diagnostic_message := "Field 'error redirect' must have a value."
				elseif success_redirect = Void then
					diagnostic_message := "Field 'success redirect' must have a value."
				end
			end
		end


feature -- Status

	is_valid: BOOLEAN is
			-- Set when configuration file has an incorrect format
		do
			Result := diagnostic_message = Void
		end


feature -- Access

	diagnostic_message: STRING
			-- Helpful message what's wrong if `invalid'

	filename: STRING
			-- Full path to configuration file

	from_: STRING
			-- Default "From:" if not from supplied

	from_field_name: STRING
			-- Form field name that contains the contents for the "From"
			-- field of the email

	subject: STRING
			-- Default "Subject:" if not subject supplied

	subject_field_name: STRING
			-- Form field name that contains the contents for the "Subject"
			-- field of the email

	subject_prefix: STRING
			-- Optional prefix for Subject field;
			-- Makes it easier to recognize eformmail messages.

	to: STRING
			-- Contents of To field of email message

	transform: STRING
			-- Path and options to a program that can transform the body
			-- into the required format

	error_redirect: STRING
			-- Redirect to this URL on failure

	success_redirect: STRING
			-- Redirect to this URL on sucessful send of email

	validated_fields: DS_HASH_TABLE [RX_PCRE_REGULAR_EXPRESSION, STRING]
			-- Optional list of fields that must match the provided
			-- regular expression

	black_hole_fields: DS_HASH_TABLE [RX_PCRE_REGULAR_EXPRESSION, STRING]
			-- Optional list of fields that when the provided regular
			-- expression matches, will cause the message to be silently
			-- dismissed.


feature {NONE} -- Once strings

	once_from_field_name: STRING is "from field name"

	once_from: STRING is "from"

	once_subject: STRING is "subject"

	once_subject_field_name: STRING is "subject field name"

	once_subject_prefix: STRING is "subject prefix"

	once_to: STRING is "to"

	once_transform: STRING is "transform"

	once_error_redirect: STRING is "error redirect"

	once_success_redirect: STRING is "success redirect"

	once_validate: STRING is "validate "

	once_spam: STRING is "spam "


feature {NONE} -- Implementation

	standard_reg_exps: DS_HASH_TABLE [STRING, STRING] is
		once
			create Result.make (6)
			-- From http://www.breakingpar.com/bkp/home.nsf/Doc?OpenNavigator&U=87256B280015193F87256C40004CC8C6
			Result.put_last ("^[0-9]+$", "double")
			Result.put_last ("^(([^<>()[\]\\.,;:\s@%"]+(\.[^<>()[\]\\.,;:\s@%"]+)*)|(\%".+%"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$", "email")
			Result.put_last ("^[\-+]?[0-9]+$", "integer")
			Result.put_last ("^\d+$", "nonNegativeInteger")
			Result.put_last ("^[^\r\n\000]+$", "subject")
			Result.put_last ("^(\w+)://([^/:]+)(:\d+)?/(.*)$", "url")
		ensure
			standard_reg_exps_not_void: Result /= Void
		end


invariant

	filename_set: filename /= Void and then not filename.is_empty
	to_not_empty: is_valid implies to /= Void and then not to.is_empty
	error_redirect_not_empty: is_valid implies error_redirect /= Void and then not error_redirect.is_empty
	success_redirect_not_empty: is_valid implies success_redirect /= Void and then not success_redirect.is_empty
	transform_void_or_not_empty: is_valid implies transform = Void or else not transform.is_empty
	validated_fields_not_void: validated_fields /= Void

end

# Filename: ./eformmail-2.0.1/src/form_mail.e
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

# Filename: ./ex_cli/application.e
note
	description: "ex_cli application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			 if attached separate_character_option_value ('c') as l_val then
                print ("Command line argument value for option 'c' is: ")
                print (l_val + "%N")
            end
            if attached separate_character_option_value ('h') as l_val then
                print ("Command line argument value for option 'h' is: ")
                print (l_val + "%N")
            end
            io.read_line  -- keep the line open
		end

end

# Filename: ./SET_THEORY/application.e
note
	description: "SET_THEORY application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			--| Add your code here
			print ("Hello Eiffel World!%N")
		end

end

# Filename: ./SET_THEORY/sts_set.e
﻿note
	description: "Summary description for {STS_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	STS_SET [ELEMENT, EQ->EQUALITY[ELEMENT]]

--inherit
--	ELEMENT
--		rename
--			is_in as element_is_in,
--			is_not_in as element is_not_in
--		end

feature
	is_empty:BOOLEAN
		deferred
		end

	any:ELEMENT
		-- An arbitrary element in the current set
		require
			set_has_at_least_an_element: not is_empty
		deferred
		end

	others: like subset_anchor
		-- Set that has all the elements except 'any'
		-- | NOTICE: there is no precondition to 'others': if current set is empty `others' is empty too. as stated in the invariant.
		deferred
		end

	eq: EQ
		-- Rule for testing equality between elements in current set
		-- | Notice that the type of `eq' is hard-wired as a generic parameter.
		-- | Though it is not very flexible, the alternative would be to guard with preconditons every feature where two sets are somehow compared.
		-- | in order to check whethec their current equalities are equivalent,
		-- | and this would be rather cumbersome.
		-- | Makinng the equality part of the set type guarentees that only compatible sets are compared at any time.
		-- | with no need for preconditions
		deferred
		end

feature -- Membership
	has alias "∋" (e: ELEMENT): BOOLEAN
		-- Is `e' an element in current set?
		do
			Result := Current |∃ agent equality_holds (e, ?)
		ensure
			definition: Result = (Current |∃ agent equality_holds (e, ?))
		end

	is_in alias "∈" (s:SET [ SET [ELEMENT,EQ], EQUALITY [SET [ELEMENT,EQ]]]):BOOLEAN
		-- Does `s' have a current set?
		do
			Result := s ∋ Current
		ensure
			definition: Result = s ∋ Current
		end

	is_not_in alias "∉" (s: SET [SET[ELEMENT,EQ], EQUALITY[SET[ELEMENT,EQ]]]):BOOLEAN
		do
			Result := not (Current ∈ s)
		ensure
			definition: Result = not (Current ∈ s)
		end

	does_not_have alias "∌" (e:ELEMENT):BOOLEAN
		do
			Result := not (Current ∋ e)
		ensure
			definition: Resul = not (Current ∋ e)
		end

feature -- Construction
	with alias "&" (e:ELEMENT): like superset_anchor
	deferred
	ensure
		with_appended_element: Result ∋ e
		nothing_lost: Current |∀ agent Result.has
		nothing_added: Result |∀ agent ored(agent has, agent equality_holds(e,?),?)
	end

	without alias "/" (e:ELEMENT): like subset_anchor
		-- Every element in current set except A
		deferred
		ensure
			does_not_have_element: Result ∌ e
			nothing_lost: Current |∀ agent xored (agent Result.has, agent equality_holds(e,?),?)
			nothing_modified: Result |∀ agent has
		end
feature -- Quality
	is_singleton:BOOLEAN
		do
			Result := not is_empty and others.is_empty
		ensure
			definition: Result = (not is_empty and others.is_empty)
		end

feature -- Measurement
	cardinality alias "#":like natural_anchor
		do
			Result := transformer_to_natural.set_reduction (Current, 0, agent cumulative_succesor)
		ensure
			definition: Result = transformer_to_natural.set_reduction (Current, 0, agent cumulative_succesor)
		end

feature -- Quantifiers
	exists alias "|∃" (p:PREDICATE[ELEMENT]): BOOLEAN
		do
			Result := transformer_to_boolean.set_reduction(Current, False, agent cumulative_disjunction(?,p,?))
		ensure
			definition: Result = transformer_to_boolean.set_reduction(Current, False, agent cumulative_disjunction(?, p, ?))
		end
	for_all alias "|∀" (p:PREDICATE [ELEMENT]): BOOLEAN
		do
			Result := transformer_to_boolean.set_reduction(Current, True, agent cumulative_conjuction(?,p,?))
		ensure
			definition: Result = transformer_to_boolean.set_reduction(Current, True, agent cumulative_conjuction(?,p,?))
		end


feature -- transformers
	transformer_to_boolean: TRANSFORMER[ELEMENT, BOOLEAN, OBJECT_EQUALITY[BOOLEAN]]
				-- Transformer of objects whose types derive from {A} to objects whose types derive from {BOOLEAN}
		deferred
		end
	transformer_to_natural: TRANSFORMER [ELEMENT, like natural_anchor, OBJECT_EQUALITY [like natural_anchor]]
			-- Transformer of objects whose types derive from {A} to objects whose types derive from {like natural_anchor}
		deferred
		end

feature --Anchor
	natural_anchor: NATURAL
			-- Anchor for natural numbers
			--| TODO: Pull it up to a target-dependant class.
		do
		ensure
			class
		end

	set_anchor: SET[ELEMENT, EQ]
		-- Anchor for sets like current one
		-- TODO: Why didn't we use like Current ?
		deferred
		end
	subset_anchor: SET[ELEMENT, EQ]
		-- Anchor for subsets of the current SET
		-- TODO: Again why don't we use like Current, if every subset must be of the same type of elements that the current?
		deferred
		end

	superset_anchor: SET[ELEMENT, EQ]
		--Anchor for the superset
				-- TODO: Again why don't we use like Current, if every subset must be of the same type of elements that the current?
		deferred
		end

end

# Filename: ./ex_sieve/application.e
note
	description: "ex_sieve application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature -- Initialization

	make
			-- Run application.
		do
			across primes_generator(100) as ic loop print(ic.item.out + ", ") end
		end

	primes_generator(a_limit: INTEGER): LINKED_LIST[INTEGER]
		require
			a_positive_limit : a_limit >= 2
		local
			l_tab : ARRAY[BOOLEAN]
		do
			create Result.make
			create l_tab.make_filled (True, 2, a_limit)
			across l_tab as ic loop
				if ic.item then
					Result.extend(ic.target_index)
					across ((ic.target_index * ic.target_index) |..| l_tab.upper).new_cursor.with_step (ic.target_index) as id
					loop
						l_tab[id.item] := False
					end

				end
			end
		end
end

# Filename: ./ex_attributes/person.e
note
	description: "Summary description for {PERSON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PERSON

	feature -- access
		mood: STRING assign set_mood
			attribute
				Result := "happy"
			end

		set_mood(a_string: STRING)
			require
				single_token: a_string.occurrences (' ') = 0
				do
					mood := a_string
				ensure
					mood_was_set: mood = a_string
				end
end

# Filename: ./ex_attributes/application.e
note
	description: "ex_attributes application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			create my_person
			print("mood with default values" + my_person.mood + "%N")
			my_person.mood := "Ecstatic"
			print("mood after assignment" + my_person.mood + "%N")
		end

	my_person:PERSON
end

# Filename: ./ex_sleep/application.e
note
	description: "ex_sleep application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			print ("How many nanoseconds (1 seg = 1_000_000_000) should I sleep?%N")
			io.read_integer_64
			print ("Sleeping....%N")
			sleep(io.last_integer_64)
			print("Awake...%N")
		end

end

# Filename: ./literate_polymophic_identfiers/http_scheme.e

feature
    example_grdual_construction:like Current
            -- This is in example fo how I would use this class it should be used like test case
        local
            l_http:HTTP
            host = "www.example.com"
            folder = "folder"
            subfolder = "subfolder"
            file = "filename.extension"
            qry = "query_string=value&var2=value"
            anchor = "a heding in the document"
        do
            l_http := {HTTP}:// host / folder / subfolder / file ? qury # anchor

            check
                scheme_gets_created_statically: l_http /= void
                scheme_can_get_created_gradually: "http://www.example.com/folder/subfolder/filename?query_string#anchor" = l_http
                scheme_pretty_prints: "http://www.example.com/folder/subfolder/filename?query_string#anchor" = l_http
            end


            l_http := "http://www.example.com/folder/subfolder/filename?query_string#anchor"

            check
                an_scheme_can_be_created_by_string: "http://www.example.com/folder/subfolder/filename?query_string#anchor" = l_http
            end

            check
                can_we_ask_things_of_the_service: host = l_http.host
                what_is_the_path: folder = l_http.path
                what_is_the_file: file = l_http.file
            end
        end
    end


# Filename: ./literate_polymophic_identfiers/scheme.e
deferred class SCHEME
    creation
        make
    feature -- creation

        make alias ":"
            -- schemes are supposde to be started statically
            do
                create Current
            end
    feture
end

# Filename: ./ex_reverse/application.e
note
	description: "ex_reverse application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate string reversal.
		local
			my_string: STRING
		do
			my_string := "Hello World!"
			my_string.mirror
			print(my_string)
		end

end

# Filename: ./componization_patterns/Pag49/application.e
note
	description: "thesis application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			--| Add your code here
			print ("Hello Eiffel World!%N")
		end

end

# Filename: ./componization_patterns/Pag49/book.e
note
	description: "Summary description for {BOOK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BOOK

feature
	borrowed:BOOLEAN
	free:BOOLEAN

	borrow
		do
			if free then
				borrowed := true
				free:= false
			else
				-- rais exception is not possible to start borrow if its already borrowed
			end
		end

end

# Filename: ./componization_patterns/Pag50/state.e
note
	description: "Summary description for {STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATE

create make

feature
	make
	do
		my_state := "free"
	end


feature
	my_state:STRING

feature
	borrow
	require
		the_book_is_free: my_state = "free"
	do
		my_state := "borrowed"
	ensure
		the_book_is_now_borrowed: my_state = "borrowed"
	end

end

# Filename: ./componization_patterns/Pag50/application.e
note
	description: "thesis application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			--| Add your code here
			print ("Hello Eiffel World!%N")
		end

end

# Filename: ./componization_patterns/Pag50/book.e
note
	description: "Summary description for {BOOK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BOOK

feature
	borrow
		do
			state.borrow
		end

feature {NONE}
	state:STATE
	attribute
		create Result.make
	end
end

# Filename: ./componization_patterns/main/state.e
note
	description: "Summary description for {STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATE

create make

feature
	make
	do
		my_state := "free"
	end


feature
	my_state:STRING

feature
	borrow
	require
		the_book_is_free: my_state = "free"
	do
		my_state := "borrowed"
	ensure
		the_book_is_now_borrowed: my_state = "borrowed"
	end

end

# Filename: ./componization_patterns/main/application.e
note
	description: "thesis application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			--| Add your code here
			print ("Hello Eiffel World!%N")
		end

end

# Filename: ./componization_patterns/main/book.e
note
	description: "Summary description for {BOOK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BOOK

feature
	borrow
		do
			state.borrow
		end

feature {NONE}
	state:STATE
	attribute
		create Result.make
	end
end

# Filename: ./libertyEiffel_xml/my_validating_tree.e
note
	description: "Summary description for {MY_VALIDATING_TREE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MY_VALIDATING_TREE

inherit
	XML_TREE
	redefine new_node
	end

create {EXAMPLE2}
	with_error_handler

feature {NONE} -- Initialization

	Tree_tag:UNICODE_STRING
		once
			Result := "Tree"
		end
	Node_tag: UNICODE_STRING
		once
			Result := "node"
		end

	Leaf_tag: UNICODE_STRING
		once
			Result := "leaf"
		end

	new_node(node_name:UNICODE_STRING; line, column: INTEGER): XML_COMPOSITE_NODE
		do
			inspect
				node_name.as_utf8
			when "tree" then
				if current_node /= void then
					parse_error(line, column, "unexpected node without a parent node")
				else
					create Result.make(Tree_tag, line, column)
				end
			when "node" then
				if current_node = Void or else current_node = Leaf_tag then
					parse_error(line, column, "unexpected node without parent node or with parent being a node leaf")
				else
					create Result.make(Node_tag, line, column)
				end
			when "leaf" then
				if current_node = Void then
					parse_error(line,column,"unexpected leaf without parent node")
				else
					create Result.make(Leaf_tag, line, column)
				end
			end
		end
end

# Filename: ./libertyEiffel_xml/example2.e
note
	description: "Summary description for {EXAMPLE2}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXAMPLE2

inherit
	APPLICATION
	redefine make
	end

create
	make

feature {NONE} -- Initialization

	make
		local
			in: TEXT_FILE_READ;
			tree: MY_VALIDATING_TREE;
			version: UNICODE_STRING
		do
			if argument_count = 0 then
				std_error.put_line("Usage: #(1) <file.xml>")
				die_with_code(1)
			end

			-- first create the stream
			create in.connect_to(argument(1))
			if in.is_connected then
				create tree.with_error_handler(in.url, agent(error(?,?))

				version := tree.attribute_at("version")
				if version /= void then
					io.put_string("XML version")
					io.put_string(version.as_utf8)
					io.put_new_line
				end

				tree.root.accept(Current)
			end
		end

feature -- Access

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end

# Filename: ./libertyEiffel_xml/application.e
note
	description: "libertyEiffel_xml application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	XML_NODE_VISITOR
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
		local
			in: TEXT_FILE_READ;
			tree: XML_TREE;
			version: UNICODE_STRING
		do
			if argument_count = 0 then
				std_error.put_line("Usage: #(1) <file.xml>" # command_name)
				die_with_code(1)
			end

			-- first create the stream
			create in.connect_to(argument(1))
			if (in.is_connected) then
				create tree.with_error_handler(in.url, agent error(?,?))

				version := tree.attribute_at("vesion")
				if version /= Void then
					io.put_string ("XML version:")
					io.put_string (version.as_utf8)
					io.put_new_line
				end

				check
					indent = 0
				end
				tree.root.accept(Current)

			end
		end

	indent: INTEGER

feature {XML_DATA_NODE}
	visit_data_nade (node:XML_DATA_NODE)
	do
		-- data not displayed in this example
	end

feature {XML_COMPOSITE_NODE}
	visit_composite_node(node: XML_COMPOSITE_NODE)
	local
		i, start_indent:INTEGER
	do
		from
			i := 1
		until
			i > indent
		loop
			io.put_string (" ")
			i := i +1
		end

		io.put_string (node.name.as_utf8)

		if node.attributes_count > 0 then
			io.put_character('(')
			from
				i := 1
			until
				i > node.attributes_count
			loop
				if i > 1 then
					io.put_string (",")
				end

				io.put_string (node.attribute_name(i).as_utf8)
				io.put_character ('=')
				io.put_string (node.attribute_value(i).as_utf8)
				i := i + 1
			end

			io.put_character (')')
		end

		io.put_new_line
		from
			start_indent := indent
			indent := start_indent+1
			i := 1
		invariant
			indent = start_index + 1
		until
			i > node.children_count
		loop
			node.child(i).accept(Current)
			i := i + 1
		end

		indent := start_indent
	end

error(line,count : INTEGER)
	do
		std_error.put_string("Error at ")
		std_error.put_integer(line)
		std_error.put_string(",")
		std_error.put_integer(column)
		std_error.put_string( "!%N")
		die_with_code(1)
	end
end

# Filename: ./eformmail-2.0/src/main_configuration.e
indexing

	description: "Reading and parsing of main configuration file."

	author: "Berend de Boer"
	copyright:   "Copyright (c) 2004, Berend de Boer"
	license:     "Eiffel Forum Freeware License v2 (see forum.txt)"
	date: "$Date: 2007/03/02 $"
	revision: "$Revision: #2 $"


class

	MAIN_CONFIGURATION


inherit

	ANY

	EPX_FACTORY
		export
			{NONE} all;
			{ANY} fs;
		end


creation

	make


feature {NONE} -- Initialization

	make (a_filename: STRING) is
		require
			readable: fs.is_readable (a_filename)
		local
			config: EPX_CONFIG_FILE
		do
			filename := a_filename
			create config.make (a_filename)
			from
				config.read_line
			until
				not is_valid or else
				config.eof
			loop
				if config.is_key_value_line then
					config.split_on_equal_sign
					if not config.value.is_empty then
						if config.key.is_equal (once_key_field_name) then
							key_field_name := config.value
						elseif config.key.is_equal (once_error_redirect) then
							error_redirect := config.value
						elseif config.key.is_equal (once_sendmail) then
							sendmail := config.value
						elseif config.key.is_equal (once_smart_host) then
							smart_host := config.value
						else
							diagnostic_message := "Unrecognized field '" + config.key + "' in main configuration file at line " + config.line_number.out + "."
						end
					else
						diagnostic_message := "Configuration file has invalid value for key '" + config.key + "' at line " + config.line_number.out + ": this field may not be empty."
					end
				else
					diagnostic_message := "Configuration file has invalid format at line " + config.line_number.out + "."
				end
				config.read_line
			end
			if diagnostic_message = Void then
				if key_field_name = Void then
					diagnostic_message := "Field 'key field name' must have a value."
				elseif error_redirect = Void then
					diagnostic_message := "Field 'error redirect' must have a value."
				end
			end
		end


feature -- Status

	is_valid: BOOLEAN is
			-- Set when configuration file has an incorrect format
		do
			Result := diagnostic_message = Void
		end


feature -- Access

	diagnostic_message: STRING
			-- Helpful message what's wrong if `invalid'

	filename: STRING
			-- Full path to configuration file

	key_field_name: STRING
			-- Name of field in form that contains the key

	error_redirect: STRING
			-- Redirect to this URL on failure

	sendmail: STRING
			-- Full path and options to sendmail binary

	smart_host: STRING
			-- Smart host for mail delivery


feature {NONE} -- Once strings

	once_key_field_name: STRING is "key field name"

	once_error_redirect: STRING is "error redirect"

	once_sendmail: STRING is "sendmail"

	once_smart_host: STRING is "smart host"


invariant

	filename_set: filename /= Void and then not filename.is_empty
	key_field_name_not_empty: is_valid implies key_field_name /= Void and then not key_field_name.is_empty
	sendmail_void_or_not_empty: is_valid implies sendmail = Void or else not sendmail.is_empty
	error_redirect_not_empty: is_valid implies error_redirect /= Void and then not error_redirect.is_empty

end

# Filename: ./eformmail-2.0/src/key_configuration.e
indexing

	description: "Reading and parsing of key configuration file."

	author: "Berend de Boer"
	copyright:   "Copyright (c) 2004, Berend de Boer"
	license:     "Eiffel Forum Freeware License v2 (see forum.txt)"
	date: "$Date: 2007/03/02 $"
	revision: "$Revision: #1 $"


class

	KEY_CONFIGURATION


inherit

	ANY

	EPX_FACTORY
		export
			{NONE} all;
			{ANY} fs;
		end

	KL_IMPORTED_STRING_ROUTINES
		export
			{NONE} all
		end


creation

	make


feature {NONE} -- Initialization

	make (a_filename: STRING) is
			-- Read and parse the given configuration file.
		require
			readable: fs.is_readable (a_filename)
		local
			config: EPX_CONFIG_FILE
			field_name: STRING
			reg_exp: STRING
			rx: RX_PCRE_REGULAR_EXPRESSION
			tester: KL_CASE_INSENSITIVE_STRING_EQUALITY_TESTER
			p: INTEGER
		do
			filename := a_filename
			create tester
			create validated_fields.make (16)
			validated_fields.set_key_equality_tester (tester)
			create black_hole_fields.make (16)
			black_hole_fields.set_key_equality_tester (tester)
			create config.make (a_filename)
			from
				config.read_line
			until
				not is_valid or else
				config.end_of_input
			loop
				if config.is_key_value_line then
					config.split_on_equal_sign
					if not config.value.is_empty then
						if config.key.is_equal (once_to) then
							to := config.value
						elseif config.key.is_equal (once_from_field_name) then
							from_field_name := config.value
						elseif config.key.is_equal (once_from) then
							from_ := config.value
						elseif config.key.is_equal (once_subject) then
							subject := config.value
						elseif config.key.is_equal (once_subject_field_name) then
							subject_field_name := config.value
						elseif config.key.is_equal (once_subject_prefix) then
							subject_prefix := config.value
						elseif config.key.is_equal (once_transform) then
							transform := config.value
						elseif config.key.is_equal (once_error_redirect) then
							error_redirect := config.value
						elseif config.key.is_equal (once_success_redirect) then
							success_redirect := config.value
						elseif
							config.key.substring_index (once_validate, 1) = 1 or else
							config.key.substring_index (once_spam, 1) = 1
						then
							p := config.key.index_of (' ', 1)
							field_name := config.key.substring (p + 1, config.key.count)
							field_name.left_adjust
							if config.value.item (1) = '/' then
								reg_exp := config.value.substring (2, config.value.count - 1)
							else
								standard_reg_exps.search (config.value)
								if standard_reg_exps.found then
									reg_exp := standard_reg_exps.found_item
								else
									diagnostic_message := "Field validation for field '" + field_name + "' at line " + config.line_number.out + " has the unrecognized type '" + config.value + "'. If you intended to write a regular expression instead of a type, make sure to start and stop it with a '/' character."
								end
							end
							if diagnostic_message = Void then
								create rx.make
								rx.compile (reg_exp)
								if rx.is_compiled then
									if config.key.substring_index (once_validate, 1) = 1 then
										validated_fields.force_last (rx, field_name)
									else
										black_hole_fields.force_last (rx, field_name)
									end
								else
									diagnostic_message := "Field validation at line " + config.line_number.out + " has an invalid regular expression: " + config.value + "."
								end
							end
						else
							diagnostic_message := "Unrecognized field '" + config.key + "' in main configuration file at line " + config.line_number.out + "."
						end
					else
						diagnostic_message := "Configuration file has invalid value for 'key field name' at line " + config.line_number.out + ": this field may not be empty."
					end
				else
					diagnostic_message := "Configuration file has invalid format at line " + config.line_number.out + "."
				end
				config.read_line
			end
			if diagnostic_message = Void then
				if from_ = Void then
					diagnostic_message := "Field 'from' must have a value."
				elseif subject = Void then
					diagnostic_message := "Field 'subject' must have a value."
				elseif to = Void then
				diagnostic_message := "Field 'to' must have a value."
				elseif error_redirect = Void then
					diagnostic_message := "Field 'error redirect' must have a value."
				elseif success_redirect = Void then
					diagnostic_message := "Field 'success redirect' must have a value."
				end
			end
		end


feature -- Status

	is_valid: BOOLEAN is
			-- Set when configuration file has an incorrect format
		do
			Result := diagnostic_message = Void
		end


feature -- Access

	diagnostic_message: STRING
			-- Helpful message what's wrong if `invalid'

	filename: STRING
			-- Full path to configuration file

	from_: STRING
			-- Default "From:" if not from supplied

	from_field_name: STRING
			-- Form field name that contains the contents for the "From"
			-- field of the email

	subject: STRING
			-- Default "Subject:" if not subject supplied

	subject_field_name: STRING
			-- Form field name that contains the contents for the "Subject"
			-- field of the email

	subject_prefix: STRING
			-- Optional prefix for Subject field;
			-- Makes it easier to recognize eformmail messages.

	to: STRING
			-- Contents of To field of email message

	transform: STRING
			-- Path and options to a program that can transform the body
			-- into the required format

	error_redirect: STRING
			-- Redirect to this URL on failure

	success_redirect: STRING
			-- Redirect to this URL on sucessful send of email

	validated_fields: DS_HASH_TABLE [RX_PCRE_REGULAR_EXPRESSION, STRING]
			-- Optional list of fields that must match the provided
			-- regular expression

	black_hole_fields: DS_HASH_TABLE [RX_PCRE_REGULAR_EXPRESSION, STRING]
			-- Optional list of fields that when the provided regular
			-- expression matches, will cause the message to be silently
			-- dismissed.


feature {NONE} -- Once strings

	once_from_field_name: STRING is "from field name"

	once_from: STRING is "from"

	once_subject: STRING is "subject"

	once_subject_field_name: STRING is "subject field name"

	once_subject_prefix: STRING is "subject prefix"

	once_to: STRING is "to"

	once_transform: STRING is "transform"

	once_error_redirect: STRING is "error redirect"

	once_success_redirect: STRING is "success redirect"

	once_validate: STRING is "validate "

	once_spam: STRING is "spam "


feature {NONE} -- Implementation

	standard_reg_exps: DS_HASH_TABLE [STRING, STRING] is
		once
			create Result.make (6)
			-- From http://www.breakingpar.com/bkp/home.nsf/Doc?OpenNavigator&U=87256B280015193F87256C40004CC8C6
			Result.put_last ("^[0-9]+$", "double")
			Result.put_last ("^(([^<>()[\]\\.,;:\s@%"]+(\.[^<>()[\]\\.,;:\s@%"]+)*)|(\%".+%"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$", "email")
			Result.put_last ("^[\-+]?[0-9]+$", "integer")
			Result.put_last ("^\d+$", "nonNegativeInteger")
			Result.put_last ("^[^\r\n\000]+$", "subject")
			Result.put_last ("^(\w+)://([^/:]+)(:\d+)?/(.*)$", "url")
		ensure
			standard_reg_exps_not_void: Result /= Void
		end


invariant

	filename_set: filename /= Void and then not filename.is_empty
	to_not_empty: is_valid implies to /= Void and then not to.is_empty
	error_redirect_not_empty: is_valid implies error_redirect /= Void and then not error_redirect.is_empty
	success_redirect_not_empty: is_valid implies success_redirect /= Void and then not success_redirect.is_empty
	transform_void_or_not_empty: is_valid implies transform = Void or else not transform.is_empty
	validated_fields_not_void: validated_fields /= Void

end

# Filename: ./eformmail-2.0/src/form_mail.e
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

# Filename: ./ex_fileIO/application.e
note
	description: "ex_fileIO application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			input_file: PLAIN_TEXT_FILE
			output_file: PLAIN_TEXT_FILE
		do
			create input_file.make_open_read ("input.txt")
			create output_file.make_open_write ("output.txt")

			from
				input_file.read_character
			until
				input_file.exhausted
			loop
				output_file.put(input_file.last_character)
				input_file.read_character
			end

			input_file.close
			output_file.close
		end

end

# Filename: ./ex_environment_variables/application.e
note
	description: "ex_environment_variables application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			put ("Hello World!", "MY_VARIABLE")
			print(get("MY_VARIABLE"))
		end

end

# Filename: ./DBCbyExample_28/simple_stack.e
note
	description: "Summary description for {SIMPLE_STACK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SIMPLE_STACK[G]

feature

	count:STRING

	item_at(i:INTEGER):G
		do
			Result:G 
		end

end

# Filename: ./DBCbyExample_28/application.e
note
	description: "Design by Contract by example code 2.8"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			--| Add your code here
			print ("Hello Eiffel World!%N")
		end

end

# Filename: ./DBCByExamplePag36v2/simple_stack.e
note
	description: "Summary description for {SIMPLE_STACK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SIMPLE_STACK [G]


feature -- 1. Basic Queries
	count:INTEGER

	item_at (i:INTEGER) : G
		require
			i_within_boundaries: i >= 1 and i <= count
		deferred
		end

feature -- 2. Derived Queries
	is_empty:BOOLEAN
		deferred
		ensure
			consistent_with_count: Result = (count = 0)
		end

	item:G
		-- the item on the top of the stack
		require
			stack_not_empty: count > 0
		deferred
		ensure
			consistent_with_item_at: Result = item_at(count)
		end
feature -- 3. Creation commands
	initalize
		deferred
		ensure
			stack_is_empty: count = 0
		end

feature -- 4. Other commands
	put(g:G)
		deferred
		ensure
			count_increased: count = old count + 1
			g_on_top: item_at(count)= old g
		end
	remove
		require
			stack_not_empty: count > 0
		deferred
		ensure
			count_decreased: count = old count - 1
		end
invariant
	count_is_never_negative: count >= 0
	
end

# Filename: ./DBCByExamplePag36v2/application.e
note
	description: "DBCByExamplePag36v2 application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			--| Add your code here
			print ("Hello Eiffel World!%N")
		end

end

# Filename: ./libertyEiffel_piramyd/application.e
note
	description: "libertyEiffel_piramyd application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization
	size:INTEGER

	make
			-- Run application.
		do
			if argument_count = 0 then
				std_output.put_string("What to compute a small pyramid? %N Enter asmall number (>1):")
				std_output.flush
				std_input.read_integer
				size := std_input.last_integer
			else
				size := argument(1).to_integer
			end

			if size <= 1 then
				std_output.put_string("You feel sick ? %N")
			elseif size > biggest_one then
				std_output.put_string("Value too big for this method. %N")
			else
				create elem.make_filled(1,max)
				if fill_up(1) then
					std_output.put_string("Full pyramid:%N")
					print_on(std_output)
				else
					std_output.put_string("Unable to fill_up such one. $N")
				end
			end
		end

	max:INTEGER
		do
			Result := size * (size + 1) // 2
		end

	out_in_tagged_out_memory
		local
			lig, col, nb: INTEGER
		do
			from
				lig:=1
				col:=1
				nb:=0
			until
				nb = max
			loop
				if col = 1 then
					tagged_out_memory.extend("%N")
				end
				elem.item(indice(lig,col)).append_in(tagged_out_memory)
				tagged_out_memory.append(" ")
				if col = size - lig + 1 then
					col := 1
					lig := lig + 1
				else
					col := col +1
				end

				nb := nb + 1
			end
			tagged_out_memory.extend('%N')
		end

	belongs_to (nb:INTEGER):BOOLEAN
		require
			too_small: nb >= 1
			too_large: nb <= max
		local
			i:INTEGER
			found: BOOLEAN
		do
			from
				i := 1
			until
				i > max or found
			loop
				found := nb = elem.item(i)
				i := i + 1
			end

			Result := found
		end

	propagate ( col, val_column_1: INTEGER): BOOLEAN
		require
			val_column_1.in_range(1, max)
			col.in_range(1, size)
		local
			stop: BOOLEAN; lig:INTEGER; val:INTEGER
		do
			if belongs_to(val_column_1) then
				Result := false
			else
				from
					elem.put(val_column_1, indice(1, col))
					lig := 1
					val := val_column_1
					stop := False
					Result := True
				until
					stop
				loop
					lig := lig + 1
					if lig > col then
						stop := True
					else
						val := val - elem.item(indice(lig - 1 , col - lig + 1))
						val := val.abs
						if belongs_to(val) then
							clear_column(col)
							stop := True
							Result := False
						else
							elem.put(val, indice(lig,  col - lig + 1))
						end
					end
				end
			end
		end

	fill_up (col:INTEGER):BOOLEAN
		require
			col >= 1
		local
			stop: BOOLEAN; nb:INTEGER
		do
			if col >size then
				Result := True
			else
				from
					stop := false
					nb := max
				until
					stop
				loop
					if belongs_to(nb) then
						nb := nb - 1
						stop := nb = 0
					elseif propagate(col, nb) then
						if fill_up(col + 1) then
							stop := True
						else
							clear_column(col)
							nb := nb - 1
							stop := nb = 0
						end
					else
						nb := nb + 1
						stop := nb = 0
					end
				end
				Result := nb > 0
			end
		end
feature{NONE}
	elem : ARRAY[INTEGER]
	case_vide: INTEGER
	biggest_one:INTEGER
	indice(lig, col :INTEGER):INTEGER
		require
			lig_trop_petit: lig >= 1
			lig_trop_grand: lig <= size
			col_trop_petit: col >= 1
			col_trop_grand: col <= size
		local
			l:INTEGER
		do
			l := size - lig + 1
			Result := max - l * (l+1) // 2 + col
		ensure
			Result >= 1
			Result <= max
		end

	clear_column(col:INTEGER)
		require
			col >= 1
			col <= size
		local
			lig:INTEGER
		do
			from
				lig := 1
			until
				lig > col
			loop
				elem.put(case_vide, indice(lig, col - lig + 1))
				lig := lig + 1
			end
		end
end

# Filename: ./DBCbyExamplePag36/simple_stack.e
+note
	description: "Summary description for {SIMPLE_STACK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class MY_LIST [G] feature

    first : G
    last : G
    extend (new_element: G) : G
        do
            -- Add element to list...
        end

end

# Filename: ./DBCbyExamplePag36/application.e
note
	description: "Summary description for {SIMPLE_STACK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class APPLICATION feature

end

