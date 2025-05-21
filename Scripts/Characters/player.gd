extends CharacterBody2D
class_name Player

@export var velocity_component : Velocity_Component
@export var health_component : Health_Component
@export var attackbox_component : Attackbox_Component
@export var inventory : Inventory



var can_move : bool = true

enum INPUTMODE {
	BUILDING = 0,
	FIGHTING = 1
}

var mode: INPUTMODE = INPUTMODE.BUILDING

const JUMP_VELOCITY = 200.0

@onready var left_hand_node : Node2D = %Visual_Container.get_node("%Left_Arm_Node")
@onready var right_hand_node : Node2D = %Visual_Container.get_node("%Left_Arm_Node")

@onready var visible_left = left_hand_node
@onready var visible_right = right_hand_node

@onready var skeleton = %Visual_Container.get_node("%Skeleton2D")

@export var damage = 10;

func _ready() -> void:
	load_character()
	inventory.wearable_equipped.connect(EQUIPARMOR)

func _input(event: InputEvent) -> void:
	if !can_move || !Global.loaded_world:
		return
	
	if event is InputEventMouseButton:
		if mode == INPUTMODE.FIGHTING:
			if Input.is_action_just_pressed("left_click"):
				%AnimationTree.set("parameters/hit/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
				attackbox_component.deal_damage()
	
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
			if Input.is_action_pressed("shift") && direction != Vector2.ZERO && velocity_component.get_speed_stage() != "RUNNING" && mode != INPUTMODE.FIGHTING:
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
		
		if Input.is_action_just_pressed("input_mode_switch"):
			mode = INPUTMODE.BUILDING if mode == INPUTMODE.FIGHTING else INPUTMODE.FIGHTING
			%AnimationTree["parameters/mode/add_amount"] = mode
		
		if mode == INPUTMODE.BUILDING:
			Global.data["worlds"][Global.loaded_world.uid]["player_data"]["position"] = {"x": position.x, "y": position.y}
			Global.save()
			


func _physics_process(delta: float) -> void:
	if velocity.x > 0:
		visible_right = right_hand_node
		visible_left = left_hand_node
	elif velocity.x < 0:
		visible_right = left_hand_node
		visible_left = right_hand_node
	visible_right.z_index = 3
	visible_left.z_index = 0

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
	


func EQUIPARMOR(armor, type):
	print(armor, type)
	
	#self.get_node("%Head_Overlay").texture = load(CharacterVisuals.HAIR_STYLES[Global.data["character"]["HAIR_STYLE"]])
	match type:
		"Chestplate":
			self.get_node("%Upper_Body_Overlay").texture = Global.load_resource(CharacterVisuals.CHESTPLATE_STYLES[armor]["UPPER_BODY"])
			self.get_node("%Mid_Body_Overlay").texture = Global.load_resource(CharacterVisuals.CHESTPLATE_STYLES[armor]["MID_BODY"])
			self.get_node("%Upper_Left_Arm_Overlay").texture = Global.load_resource(CharacterVisuals.CHESTPLATE_STYLES[armor]["UPPER_LEFT_ARM"])
			self.get_node("%Upper_Right_Arm_Overlay").texture = Global.load_resource(CharacterVisuals.CHESTPLATE_STYLES[armor]["UPPER_RIGHT_ARM"])
			return
	
	#self.get_node("%Lower_Body_Overlay").texture = Global.load_resource(CharacterVisuals.PANT_STYLES[Global.data["character"]["PANT_STYLE"]]["LOWER_BODY"])
	#self.get_node("%Lower_Left_Leg_Overlay").texture = Global.load_resource(CharacterVisuals.PANT_STYLES[Global.data["character"]["PANT_STYLE"]]["LOWER_LEFT_LEG"])
	#self.get_node("%Upper_Left_Leg_Overlay").texture = Global.load_resource(CharacterVisuals.PANT_STYLES[Global.data["character"]["PANT_STYLE"]]["UPPER_LEFT_LEG"])
	#self.get_node("%Lower_Right_Leg_Overlay").texture = Global.load_resource(CharacterVisuals.PANT_STYLES[Global.data["character"]["PANT_STYLE"]]["LOWER_RIGHT_LEG"])
	#self.get_node("%Upper_Right_Leg_Overlay").texture = Global.load_resource(CharacterVisuals.PANT_STYLES[Global.data["character"]["PANT_STYLE"]]["UPPER_RIGHT_LEG"])
	
