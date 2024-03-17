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
