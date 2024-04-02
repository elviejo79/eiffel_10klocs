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
			when "tree" then
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
