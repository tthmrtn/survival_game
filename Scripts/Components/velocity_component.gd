extends Node
class_name Velocity_Component

@export var body : CharacterBody2D
@export var SPEED_STAGES : Dictionary = {"STANDING": 0}

@export var linear_speed : bool
@export var transition_speed : float = 0.1

@export var affected_by_gravity : bool

var current_speed_stage : String = "STANDING"
var current_speed : float = SPEED_STAGES["STANDING"]
var current_direction : Vector2 = Vector2(0,0)

func change_speed(key: String) -> void:
	if SPEED_STAGES.keys().find(key) != -1:
		current_speed_stage = key

func get_speed_stage() -> String:
	return current_speed_stage

func get_speed() -> float:
	return current_speed

func change_direction(direction: Vector2) -> void:
	current_direction = direction.normalized()

func get_direction() -> Vector2:
	return current_direction

func apply_force(direction: Vector2, force: float) -> void:
	body.velocity = direction.normalized() * force

func apply_force_vector(vector: Vector2) -> void:
	body.velocity += vector

func _process(delta: float) -> void:
	if linear_speed:
		current_speed = move_toward(current_speed, SPEED_STAGES[current_speed_stage], transition_speed)
	else:
		current_speed = SPEED_STAGES[current_speed_stage]
	body.velocity.x = current_direction.x * current_speed
	if affected_by_gravity:
		if not body.is_on_floor():
			body.velocity += body.get_gravity() * delta
	body.move_and_slide()
