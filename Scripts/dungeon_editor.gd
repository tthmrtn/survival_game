extends Node2D
class_name DungeonEditor

signal block_changed(block: Block)

var structure_name: String
var layers: Array[TileMapLayer]

var loaded_dungeon

func _ready() -> void:
	layers = [
		%Background_Layer,
		%Main_Layer,
		%Foreground_Layer
	]
	
	var sorted = (Items.get_blocks_as_items() as Array[Item])
	sorted.sort_custom(sortSpecialsFirst)
	
	for block in sorted:
		var slot = preload("res://Visuals/GUI-s/inventory_slot.tscn")
		var instance = slot.instantiate()
		instance.item = null
		instance.clicked.connect(_on_slot_clicked)
		instance.visible_amount = false
		instance.hovering.connect(%Terrain_Mod.lock_input)
		instance.add_item(block)
		
		%VBoxContainer.add_child(instance)
	
	%Terrain_Mod.block_placed.connect(handle_block_placed)
	
	loaded_dungeon = Global.loaded_dungeon
	
	_load_structure()

func sortSpecialsFirst(a: Item, b: Item):
	var ab : Block = Blocks.get_block_by_name(a.name)
	var bb : Block = Blocks.get_block_by_name(b.name)
	
	return ab.layer >= bb.layer && ab.id < bb.id

func _on_slot_clicked(slot: InventorySlot):
	block_changed.emit(Blocks.get_block_by_name(slot.item.name))

func handle_block_placed(coords: Vector2i, layer: TileMapLayer, cell_type: Block):
	Global.update_structure(coords, layer, cell_type)

func _input(event):
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://Visuals/GUI-s/main_menu.tscn")
	
	if Input.is_action_just_pressed("space"):
		var defEnter = loaded_dungeon.key_to_vec(loaded_dungeon.enterKey)
		var relative = loaded_dungeon.get_structure_offseted(-defEnter)

func _load_structure():
	if !Global.loaded_dungeon && loaded_dungeon:
		return
	
	var dungeon = loaded_dungeon
	for key: String in dungeon.modified_blocks.keys():
		var x = str_to_var(key.split(",")[0])
		var y = str_to_var(key.split(",")[1])
		for i in range(3):
			if (dungeon.modified_blocks[key][i]):
				var block = Blocks.get_block_by_name(dungeon.modified_blocks[key][i])
				layers[i].set_cell(Vector2i(x,y),block.layer,block.atlas_position)
				if (block.name == Blocks.torch.name):
					var torch = preload("res://Objects/torch_light.tscn")
					var torchInstance = torch.instantiate()
					torchInstance.position = %Main_Layer.map_to_local(Vector2i(x,y))
					torchInstance.name = key
					%Torches.add_child(torchInstance)
	
