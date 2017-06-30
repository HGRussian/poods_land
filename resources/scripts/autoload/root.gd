extends Node

var root_node

func _ready():
	root_node = get_tree().get_current_scene()

func get_root_node():
	return root_node