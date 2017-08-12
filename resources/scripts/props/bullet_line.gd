extends Node2D

var bullet_scale = 1

func _ready():
	scale.y = bullet_scale

func _on_Timer_timeout():
	queue_free()
