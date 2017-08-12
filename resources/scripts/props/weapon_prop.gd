extends RigidBody2D

export var gun_name = "magnum"
var label_name = ""

var picked = false
var pl_in = false
var pl_body
var gun_scn

func _ready():
	gun_scn = load("res://resources/scenes/weapons/"+gun_name+".tscn")
	$tex.texture = load("res://resources/art/weapons/"+gun_name+"/"+gun_name+".png")
	label_name = gun_scn.instance().label_name
	$Label.text = label_name
	set_process(true)

func _process(delta):
	if pl_in and Input.is_action_just_pressed("pick") and !picked:
		picked = true
		$anim.play("picked")
		$Label.hide()
		pl_body.get_node("weapon_handler").add_weapon(gun_scn)
		yield($anim,"animation_finished")
		queue_free()

func _on_area_body_entered( body ):
	if body.is_in_group("pl") and !picked:
		$Label.show()
		pl_in = true
		pl_body = body

func _on_area_body_exited( body ):
	if body.is_in_group("pl") and !picked:
		$Label.hide()
		pl_in = false
		pl_body = body
