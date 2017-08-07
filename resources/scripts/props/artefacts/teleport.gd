extends Sprite

### BASE CONFIG
var tex = preload("res://resources/art/artefacts/double_jump.png")
var art_name = "teleport"
### END

var count = 0
### SELF VARS HERE
var tele_range = 32
var tele_timeout = 0.0
var tele_first_side = false # true - right, false - left
###END

func ch_params( who ):
### CHANGING PARAMS HERE
	tele_range+=32
### END

func teleport( side ,who): # true - right, false - left
	if side and !who.test_motion(Vector2(tele_range,0)):
		who.position.x+=tele_range
	elif !who.test_motion(Vector2(-tele_range,0)):
		who.position.x-=tele_range

func _process(delta):
	var who = get_node("../..")
### HANDLING PROCESS
	var move_right = Input.is_action_just_pressed("move_right")
	var move_left = Input.is_action_just_pressed("move_left")
	
	if tele_timeout > 0:
		tele_timeout-=delta
	
	if move_left:
		if tele_timeout > 0 and tele_first_side == false:
			teleport(false, who)
		else:
			tele_first_side = false
			tele_timeout = 0.3
	if move_right:
		if tele_timeout > 0 and tele_first_side == true:
			teleport(true, who)
		else:
			tele_first_side = true
			tele_timeout = 0.3
### END

func added():
	var who = get_node("../..")
	set_name(art_name)
	hide()
	count+=1
	ch_params(who)
	set_process(true)

func repeat():
	var who = get_node("../..")
	who.JUMPS+=1
	count+=1
	ch_params(who)

func _init():
	texture = tex

func picked( who ):
	var artefact_handler = who.get_node("artefact_handler")
	if artefact_handler.has_node(art_name):
		artefact_handler.get_node(art_name).repeat()
	else:
		var to_add = self.duplicate()
		artefact_handler.add_child(to_add)
		to_add.added()