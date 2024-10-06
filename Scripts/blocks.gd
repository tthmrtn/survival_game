extends Node
class_name BLOCKS

@export var BLOCK_IDS : Dictionary = {
	"AIR": Vector2i(-1,-1),
	"GRASS": Vector2i(0,0),
	"GRASS_SLAB": Vector2i(1,0),
	"DIRT": Vector2i(2,0),
	"STONE": Vector2i(3,0),
	"DARK_STONE": Vector2i(0,1),
	"SAND": Vector2i(1,1),
	"OAK_LOG": Vector2i(2,1),
	"LEAVES": Vector2i(3,1),
	"BIRCH_LOG": Vector2i(0,2)
}

func _get_block_atlas_coords_by_name(string: String):
	return BLOCK_IDS[string]

func _get_block_name_by_id(id: int):
	return BLOCK_IDS.keys()[id]

func _get_block_atlas_coords_by_id(id: int):
	return BLOCK_IDS.values()[id]
