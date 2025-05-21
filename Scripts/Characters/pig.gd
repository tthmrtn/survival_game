extends CharacterBody2D

var count_down = 0;
var tick = 0;

@export var velocity_component : Velocity_Component

const JUMP_VELOCITY = 200.0
var direction = Vector2(0,0);

var drop : Item = Items.get_item_by_name("stick")
var possible_drop_amounts = [1,2,3,4]

func _physics_process(delta: float) -> void:
	if (count_down == 0):
		count_down = randi()%3+5
		direction = Vector2(randi()%3-1,0)
	
	tick += 1
	
	if (tick % 60 == 0):
		count_down -= 1
	
	if (get_tree().root.get_child(0).get_node("%Main_Layer")):
		print("FASZ")
	else:
		print("FASZ2")
	var layer : TileMapLayer = %Main_Layer
	
	if (direction.x == 0):
		velocity_component.change_speed("STANDING")
	else:
		velocity_component.change_speed("WALKING")
	
	%AnimationTree["parameters/idle_or_walk/blend_amount"] = abs(velocity.x) / 10.0
	if (velocity.x >= 0):
		%Visual_Container.scale.x = -1
	else:
		%Visual_Container.scale.x = 1
		
	velocity_component.change_direction(direction)
	
	if (!layer):
		return
	if (Blocks.is_solid(Blocks.get_block_by_atlas_coords(layer.get_cell_atlas_coords(layer.local_to_map(position+direction * 20))))):
		if is_on_floor():
			velocity_component.apply_force(Vector2(0,-1),JUMP_VELOCITY)
	
	
