extends Node2D

var nodes = 4
var len = 16
var type = ""

var is_art = false

var y_place

func gen():
	for i in nodes+1:
		var radius = clamp(randi()%(len/4)+2,len/nodes,999)
	
		var x = len/nodes*i
		x = clamp(x,radius,len-radius)
		for j in radius:
			circle(x-2+randi()%4,j,radius-j/2)
			circle(x-1+randi()%2,-j/4,radius-j/2)
		for j in radius*1.5:
			circle(x,j,clamp(7-j,2,999))
	var t = get_node("pivot/tile_map")
	for i in len+8:
		for j in len:
			var x = i-4
			var y = j-len/2
			if t.get_cell(x,y) > -1:
				if t.get_cell(x,y-1) == -1:
					t.set_cell(x,y,11)
	
	

### FORM_FUNCS

func circle(x0, y0, r):
	var t = get_node("pivot/tile_map")
	var x=0
	var y=r
	for i in r+1:
		var pi = asin(float(y)/r)
		if abs(r-i) == r:
			pi=pi-(pi/abs(pi))*0.2
		x = cos(pi)*r
		if x-int(x) > 0.75:
			x=int(x)+1
		else: x=int(x)
		for j in range(-x,x):
			t.set_cell(j+x0,y+y0,0)
		t.set_cell(x+x0,y+y0,0)
		t.set_cell(-x+x0,y+y0,0)
		y-=1
		
func _ready():
	randomize()
	$animation_player.set_speed_scale(clamp(randf(),0.2,1))
	if type == "secondroom":
		len = 12
		nodes = 3
	elif type == "thirdroom":
		len = 12
		nodes = 2
	gen()
	y_place = 0
	for i in range(0,32):
			if get_node("pivot/tile_map").get_cell(len/2,-i) == -1:
				y_place = -i*32+32
				break
	if type == "artroom":
		var a = preload("res://resources/scenes/props/artefact.tscn")
		a = a.instance()
		a.position.x = len/2*32
		a.position.y = y_place
		$pivot.add_child(a)
	
	
