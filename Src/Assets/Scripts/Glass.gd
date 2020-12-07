extends Polygon2D

var damaged = false

func damage(body = null):
	if damaged:
		queue_free()
	else:
		damaged = true
		var a = Area2D.new()
		a.add_child($static/col.duplicate())
		a.collision_mask = $static.collision_mask
		a.collision_layer = $static.collision_layer
		$static.queue_free()
		color = Color(1,1,1)
		add_child(a)
		a.connect("body_entered", self, "damage")
		return a
