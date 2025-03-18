extends Node
class_name ITEMS

var stick = Item.new("Stick", load("res://Visuals/Items/Stick.png"), 64, false)
var wood_sword = Item.new("Wood Sword", load("res://Visuals/Items/WoodSword.png"), 1, false)
var wood_pickaxe = Item.new("Wood Pickaxe", load("res://Visuals/Items/WoodPickaxe.png"), 1, false)
var wood_axe = Item.new("Wood Axe", load("res://Visuals/Items/WoodAxe.png"), 1, false)
var iron_sword = Item.new("Iron Sword", load("res://Visuals/Items/IronSword.png"), 1, false)
var iron_pickaxe = Item.new("Iron Pickaxe", load("res://Visuals/Items/IronPickaxe.png"), 1, false)
var iron_axe = Item.new("Iron Axe", load("res://Visuals/Items/IronAxe.png"), 1, false)

var as_array : Array[Item] = [
	stick.copy(),
	wood_sword.copy(),
	wood_pickaxe.copy(),
	wood_axe.copy(),
	iron_sword.copy(),
	iron_pickaxe.copy(),
	iron_axe.copy()
]

#var air : Block = Block.new("Air", -1, Vector2i(-1,-1), 0)
#var grass : Block = Block.new("Grass", 0, Vector2i(0,0), 10)
#var grass_slab : Block = Block.new("Grass Slab", 1, Vector2i(1,0), 10)
#var dirt : Block = Block.new("Dirt", 2, Vector2i(2,0), 10)
#var stone : Block = Block.new("Stone", 3, Vector2i(3,0), 15)
#var dark_stone : Block = Block.new("Dark Stone", 4, Vector2i(0,1), 20)
#var sand : Block = Block.new("Sand", 5, Vector2i(1,1), 10)
#var oak_log : Block = Block.new("Oak Log", 6, Vector2i(2,1), 15)
#var birch_log : Block = Block.new("Birch Log", 8, Vector2i(0,2), 15)
#var leaves : Block = Block.new("Leaves", 7, Vector2i(3,1), 5)


func _ready():
	self.as_array += get_blocks_as_items()
	
	self.recipes = [
		Recipe.new(
			"Log",
			0,
			"Log",
			0, 
			self.stick.copy(), 
			"*|2", 
			"N:M"
		),
		Recipe.new(
			"Stick",
			1,
			"Log",
			1,
			self.wood_sword.copy(), 
			"+|1", 
			"1:1"
		),
		Recipe.new(
			"Stick",
			1,
			"Log",
			2,
			self.wood_axe.copy(), 
			"+|1", 
			"1:1"
		),
		Recipe.new(
			"Stick",
			1,
			"Log",
			3,
			self.wood_pickaxe.copy(), 
			"+|1", 
			"1:1"
		),
	]


func get_blocks_as_items():
	var blocks : Array[Item]
	for block in Blocks.as_array:
		if block.id == -1:
			continue
		var temp_texture = AtlasTexture.new()
		temp_texture.atlas = load("res://Visuals/TileSets/world_basic.png")
		temp_texture.set_region(Rect2i(block.atlas_position.x*16, block.atlas_position.y*16,16,16))
		
		var temp = Item.new(block.name, temp_texture, 64, false)
		blocks.append(temp)
	return blocks

func get_item_by_name(name: String):
	for item in as_array:
		if item.name == name:
			return item.copy()
	return null

func get_item_by_id(id: int):
	if id < 0 or id > as_array.size():
		return null
	return as_array[id].copy()

func is_block_item(item: Item):
	if item == null:
		return false
	for i in get_blocks_as_items():
		if i.name == item.name:
			return true
	return false


var recipes = []
