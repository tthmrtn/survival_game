extends Node2D

var depth: int = 20

var layers: Array[TileMapLayer]

var latestEndPointKey: Vector2i = Vector2i(0,0)

func _ready():
	%Terrain_Mod.canbreak = false
	layers = [
		%Background_Layer,
		%Main_Layer,
		%Foreground_Layer
	]
	
	var dungeons = Global.data["dungeons"]
	var dungeonKeys = Global.data["dungeons"].keys()
	
	randomize()
	
	for i in range(depth):
		var randomKey = dungeonKeys[randi() % dungeonKeys.size()]
		
		generate_structure(randomKey, latestEndPointKey)
		print(randomKey)
		pass
	
	pass

func generate_structure(structureKey: String, offset: Vector2i):
	var dungeonData = Global.data["dungeons"][structureKey]
	
	var dungeon : DungeonData = DungeonData.new()
	dungeon.apply_payload(dungeonData)
	
	var offsetedDungeon = dungeon.get_structure_starting_from_position(offset)
	
	latestEndPointKey = dungeon.key_to_vec(offsetedDungeon["exit"])
	#print(offsetedDungeon["enter"])
	
	for key: String in offsetedDungeon["blocks"]:
		var x = str_to_var(key.split(",")[0])
		var y = str_to_var(key.split(",")[1])
		for i in range(3):
			if (offsetedDungeon["blocks"][key][i]):
				var block = Blocks.get_block_by_name(offsetedDungeon["blocks"][key][i])
				if (block.name != "Enter" and block.name != "Exit" and block.name != "Air"):
					layers[i].set_cell(Vector2i(x,y),block.layer,block.atlas_position)
