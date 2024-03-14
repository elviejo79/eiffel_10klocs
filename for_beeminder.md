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

