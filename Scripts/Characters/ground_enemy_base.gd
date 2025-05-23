extends CharacterBody2D
#
#@export var velocity_component : Velocity_Component
#
#const JUMP_VELOCITY = 200.0
#var direction;
#func _physics_process(delta: float) -> void:
	#
	#direction = Vector2(%Player.position.x - position.x,0).normalized()
	#var layer : TileMapLayer = %Main_Layer
	#
	#if (!will_fall()):
		#if (abs(%Player.position.x - position.x) > 5):
			#velocity_component.change_speed("WALKING")
		#else:
			#velocity_component.change_speed("STANDING")
	#else:
		#velocity_component.change_speed("STANDING")
	#
	#velocity_component.change_direction(direction)
	#
	#
	#if (Blocks.is_solid(Blocks.get_block_by_atlas_coords(layer.get_cell_atlas_coords(layer.local_to_map(position+direction * 10))))):
		#if is_on_floor():
			#velocity_component.apply_force(Vector2(0,-1),JUMP_VELOCITY)
	#
	#
	#
	#pass
#
#func will_fall():
	#var layer : TileMapLayer = %Main_Layer
	#
	#for i in range(2):
		#if (Blocks.is_solid(Blocks.get_block_by_atlas_coords(layer.get_cell_atlas_coords(layer.local_to_map(position+direction * 5) + Vector2i(0,i+1))))):
			#return false
	#return true
