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

@onready var left_hand_node : Node2D = %Visual_Container.get_node("%Left_Arm_Node")
@onready var right_hand_node : Node2D = %Visual_Container.get_node("%Left_Arm_Node")

@onready var visible_left = left_hand_node
@onready var visible_right = right_hand_node

@onready var skeleton = %Visual_Container.get_node("%Skeleton2D")

func _ready() -> void:
	print(skeleton)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var direction = Vector2(Input.get_axis("left", "right"),0).normalized()
		if direction.x:
			skeleton.scale.x = direction.x
			
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
		visible_right = right_hand_node
		visible_left = left_hand_node
	elif velocity.x < 0:
		visible_right = left_hand_node
		visible_left = right_hand_node
