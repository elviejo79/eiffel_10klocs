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
