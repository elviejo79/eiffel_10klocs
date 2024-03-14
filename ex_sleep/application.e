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
