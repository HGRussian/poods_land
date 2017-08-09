extends Sprite

### BASE CONFIG
var tex = preload("res://resources/art/artefacts/ex_jump2.png")
var art_name = "rare_template"
var desc = "does nothing."
var label_name = "Template"
var rarity = "Rare"
### END

var count = 0
### SELF VARS HERE
###END

func ch_params( who ):
### CHANGING PARAMS HERE
	pass
### END

func _process(delta):
	var who = get_node("../..")
### HANDLING PROCESS
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
