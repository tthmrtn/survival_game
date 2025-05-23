extends Camera2D
class_name FreeCamera

var clickPos: Vector2
var oldPos: Vector2

func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		if Input.is_action_just_pressed("left_click"):
			oldPos = position
			clickPos = get_global_mouse_position()
		if Input.is_action_just_released("left_click"):
			clickPos = Vector2.ZERO
		if event is InputEventMouseMotion and clickPos != Vector2.ZERO:
			position =  oldPos + (clickPos - get_global_mouse_position())
