extends Sprite

var force_rarity = "random"
var rarity 

func art_load():
	randomize()
	if force_rarity == "random":
		rarity = rarity()
	else:
		rarity = force_rarity
	var arts = list_files_in_directory("res://resources/scripts/artefacts/"+rarity)
	var art_script = load("res://resources/scripts/artefacts/"+rarity+"/"+arts[randi()%arts.size()])
	set_script(art_script)

func rarity():
	var n = randi()%100
	var rarity = ""
	if n < 1:
		rarity = "legendary"
	elif n < 10:
		rarity = "ultra"
	elif n < 30:
		rarity = "rare"
	elif n < 50:
		rarity = "normal"
	elif n < 80:
		rarity = "basic"
	else:
		rarity = "junk"
	return rarity

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