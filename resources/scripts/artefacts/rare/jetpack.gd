extends Sprite

### BASE CONFIG
var tex = preload("res://resources/art/artefacts/jetpack.png")
var art_name = "jetpack"
var desc = "You can fly!"
var label_name = "Jetpack"
var rarity = "Rare"
### END

var count = 0
### SELF VARS HERE
var prop = preload("res://resources/scenes/props/jetpack.tscn")
var jet_node 
var canim = ""
var max_fuel = 100
var fuel = max_fuel
var pop = false
###END

func ch_params( who ):
### CHANGING PARAMS HERE
	max_fuel+=50
	fuel = max_fuel
### END

func _process(delta):
	var who = get_node("../..")
### HANDLING PROCESS
	who.get_node("../UI").set_counter(["Jetpack",int(fuel),max_fuel])

	if who.get_node("tex").flip_h:
		who.get_node("jetpack").scale.x = -1
		who.get_node("jetpack").position.x = 6
	else:
		who.get_node("jetpack").scale.x = 1
		who.get_node("jetpack").position.x = -6
	if jet_node.get_node("anim").get_current_animation() == "init" and jet_node.get_node("anim").is_playing():
		return
	
	if Input.is_action_just_pressed("move_jump"):
		jet_set_anim("start")
		jet_node.get_node("smoke").emitting = true
	if who.onair_time > 0.2 and !pop and who.cjumps == who.JUMPS:
		if Input.is_action_just_pressed("move_jump"):
			pop = true
			jet_set_anim("start")
	elif pop and Input.is_action_pressed("move_jump") and fuel > 0:
		if jet_node.get_node("anim").get_current_animation() == "start" and !jet_node.get_node("anim").is_playing():
			jet_set_anim("fire")
		who.linear_velocity.y = lerp(who.linear_velocity.y,-300,5*delta)
		fuel-=delta*50
	else:
		if who.onair_time == 0:
			pop = false
		elif fuel < 1:
			jet_set_anim("fire")
		else:
			jet_set_anim("idle")
			jet_node.get_node("smoke").emitting = false
			jet_node.get_node("smoke_2").emitting = false
	if fuel < max_fuel:
		fuel+=delta*10
### END

func jet_set_anim(anim):
	
	if canim != anim:
		canim = anim
		jet_node.get_node("anim").play(anim)

func added():
	var who = get_node("../..")
	set_name(art_name)
	hide()
	count+=1
	who.add_child(prop.instance())
	jet_node = who.get_node("jetpack")
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
	$rarity.self_modulate = Color(1,0.3,0.5)

func picked( who ):
	var artefact_handler = who.get_node("artefact_handler")
	if artefact_handler.has_node(art_name):
		artefact_handler.get_node(art_name).repeat()
	else:
		var to_add = self.duplicate()
		artefact_handler.add_child(to_add)
		to_add.added()
