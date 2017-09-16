extends Node2D

onready var pl = $poods
onready var gen = $green_zone_gen

func _ready():
	var start_room = gen.get_node("start0")
	var start_pos = Vector2(start_room.len/2*32,start_room.y_place)
	
	pl.position = start_pos
