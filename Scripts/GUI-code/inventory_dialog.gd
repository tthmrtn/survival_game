extends Control
class_name Inventory

signal block_changed(block: Block)

@export var columns : int = 6
@export var rows : int = 4

var inventory : Array = []

var _moving_from_slot : InventorySlot = null

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
	
	for item in Items.as_array:
		print(item.name)
		self.add_item(item, 1)
	
	print(export_payload())


func _on_slot_clicked(slot: InventorySlot) -> void:
	if slot and slot.item:
		_moving_from_slot = slot
		%MovingItem.texture = slot.item.texture

func _on_slot_click_released(slot: InventorySlot) -> void:
	if slot and _moving_from_slot and _moving_from_slot.item and not slot.item and slot.inventory_position != _moving_from_slot.inventory_position:
		slot.add_item(_moving_from_slot.item)
		_moving_from_slot.add_item(null)
	_moving_from_slot = null
	%MovingItem.texture = null

func _on_slot_right_clicked(slot: InventorySlot, equipped: bool):
	if (Items.is_block_item(slot.item)):
		block_changed.emit(Blocks.get_block_by_name(slot.item.name))

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
				#print(inventory[i][j].item.amount)
				print("WANT TO ADD")
				print(want_to_add_amount)
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
	for i in range(data.size()):
		for j in range(data[i].size()):
			if (data[i][j]):
				(self.inventory[i][j] as InventorySlot).add_item(Items.get_item_by_name(data[i][j]["name"]))
				(self.inventory[i][j] as InventorySlot).item.add_amount(data[i][j]["amount"])
