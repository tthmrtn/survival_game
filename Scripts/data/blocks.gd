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
var leaves : Block = Block.new("Leaves", 7, Vector2i(3,1), 5)
var birch_log : Block = Block.new("Birch Log", 8, Vector2i(0,2), 15)
var stone_brick : Block = Block.new("Stone Brick", 8, Vector2i(1,2), 30)
var stone_brick_wall : Block = Block.new("Stone Brick Wall", 9, Vector2i(2,2), 30)
var stone_brick_slab : Block = Block.new("Stone Brick Slab", 10, Vector2i(3,2), 30)
var chest : Block = Block.new("Chest", 11, Vector2i(0,3), 20)
var moss : Block = Block.new("Moss", 12, Vector2i(1,3), 30)
var torch : Block = Block.new("Torch", 13, Vector2i(2,3), 30)
var iron_ore : Block = Block.new("Iron Ore", 14, Vector2i(3,3), 30)

var enter : Block = Block.new("Enter", 1001, Vector2i(0,0), 0, 1)
var exit : Block = Block.new("Exit", 1002, Vector2i(1,0), 0, 1)
var spawner : Block = Block.new("Spawner", 1003, Vector2i(2,0), 0, 1)

var special_blocks : Array[Block] = [
	enter,
	exit,
	spawner
]

var interactable_blocks : Array[Block] = [
	chest
]

var not_solid_blocks : Array[Block] = [
	air,
	oak_log,
	birch_log,
	leaves,
	chest,
	moss,
	torch
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
	birch_log,
	stone_brick,
	stone_brick_wall,
	stone_brick_slab,
	chest,
	moss,
	torch,
	iron_ore,
	enter,
	exit,
	spawner,
]

func is_special_block(block: Block):
	for sblock in special_blocks:
		if sblock.name == block.name:
			return true
	return false

func is_interactable_block(block: Block):
	for iblock in interactable_blocks:
		if iblock.name == block.name:
			return true
	return false

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
