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
