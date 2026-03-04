@tool
extends Button

@export var scene: PackedScene
@export var graph: GraphEdit
var spawn_step = 0

func _pressed():
	var instance = scene.instantiate()
	graph.add_child(instance)
	
	var view_scroll = graph.scroll_offset
	var view_size = graph.size
	var current_zoom = graph.zoom
	
	var screen_center = view_size / 2.0
	
	var graph_center = (screen_center / current_zoom) + (view_scroll / current_zoom)

	var node_half_size = Vector2(100, 50) 
	var final_base_pos = graph_center - node_half_size
	
	var cascade = Vector2(30, 30) * (spawn_step % 5)
	
	instance.position_offset = final_base_pos + cascade
	spawn_step += 1
	
