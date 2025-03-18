extends CharacterBody2D

@export var velocity_component : Velocity_Component
@export var health_component : Health_Component
@export var inventory : Inventory

var can_move : bool = true

const JUMP_VELOCITY = 200.0

@onready var left_hand_node : Node2D = %Visual_Container.get_node("%Left_Arm_Node")
@onready var right_hand_node : Node2D = %Visual_Container.get_node("%Left_Arm_Node")

@onready var visible_left = left_hand_node
@onready var visible_right = right_hand_node

@onready var skeleton = %Visual_Container.get_node("%Skeleton2D")

func _ready() -> void:
	load_character()

func _input(event: InputEvent) -> void:
	if !can_move || !Global.loaded_world:
		return
	
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
		if velocity_component.get_speed_stage() == "STANDING":
			%AnimationTree["parameters/Movement_Add/add_amount"] = 0
		else:
			%AnimationTree["parameters/Movement_Add/add_amount"] = 1
			if velocity_component.get_speed_stage() == "WALKING":
				%AnimationTree["parameters/walk_or_run/blend_amount"]= 0
			elif velocity_component.get_speed_stage() == "RUNNING":
				%AnimationTree["parameters/walk_or_run/blend_amount"]= 1
		
		Global.data["worlds"][Global.loaded_world.uid]["player_data"]["position"] = {"x": position.x, "y": position.y}
		Global.save()


func _physics_process(delta: float) -> void:
	if velocity.x > 0:
		visible_right = right_hand_node
		visible_left = left_hand_node
	elif velocity.x < 0:
		visible_right = left_hand_node
		visible_left = right_hand_node

func load_character():
	if !Global.data.has("character"):
		return
	#HAIR 
	self.get_node("%Hair").texture = load(CharacterVisuals.HAIR_STYLES[Global.data["character"]["HAIR_STYLE"]])
	self.get_node("%Hair").modulate = Global.data["character"]["HAIR_COLOR"]
	
	#SHIRT
	self.get_node("%Upper_Body_Shirt").texture = Global.load_resource(CharacterVisuals.SHIRT_STYLES[Global.data["character"]["SHIRT_STYLE"]]["UPPER_BODY"])
	self.get_node("%Mid_Body_Shirt").texture = Global.load_resource(CharacterVisuals.SHIRT_STYLES[Global.data["character"]["SHIRT_STYLE"]]["MID_BODY"])
	self.get_node("%Upper_Left_Arm_Shirt").texture = Global.load_resource(CharacterVisuals.SHIRT_STYLES[Global.data["character"]["SHIRT_STYLE"]]["UPPER_LEFT_ARM"])
	self.get_node("%Upper_Right_Arm_Shirt").texture = Global.load_resource(CharacterVisuals.SHIRT_STYLES[Global.data["character"]["SHIRT_STYLE"]]["UPPER_RIGHT_ARM"])
	
	self.get_node("%Upper_Body_Shirt").modulate = Global.data["character"]["SHIRT_COLOR"]
	self.get_node("%Mid_Body_Shirt").modulate = Global.data["character"]["SHIRT_COLOR"]
	self.get_node("%Upper_Left_Arm_Shirt").modulate = Global.data["character"]["SHIRT_COLOR"]
	self.get_node("%Upper_Right_Arm_Shirt").modulate = Global.data["character"]["SHIRT_COLOR"]
	
	#PANTS
	self.get_node("%Lower_Body_Pant").texture = Global.load_resource(CharacterVisuals.PANT_STYLES[Global.data["character"]["PANT_STYLE"]]["LOWER_BODY"])
	self.get_node("%Lower_Left_Leg_Pant").texture = Global.load_resource(CharacterVisuals.PANT_STYLES[Global.data["character"]["PANT_STYLE"]]["LOWER_LEFT_LEG"])
	self.get_node("%Upper_Left_Leg_Pant").texture = Global.load_resource(CharacterVisuals.PANT_STYLES[Global.data["character"]["PANT_STYLE"]]["UPPER_LEFT_LEG"])
	self.get_node("%Lower_Right_Leg_Pant").texture = Global.load_resource(CharacterVisuals.PANT_STYLES[Global.data["character"]["PANT_STYLE"]]["LOWER_RIGHT_LEG"])
	self.get_node("%Upper_Right_Leg_Pant").texture = Global.load_resource(CharacterVisuals.PANT_STYLES[Global.data["character"]["PANT_STYLE"]]["UPPER_RIGHT_LEG"])
	
	self.get_node("%Lower_Body_Pant").modulate = Global.data["character"]["PANT_COLOR"]
	self.get_node("%Lower_Left_Leg_Pant").modulate = Global.data["character"]["PANT_COLOR"]
	self.get_node("%Upper_Left_Leg_Pant").modulate = Global.data["character"]["PANT_COLOR"]
	self.get_node("%Lower_Right_Leg_Pant").modulate = Global.data["character"]["PANT_COLOR"]
	self.get_node("%Upper_Right_Leg_Pant").modulate = Global.data["character"]["PANT_COLOR"]
