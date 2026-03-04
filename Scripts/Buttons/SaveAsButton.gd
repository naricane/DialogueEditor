@tool
extends Button

@export var graph: GraphEdit
@onready var file_dialog = $FileDialog

func _ready():
	file_dialog.file_selected.connect(save_graph)
	
func _pressed():
	file_dialog.popup_centered_clamped(Vector2i(800, 600))

func save_graph(path: String):
	var graph_data = DialogueGraphData.new()
	
	for child in graph.get_children():
		if child is GraphNode:
			var data: DialogueNodeData
			
			if child is SpeechNode:
				data = DialogueNodeSpeechData.new()
				data.text = child.text_edit.text
				data.character = child.get_character_data()
			elif child is StartNode:
				data = DialogueNodeStartData.new()
			
			if data:
				data.id = child.name
				data.position = child.position_offset
				graph_data.nodes.append(data)
	
	graph_data.connections = graph.get_connection_list()
	
	ResourceSaver.save(graph_data, path)
