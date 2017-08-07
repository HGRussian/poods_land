extends Area2D

var picked = false

func _on_artefact_body_entered( body ):
	if body.is_in_group("pl") and !picked:
		picked = true
		$artefact.picked( body )
		$AnimationPlayer.play("pick")
		yield($AnimationPlayer,"animation_finished")
		$artefact.queue_free()