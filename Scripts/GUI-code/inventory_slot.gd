extends PanelContainer
class_name InventorySlot

signal clicked(slot: InventorySlot)
signal click_released(slot: InventorySlot)
signal right_clicked(slot: InventorySlot, equipped: bool)

var mouse_in : bool = false
var item : Item
var inventory_position : Vector2i

func add_item(item: Item):
	if (item):
		self.item = item.copy()
		self.item.amount_updated.connect(update_amount)
		%Texture.texture = item.texture
		update_amount()
	else:
		self.item = null
		%Texture.texture = null

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if mouse_in:
			if Input.is_action_just_pressed("left_click"):
				clicked.emit(self)
			if Input.is_action_just_released("left_click"):
				click_released.emit(self)
			if Input.is_action_just_pressed("right_click"):
				right_clicked.emit(self, inventory_position == Vector2i(-1,-1))

func update_amount():
	if (item):
		%Amount.text = var_to_str(item.amount)
	else:
		%Amount.text = ""

func remove():
	item = null
	%Amount.text = ""
	%Texture.texture = null

func _on_mouse_entered() -> void:
	self.mouse_in = true
	%Panel.modulate = "#ffffff"


func _on_mouse_exited() -> void:
	self.mouse_in = false
	%Panel.modulate = "#000000"
