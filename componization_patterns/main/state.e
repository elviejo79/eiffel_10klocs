note
	description: "Summary description for {STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATE

create make

feature
	make
	do
		my_state := "free"
	end


feature
	my_state:STRING

feature
	borrow
	require
		the_book_is_free: my_state = "free"
	do
		my_state := "borrowed"
	ensure
		the_book_is_now_borrowed: my_state = "borrowed"
	end

end
