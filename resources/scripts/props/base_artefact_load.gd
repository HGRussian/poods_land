extends Sprite

func _ready():
	randomize()
	var arts = list_files_in_directory("res://resources/scripts/props/artefacts")
	var art_script = load("res://resources/scripts/props/artefacts/"+arts[randi()%arts.size()])
	set_script(art_script)

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files