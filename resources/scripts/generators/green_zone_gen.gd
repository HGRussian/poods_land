extends Node2D

const BOX_W = 32
const BOX_H = 24

var nodes = 6
var second_nodes = 8
var third_nodes = 8
var distance = 36
var distance_rand = 16
var boxes
var meta 

func _ready():
	randomize()
	boxes = gen()
	meta = gen_meta(boxes)
	update()

func gen_meta(gen_boxes):
	pass

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

func _draw():
	var box = Vector2(BOX_W,BOX_H)
	var count = 0
	for i in boxes:
		count+=1
		if count <= nodes:
			draw_rect(Rect2(i,box),Color(1,0,0))
		elif count <= second_nodes+nodes:
			draw_rect(Rect2(i,box),Color(1,1,0))
		else:
			draw_rect(Rect2(i,box),Color(1,1,1))