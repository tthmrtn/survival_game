extends Node
class_name Health_Component

@export var max_health : float = 100
@export var health_bar : ProgressBar
var health : float = max_health

func _ready() -> void:
	health_bar.max_value = max_health
	health_bar.value = max_health

func change_health(value: float):
	health = clamp(health + value, 0, max_health)
	health_bar.value = health
	if health == 0:
		get_parent().queue_free()
