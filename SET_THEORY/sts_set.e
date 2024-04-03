note
	description: "Summary description for {STS_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	STS_SET [ELEMENT, EQ->EQUALITY[A]]

--inherit
--	ELEMENT
--		rename
--			is_in as element_is_in,
--			is_not_in as element is_not_in
--		end

feature
	is_empty:BOOLEAN
		deferred
		end

	any:ELEMENT
		-- An arbitrary element in the current set
		require
			set_has_at_least_an_element: not is_empty
		deferred
		end

	others: like subset_anchor
		-- Set that has all the elements except 'any'
		-- | NOTICE: there is no precondition to 'others': if current set is empty `others' is empty too. as stated in the invariant.
		deferred
		end

	eq: EQ
		-- Rule for testing equality between elements in current set
		-- | Notice that the type of `eq' is hard-wired as a generic parameter.
		-- | Though it is not very flexible, the alternative would be to guard with preconditons every feature where two sets are somehow compared.
		-- | in order to check whethec their current equalities are equivalent,
		-- | and this would be rather cumbersome.
		-- | Makinng the equality part of the set type guarentees that only compatible sets are compared at any time.
		-- | with no need for preconditions
		deferred
		end

feature -- Membership
	has alias "∋" (e: ELEMENT): BOOLEAN
		-- Is `e' an element in current set?
		do
			Result := Current |∃ agent equality_holds (e, ?)
		ensure
			definition: Result = (Current |∃ agent equality_holds (e, ?))
		end

end
