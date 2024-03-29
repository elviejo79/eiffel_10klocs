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

# Filename: ./libertyEiffel_xml/my_validating_tree.e
note
	description: "Summary description for {MY_VALIDATING_TREE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MY_VALIDATING_TREE

inherit
	XML_TREE
	redefine new_node
	end

create {EXAMPLE2}
	with_error_handler

feature {NONE} -- Initialization

	Tree_tag:UNICODE_STRING
		once
			Result := "Tree"
		end
	Node_tag: UNICODE_STRING
		once
			Result := "node"
		end

	Leaf_tag: UNICODE_STRING
		once
			Result := "leaf"
		end

	new_node(node_name:UNICODE_STRING; line, column: INTEGER): XML_COMPOSITE_NODE
		do
			inspect
				node_name.as_utf8
			when ("tree") then
				if current_node /= void then
					parse_error(line, column, "unexpected node without a parent node")
				else
					create Result.make(Tree_tag, line, column)
				end
			when "node" then
				if current_node = Void or else current_node = Leaf_tag then
					parse_error(line, column, "unexpected node without parent node or with parent being a node leaf")
				else
					create Result.make(Node_tag, line, column)
				end
			when "leaf" then
				if current_node = Void then
					parse_error(line,column,"unexpected leaf without parent node")
				else
					create Result.make(Leaf_tag, line, column)
				end
			end
		end
end

# Filename: ./libertyEiffel_xml/example2.e
note
	description: "Summary description for {EXAMPLE2}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXAMPLE2

inherit
	APPLICATION
	redefine make
	end

create
	make

feature {NONE} -- Initialization

	make
		local
			in: TEXT_FILE_READ;
			tree: MY_VALIDATING_TREE;
			version: UNICODE_STRING
		do
			if argument_count = 0 then
				std_error.put_line("Usage: #(1) <file.xml>")
				die_with_code(1)
			end

			-- first create the stream
			create in.connect_to(argument(1))
			if in.is_connected then
				create tree.with_error_handler(in.url, agent(error(?,?))

				version := tree.attribute_at("version")
				if version /= void then
					io.put_string("XML version")
					io.put_string(version.as_utf8)
					io.put_new_line
				end

				tree.root.accept(Current)
			end
		end

feature -- Access

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end

# Filename: ./libertyEiffel_xml/application.e
note
	description: "libertyEiffel_xml application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	XML_NODE_VISITOR
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
		local
			in: TEXT_FILE_READ;
			tree: XML_TREE;
			version: UNICODE_STRING
		do
			if argument_count = 0 then
				std_error.put_line("Usage: #(1) <file.xml>" # command_name)
				die_with_code(1)
			end

			-- first create the stream
			create in.connect_to(argument(1))
			if (in.is_connected) then
				create tree.with_error_handler(in.url, agent error(?,?))

				version := tree.attribute_at("vesion")
				if version /= Void then
					io.put_string ("XML version:")
					io.put_string (version.as_utf8)
					io.put_new_line
				end

				check
					indent = 0
				end
				tree.root.accept(Current)

			end
		end

	indent: INTEGER

feature {XML_DATA_NODE}
	visit_data_nade (node:XML_DATA_NODE)
	do
		-- data not displayed in this example
	end

feature {XML_COMPOSITE_NODE}
	visit_composite_node(node: XML_COMPOSITE_NODE)
	local
		i, start_indent:INTEGER
	do
		from
			i := 1
		until
			i > indent
		loop
			io.put_string (" ")
			i := i +1
		end

		io.put_string (node.name.as_utf8)

		if node.attributes_count > 0 then
			io.put_character('(')
			from
				i := 1
			until
				i > node.attributes_count
			loop
				if i > 1 then
					io.put_string (",")
				end

				io.put_string (node.attribute_name(i).as_utf8)
				io.put_character ('=')
				io.put_string (node.attribute_value(i).as_utf8)
				i := i + 1
			end

			io.put_character (')')
		end

		io.put_new_line
		from
			start_indent := indent
			indent := start_indent+1
			i := 1
		invariant
			indent = start_index + 1
		until
			i > node.children_count
		loop
			node.child(i).accept(Current)
			i := i + 1
		end

		indent := start_indent
	end

error(line,count : INTEGER)
	do
		std_error.put_string("Error at ")
		std_error.put_integer(line)
		std_error.put_string(",")
		std_error.put_integer(column)
		std_error.put_string( "!%N")
		die_with_code(1)
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

# Filename: ./DBCbyExample_28/simple_stack.e
note
	description: "Summary description for {SIMPLE_STACK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SIMPLE_STACK[G]

feature

	count:STRING

	item_at(i:INTEGER):G
		do
			Result:G 
		end

end

# Filename: ./DBCbyExample_28/application.e
note
	description: "Design by Contract by example code 2.8"
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
			--| Add your code here
			print ("Hello Eiffel World!%N")
		end

end

# Filename: ./libertyEiffel_piramyd/application.e
note
	description: "libertyEiffel_piramyd application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization
	size:INTEGER

	make
			-- Run application.
		do
			if argument_count = 0 then
				std_output.put_string("What to compute a small pyramid? %N Enter asmall number (>1):")
				std_output.flush
				std_input.read_integer
				size := std_input.last_integer
			else
				size := argument(1).to_integer
			end

			if size <= 1 then
				std_output.put_string("You feel sick ? %N")
			elseif size > biggest_one then
				std_output.put_string("Value too big for this method. %N")
			else
				create elem.make_filled(1,max)
				if fill_up(1) then
					std_output.put_string("Full pyramid:%N")
					print_on(std_output)
				else
					std_output.put_string("Unable to fill_up such one. $N")
				end
			end
		end

	max:INTEGER
		do
			Result := size * (size + 1) // 2
		end

	out_in_tagged_out_memory
		local
			lig, col, nb: INTEGER
		do
			from
				lig:=1
				col:=1
				nb:=0
			until
				nb = max
			loop
				if col = 1 then
					tagged_out_memory.extend("%N")
				end
				elem.item(indice(lig,col)).append_in(tagged_out_memory)
				tagged_out_memory.append(" ")
				if col = size - lig + 1 then
					col := 1
					lig := lig + 1
				else
					col := col +1
				end

				nb := nb + 1
			end
			tagged_out_memory.extend('%N')
		end

	belongs_to (nb:INTEGER):BOOLEAN
		require
			too_small: nb >= 1
			too_large: nb <= max
		local
			i:INTEGER
			found: BOOLEAN
		do
			from
				i := 1
			until
				i > max or found
			loop
				found := nb = elem.item(i)
				i := i + 1
			end

			Result := found
		end

	propagate ( col, val_column_1: INTEGER): BOOLEAN
		require
			val_column_1.in_range(1, max)
			col.in_range(1, size)
		local
			stop: BOOLEAN; lig:INTEGER; val:INTEGER
		do
			if belongs_to(val_column_1) then
				Result := false
			else
				from
					elem.put(val_column_1, indice(1, col))
					lig := 1
					val := val_column_1
					stop := False
					Result := True
				until
					stop
				loop
					lig := lig + 1
					if lig > col then
						stop := True
					else
						val := val - elem.item(indice(lig - 1 , col - lig + 1))
						val := val.abs
						if belongs_to(val) then
							clear_column(col)
							stop := True
							Result := False
						else
							elem.put(val, indice(lig,  col - lig + 1))
						end
					end
				end
			end
		end

	fill_up (col:INTEGER):BOOLEAN
		require
			col >= 1
		local
			stop: BOOLEAN; nb:INTEGER
		do
			if col >size then
				Result := True
			else
				from
					stop := false
					nb := max
				until
					stop
				loop
					if belongs_to(nb) then
						nb := nb - 1
						stop := nb = 0
					elseif propagate(col, nb) then
						if fill_up(col + 1) then
							stop := True
						else
							clear_column(col)
							nb := nb - 1
							stop := nb = 0
						end
					else
						nb := nb + 1
						stop := nb = 0
					end
				end
				Result := nb > 0
			end
		end
feature{NONE}
	elem : ARRAY[INTEGER]
	case_vide: INTEGER
	biggest_one:INTEGER
	indice(lig, col :INTEGER):INTEGER
		require
			lig_trop_petit: lig >= 1
			lig_trop_grand: lig <= size
			col_trop_petit: col >= 1
			col_trop_grand: col <= size
		local
			l:INTEGER
		do
			l := size - lig + 1
			Result := max - l * (l+1) // 2 + col
		ensure
			Result >= 1
			Result <= max
		end

	clear_column(col:INTEGER)
		require
			col >= 1
			col <= size
		local
			lig:INTEGER
		do
			from
				lig := 1
			until
				lig > col
			loop
				elem.put(case_vide, indice(lig, col - lig + 1))
				lig := lig + 1
			end
		end
end

