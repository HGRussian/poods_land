extends RayCast2D

const SPEED = 2048

var dir = Vector2.ZERO
var points = PoolVector2Array([Vector2.ZERO, Vector2.ZERO])
var next_step = Vector2.ZERO

var ex

func _process(delta: float) -> void:
	if next_step != Vector2.ZERO:
		position += next_step
		next_step = Vector2.ZERO
	var d = dir.normalized()*SPEED*delta
	cast_to = d
	if is_colliding():
		if ex != null:
			remove_exception(ex)
		points.set(1, get_collision_point() - global_position)
		print(get_collision_normal())
		if abs(dir.normalized().dot(get_collision_normal())) < 0.5 and get_collision_normal() != Vector2.ZERO: 
			print(dir)
			dir = dir.reflect(Vector2.RIGHT)
			print(dir)
			add_exception(get_collider())
			ex = get_collider()
#			next_step = get_collision_point() - global_position
		else:
			queue_free()
	else:
		points.set(1, d)
		next_step = d
	$trace.points = points
