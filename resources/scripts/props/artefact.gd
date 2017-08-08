extends Area2D

var picked = false
var pl_in = false
var pl_body

func _ready():
	set_process(true)

func _process(delta):
	if pl_in and Input.is_action_just_pressed("pick") and !picked:
		picked = true
		$artefact.picked( pl_body )
		$AnimationPlayer.play("pick")
		yield($AnimationPlayer,"animation_finished")
		$artefact.queue_free()
		set_process(false)

func _on_artefact_body_entered( body ):
	if body.is_in_group("pl") and !picked:
		pl_body = body
		pl_in = true
		$artefact.desc_fix()
		$artefact.get_node("desc").show()


func _on_artefact_body_exited( body ):
	if body.is_in_group("pl") and !picked:
		pl_in = false
		$artefact.get_node("desc").hide()
