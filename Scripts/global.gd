extends Node

var loaded_world: WorldData
var loaded_dungeon: DungeonData
var player_visuals: Dictionary

signal update_worlds_array()
signal update_dungeons_array()

func _ready() -> void:
	if (read_save() != null):
		data = read_save()
		if data.has("worlds"):
			for uid in data["worlds"]:
				var world = WorldData.new()
				world.apply_payload(data["worlds"][uid])
				WORLDS.push_back(world)
		if data.has("dungeons"):
			for uid in data["dungeons"]:
				var dungeon = DungeonData.new()
				dungeon.apply_payload(data["dungeons"][uid])
				DUNGEONS.push_back(dungeon)
		if data.has("lang"):
			lang = data["lang"]
	#DUNGEONS = []
	#data["dungeons"] = dungeons_to_dict()
	#save()

var json = JSON.new()
var path = "user://data.json"
var lang = "en"

var data = {}

var WORLDS: Array[WorldData] = []
var DUNGEONS: Array[DungeonData] = []

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

func create_new_dungeon(dungeon_name: String):
	randomize()
	var dungeon = DungeonData.new()
	dungeon.name = dungeon_name
	dungeon.uid = _generate_uid()
	DUNGEONS.append(dungeon)
	data["dungeons"] = dungeons_to_dict()
	save()
	update_dungeons_array.emit()

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

func dungeons_to_dict():
	var dict: Dictionary
	if (DUNGEONS):
		for dungeon in DUNGEONS:
			if (dungeon):
				dict[dungeon.uid] = dungeon.export_payload()
	return dict

func dict_to_worlds() -> Array[WorldData]:
	var worlds: Array[WorldData]
	for world in data["worlds"]:
		var temp = WorldData.new()
		temp.apply_payload(data["worlds"][world])
		worlds.push_back(temp)
	return worlds

func dict_to_dungeons() -> Array[DungeonData]:
	var dungeons: Array[DungeonData]
	for dungeon in data["dungeons"]:
		var temp = DungeonData.new()
		temp.apply_payload(data["dungeons"][dungeon])
		dungeons.push_back(temp)
	return dungeons

func delete_world(uid: String):
	data["worlds"].erase(uid)
	WORLDS = dict_to_worlds()
	save()
	update_worlds_array.emit()

func delete_dungeon(uid: String):
	data["dungeons"].erase(uid)
	DUNGEONS = dict_to_dungeons()
	save()
	update_dungeons_array.emit()

func load_resource(path):
	if path:
		return load(path)
	else:
		return null

func update_structure(coords: Vector2i, layer: TileMapLayer, cell_type: Block):
	var dungeons = dungeons_to_dict()
	
	var key: String = var_to_str(coords.x)+","+var_to_str(coords.y)
	var id = 0
	if layer.name == "Main_Layer":
		id = 1
	elif layer.name == "Foreground_Layer":
		id = 2
	
	if dungeons[loaded_dungeon.uid]["modified_blocks"].has(key):
		dungeons[loaded_dungeon.uid]["modified_blocks"][key][id] = cell_type.name
	else:
		dungeons[loaded_dungeon.uid]["modified_blocks"][key] = [null, null, null]
		dungeons[loaded_dungeon.uid]["modified_blocks"][key][id] = cell_type.name
	
	DUNGEONS = dict_to_dungeons()
	save()
	update_dungeons_array.emit()

func update_world(coords: Vector2i, layer: TileMapLayer, cell_type: Block):
	var worlds = worlds_to_dict()
	
	var key: String = var_to_str(coords.x)+","+var_to_str(coords.y)
	var id = 0
	if layer.name == "Main_Layer":
		id = 1
	elif layer.name == "Foreground_Layer":
		id = 2
	
	if worlds[loaded_world.uid]["modified_blocks"].has(key):
		worlds[loaded_world.uid]["modified_blocks"][key][id] = cell_type.name
	else:
		worlds[loaded_world.uid]["modified_blocks"][key] = [null, null, null]
		worlds[loaded_world.uid]["modified_blocks"][key][id] = cell_type.name
	
	WORLDS = dict_to_worlds()
	save()
	update_worlds_array.emit()

func update_world_player_data(player_data):
	var worlds = worlds_to_dict()
	
	data["worlds"][loaded_world.uid]["player_data"] = player_data
	WORLDS = dict_to_worlds()
	save()

const STATS = {
	"health": {
		"name": "Health",
		"description": "Makes your max health higher (5 hp/level)"
		},
	"attack": {
		"name": "Attack",
		"description": "Makes your attack damage higher (5 power/level)"
		},
	"movement_speed": {
		"name": "Movement speed",
		"description": "Makes your speed higher (5 speed/level)"
		},
	"hunger_fullness": {
		"name": "Hunger fullness",
		"description": "Makes your hunger decrease slower (10 hunger/level)"
	}
}
