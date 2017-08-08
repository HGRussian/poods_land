extends Particles2D

export var destroy = true

func _ready():
	if destroy:
		$Timer.start()

func destroy():
	queue_free()

func _on_Timer_timeout():
	destroy()
