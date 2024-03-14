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
