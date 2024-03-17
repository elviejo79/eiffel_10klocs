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
