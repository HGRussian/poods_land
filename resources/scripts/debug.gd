extends CanvasLayer

onready var hat_list = $'player/hat/hat_button'
var player

func _ready():
	$player.visible = false
	player = $'../poods'
	
	var arts
	arts = ['none']
	arts += list_files_in_directory("res://resources/art/players/hats")
	for hat in arts:
		hat_list.add_item(hat)
	var hat_on_player = player.get_node("tex/hat").get_texture().get_path().get_file().get_basename()
	if hat_list.items.has(hat_on_player):
		hat_list.select(hat_list.items.find(hat_on_player)/5)
	else:
		player.get_node("tex/hat").texture = null

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":	break
		elif not file.begins_with(".") and file.ends_with(".png"):
			files.append(file.get_basename())
	dir.list_dir_end()
	return files

func _on_hat_button_item_selected( ID ):
	var path = "res://resources/art/players/hats/" + hat_list.get_item_text(ID) + ".png"
	player.get_node("tex/hat").texture = load(path)
	

func _input(ev):
	if (ev is InputEventKey) and ev.pressed:
			if (ev.scancode == 16777248):		#F5
				$player.visible = not $player.visible
