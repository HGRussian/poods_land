extends Node2D

var shoot 
var shoot_c

func _ready():
	set_process(true)

func _process(delta):
	shoot_c = Input.is_action_pressed("shoot")
	shoot = Input.is_action_just_pressed("shoot")
	
	if get_parent().get_node("tex").flip_h:
		scale.x = -1
	else:
		scale.x = 1
	
	if shoot_c and get_children().size() != 0:
		for i in get_children():
			if i.has_method("shoot"):
				i.shoot()
				

func recoil(recoil):
	get_parent().apply_impulse(Vector2(),-Vector2(scale.x*recoil,0))