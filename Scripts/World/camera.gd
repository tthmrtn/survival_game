extends Camera2D

@export_category("Following")
@export var target : CharacterBody2D
@export var target_offset : Vector2

@export_category("Zoom Properties")
@export var min_zoom : float = 7
@export var max_zoom : float = 0.417
@export var focus_cursor : bool

@export_category("Camera Smoothing")
@export var smooth_following : bool
@export var smooth_zoom : bool

var current_zoom = 4
var target_zoom = current_zoom

func _ready() -> void:
	position = target.position + target_offset
	

func _physics_process(_delta: float) -> void:
	if (smooth_zoom):
		current_zoom = move_toward(current_zoom, target_zoom, 0.1)
	else:
		current_zoom = target_zoom
	zoom = Vector2(current_zoom,current_zoom)
	if (smooth_following):
		position.x = move_toward(position.x, target.position.x, 0.8 + abs(position.x - target.position.x)/80)
		position.y = move_toward(position.y, target.position.y, 0.8 + abs(position.y - target.position.y)/80)
	else:
		position = target.position
	if (focus_cursor):
		var target_offset_position = (get_global_mouse_position() - position)/4
		offset.x = move_toward(offset.x,target_offset_position.x, 5 + abs(position.x - target_offset_position.x)/100)
		offset.y = move_toward(offset.y,target_offset_position.y, 5 + abs(position.x - target_offset_position.x)/100)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("wheel_up"):
			target_zoom = clamp(target_zoom * 1.2, max_zoom, min_zoom)
		elif Input.is_action_just_pressed("wheel_down"):
			target_zoom = clamp(target_zoom / 1.2, max_zoom, min_zoom)
	if Input.is_action_pressed("alt"):
		focus_cursor = true
	if Input.is_action_just_released("alt"):
		focus_cursor = false
		offset = Vector2(0,0)
