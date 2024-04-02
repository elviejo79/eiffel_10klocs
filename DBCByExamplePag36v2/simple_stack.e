note
	description: "Summary description for {SIMPLE_STACK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SIMPLE_STACK [G]


feature -- 1. Basic Queries
	count:INTEGER

	item_at (i:INTEGER) : G
		require
			i_within_boundaries: i >= 1 and i <= count
		deferred
		end

feature -- 2. Derived Queries
	is_empty:BOOLEAN
		deferred
		ensure
			consistent_with_count: Result = (count = 0)
		end

	item:G
		-- the item on the top of the stack
		require
			stack_not_empty: count > 0
		deferred
		ensure
			consistent_with_item_at: Result = item_at(count)
		end
feature -- 3. Creation commands
	initalize
		deferred
		ensure
			stack_is_empty: count = 0
		end

feature -- 4. Other commands
	put(g:G)
		deferred
		ensure
			count_increased: count = old count + 1
			g_on_top: item_at(count)= old g
		end
	remove
		require
			stack_not_empty: count > 0
		deferred
		ensure
			count_decreased: count = old count - 1
		end
invariant
	count_is_never_negative: count >= 0
	
end
