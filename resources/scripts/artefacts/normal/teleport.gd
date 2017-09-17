extends Sprite

### BASE CONFIG
var tex = preload("res://resources/art/artefacts/teleport.png")
var art_name = "teleport"
var desc = "Double tap to teleport!"
var label_name = "Fast Teleport"
var rarity = "Normal"
### END

var count = 0
### SELF VARS HERE
var parts = preload("res://resources/scenes/props/particles.tscn")
var check = preload("res://resources/scenes/props/check.tscn")
var tp_dis_sprite = preload("res://resources/scenes/props/teleport_dissolution.tscn")
var ray
var timer
var tele_range = 96
var cooldown = 1.0
var tele_timeout = 0.0
var tele_first_side = false # true - right, false - left
###END

func ch_params( who ):
### CHANGING PARAMS HERE
	tele_range*=1.1
	cooldown*=0.8
	$timer.wait_time = cooldown
### END


func teleport( side ,who): # true - right, false - left
	if side:
		if $check.get_overlapping_bodies().size() == 0:
			var poof = tp_dis_sprite.instance()
			poof.position = who.position
			who.get_parent().add_child(poof)
			var effect = parts.instance()
			who.add_child(effect)
			who.position.x+=tele_range
		else:
			var poof = tp_dis_sprite.instance()
			poof.position = who.position
			who.get_parent().add_child(poof)
			var effect = parts.instance()
			who.add_child(effect)
			who.position.x-= who.position.x-$ray.get_collision_point().x+8
	else:
		if $check.get_overlapping_bodies().size() == 0:
			var poof = tp_dis_sprite.instance()
			poof.position = who.position
			who.get_parent().add_child(poof)
			var effect = parts.instance()
			who.add_child(effect)
			who.position.x-=tele_range
		else:
			var poof = tp_dis_sprite.instance()
			poof.position = who.position
			who.get_parent().add_child(poof)
			var effect = parts.instance()
			who.add_child(effect)
			who.position.x-= who.position.x-$ray.get_collision_point().x-8

func _process(delta):
	var who = get_node("../..")
### HANDLING PROCESS
	who.get_node("../UI").set_counter(["Teleport",int((cooldown-$timer.get_time_left())*100),cooldown*100])
	$ray.global_rotation = 0
	$check.global_rotation = 0
	if who.get_node("tex").flip_h:
		$check.position.x = -tele_range
		$ray.cast_to.x = -tele_range
	else:
		$check.position.x = tele_range
		$ray.cast_to.x = tele_range
	var move_right = Input.is_action_just_pressed("move_right")
	var move_left = Input.is_action_just_pressed("move_left")
	
	if tele_timeout > 0:
		tele_timeout-=delta
	
	if move_left:
		if tele_timeout > 0 and tele_first_side == false:
			if $timer.is_stopped():
				teleport(false, who)
				$timer.start()
		else:
			tele_first_side = false
			tele_timeout = 0.3
	if move_right:
		if tele_timeout > 0 and tele_first_side == true:
			if $timer.is_stopped():
				teleport(true, who)
				$timer.start()
		else:
			tele_first_side = true
			tele_timeout = 0.3
### END

func added():
	var who = get_node("../..")
	set_name(art_name)
	hide()
	count+=1
	ray = RayCast2D.new()
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = cooldown
	timer.set_name("timer")
	ray.enabled = true
	ray.set_name("ray")
	ray.cast_to.y = 0
	add_child(timer)
	add_child(check.instance())
	add_child(ray)
	set_process(true)

func repeat():
	var who = get_node("../..")
	count+=1
	ch_params(who)

func _init():
	texture = tex
	$desc.text = desc
	$name.text = label_name
	$rarity.text = rarity
	$rarity.self_modulate = Color(0.5,0.5,1)

func picked( who ):
	var artefact_handler = who.get_node("artefact_handler")
	if artefact_handler.has_node(art_name):
		artefact_handler.get_node(art_name).repeat()
	else:
		var to_add = self.duplicate()
		artefact_handler.add_child(to_add)
		to_add.added()
