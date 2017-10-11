extends Node2D

const BOX_W = 18
const BOX_H = 9

var nodes = 7
var second_nodes = 8
var third_nodes = 8
var distance = 32
var distance_rand = 8
var boxes
var meta 

var island = preload("res://resources/scenes/generators/green_zone_room.tscn")

func _ready():
	randomize()
	boxes = gen()
	meta = gen_meta(boxes)
	place(boxes,meta)

func gen_meta(gen_boxes):
	var meta = []
	for i in range(gen_boxes.size()):
		if i < nodes:
			if i == 0:
				meta.append("start")
			elif i == nodes-1:
				meta.append("end")
			elif i == nodes/2:
				meta.append("checkpoint")
			elif randi()%(nodes/2) == 0:
				meta.append("artroom")
			else:
				meta.append("keyroom")
		elif i < nodes+second_nodes:
			if randi()%(second_nodes/4) == 0:
				meta.append("artroom")
			else:
				meta.append("secondroom")
		elif i < nodes+second_nodes+third_nodes:
			if randi()%(third_nodes/2) == 0:
				meta.append("artroom")
			else:
				meta.append("thirdroom")
	return meta
	
func gen():
	var gen_boxes = [Vector2(0,0)]
	var box_size = Vector2(BOX_W,BOX_H)
	
	while gen_boxes.size() < nodes:
		var cur_distance = distance+randi()%distance_rand
		var cur_angle = pow(-1,randi()%2)*sin(randf()-0.5)
		var box = gen_boxes[gen_boxes.size()-1]+Vector2(cur_distance,0).rotated(cur_angle)
		box = box.snapped(Vector2(1,1))
		if check_intersect(gen_boxes, box): gen_boxes.append(box)
		
	while gen_boxes.size() < second_nodes+nodes:
		var cur_distance = distance+randi()%distance_rand
		var cur_angle = deg2rad(randi()%360)
		var box = gen_boxes[randi()%nodes]+Vector2(cur_distance,0).rotated(cur_angle)
		box = box.snapped(Vector2(1,1))
		if check_intersect(gen_boxes, box): gen_boxes.append(box)
	
	while gen_boxes.size() < second_nodes+nodes+third_nodes:
		var cur_distance = distance*2+randi()%distance_rand
		var cur_angle = deg2rad(randi()%360)
		var box = gen_boxes[(randi()%second_nodes)+nodes]+Vector2(cur_distance,0).rotated(cur_angle)
		box = box.snapped(Vector2(1,1))
		if check_intersect(gen_boxes, box): gen_boxes.append(box)
	
	return gen_boxes

func check_intersect(gen_boxes, box):
	var box_size = Vector2(BOX_W,BOX_H)
	var place = true
	for i in gen_boxes:
		if Rect2(i-Vector2(8,16),box_size+Vector2(16,32)).intersects(Rect2(box,box_size)):
			place = false
	return place

func place(boxes,meta):
	for i in boxes.size():
		var a = island.instance()
		a.set_name(meta[i]+str(i))
		a.type = meta[i]
		a.nodes = randi()%4+3
		a.position = boxes[i]*32
		add_child(a)