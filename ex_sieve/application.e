note
	description: "ex_sieve application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature -- Initialization

	make
			-- Run application.
		do
			across primes_generator(100) as ic loop print(ic.item.out + ", ") end
		end

	primes_generator(a_limit: INTEGER): LINKED_LIST[INTEGER]
		require
			a_positive_limit : a_limit >= 2
		local
			l_tab : ARRAY[BOOLEAN]
		do
			create Result.make
			create l_tab.make_filled (True, 2, a_limit)
			across l_tab as ic loop
				if ic.item then
					Result.extend(ic.target_index)
					across ((ic.target_index * ic.target_index) |..| l_tab.upper).new_cursor.with_step (ic.target_index) as id
					loop
						l_tab[id.item] := False
					end

				end
			end
		end
end
