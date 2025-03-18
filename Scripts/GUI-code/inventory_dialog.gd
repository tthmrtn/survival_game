extends Control
class_name Inventory

signal block_changed(block: Block)

@export var columns : int = 6
@export var rows : int = 4

var inventory : Array = []

var _moving_from_slot : InventorySlot = null

var loaded_data = null
var selected_block = null

func _ready() -> void:
	for child in %Equippable.get_children():
		child.inventory_position = Vector2i(-1,-1)
		child.right_clicked.connect(_on_slot_right_clicked)
		child.get_node("%Amount").queue_free()
	
	
	for y in rows:
		var temp : Array[InventorySlot]
		inventory.append(temp)
		for x in columns:
			var slot = preload("res://Visuals/GUI-s/inventory_slot.tscn")
			var instance = slot.instantiate()
			instance.item = null
			instance.clicked.connect(_on_slot_clicked)
			instance.click_released.connect(_on_slot_click_released)
			instance.right_clicked.connect(_on_slot_right_clicked)
			instance.inventory_position = Vector2i(x,y)
			inventory[y].append(instance)
			
			%GridContainer.add_child(instance)
	
	
	if (Global.loaded_world && Global.data["worlds"][Global.loaded_world.uid]["player_data"]["inventory"]):
		loaded_data = Global.data["worlds"][Global.loaded_world.uid]["player_data"]["inventory"]
	if loaded_data:
		for i in range((loaded_data as Array).size()):
			for j in range((loaded_data[i] as Array).size()):
				if (loaded_data[i][j]):
					var dummy_item = Items.get_item_by_name(loaded_data[i][j]["name"])
					
					(inventory[i][j] as InventorySlot).add_item(dummy_item)
					(inventory[i][j] as InventorySlot).item.add_amount(loaded_data[i][j]["amount"])




func add_item(item: Item, amount: int):
	var want_to_add_amount = amount
	var full : bool = true
	
	for i in range(inventory.size()):
		for j in range(inventory[i].size()):
			if !inventory[i][j].item:
				full = false
			if inventory[i][j].item:
				if (inventory[i][j].item as Item).name == item.name:
					want_to_add_amount = (inventory[i][j].item as Item).add_amount(want_to_add_amount)
				if want_to_add_amount == 0:
					return 0
	
	if full:
		return want_to_add_amount
	
	for i in range(inventory.size()):
		for j in range(inventory[i].size()):
			if !inventory[i][j].item:
				
				inventory[i][j].add_item(item.copy())
				want_to_add_amount = inventory[i][j].item.add_amount(want_to_add_amount)
				inventory[i][j].update_amount()
			if want_to_add_amount == 0:
				return 0
	return want_to_add_amount

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory"):
		visible = !visible
	if _moving_from_slot:
		%MovingItem.position = get_global_mouse_position()
	if Input.is_action_just_released("left_click"):
		_moving_from_slot = null
		%MovingItem.texture = null

func export_payload():
	var data = []
	for row in inventory:
		data.append([])
		for column : InventorySlot in row:
			var item = column.item
			if item:
				(data.back() as Array).append(item.export_payload())
			else:
				(data.back() as Array).append(null)
	return data

func apply_payload(data):
	loaded_data = data

func _on_slot_clicked(slot: InventorySlot) -> void:
	if slot and slot.item:
		_moving_from_slot = slot
		%MovingItem.texture = slot.item.texture

func _on_slot_click_released(slot: InventorySlot) -> void:
	if slot and _moving_from_slot and _moving_from_slot.item and not slot.item and slot.inventory_position != _moving_from_slot.inventory_position:
		slot.add_item(_moving_from_slot.item.copy())
		slot.item.add_amount(_moving_from_slot.item.amount)
		_moving_from_slot.add_item(null)
		_moving_from_slot.update_amount()
	if slot and _moving_from_slot and _moving_from_slot.item and slot.item and slot.inventory_position != _moving_from_slot.inventory_position:
		if _moving_from_slot.item.name == slot.item.name:
			_moving_from_slot.item.amount = slot.item.add_amount(_moving_from_slot.item.amount)
			_moving_from_slot.update_amount()
			slot.update_amount()
			
			
	_moving_from_slot = null
	save_inventory()

func _on_slot_right_clicked(slot: InventorySlot, equipped: bool):
	if (Items.is_block_item(slot.item)):
		block_changed.emit(Blocks.get_block_by_name(slot.item.name))

func handle_block_placement(coords: Vector2i, layer: TileMapLayer, cell_type: Block):
	if cell_type.name == Blocks.air.name:
		var block = Blocks.get_block_by_atlas_coords(layer.get_cell_atlas_coords(coords)).name
		var block_item = Items.get_item_by_name(block)
		add_item(block_item, 1)
		save_inventory()
	else:
		
		print("PLACE")
	Global.update_world(coords, layer, cell_type)

func save_inventory():
	Global.data["worlds"][Global.loaded_world.uid]["player_data"]["inventory"] = export_payload()
	Global.save()
