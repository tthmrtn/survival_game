extends CharacterBody2D

@export var velocity_component : Velocity_Component

enum MOVEMENT {
	WALKING = 30,
	RUNNING = 180,
	STANDING = 0
}

var current_speed : float = MOVEMENT.WALKING
@onready var current_movement_speed : int = MOVEMENT.WALKING

const JUMP_VELOCITY = 200.0

@onready var left_hand_node : Node2D = %Right_Arm_Node
@onready var right_hand_node : Node2D = %Left_Arm_Node

func _ready() -> void:
	%TestSword.z_index = 3
	%TestSword.global_position = %Right_Arm_Node.global_position
	%TestSword.global_rotation = %Right_Arm_Node.global_rotation
	%TestSword2.z_index = 1
	%TestSword2.global_position = %Left_Arm_Node.global_position
	%TestSword2.global_rotation = %Left_Arm_Node.global_rotation + PI


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var direction = Vector2(Input.get_axis("left", "right"),0).normalized()
		if direction.x:
			%Skeleton2D.scale.x = direction.x
		velocity_component.change_direction(direction)
		
		#JUMP
		if Input.is_action_pressed("space") and is_on_floor():
			velocity_component.apply_force(Vector2(0,-1),JUMP_VELOCITY)
		
		#SIDEWAYS MOVEMENT
		if direction == Vector2.ZERO:
			velocity_component.change_speed("STANDING")
		else:
			if velocity_component.get_speed_stage() == "STANDING":
				velocity_component.change_speed("WALKING")
			if Input.is_action_pressed("shift") && direction != Vector2.ZERO && velocity_component.get_speed_stage() != "RUNNING":
				velocity_component.change_speed("RUNNING")
			if Input.is_action_just_released("shift") && direction != Vector2.ZERO:
				velocity_component.change_speed("WALKING")
		
		#ANIMATION HANDLING
		print(velocity_component.get_speed_stage())
		if velocity_component.get_speed_stage() == "STANDING":
			%AnimationTree["parameters/Movement_Add/add_amount"] = 0
		else:
			%AnimationTree["parameters/Movement_Add/add_amount"] = 1
			if velocity_component.get_speed_stage() == "WALKING":
				%AnimationTree["parameters/walk_or_run/blend_amount"]= 0
			elif velocity_component.get_speed_stage() == "RUNNING":
				%AnimationTree["parameters/walk_or_run/blend_amount"]= 1
		
				
		


func _physics_process(delta: float) -> void:
	if velocity.x > 0:
		right_hand_node = %Right_Arm_Node
		left_hand_node = %Left_Arm_Node
		%TestSword.z_index = 3
		%TestSword2.z_index = 1
	elif velocity.x < 0:
		right_hand_node = %Left_Arm_Node
		left_hand_node = %Right_Arm_Node
		%TestSword.z_index = 1
		%TestSword2.z_index = 3
	
	if right_hand_node:
		%TestSword.global_position = right_hand_node.global_position
		%TestSword.global_rotation = right_hand_node.global_rotation + PI
	if left_hand_node:
		%TestSword2.global_position = left_hand_node.global_position
		%TestSword2.global_rotation = left_hand_node.global_rotation
		
	#move_and_slide()
