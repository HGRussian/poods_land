extends Node2D

onready var pl = $poods
onready var gen = $green_zone_gen

func _ready():
	var start_room = gen.get_node("start0")
	var start_pos = Vector2(start_room.len/2*32+16,start_room.y_place(start_room.len/2))
	
	pl.position = start_pos
	
	#for 1st room in 1st location
	var a = preload("res://resources/scenes/props/artefact.tscn")
	a = a.instance()
	a.force_rarity = "rare"
	a.force_item = "jetpack"
	a.position.x = start_room.len/2*32+16
	a.position.y = start_room.y_place(start_room.len/2)
	start_room.place_weapon()
	start_room.get_node("pivot").add_child(a)
	