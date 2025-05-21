extends Node2D

@export var ground_noise : FastNoiseLite
@export var cave_noise : FastNoiseLite
@export var foliage_noise : FastNoiseLite
@export var biome_noise : FastNoiseLite

@export var world_width : int = 500
@export var world_amp : int = 60
@export var bottom_of_world : int = 300

var seed : int = -1
var layers: Array[TileMapLayer]

func _ready() -> void:
	layers.push_back(%Background_Layer)
	layers.push_back(%Main_Layer)
	layers.push_back(%Foreground_Layer)
	
	if Global.loaded_world && Global.loaded_world.seed:
		self.seed = Global.loaded_world.seed
	else:
		self.seed = randi()
	
	ground_noise.seed = self.seed
	cave_noise.seed = self.seed
	foliage_noise.seed = self.seed
	
	for x in range(-world_width,world_width):
		var ground_level = floori(ground_noise.get_noise_1d(x) * world_amp)
		var ground_level_before = floori(ground_noise.get_noise_1d(x - 1) * world_amp)
		var ground_level_after = floori(ground_noise.get_noise_1d(x + 1) * world_amp)
		
		for y in range (ground_level,bottom_of_world):
			if (y <= ground_level + 5):
				if ((!_is_solid(x,y-1) || y == ground_level) && _is_solid(x,y)):
					if ((_is_solid(x-1,y) && (ground_level_after > y || !_is_solid(x-1,y)) )|| (_is_solid(x+1,y) && (ground_level_before > y || !_is_solid(x-1,y)))):
						if biome_noise.get_noise_1d(x) >= 0:
							%Main_Layer.set_cell(Vector2i(x,y),0,Blocks.grass_slab.atlas_position)
						else:
							%Main_Layer.set_cell(Vector2i(x,y),0,Blocks.sand.atlas_position)
					else:
						if biome_noise.get_noise_1d(x) >= 0:
							%Main_Layer.set_cell(Vector2i(x,y),0,Blocks.grass.atlas_position)
						else:
							%Main_Layer.set_cell(Vector2i(x,y),0,Blocks.sand.atlas_position)
				elif(_is_solid(x,y)):
					if biome_noise.get_noise_1d(x) >= 0:
						%Main_Layer.set_cell(Vector2i(x,y),0,Blocks.dirt.atlas_position)
					else:
						%Main_Layer.set_cell(Vector2i(x,y),0,Blocks.sand.atlas_position)
			elif (y > ground_level + 5 && y < bottom_of_world - 100):
				if (_is_solid(x,y)):
					var place: Block
					if foliage_noise.get_noise_2d(x, y) > .7:
						place = Blocks.iron_ore
					else:
						place = Blocks.stone
					
					%Main_Layer.set_cell(Vector2i(x,y),0,place.atlas_position)
			else:
				if (_is_solid(x,y)):
					%Main_Layer.set_cell(Vector2i(x,y),0,Blocks.dark_stone.atlas_position)
	
	#GENERATE BACKGROUND LAYER
	for x in range(-world_width,world_width):
		print(biome_noise.get_noise_1d(x))
		var ground_level = floori(ground_noise.get_noise_1d(x) * world_amp)
		var ground_level_before = floori(ground_noise.get_noise_1d(x - 1) * world_amp)
		var ground_level_after = floori(ground_noise.get_noise_1d(x + 1) * world_amp)
		if ground_level < ground_level_after || ground_level < ground_level_before:
			if biome_noise.get_noise_1d(x) >= 0:
				%Background_Layer.set_cell(Vector2i(x,ground_level),0,Blocks.grass_slab.atlas_position)
			else :
				%Background_Layer.set_cell(Vector2i(x,ground_level),0,Blocks.sand.atlas_position)
		else:
			if biome_noise.get_noise_1d(x) >= 0:
				%Background_Layer.set_cell(Vector2i(x,ground_level),0,Blocks.grass.atlas_position)
			else:
				%Background_Layer.set_cell(Vector2i(x,ground_level),0,Blocks.sand.atlas_position)
		for y in range(1,5):
			if biome_noise.get_noise_1d(x) >= 0:
				%Background_Layer.set_cell(Vector2i(x,ground_level+y),0,Blocks.dirt.atlas_position)
			else:
				%Background_Layer.set_cell(Vector2i(x,ground_level+y),0,Blocks.sand.atlas_position)
		for y in range(ground_level + 5,bottom_of_world-100):
			var place: Block
			if foliage_noise.get_noise_2d(x, y) > .7:
				place = Blocks.iron_ore
			else:
				place = Blocks.stone
			
			%Background_Layer.set_cell(Vector2i(x,y),0,place.atlas_position)
		for y in range(bottom_of_world-100,bottom_of_world):
			%Background_Layer.set_cell(Vector2i(x,y),0,Blocks.dark_stone.atlas_position)
			
	
	#GENERATE FOLIAGE
	for x in range(-world_width,world_width):
		var ground_level = floori(ground_noise.get_noise_1d(x) * world_amp)
		if foliage_noise.get_noise_1d(x) > .5 && foliage_noise.get_noise_1d(x) < .8:
			if (%Main_Layer.get_cell_atlas_coords(Vector2i(x,ground_level)) == Blocks.grass.atlas_position):
				_generate_tree(x,ground_level-1,ground_level%3 + 5)
				
			elif (%Main_Layer.get_cell_atlas_coords(Vector2i(x,ground_level)) == Blocks.grass_slab.atlas_position):
				_generate_tree(x,ground_level,ground_level%3 + 5)
	
	#LOAD PREVIOUS DATA
	_load_world()
	
func _is_solid(x,y):
	if (y > bottom_of_world - 10):
		return true
	if (y > 150):
		return abs(cave_noise.get_noise_2d(x,y)) > .1
	
	return abs(cave_noise.get_noise_2d(x,y)) > .2

func _generate_tree(x,y,height):
	var type = Blocks.birch_log.atlas_position
	if (x+y)%2 == 0:
		type = Blocks.oak_log.atlas_position
	for tree_y in range(0,height):
		%Main_Layer.set_cell(Vector2i(x,y-tree_y),0,type)
	for leaf_x in range(-2,3):
		%Foreground_Layer.set_cell(Vector2i(x+leaf_x,y-height+2),0,Blocks.leaves.atlas_position)
		%Foreground_Layer.set_cell(Vector2i(x+leaf_x,y-height+1),0,Blocks.leaves.atlas_position)
		%Foreground_Layer.set_cell(Vector2i(x+leaf_x,y-height),0,Blocks.leaves.atlas_position)
	for leaf_x in range(-1,2):
		%Foreground_Layer.set_cell(Vector2i(x+leaf_x,y-height-1),0,Blocks.leaves.atlas_position)
	%Main_Layer.set_cell(Vector2i(x,y+1),0,Blocks.grass.atlas_position)

func _load_world():
	if !Global.loaded_world:
		return
	
	var world = Global.loaded_world
	for key: String in world.modified_blocks.keys():
		var x = str_to_var(key.split(",")[0])
		var y = str_to_var(key.split(",")[1])
		for i in range(3):
			if (world.modified_blocks[key][i]):
				layers[i].set_cell(Vector2i(x,y),0,Blocks.get_block_by_name(world.modified_blocks[key][i]).atlas_position)
	
	%Player.position = world.player_data.player_position
