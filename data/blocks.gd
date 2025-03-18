extends Node
class_name BLOCKS

var air : Block = Block.new("Air", -1, Vector2i(-1,-1), 0)
var grass : Block = Block.new("Grass", 0, Vector2i(0,0), 10)
var grass_slab : Block = Block.new("Grass Slab", 1, Vector2i(1,0), 10)
var dirt : Block = Block.new("Dirt", 2, Vector2i(2,0), 10)
var stone : Block = Block.new("Stone", 3, Vector2i(3,0), 15)
var dark_stone : Block = Block.new("Dark Stone", 4, Vector2i(0,1), 20)
var sand : Block = Block.new("Sand", 5, Vector2i(1,1), 10)
var oak_log : Block = Block.new("Oak Log", 6, Vector2i(2,1), 15)
var birch_log : Block = Block.new("Birch Log", 8, Vector2i(0,2), 15)
var leaves : Block = Block.new("Leaves", 7, Vector2i(3,1), 5)

var not_solid_blocks : Array[Block] = [
	air,
	oak_log,
	birch_log,
	leaves
]

func is_solid(block: Block):
	for b in not_solid_blocks:
		if block.name == b.name:
			return false
	return true;

var as_array : Array[Block] = [
	air,
	grass,
	grass_slab,
	dirt,
	stone,
	dark_stone,
	sand,
	oak_log,
	leaves,
	birch_log
]

func get_block_by_atlas_coords(coords: Vector2i) -> Block:
	for block in as_array:
		if block.atlas_position == coords:
			return block
	return null

func get_block_by_name(name: String) -> Block:
	for block in as_array:
		if block.name == name:
			return block
	return null

func get_block_by_id(id: int) -> Block:
	if id < -1 or id > as_array.size()-2:
		return null
	return as_array[id+1]
