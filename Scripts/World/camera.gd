extends Camera2D

@export_category("Following")
@export var target : CharacterBody2D
@export var target_offset : Vector2

@export_category("Zoom Properties")
@export var min_zoom : float = 7
@export var max_zoom : float = 0.417

@export_category("Camera Smoothing")
@export var smooth_following : bool
@export var smooth_zoom : bool

var current_zoom = 1

func _ready() -> void:
	position = target_offset

func _process(_delta: float) -> void:
	zoom = Vector2(current_zoom,current_zoom)
	position = target.position
	offset = (get_global_mouse_position() - position)/4

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("wheel_up"):
			current_zoom = clamp(current_zoom * 1.2, max_zoom, min_zoom)
		elif Input.is_action_just_pressed("wheel_down"):
			
			current_zoom = clamp(current_zoom / 1.2, max_zoom, min_zoom)
