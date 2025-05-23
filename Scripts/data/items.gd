extends Node
class_name ITEMS

var itemTypes =  {
	wearable = "WEARABLE",
	handheld = "HANDHELD",
	consumable = "CONMSUMABLE",
	block = "BLOCK",
	material = "MATERIAL"
}


var stick = Item.new("Stick", load("res://Visuals/Items/Stick.png"), 64, itemTypes.material)
var wood_sword = Item.new("Wood Sword", load("res://Visuals/Items/WoodSword.png"), 1, itemTypes.handheld, {"attack": 15, "duration": 50})
var wood_pickaxe = Item.new("Wood Pickaxe", load("res://Visuals/Items/WoodPickaxe.png"), 1, itemTypes.handheld, {"attack": 10, "duration": 50})
var wood_axe = Item.new("Wood Axe", load("res://Visuals/Items/WoodAxe.png"), 1, itemTypes.handheld, {"attack": 20, "duration": 50})
var iron_sword = Item.new("Iron Sword", load("res://Visuals/Items/IronSword.png"), 1, itemTypes.handheld, {"attack": 30, "duration": 100})
var iron_pickaxe = Item.new("Iron Pickaxe", load("res://Visuals/Items/IronPickaxe.png"), 1, itemTypes.handheld, {"attack": 10, "duration": 200})
var iron_axe = Item.new("Iron Axe", load("res://Visuals/Items/IronAxe.png"), 1, itemTypes.handheld, {"attack": 35, "duration": 100})
var iron_armor = Item.new("Iron Armor", load("res://Visuals/Items/IronArmor.png"), 1, itemTypes.wearable, {"armor": 15, "wearable_type": "Chestplate"})

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
	
	for item in self.as_array:
		print(item.export_payload())
	
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
			2,
			self.wood_sword.copy(), 
			"+|1", 
			"1:1"
		),
		Recipe.new(
			"Stick",
			2,
			"Log",
			3,
			self.wood_axe.copy(), 
			"+|1", 
			"1:1"
		),
		Recipe.new(
			"Stick",
			2,
			"Log",
			3,
			self.wood_pickaxe.copy(), 
			"+|1", 
			"1:1"
		),
		Recipe.new(
			"Iron Ore",
			4,
			"Stick",
			2,
			self.iron_armor.copy(),
			"+|1",
			"1:1"
			
		)
	]

func getCraftables(item1: Item, item2: Item):
	var craftables: Array[Recipe] = []
	
	for recipe: Recipe in self.recipes:
		if (recipe.canCraft(item1, item2)):
			craftables.push_back(recipe)
	
	return craftables

func get_blocks_as_items():
	var blocks : Array[Item]
	for block in Blocks.as_array:
		if block.id == -1:
			continue
		var temp_texture = AtlasTexture.new()
		temp_texture.atlas = load("res://Visuals/TileSets/world_basic.png" if block.layer == 0 else "res://Visuals/TileSets/world_editor.png")
		temp_texture.set_region(Rect2i(block.atlas_position.x*16, block.atlas_position.y*16,16,16))
		
		var temp = Item.new(block.name, temp_texture, 64,itemTypes.block, block.special)
		blocks.append(temp)
	return blocks

func get_item_by_including_string(str: String):
	var res: Array[Item] = []
	for item in as_array:
		if item.name.contains(str):
			res.push_back(item.copy())
	return res

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
