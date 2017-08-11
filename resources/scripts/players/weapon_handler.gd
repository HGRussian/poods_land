extends Node2D

var shoot 
var shoot_c

var reload_factor = 1
var spread_factor = 1

func _ready():
	update_state()
	set_process(true)

func _process(delta):
	shoot_c = Input.is_action_pressed("shoot")
	shoot = Input.is_action_just_pressed("shoot")
	
	if get_parent().get_node("tex").flip_h:
		scale.x = -1
	else:
		scale.x = 1
	
	var weapons = get_children()
	
	if shoot_c:
		if weapons.size() == 1:
			weapons[0].shoot()
		elif weapons.size() > 1:
			weapons[0].shoot()
			if weapons[0].get_node("reload").get_time_left() < weapons[0].reload/2:
				weapons[1].shoot()

func add_weapon( weapon ):
	var weapons = get_children()
	if weapons.size() < 2 and weapon.instance().double_hand:
		add_child(weapon.instance())
		update_state()
	

func update_state():
	var weapons = get_children()
	if weapons.size() == 1:
		weapons[0].position = Vector2(0,0)
	elif weapons.size() > 1:
		weapons[0].position = Vector2(-5,0)
		weapons[1].position = Vector2(0,0)
		weapons[1].z = -1

func recoil(recoil):
	get_parent().apply_impulse(Vector2(),-Vector2(scale.x*recoil,0))