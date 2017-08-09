extends Sprite

### BASE CONFIG
var tex = preload("res://resources/art/artefacts/ex_jump.png")
var art_name = "ex_jump"
var desc = "Get another jump!"
var label_name = "Extra Jump"
var rarity = "Basic"
### END

var count = 0
### SELF VARS HERE

###END

func ch_params( who ):
### CHANGING PARAMS HERE
	who.JUMPS+=1
### END

func added():
	var who = get_node("../..")
	set_name(art_name)
	hide()
	count+=1
	ch_params(who)

func repeat():
	var who = get_node("../..")
	count+=1
	ch_params(who)

func _init():
	texture = tex
	$desc.text = desc
	$name.text = label_name
	$rarity.text = rarity
	$rarity.self_modulate = Color(0.5,0.5,0.7)

func picked( who ):
	var artefact_handler = who.get_node("artefact_handler")
	if artefact_handler.has_node(art_name):
		artefact_handler.get_node(art_name).repeat()
	else:
		var to_add = self.duplicate()
		artefact_handler.add_child(to_add)
		to_add.added()
