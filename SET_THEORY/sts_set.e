note
	description: "Summary description for {STS_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	STS_SET [ELEMENT, EQ->EQUALITY[ELEMENT]]

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

	is_in alias "∈" (s:SET [ SET [ELEMENT,EQ], EQUALITY [SET [ELEMENT,EQ]]]):BOOLEAN
		-- Does `s' have a current set?
		do
			Result := s ∋ Current
		ensure
			definition: Result = s ∋ Current
		end

	is_not_in alias "∉" (s: SET [SET[ELEMENT,EQ], EQUALITY[SET[ELEMENT,EQ]]]):BOOLEAN
		do
			Result := not (Current ∈ s)
		ensure
			definition: Result = not (Current ∈ s)
		end

	does_not_have alias "∌" (e:ELEMENT):BOOLEAN
		do
			Result := not (Current ∋ e)
		ensure
			definition: Resul = not (Current ∋ e)
		end

feature -- Construction
	with alias "&" (e:ELEMENT): like superset_anchor
	deferred
	ensure
		with_appended_element: Result ∋ e
		nothing_lost: Current |∀ agent Result.has
		nothing_added: Result |∀ agent ored(agent has, agent equality_holds(e,?),?)
	end

	without alias "/" (e:ELEMENT): like subset_anchor
		-- Every element in current set except A
		deferred
		ensure
			does_not_have_element: Result ∌ e
			nothing_lost: Current |∀ agent xored (agent Result.has, agent equality_holds(e,?),?)
			nothing_modified: Result |∀ agent has
		end
feature -- Quality
	is_singleton:BOOLEAN
		do
			Result := not is_empty and others.is_empty
		ensure
			definition: Result = (not is_empty and others.is_empty)
		end

feature -- Measurement
	cardinality alias "#":like natural_anchor
		do
			Result := transformer_to_natural.set_reduction (Current, 0, agent cumulative_succesor)
		ensure
			definition: Result = transformer_to_natural.set_reduction (Current, 0, agent cumulative_succesor)
		end

feature -- Quantifiers
	exists alias "|∃" (p:PREDICATE[ELEMENT]): BOOLEAN
		do
			Result := transformer_to_boolean.set_reduction(Current, False, agent cumulative_disjunction(?,p,?))
		ensure
			definition: Result = transformer_to_boolean.set_reduction(Current, False, agent cumulative_disjunction(?, p, ?))
		end
	for_all alias "|∀" (p:PREDICATE [ELEMENT]): BOOLEAN
		do
			Result := transformer_to_boolean.set_reduction(Current, True, agent cumulative_conjuction(?,p,?))
		ensure
			definition: Result = transformer_to_boolean.set_reduction(Current, True, agent cumulative_conjuction(?,p,?))
		end


feature -- transformers
	transformer_to_boolean: TRANSFORMER[ELEMENT, BOOLEAN, OBJECT_EQUALITY[BOOLEAN]]
				-- Transformer of objects whose types derive from {A} to objects whose types derive from {BOOLEAN}
		deferred
		end
	transformer_to_natural: TRANSFORMER [ELEMENT, like natural_anchor, OBJECT_EQUALITY [like natural_anchor]]
			-- Transformer of objects whose types derive from {A} to objects whose types derive from {like natural_anchor}
		deferred
		end

feature --Anchor
	natural_anchor: NATURAL
			-- Anchor for natural numbers
			--| TODO: Pull it up to a target-dependant class.
		do
		ensure
			class
		end

	set_anchor: SET[ELEMENT, EQ]
		-- Anchor for sets like current one
		-- TODO: Why didn't we use like Current ?
		deferred
		end
	subset_anchor: SET[ELEMENT, EQ]
		-- Anchor for subsets of the current SET
		-- TODO: Again why don't we use like Current, if every subset must be of the same type of elements that the current?
		deferred
		end

	superset_anchor: SET[ELEMENT, EQ]
		--Anchor for the superset
				-- TODO: Again why don't we use like Current, if every subset must be of the same type of elements that the current?
		deferred
		end

end
