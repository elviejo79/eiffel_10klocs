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
