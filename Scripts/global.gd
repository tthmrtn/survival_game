extends Node


var world_seed

func _ready() -> void:
	world_seed = 10
	
	if (read_save() != null):
		data = read_save()

var json = JSON.new()
var path = "user://data.json"

var data = {}

var WORLDS = []

func save():
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(json.stringify(data))
	file.close()
	file = null

func read_save():
	var file = FileAccess.open(path, FileAccess.READ)
	if (file):
		var content = json.parse_string(file.get_as_text())
		return content
	else:
		save()

func create_new_world(world_name: String):
	randomize()
	WORLDS.append({
		"NAME": world_name,
		"SEED": randi()
		})
	data["worlds"] = WORLDS
	save()

func save_character(character_data):
	data["character"] = character_data
	save()
