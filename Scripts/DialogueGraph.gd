@tool
extends GraphEdit

func _on_graph_edit_gui_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_DELETE or event.keycode == KEY_BACKSPACE:
			get_viewport().set_input_as_handled()
			delete_selected_nodes()

func delete_selected_nodes():
	var to_delete = []
	for child in get_children():
		if child is GraphNode and child.selected:
			to_delete.append(child)
	
	for node in to_delete:
		var connections = get_connection_list()
		for c in connections:
			if c.from_node == node.name or c.to_node == node.name:
				disconnect_node(c.from_node, c.from_port, c.to_node, c.to_port)
		
		node.queue_free()

func _ready():
	gui_input.connect(_on_graph_edit_gui_input)
	connection_request.connect(_on_connection_request)
	disconnection_request.connect(_on_disconnection_request)

func _on_connection_request(from_node, from_port, to_node, to_port):
	for connection in get_connection_list():
		if connection.from_node == from_node and connection.from_port == from_port:
			disconnect_node(connection.from_node, connection.from_port, connection.to_node, connection.to_port)
	
	connect_node(from_node, from_port, to_node, to_port)

func _on_disconnection_request(from_node, from_port, to_node, to_port):
	disconnect_node(from_node, from_port, to_node, to_port)
