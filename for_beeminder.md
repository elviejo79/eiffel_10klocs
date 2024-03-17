# Filename: ./et_inheritance/circle.e
class
    CIRCLE

inherit
    POINT
        rename
            make as point_make
        redefine
            make_origin,
            out
        end
create
    make, make_origin, make_from_point

feature -- Initialization

    make (a_x, a_y, a_r: INTEGER)
            -- Create with values `a_x' and `a_y' and `a_r'
        require
            non_negative_radius_argument: a_r >= 0
        do
            point_make (a_x, a_y)
            set_r (a_r)
        ensure
            x_set: x = a_x
            y_set: y = a_y
            r_set: r = a_r
        end

    make_origin
            -- Create at origin with zero radius
        do
            Precursor
        ensure then
            r_set: r = 0
        end

    make_from_point (a_p: POINT; a_r: INTEGER)
            -- Initialize from `a_r' with radius `a_r'.
        require
            non_negative_radius_argument: a_r >= 0
        do
            set_x (a_p.x)
            set_y (a_p.y)
            set_r (a_r)
        ensure
            x_set: x = a_p.x
            y_set: y = a_p.y
            r_set: r = a_r
        end

feature -- Access

    r: INTEGER assign set_r
            -- Radius

feature -- Element change

    set_r (a_r: INTEGER)
            -- Set radius (`r') to `a_r'
        require
            non_negative_radius_argument: a_r >= 0
        do
            r := a_r
        ensure
            r_set: r = a_r
        end

feature -- Output

    out: STRING
            -- Display as string
        do
            Result := "Circle:  x = " + x.out + "   y = " + y.out + "   r = " + r.out
        end

invariant

    non_negative_radius: r >= 0

end

# Filename: ./et_inheritance/point.e
class
    POINT
inherit
    ANY
        redefine
            out
        end
create
    make, make_origin

feature -- Initialization

    make (a_x, a_y: INTEGER)
            -- Create with values `a_x' and `a_y'
        do
            set_x (a_x)
            set_y (a_y)
        ensure
            x_set: x = a_x
            y_set: y = a_y
        end

    make_origin
            -- Create at origin
        do
        ensure
            x_set: x = 0
            y_set: y = 0
        end

feature -- Access

    x: INTEGER assign set_x
            -- Horizontal axis coordinate

    y: INTEGER assign set_y
            -- Vertical axis coordinate

feature -- Element change

    set_x (a_x: INTEGER)
            -- Set `x' coordinate to `a_x'
        do
            x := a_x
        ensure
            x_set: x = a_x
        end

    set_y (a_y: INTEGER)
            -- Set `y' coordinate to `a_y'
        do
            y := a_y
        ensure
            y_set: y = a_y
        end

feature -- Output

    out: STRING
            -- Display as string
        do
            Result := "Point:   x = " + x.out + "   y = " + y.out
        end
end

# Filename: ./et_inheritance/application.e
class
    APPLICATION

create
    make

feature {NONE} -- Initialization

    make
            -- Run application.
        local
            my_point: POINT
            my_circle: CIRCLE
        do
            create my_point.make_origin
            print (my_point.out + "%N")

            create {CIRCLE} my_point.make_origin
            print (my_point.out + "%N")

            create my_point.make (10, 15)
            print (my_point.out + "%N")

            create {CIRCLE} my_point.make (20, 25, 5)
            print (my_point.out + "%N")

            create my_circle.make (30, 35, 10)
            print (my_circle.out + "%N")

            create my_circle.make_from_point (my_point, 35)
            print (my_circle.out + "%N")
        end

end

# Filename: ./ex_cli/application.e
note
	description: "ex_cli application root class"
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
			 if attached separate_character_option_value ('c') as l_val then
                print ("Command line argument value for option 'c' is: ")
                print (l_val + "%N")
            end
            if attached separate_character_option_value ('h') as l_val then
                print ("Command line argument value for option 'h' is: ")
                print (l_val + "%N")
            end
            io.read_line  -- keep the line open
		end

end

# Filename: ./ex_sieve/application.e
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

# Filename: ./ex_attributes/person.e
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

# Filename: ./ex_attributes/application.e
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

# Filename: ./ex_sleep/application.e
note
	description: "ex_sleep application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			print ("How many nanoseconds (1 seg = 1_000_000_000) should I sleep?%N")
			io.read_integer_64
			print ("Sleeping....%N")
			sleep(io.last_integer_64)
			print("Awake...%N")
		end

end

# Filename: ./ex_reverse/application.e
note
	description: "ex_reverse application root class"
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
			-- Demonstrate string reversal.
		local
			my_string: STRING
		do
			my_string := "Hello World!"
			my_string.mirror
			print(my_string)
		end

end

# Filename: ./ex_fileIO/application.e
note
	description: "ex_fileIO application root class"
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
		local
			input_file: PLAIN_TEXT_FILE
			output_file: PLAIN_TEXT_FILE
		do
			create input_file.make_open_read ("input.txt")
			create output_file.make_open_write ("output.txt")

			from
				input_file.read_character
			until
				input_file.exhausted
			loop
				output_file.put(input_file.last_character)
				input_file.read_character
			end

			input_file.close
			output_file.close
		end

end

# Filename: ./ex_environment_variables/application.e
note
	description: "ex_environment_variables application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			put ("Hello World!", "MY_VARIABLE")
			print(get("MY_VARIABLE"))
		end

end

