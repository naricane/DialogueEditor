extends Node
class_name DialoguePlayer

@export var graph: DialogueGraphData
var current_node_id = "StartNode"

func _ready():
	DialogueEventBus.next_requested.connect(next)
	if graph.start_node:
		current_node_id = graph.start_node.id
		process_current_node()

func start(data: DialogueGraphData):
	graph = data

func next():
	if DialogueEventBus.view_is_busy:
		DialogueEventBus.skip_requested.emit()
		return
	
	var next_id = ""
	
	for conn in graph.connections:
		if conn["from_node"] == current_node_id:
			next_id = conn["to_node"]
			break
	
	if next_id != "":
		current_node_id = next_id
		process_current_node()
	else:
		DialogueEventBus.dialogue_ended.emit()

func process_current_node():
	DialogueEventBus.view_is_busy = true
	var node_data = find_node_by_id(current_node_id)
	
	if node_data is DialogueNodeSpeechData:
		DialogueEventBus.text_updated.emit(node_data.text)

func find_node_by_id(id: String) -> DialogueNodeData:
	for n in graph.nodes:
		if n.id == id:
			return n

	if graph.start_node and graph.start_node.id == id:
		return graph.start_node
	return null
