extends KinematicBody2D

const GRAVITY_VEL = Vector2(0, 128)
const PHYSIC_MUL = 10
const SPEED_WALK_VEL = 256
const SPEED_RUN_VEL = 512
const JUMP_VEL = Vector2(0, -48)

var linear_velocity = Vector2.ZERO

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	# Apply gravity
	linear_velocity += GRAVITY_VEL * delta * PHYSIC_MUL
	
	# Get move vector
	var move_vec = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	
	# Apply move
	var lv = move_vec.x * (SPEED_RUN_VEL if Input.is_action_pressed("run") else SPEED_WALK_VEL) 
	linear_velocity.x = clamp(linear_velocity.x + (lv*delta), -abs(lv), abs(lv))
#	linear_velocity.x = lerp(linear_velocity.x, move_vec.x * (SPEED_RUN_VEL if Input.is_action_pressed("run") else SPEED_WALK_VEL), delta*10)
	
	# Jump
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			linear_velocity.y = JUMP_VEL.y * PHYSIC_MUL
	
	linear_velocity = move_and_slide(linear_velocity, Vector2.UP)
