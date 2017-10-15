extends Node2D

var w = 8
var h = 8

var noise = 10
var count = 24

var island_scn = preload("res://resources/scenes/generators/green_zone/island.tscn")

func _ready():
	randomize()
	place(gen())

func place(array):
	for i in array:
		var s = island_scn.instance()
		s.w = randi()%6+2
		s.position = i*384
		add_child(s)
	$poods.position = Vector2(w/2,h/2)*384-Vector2(0,256)

func gen():
	var islands = []
	islands.append(Vector2(w/2,h/2))
	while true:
		for i in range(w):
			for j in range(h):
				if (!Vector2(i-1,j) in islands and
				    !Vector2(i+1,j) in islands and
				    !Vector2(i,j-1) in islands and
				    !Vector2(i,j+1) in islands and
				    !Vector2(i,j) in islands):
						if randi()%noise == 0:
							islands.append(Vector2(i,j))
		if islands.size() > count:
			break
	return islands