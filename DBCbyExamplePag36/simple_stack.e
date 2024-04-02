+note
	description: "Summary description for {SIMPLE_STACK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class MY_LIST [G] feature

    first : G
    last : G
    extend (new_element: G) : G
        do
            -- Add element to list...
        end

end
