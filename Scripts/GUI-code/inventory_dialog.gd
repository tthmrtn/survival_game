extends Control


@export var columns : int = 6
@export var rows : int = 4

var inventory : Array = []

var _moving_from_slot : Slot = null

func _ready() -> void:
	for child in %Equippable.get_children():
		child.inventory_position = Vector2i(-1,-1)
		child.right_clicked.connect(_on_slot_right_clicked)
	
	
	for y in rows:
		var temp : Array[Slot]
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
			
	for i in range(Items.as_array.size()):
		inventory[floor(i/columns)][i%columns].add_item(Items.as_array[i])

func _on_slot_clicked(slot: Slot) -> void:
	_moving_from_slot = slot

func _on_slot_click_released(slot: Slot) -> void:
	if slot.inventory_position != _moving_from_slot.inventory_position and _moving_from_slot.item and not slot.item:
		slot.add_item(_moving_from_slot.item)
		_moving_from_slot.add_item(null)
		_moving_from_slot = null

func _on_slot_right_clicked(slot: Slot, equipped: bool):
	print(equipped)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory"):
		visible = !visible
