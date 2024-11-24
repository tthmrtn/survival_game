extends PanelContainer
class_name Slot

signal clicked(slot: Slot)
signal click_released(slot: Slot)
signal right_clicked(slot: Slot, equipped: bool)

var mouse_in : bool = false
var item : Item
var inventory_position : Vector2i

func add_item(item: Item):
	self.item = item
	if (item):
		%Texture.texture = item.texture
	else:
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


func _on_mouse_entered() -> void:
	self.mouse_in = true
	%Panel.modulate = "#ffffff"


func _on_mouse_exited() -> void:
	self.mouse_in = false
	%Panel.modulate = "#000000"
