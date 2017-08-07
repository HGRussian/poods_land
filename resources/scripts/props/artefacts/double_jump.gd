extends Sprite

### BASE CONFIG
var tex = preload("res://resources/art/artefacts/double_jump.png")
var art_name = "double_jump"
var desc = "Extra jump \n Get another jump!"
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
	who.JUMPS+=1
	count+=1
	ch_params(who)

func _init():
	texture = tex
	$desc.text = desc
	#

func picked( who ):
	var artefact_handler = who.get_node("artefact_handler")
	$desc.rect_position.x = -$desc.rect_size.x/2
	if artefact_handler.has_node(art_name):
		artefact_handler.get_node(art_name).repeat()
	else:
		var to_add = self.duplicate()
		artefact_handler.add_child(to_add)
		to_add.added()