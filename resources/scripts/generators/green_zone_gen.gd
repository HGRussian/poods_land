extends Node2D

const BOX_W = 32
const BOX_H = 24

var nodes = 6
var second_nodes = 8
var distance = 48
var distance_rand = 16
var boxes

func _ready():
	randomize()
	boxes = gen()
	update()

func gen():
	var gen_boxes = [Vector2(0,0)]
	var box_size = Vector2(BOX_W,BOX_H)
	
	while gen_boxes.size() < nodes:
		var cur_distance = distance+randi()%distance_rand
		var cur_angle = pow(-1,randi()%2)*sin(randf()-0.5)
		var box = gen_boxes[gen_boxes.size()-1]+Vector2(cur_distance,0).rotated(cur_angle)
		box = box.snapped(Vector2(1,1))
		gen_boxes.append(box)
		
	while gen_boxes.size() < second_nodes+nodes:
		var cur_distance = distance+randi()%distance_rand
		var cur_angle = deg2rad(randi()%360)
		var box = gen_boxes[randi()%nodes]+Vector2(cur_distance,0).rotated(cur_angle)
		box = box.snapped(Vector2(1,1))
		var place = true
		for i in gen_boxes:
			if Rect2(i-Vector2(16,16),box_size+Vector2(32,32)).intersects(Rect2(box,box_size)):
				place = false
		if place:
			gen_boxes.append(box)
	
	return gen_boxes

func _draw():
	var box = Vector2(BOX_W,BOX_H)
	var count = 0
	for i in boxes:
		count+=1
		if count <= nodes:
			draw_rect(Rect2(i,box),Color(1,0,0))
		else:
			draw_rect(Rect2(i,box),Color(1,1,0))