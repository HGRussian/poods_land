extends Node

const LOGO_PREVIEW = 0
const MAIN_MENU = 1
const IN_GAME = 2
const IN_GAME_PAUSE = 3

var main_menu_scn = preload ("res://resources/scenes/main_menu.tscn")

export(int, "LOGO_PREVIEW", "MAIN_MENU", "IN_GAME", "IN_GAME_PAUSE") var start_state = 1
var current_state = -1

func _ready():
	#new_state(start_state)
	pass

func new_state(state):
	if state == LOGO_PREVIEW:
		pass
	elif state == MAIN_MENU:
		if current_state == -1:
			var scn = main_menu_scn.instance()
			root.get_root_node().add_child(scn)
	elif state == IN_GAME:
		pass
	elif state == IN_GAME_PAUSE:
		pass
