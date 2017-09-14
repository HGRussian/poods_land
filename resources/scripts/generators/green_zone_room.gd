extends Node2D

var nodes = 6
var len = 32

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
	gen()
