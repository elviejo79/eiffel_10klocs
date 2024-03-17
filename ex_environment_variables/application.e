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
