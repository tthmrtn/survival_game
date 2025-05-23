extends Camera2D

@export var target : Node2D

@export var smoothing : bool

func _ready() -> void:
	position = target.position

func _process(_delta: float) -> void:
	position = target.position
	if smoothing:
		offset.x = move_toward(offset.x, target.velocity.x / 10, .1)
		offset.y = move_toward(offset.y, target.velocity.y / 10, .1)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("wheel_up"):
			zoom *= 1.2
		if Input.is_action_just_pressed("wheel_down"):
			zoom /= 1.2
