extends Sprite

var force_rarity = "random"
var force_item = "random"
var rarity 

func art_load():
	randomize()
	if force_rarity == "random":
		rarity = rarity()
	else:
		rarity = force_rarity
	var arts = list_files_in_directory("res://resources/scripts/artefacts/"+rarity)
	var art_script
	if force_item == "random":
		art_script = load("res://resources/scripts/artefacts/"+rarity+"/"+arts[randi()%arts.size()])
	else:
		art_script = load("res://resources/scripts/artefacts/"+rarity+"/"+force_item+".gd")
	set_script(art_script)

func rarity():
	var rarity = ""
	var n = randi()%100
	if n < 1:
		rarity = "legendary"
		return rarity
	n = randi()%100
	if n < 10:
		rarity = "ultra"
		return rarity
	n = randi()%100
	if n < 30:
		rarity = "rare"
		return rarity
	n = randi()%100
	if n < 50:
		rarity = "normal"
		return rarity
	n = randi()%100
	if n < 80:
		rarity = "basic"
		return rarity
	n = randi()%100
	if n < 101:
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