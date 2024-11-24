extends Node
class_name ITEMS

var stick = Item.new("Stick", load("res://Visuals/Items/Stick.png"), 64, false)
var wood_sword = Item.new("Wood Sword", load("res://Visuals/Items/WoodSword.png"), 1, true)
var wood_pickaxe = Item.new("Wood Pickaxe", load("res://Visuals/Items/WoodPickaxe.png"), 1, true)
var wood_axe = Item.new("Wood Axe", load("res://Visuals/Items/WoodAxe.png"), 1, true)
var iron_sword = Item.new("Iron Sword", load("res://Visuals/Items/IronSword.png"), 1, true)
var iron_pickaxe = Item.new("Iron Pickaxe", load("res://Visuals/Items/IronPickaxe.png"), 1, true)
var iron_axe = Item.new("Iron Axe", load("res://Visuals/Items/IronAxe.png"), 1, true)

var as_array : Array[Item] = [
	stick,
	wood_sword,
	wood_pickaxe,
	wood_axe,
	iron_sword,
	iron_pickaxe,
	iron_axe
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
