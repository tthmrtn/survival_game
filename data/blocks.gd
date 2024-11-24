extends Node
class_name BLOCKS

var air : Block = Block.new("Air", -1, Vector2i(-1,-1))
var grass : Block = Block.new("Grass", 0, Vector2i(0,0))
var grass_slab : Block = Block.new("Grass Slab", 1, Vector2i(1,0))
var dirt : Block = Block.new("Dirt", 2, Vector2i(2,0))
var stone : Block = Block.new("Stone", 3, Vector2i(3,0))
var dark_stone : Block = Block.new("Dark Stone", 4, Vector2i(0,1))
var sand : Block = Block.new("Sand", 5, Vector2i(1,1))
var oak_log : Block = Block.new("Oak Log", 6, Vector2i(2,1))
var leaves : Block = Block.new("Leaves", 7, Vector2i(3,1))
var birch_log : Block = Block.new("Birch Log", 8, Vector2i(0,2))

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
