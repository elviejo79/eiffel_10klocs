note
	description: "Summary description for {PERSON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PERSON

	feature -- access
		mood: STRING assign set_mood
			attribute
				Result := "happy"
			end

		set_mood(a_string: STRING)
			require
				single_token: a_string.occurrences (' ') = 0
				do
					mood := a_string
				ensure
					mood_was_set: mood = a_string
				end
end
