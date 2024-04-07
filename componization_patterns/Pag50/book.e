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
