extends Node2D

@export var ground_noise : FastNoiseLite
@export var cave_noise : FastNoiseLite
@export var foliage_noise : FastNoiseLite


@export var world_width : int = 500
@export var world_amp : int = 60
@export var bottom_of_world : int = 300

@export var blocks : BLOCKS

var seed : int = -1

func _ready() -> void:
	ground_noise.seed = Global.loaded_world.seed
	cave_noise.seed = Global.loaded_world.seed
	foliage_noise.seed = Global.loaded_world.seed
	
	for x in range(-world_width,world_width):
		var ground_level = floori(ground_noise.get_noise_1d(x) * world_amp)
		var ground_level_before = floori(ground_noise.get_noise_1d(x - 1) * world_amp)
		var ground_level_after = floori(ground_noise.get_noise_1d(x + 1) * world_amp)
		
		for y in range (ground_level,bottom_of_world):
			if (y <= ground_level + 5):
				if ((!_is_solid(x,y-1) || y == ground_level) && _is_solid(x,y)):
					if ((_is_solid(x-1,y) && (ground_level_after > y || !_is_solid(x-1,y)) )|| (_is_solid(x+1,y) && (ground_level_before > y || !_is_solid(x-1,y)))):
						%Main_Layer.set_cell(Vector2i(x,y),0,blocks.grass_slab.atlas_position)
					else:
						%Main_Layer.set_cell(Vector2i(x,y),0,blocks.grass.atlas_position)
						
				elif(_is_solid(x,y)):
					%Main_Layer.set_cell(Vector2i(x,y),0,blocks.dirt.atlas_position)
			elif (y > ground_level + 5 && y < bottom_of_world - 100):
				if (_is_solid(x,y)):
					%Main_Layer.set_cell(Vector2i(x,y),0,blocks.stone.atlas_position)
			else:
				if (_is_solid(x,y)):
					%Main_Layer.set_cell(Vector2i(x,y),0,blocks.dark_stone.atlas_position)
	
	#GENERATE BACKGROUND LAYER
	for x in range(-world_width,world_width):
		var ground_level = floori(ground_noise.get_noise_1d(x) * world_amp)
		var ground_level_before = floori(ground_noise.get_noise_1d(x - 1) * world_amp)
		var ground_level_after = floori(ground_noise.get_noise_1d(x + 1) * world_amp)
		if ground_level < ground_level_after || ground_level < ground_level_before:
			%Background_Layer.set_cell(Vector2i(x,ground_level),0,blocks.grass_slab.atlas_position)
		else:
			%Background_Layer.set_cell(Vector2i(x,ground_level),0,blocks.grass.atlas_position)
		for y in range(1,5):
			%Background_Layer.set_cell(Vector2i(x,ground_level+y),0,blocks.dirt.atlas_position)
		for y in range(ground_level + 5,bottom_of_world-100):
			%Background_Layer.set_cell(Vector2i(x,y),0,blocks.stone.atlas_position)
		for y in range(bottom_of_world-100,bottom_of_world):
			%Background_Layer.set_cell(Vector2i(x,y),0,blocks.dark_stone.atlas_position)
			
	
	#GENERATE FOLIAGE
	for x in range(-world_width,world_width):
		var ground_level = floori(ground_noise.get_noise_1d(x) * world_amp)
		if foliage_noise.get_noise_1d(x) > .5 && foliage_noise.get_noise_1d(x) < .8:
			if (%Main_Layer.get_cell_atlas_coords(Vector2i(x,ground_level)) == blocks.grass.atlas_position):
				_generate_tree(x,ground_level-1,ground_level%3 + 5)
				
			elif (%Main_Layer.get_cell_atlas_coords(Vector2i(x,ground_level)) == blocks.grass_slab.atlas_position):
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
	var type = blocks.birch_log.atlas_position
	if (x+y)%2 == 0:
		type = blocks.oak_log.atlas_position
	for tree_y in range(0,height):
		%Main_Layer.set_cell(Vector2i(x,y-tree_y),0,type)
	for leaf_x in range(-2,3):
		%Foreground_Layer.set_cell(Vector2i(x+leaf_x,y-height+2),0,blocks.leaves.atlas_position)
		%Foreground_Layer.set_cell(Vector2i(x+leaf_x,y-height+1),0,blocks.leaves.atlas_position)
		%Foreground_Layer.set_cell(Vector2i(x+leaf_x,y-height),0,blocks.leaves.atlas_position)
	for leaf_x in range(-1,2):
		%Foreground_Layer.set_cell(Vector2i(x+leaf_x,y-height-1),0,blocks.leaves.atlas_position)
	%Main_Layer.set_cell(Vector2i(x,y+1),0,blocks.grass.atlas_position)

func _load_world():
	print(Global.loaded_world.modified_blocks)
