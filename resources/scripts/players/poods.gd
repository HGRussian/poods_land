extends RigidBody2D

# remember some nodes
onready var det_up = $detectors/up
onready var det_down = $detectors/down
onready var det_left = $detectors/left
onready var det_right = $detectors/right

# dec some stats (need to move on)
var SPEED = 400
var JUMP = 500
var WALL_JUMP_FACTOR = 10
var ACC_FACTOR = 15
var SLIDE_FACTOR = 10
var JUMPS = 2
var STICKINESS = 0.3 # seconds

# some useful vars
var cjumps = 0
var onair_time = 0
var wallslide_time = 0
var rot_target = 0
var rot = 0
var scl = 1

# input shit
var move_left = false
var move_right = false
var move_jump = false
	
func _fixed_process(delta):
	var lin_vec = Vector2()
	# making life a bit easier with shorty input vars!
	move_right = Input.is_action_pressed("move_right")
	move_left = Input.is_action_pressed("move_left")
	move_jump = Input.is_action_just_pressed("move_jump")
	
	#process mirroring
	if move_left: 
		$tex.flip_h=true
		scl=-1
	if move_right: 
		$tex.flip_h=false
		scl=1
	
	# processing floor 
	if det_down.is_colliding():
		if onair_time > 0.1:
			cjumps = 0
		onair_time = 0
		var normal = det_down.get_collision_normal()
		if abs(rotation) < 0.5:
			rot_target = normal.angle() + deg2rad(90)
	else:
		onair_time+=delta
		if linear_velocity.y > 0:
			rot_target=deg2rad(10)*scl
		elif linear_velocity.y < 0:
			rot_target=-deg2rad(10)*scl
	
	# processing walls
	if det_left.is_colliding():
	# left wall
		wallslide_time+=delta
		if move_jump: 
			linear_damp = -1
			lin_vec.x+=SPEED*WALL_JUMP_FACTOR
			linear_velocity.y=-JUMP
		if move_right and wallslide_time > STICKINESS: lin_vec.x+=SPEED
		if move_left: 
			linear_damp = SLIDE_FACTOR
			if move_jump:
				linear_velocity.y-=JUMP/2
		else:
			linear_damp = -1
		cjumps = 0
		onair_time = 0
	elif det_right.is_colliding():
	# right wall
		wallslide_time+=delta
		if move_jump: 
			linear_damp = -1
			lin_vec.x-=SPEED*WALL_JUMP_FACTOR
			linear_velocity.y=-JUMP
		if move_left and wallslide_time > STICKINESS: lin_vec.x-=SPEED
		if move_right:
			linear_damp = SLIDE_FACTOR
			if move_jump:
					linear_velocity.y-=JUMP/2
		else:
			linear_damp = -1
		cjumps = 0
		onair_time = 0
	else:
	# on_floor controll 
		wallslide_time = 0
		linear_damp = -1
		if move_left: lin_vec.x-=SPEED
		if move_right: lin_vec.x+=SPEED
		if move_jump:
			if cjumps < JUMPS:
				linear_velocity.y=-JUMP
				cjumps+=1
		# target normal

	# put cooked x lin_vec!
	linear_velocity.x=lerp(linear_velocity.x,lin_vec.x,delta*ACC_FACTOR)
	# rotate poods
	rot = lerp(rot,rot_target,delta*10)
	rotation = rot

func _ready():
	set_fixed_process(true)