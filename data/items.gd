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

func _ready():
	as_array += get_blocks_as_items()
	
	print(as_array.size())

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
	for i in get_blocks_as_items():
		if i.name == item.name:
			return true
	return false
