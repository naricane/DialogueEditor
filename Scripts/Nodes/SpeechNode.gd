@tool

extends GraphNode
class_name SpeechNode

@export var text_edit: TextEdit
@export var option_button: OptionButton
var characters: Array[DialogueCharacterData] = []

func set_text(speech: String):
	text_edit.text = speech

func set_character(char_res: DialogueCharacterData):
	if not char_res: return
	
	if characters.is_empty(): 
		refresh_character_list()
	
	for i in range(characters.size()):
		if characters[i].resource_path == char_res.resource_path:
			option_button.selected = i
			return

func _ready():
	pass

func refresh_character_list():
	# TODO
	pass

func get_character_data() -> DialogueCharacterData:
	var idx = option_button.selected
	if idx >= 0 and idx < characters.size():
		return characters[idx]
	return null
