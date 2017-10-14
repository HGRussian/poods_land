extends Node2D

onready var tile_map = get_node("tile_map")

var w = 4

func _ready():
	randomize()
	gen()

func gen():
	for i in range(w):
		tile_map.set_cell(i,0,0)
		if randi()%3 == 0:
			tile_map.set_cell(i,-1,0)
		if randi()%3 == 0:
			tile_map.set_cell(i,1,0)
	for i in range(w):
		for j in range(-1,2):
			if tile_map.get_cell(i,j) != 0:
				if tile_map.get_cell(i+1,j) == 0 and tile_map.get_cell(i-1,j) == 0:
					tile_map.set_cell(i,j,0)
			if tile_map.get_cell(i,j) == 0:
				if tile_map.get_cell(i,j-1) != 0:
					tile_map.set_cell(i,j-1,1)
					if tile_map.get_cell(i-1,j) != 0:
						tile_map.set_cell(i-1,j-1,18)
					if tile_map.get_cell(i+1,j) != 0:
						tile_map.set_cell(i+1,j-1,17)
				if tile_map.get_cell(i,j+1) != 0:
					tile_map.set_cell(i,j+1,2)
					if tile_map.get_cell(i-1,j) != 0:
						tile_map.set_cell(i-1,j+1,24)
					if tile_map.get_cell(i+1,j) != 0:
						tile_map.set_cell(i+1,j+1,19)
				if tile_map.get_cell(i+1,j) != 0:
					tile_map.set_cell(i+1,j,3)
				if tile_map.get_cell(i-1,j) != 0:
					tile_map.set_cell(i-1,j,8)
	for i in range(w):
		for j in range(-1,2):
			if tile_map.get_cell(i,j) > 0:
				if (tile_map.get_cell(i-1,j) == 0 and
				 tile_map.get_cell(i,j+1) == 0):
					tile_map.set_cell(i,j,9)
					tile_map.set_cell(i,j-1,17)
				if (tile_map.get_cell(i+1,j) == 0 and
				 tile_map.get_cell(i,j+1) == 0):
					tile_map.set_cell(i,j,10)
					tile_map.set_cell(i,j-1,18)
				if (tile_map.get_cell(i-1,j) == 0 and
				 tile_map.get_cell(i,j-1) == 0):
					tile_map.set_cell(i,j,16)
					tile_map.set_cell(i,j+1,19)
				if (tile_map.get_cell(i+1,j) == 0 and
				 tile_map.get_cell(i,j-1) == 0):
					tile_map.set_cell(i,j,11)
					tile_map.set_cell(i,j+1,24)