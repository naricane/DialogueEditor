@tool
extends Button

@export var graph: GraphEdit
@onready var file_dialog = $FileDialog

@export var speech_node_scene: PackedScene
@export var start_node_scene: PackedScene
@export var character_node_scene: PackedScene

func _ready():
	file_dialog.file_selected.connect(open_graph)
	
func _pressed():
	file_dialog.popup_centered_clamped(Vector2i(800, 600))

func open_graph(path: String):
	var graph_data = ResourceLoader.load(path) as DialogueGraphData
	if not graph_data:
		return
	
	graph.clear_connections()
	for child in graph.get_children():
		if child is GraphNode:
			child.queue_free()

	var nodes_by_id = {}

	for data in graph_data.nodes:
		var node_instance: GraphNode
		
		if data is DialogueNodeSpeechData:
			node_instance = speech_node_scene.instantiate()
			node_instance.set_text(data.text)
			node_instance.set_character(data.character)
		elif data is DialogueNodeStartData:
			node_instance = start_node_scene.instantiate()
			
		graph.add_child(node_instance)
		
		node_instance.position_offset = data.position
		
		nodes_by_id[data.id] = node_instance

	for conn in graph_data.connections:
		var from_id = conn["from_node"]
		var to_id = conn["to_node"]
		
		if nodes_by_id.has(from_id) and nodes_by_id.has(to_id):
			var node_from = nodes_by_id[from_id]
			var node_to = nodes_by_id[to_id]
			
			graph.connect_node(
				node_from.name, conn["from_port"], 
				node_to.name, conn["to_port"]
			)
		
