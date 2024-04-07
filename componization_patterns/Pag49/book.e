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
