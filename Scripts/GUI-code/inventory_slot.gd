extends PanelContainer
class_name InventorySlot

signal clicked(slot: InventorySlot)
signal click_released(slot: InventorySlot)
signal right_clicked(slot: InventorySlot, equipped: bool)
signal hovering(is_hovering: bool)

var mouse_in : bool = false
var item : Item
var inventory_position : Vector2i
var visible_amount : bool = true

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
	if inventory_position == Vector2i(-1,-1) || !self.get_node("%Amount"): return
	if (item && visible_amount):
		%Amount.text = var_to_str(item.amount)
	else:
		%Amount.text = ""

func remove():
	item = null
	if self.get_node("%Amount"):
		%Amount.text = ""
	%Texture.texture = null

func _on_mouse_entered() -> void:
	self.mouse_in = true
	%Panel.modulate = "#ffffff55"
	hovering.emit(true)


func _on_mouse_exited() -> void:
	self.mouse_in = false
	%Panel.modulate = "#7777779e"
	hovering.emit(false)
