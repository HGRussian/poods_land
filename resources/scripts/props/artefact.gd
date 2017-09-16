extends Area2D

export(String, "junk", "basic", "normal", "rare", "ultra", "legendary", "random") var force_rarity = "random"
export var force_item = "random"
var picked = false
var pl_in = false
var pl_body

func _ready():
	$artefact.force_rarity = force_rarity
	$artefact.force_item = force_item
	$artefact.art_load()
	set_process(true)

func _process(delta):
	if pl_in and Input.is_action_just_pressed("pick") and !picked:
		picked = true
		$artefact.get_node("desc").hide()
		$artefact.get_node("name").hide()
		$artefact.get_node("rarity").hide()
		$artefact.picked( pl_body )
		$AnimationPlayer.play("pick")
		yield($AnimationPlayer,"animation_finished")
		$artefact.queue_free()
		set_process(false)

func _on_artefact_body_entered( body ):
	if body.is_in_group("pl") and !picked:
		pl_body = body
		pl_in = true
		$artefact.get_node("desc").show()
		$artefact.get_node("name").show()
		$artefact.get_node("rarity").show()


func _on_artefact_body_exited( body ):
	if body.is_in_group("pl") and !picked:
		pl_in = false
		$artefact.get_node("desc").hide()
		$artefact.get_node("name").hide()
		$artefact.get_node("rarity").hide()

