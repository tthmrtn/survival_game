extends CharacterBody2D

@export var velocity_component : Velocity_Component

func _physics_process(delta: float) -> void:
	
	velocity_component.change_speed("WALKING")
	if (get_tree().root.get_child(0).get_node("%Player")):
		print("FASZ")
	else:
		print("FASZ2")
	#%Visual.rotation = (position.angle_to_point(%Player.position))
	
	
	#velocity_component.change_direction(position.direction_to(%Player.position))
