extends KinematicBody2D

const GRAVITY_VEL = Vector2(0, 128)
const PHYSIC_MUL = 10
const SPEED_WALK_VEL = 256
const SPEED_RUN_VEL = 384
const JUMP_VEL = Vector2(0, -48)

var linear_velocity = Vector2.ZERO

var wall_slide_delay = 0.0
var is_sliding = false

var bullet_scene = preload('res://Assets/Scenes/Bullet.tscn')
var shoot_cooldown = 0

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	
	# Apply gravity
	if not is_on_floor():
		if is_on_wall() or is_sliding:
			if not ($check_wall_l.is_colliding() or $check_wall_r.is_colliding()):
				wall_slide_delay = 0
				is_sliding = false
				linear_velocity += GRAVITY_VEL * delta * PHYSIC_MUL
			else:
				is_sliding = true
				if linear_velocity.y < 0: # Jump?
					linear_velocity += GRAVITY_VEL * delta * PHYSIC_MUL
				else:
					if linear_velocity.y > 128:
						linear_velocity -= GRAVITY_VEL * delta * PHYSIC_MUL
					else:
						linear_velocity.y = clamp(linear_velocity.y + GRAVITY_VEL.y * delta, 0, 128)
		else:
			wall_slide_delay = 0
			is_sliding = false
			linear_velocity += GRAVITY_VEL * delta * PHYSIC_MUL
		
		if is_sliding:
			if wall_slide_delay < 0.5:
				wall_slide_delay += delta
			else:
				wall_slide_delay = 0
				is_sliding = false
	else:
		linear_velocity += GRAVITY_VEL * delta * PHYSIC_MUL
		wall_slide_delay = 0
		is_sliding = false
	
	# Get move vector
	var move_vec = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	
	# Apply move
	if move_vec.x != 0 and not is_sliding:
		var speed = SPEED_RUN_VEL if Input.is_action_pressed("run") else SPEED_WALK_VEL
		var lv = move_vec.x * speed 
		linear_velocity.x = clamp(linear_velocity.x + (lv*delta*(3 if is_on_floor() else 6)), -abs(lv), abs(lv))
#		linear_velocity.x = clamp(linear_velocity.x + (lv*delta*4), -abs(lv), abs(lv))
	else:
		linear_velocity.x = lerp(linear_velocity.x, 0, delta*10)
	
	# Jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			linear_velocity.y = JUMP_VEL.y * PHYSIC_MUL
		else:
			if is_sliding:
				linear_velocity.y = JUMP_VEL.y * PHYSIC_MUL
				linear_velocity.x = SPEED_RUN_VEL if Input.is_action_pressed("run") else SPEED_WALK_VEL
				if $check_wall_r.is_colliding():
					linear_velocity.x *= -1
				is_sliding = false
				wall_slide_delay = 0
	
	linear_velocity = move_and_slide(linear_velocity, Vector2.UP)
	if abs(linear_velocity.x) < 8.0:
		linear_velocity.x = 0 
	
	if is_on_floor():
		if linear_velocity.x > 32.0: # move right
			if Input.is_action_pressed('move_right'):
				$anim.play('run', 0.2, 1.5 if Input.is_action_pressed("run") else 1.0)
			else:
				$anim.play('brake', 0.2)
			$sprites.scale.x = 1
		elif linear_velocity.x < -32.0:
			if Input.is_action_pressed('move_left'):
				$anim.play('run', 0.2, 1.5 if Input.is_action_pressed("run") else 1.0)
			else:
				$anim.play('brake', 0.2)
			$sprites.scale.x = -1
		else:
			$anim.play('idle')
	else:
		if is_on_wall() or is_sliding:
			$anim.play('sliding')
			if $check_wall_l.is_colliding():
				$sprites.scale.x = 1
			else:
				$sprites.scale.x = -1
		else:
			if linear_velocity.y < 0:
				$anim.play('jump', 0.1)
			else:
				$anim.play('falling', 0.1)
			if linear_velocity.x > 0: # move right
				$sprites.scale.x = 1
			elif linear_velocity.x < 0:
				$sprites.scale.x = -1

func _process(delta):
	if Input.is_action_pressed('shoot') and shoot_cooldown > 0.1:
		shoot_cooldown = 0
		var b = bullet_scene.instance()
		b.position = global_position
		b.dir = Vector2($sprites.scale.x, (randf()-0.5)/5.0)
		get_parent().add_child(b)
		linear_velocity.x -= b.dir.x * 16
	
	shoot_cooldown += delta
