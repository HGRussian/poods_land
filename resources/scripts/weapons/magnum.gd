extends Sprite

var spread = 50
var recoil = 60
var reload = 0.3

var smoke_scn = preload("res://resources/scenes/props/shoot_smoke.tscn")
var hit_smoke_scn = preload("res://resources/scenes/props/hit_smoke.tscn")
var bullet_line_scn = preload("res://resources/scenes/props/bullet_line.tscn")

func _ready():
	$reload.wait_time = reload

func shoot():
	if $reload.get_time_left() > 0:
		return
	
	var bullet_line = bullet_line_scn.instance()
	var smoke = smoke_scn.instance()
	var hit_smoke = hit_smoke_scn.instance()
	var scale_x = get_parent().scale.x
	var s_y = randi()%spread
	
	bullet_line.rotation = Vector2().angle_to_point(scale_x*$ray.cast_to)+3.14
	bullet_line.position = $ray.global_position-Vector2(0,2)
	
	$ray.add_child(smoke)
	
	var distance = ($ray.get_collision_point()-$ray.global_position)
	$ray.cast_to.y = s_y-spread/2
	
	$anim.play("shoot")
	
	if $ray.is_colliding():
		bullet_line.scale.x = scale_x*distance.x/3
		hit_smoke.position = distance*scale_x-Vector2(0,2)
		hit_smoke.scale.x*=-1
		
		$ray.add_child(hit_smoke)
		
		get_tree().get_current_scene().add_child(bullet_line)
	else:
		bullet_line.scale.x = 340
		
		get_tree().get_current_scene().add_child(bullet_line)
	
	get_parent().recoil(recoil)
	$reload.start()