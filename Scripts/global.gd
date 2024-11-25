extends Node

var loaded_world: WorldData
var player_visuals: Dictionary

signal update_worlds_array()

func _ready() -> void:
	if (read_save() != null):
		data = read_save()
		if data.has("worlds"):
			for uid in data["worlds"]:
				var world = WorldData.new()
				world.apply_payload(data["worlds"][uid])
				WORLDS.push_back(world)

var json = JSON.new()
var path = "user://data.json"

var data = {}

var WORLDS: Array[WorldData] = []

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
	var world = WorldData.new()
	world.name = world_name
	world.seed = randi()
	world.uid = _generate_uid()
	WORLDS.append(world)
	data["worlds"] = worlds_to_dict()
	save()
	update_worlds_array.emit()

func save_character(character_data):
	data["character"] = character_data
	save()

func _generate_uid():
	var chars = 'abcdefghijklmnopqrstuvwxyz'
	var uid: String
	var n_char = len(chars)
	for i in range(8):
		uid += chars[randi()% n_char]
	return uid

func worlds_to_dict():
	var dict: Dictionary
	if (WORLDS):
		for world in WORLDS:
			if (world):
				dict[world.uid] = world.export_payload()
	return dict

func dict_to_worlds():
	var worlds: Array[WorldData]
	for world in data["worlds"]:
		var temp = WorldData.new()
		temp.apply_payload(data["worlds"][world])
		worlds.push_back(temp)
	return worlds

func save_loaded_world_data():
	print(worlds_to_dict()["xpvbrnwt"])

func delete_world(uid: String):
	data["worlds"].erase(uid)
	WORLDS = dict_to_worlds()
	save()
	update_worlds_array.emit()

func load_resource(path):
	if path:
		return load(path)
	else:
		return null
