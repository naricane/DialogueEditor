extends Node

signal next_requested
signal text_updated(speech: String)
signal dialogue_ended

func request_next():
	next_requested.emit()

signal skip_requested 
var view_is_busy: bool = false
	
