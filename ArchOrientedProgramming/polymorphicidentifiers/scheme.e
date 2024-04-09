note
	description: "Summary description for {SCHEME}."
	author: "Alejandro Garcia Fernandez"
	date: "2024-apr-7"
	revision: "1"
	examples:"[
	person
	name
	var:person/name
	var:person/{attribute}
	file://tmp/button.png
	htttp://www.example.com/button.pngg
	file:{env:HOME}/rfcs/{rfcnName}
	]"

deferred class
	SCHEME

	create
		make

	feature --creation
		make alias ":"
		deferred
		end

	feature path_sections:TREE[STRING]
	feature add_root alias "//" (sever_name:STRING):like Current
		require
			server_name_is_valid_url: 

	feature
		add_to_path alias "/" (identifier:STRING):like Current
		require
			identifier_doesnt_have_spaces: not(identifer.has("/") ) and (not (identifier.has" "))
		deferred
		end

end
