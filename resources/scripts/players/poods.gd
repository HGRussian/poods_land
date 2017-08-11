extends RigidBody2D

# remember some nodes
onready var detectors = $detectors
onready var det_down = detectors.get_node("down")
onready var det_left = detectors.get_node("left")
onready var det_right = detectors.get_node("right")

# dec some stats (need to move on)
var SPEED = 400
var SPRINT_SPEED = 550
var JUMP = 400
var SPRINT_JUMP = 450
var WALL_JUMP_FACTOR = 10
var ACC_FACTOR = 15
var SLIDE_FACTOR = 10
var JUMPS = 1
var STICKINESS = 0.3 # seconds

# some useful vars
var cjumps = 0
var onair_time = 0
var wallslide_time = 0
var rot_target = 0
var rot = 0
var scl = 1
var canim = "idle"
var jump_speed

# input shit
var move_left = false
var move_right = false
var move_jump = false
var move_sprint = false

func _fixed_process(delta):
	var lin_vec = Vector2()
	# making life a bit easier with shorty input vars!
	move_right = Input.is_action_pressed("move_right")
	move_left = Input.is_action_pressed("move_left")
	move_jump = Input.is_action_just_pressed("move_jump")
	move_sprint = Input.is_action_pressed("move_sprint")

	#process mirroring
	if move_left:
		$tex.flip_h=true
		scl=-1
		if wallslide_time > 0 and !det_down.is_colliding():
			$tex.flip_h=false
	elif move_right:
		$tex.flip_h=false
		scl=1
		if wallslide_time > 0 and !det_down.is_colliding():
			$tex.flip_h=true

	# processing floor 
	if det_down.is_colliding():
		if test_motion(Vector2(0,1)):
			cjumps = 0
			onair_time = 0

		#anim
		if abs(linear_velocity.x) > 75:
			if move_left or move_right:
				if move_sprint:
					set_anim("sprint")
				else:
					set_anim("walk")
			else:
				set_anim("brake")
		else:
			set_anim("idle")
		var normal = det_down.get_collision_normal()
		if abs(rot) < 0.8 or move_sprint:
			rot_target = normal.angle() + deg2rad(90)
		else:
			rot_target = 0
	else:
		onair_time+=delta
		if linear_velocity.y > 0:
			rot_target=deg2rad(5)*scl
			if wallslide_time > 0:
				set_anim("stick")
			else:
				set_anim("fall")
		elif linear_velocity.y < 0:
			rot_target=-deg2rad(5)*scl
			set_anim("jump")

	# processing walls
	if det_left.is_colliding() and !det_down.is_colliding():
	# left wall
		wallslide_time+=delta
		var normal = det_left.get_collision_normal()
		if abs(rot) < 0.1:
			rot_target = normal.angle()
		if move_jump:
			linear_damp = -1
			lin_vec.x+=SPEED*WALL_JUMP_FACTOR
			linear_velocity.y=-jump_speed
		if move_right and wallslide_time > STICKINESS and !det_down.is_colliding() and !move_jump: lin_vec.x+=SPEED
		if move_left:
			linear_damp = SLIDE_FACTOR
			if move_jump:
				linear_velocity.y-=jump_speed/2
		else:
			linear_damp = -1
		cjumps = 1
		onair_time = 0
	elif det_right.is_colliding() and !det_down.is_colliding():
	# right wall
		wallslide_time+=delta
		var normal = det_right.get_collision_normal()
		if abs(rot) < 0.1:
			# пожалуйста убейте меня за эту строчку
			# но я понятия не имею как сделать иначе
			# please help
			rot_target = normal.angle() - abs(normal.angle())/normal.angle() * deg2rad(180)
		if move_jump:
			linear_damp = -1
			lin_vec.x-=SPEED*WALL_JUMP_FACTOR
			linear_velocity.y=-jump_speed
		if move_left and wallslide_time > STICKINESS and !det_down.is_colliding() and !move_jump: lin_vec.x-=SPEED
		if move_right:
			linear_damp = SLIDE_FACTOR
			if move_jump:
					linear_velocity.y-=jump_speed/2
		else:
			linear_damp = -1
		cjumps = 1
		onair_time = 0
	else:
	# on_floor controll 
		wallslide_time = 0
		linear_damp = -1
		if move_sprint and !wallslide_time > 0:
			jump_speed = SPRINT_JUMP
			if abs(linear_velocity.x) > 25:
				friction = 0.1
			else:
				friction = 1
			if move_left: lin_vec.x-=SPRINT_SPEED
			if move_right: lin_vec.x+=SPRINT_SPEED
		else:
			jump_speed = JUMP
			if onair_time > 0:
				friction = 0
			else:
				friction = 1
			if move_left: lin_vec.x-=SPEED
			if move_right: lin_vec.x+=SPEED
		if move_jump:
			if cjumps < JUMPS:
				linear_velocity=Vector2(0,-jump_speed).rotated(rot_target)
				cjumps+=1
		# target normal

	# put cooked x lin_vec!
	linear_velocity.x=lerp(linear_velocity.x,lin_vec.x,delta*ACC_FACTOR)
	# rotate poods
	rot = lerp(rot,rot_target,delta*25)
	rotation = rot

func set_anim(anim):
	if canim != anim:
		$anim.play(anim)
		canim = anim

func _ready():
	set_fixed_process(true)
