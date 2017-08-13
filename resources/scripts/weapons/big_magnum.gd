extends Node2D

var label_name = "Big Magnum"
var gun_name = "big_magnum"
var spread = 40
var recoil = 200
var reload = 0.5
var double_hand = false

var smoke_scn = preload("res://resources/scenes/props/shoot_smoke.tscn")
var hit_smoke_scn = preload("res://resources/scenes/props/hit_smoke.tscn")
var bullet_line_scn = preload("res://resources/scenes/props/bullet_line.tscn")

func _ready():
	update_state()

func update_state():
	reload*=get_parent().reload_factor
	spread*=get_parent().spread_factor
	
	$reload.wait_time = reload

func shoot():
	if $reload.get_time_left() > 0:
		return
	
	var bullet_line = bullet_line_scn.instance()
	var hit_smoke = hit_smoke_scn.instance()
	var scale_x = get_parent().scale.x
	var s_y = randi()%int(spread)
	
	bullet_line.position = $ray.global_position
	bullet_line.bullet_scale = 2
	
	var distance = ($ray.get_collision_point()-$ray.global_position)
	bullet_line.rotation = Vector2().angle_to_point(distance)+3.14
	$ray.cast_to.y = s_y-spread/2
	
	$anim.play("shoot")
	
	if $ray.is_colliding():
		bullet_line.scale.x = scale_x*distance.x/3
		hit_smoke.position = $ray.get_collision_point()-Vector2(0,2)
		hit_smoke.scale.x = -scale_x
		
		get_tree().get_current_scene().add_child(hit_smoke)
		
		get_tree().get_current_scene().add_child(bullet_line)
	else:
		bullet_line.rotation = get_parent().global_rotation
		bullet_line.rotation+= Vector2().angle_to_point($ray.cast_to)+3.14
		bullet_line.scale.x = 340
		
		get_tree().get_current_scene().add_child(bullet_line)
	
	get_parent().recoil(recoil)
	$reload.start()

func after_shoot ():
	var smoke = smoke_scn.instance()
	$'body/smoke_pos'.add_child(smoke) 

func rand_fire(count):
	$'fire_sprite'.frame = randi()%count
