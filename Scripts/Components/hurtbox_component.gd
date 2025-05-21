extends Area2D
class_name Hurtbox_Component

@export var health_component : Health_Component

func take_damage(value: float):
	health_component.change_health_by(-value)
