extends KinematicBody2D

const SPEED = 2048

var dir = Vector2.ZERO
var old_pos = Vector2.ZERO

var trace_points = PoolVector2Array([Vector2.ZERO, Vector2.ZERO])

func _ready() -> void:
	old_pos = global_position


func _physics_process(delta: float) -> void:
	if move_and_collide(dir.normalized()*SPEED*delta) != null:
		queue_free()
	trace_points.set(1, global_position - old_pos)
	$trace.points = trace_points
	old_pos = global_position
