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
