extends Control

@onready var options_list = [
	%HairOptions,
	%ShirtOptions,
	%PantsOptions
]


func load_save():
	if Global.data.has("character"):
		var gdata = Global.data["character"]
		print(gdata)
		hair_color = gdata["HAIR_COLOR"]
		hair_style_id = gdata["HAIR_STYLE"]
		shirt_color = gdata["SHIRT_COLOR"]
		shirt_style_id = gdata["SHIRT_STYLE"]
		pant_color = gdata["PANT_COLOR"]
		pant_style_id = gdata["PANT_STYLE"]

func _ready() -> void:
	load_save()
	%HairColorPicker.color = Color(hair_color)
	modulate_hair(Color(hair_color))
	change_hair(hair_style_id)
	%ShirtColorPicker.color = Color(shirt_color)
	modulate_shirt(Color(shirt_color))
	change_shirt(shirt_style_id)
	%PantColorPicker.color = Color(pant_color)
	modulate_pant(Color(pant_color))
	change_pant(pant_style_id)

func changeOptionsDialog(ref):
	for dialog in options_list:
		dialog.visible = false
	ref.visible = true

func _process(delta: float) -> void:
	pass


func _on_hair_button_pressed() -> void:
	changeOptionsDialog(%HairOptions)


func _on_shirt_button_pressed() -> void:
	changeOptionsDialog(%ShirtOptions)


func _on_pants_button_pressed() -> void:
	changeOptionsDialog(%PantsOptions)


# HAIR OPTIONS

@onready var HAIR_STYLES = [
	load("res://Visuals/Characters/Player/player(Hair1) _0001.png"),
	load("res://Visuals/Characters/Player/player(Hair2) _0001.png"),
	load("res://Visuals/Characters/Player/player(Hair3) _0001.png")
]

var hair_style_id = 0
var hair_color : String

func modulate_hair(color: Color):
	hair_color = "#"+color.to_html(false)
	%Player.get_node("%Hair").modulate = color


func change_hair(id: int):
	hair_style_id = id % HAIR_STYLES.size()
	%Player.get_node("%Hair").texture = HAIR_STYLES[hair_style_id]

func _on_hair_color_picker_color_changed(color: Color) -> void:
	modulate_hair(color)


func _on_prev_hair_style_pressed() -> void:
	change_hair(hair_style_id-1)


func _on_next_hair_style_pressed() -> void:
	change_hair(hair_style_id+1)


# SHIRT OPTIONS

@onready var SHIRT_STYLES = [
	{
		"UPPER_RIGHT_ARM": load("res://Visuals/Characters/Player/player(Shirt1_Upper_right_arm) _0001.png"),
		"UPPER_LEFT_ARM": load("res://Visuals/Characters/Player/player(Shirt1_Upper_left_arm) _0001.png"),
		"UPPER_BODY": load("res://Visuals/Characters/Player/player(Shirt1_Upper_body) _0001.png"),
		"MID_BODY": load("res://Visuals/Characters/Player/player(Shirt1_Mid_body) _0001.png")
	},
	{
		"UPPER_RIGHT_ARM": null,
		"UPPER_LEFT_ARM": null,
		"UPPER_BODY": load("res://Visuals/Characters/Player/player(Shirt1_Upper_body) _0001.png"),
		"MID_BODY": load("res://Visuals/Characters/Player/player(Shirt1_Mid_body) _0001.png")
	}
]

var shirt_style_id = 0
var shirt_color : String


func modulate_shirt(color: Color):
	shirt_color = "#"+color.to_html(false)
	%Player.get_node("%Upper_Body_Shirt").modulate = color
	%Player.get_node("%Mid_Body_Shirt").modulate = color
	%Player.get_node("%Upper_Left_Arm_Shirt").modulate = color
	%Player.get_node("%Upper_Right_Arm_Shirt").modulate = color


func change_shirt(id: int):
	shirt_style_id = id % SHIRT_STYLES.size()
	%Player.get_node("%Upper_Body_Shirt").texture = SHIRT_STYLES[shirt_style_id]["UPPER_BODY"]
	%Player.get_node("%Mid_Body_Shirt").texture = SHIRT_STYLES[shirt_style_id]["MID_BODY"]
	%Player.get_node("%Upper_Left_Arm_Shirt").texture = SHIRT_STYLES[shirt_style_id]["UPPER_LEFT_ARM"]
	%Player.get_node("%Upper_Right_Arm_Shirt").texture = SHIRT_STYLES[shirt_style_id]["UPPER_RIGHT_ARM"]


func _on_shirt_color_picker_color_changed(color: Color) -> void:
	modulate_shirt(color)


func _on_prev_shirt_style_pressed() -> void:
	change_shirt(shirt_style_id-1)


func _on_next_shirt_style_pressed() -> void:
	change_shirt(shirt_style_id+1)


# PANT OPTIONS

@onready var PANT_STYLES = [
	{
		"LOWER_BODY": load("res://Visuals/Characters/Player/pants(Pant1_Lower_body) _0001.png"),
		"LOWER_LEFT_LEG": load("res://Visuals/Characters/Player/pants(Pant1_Lower_left_leg) _0001.png"),
		"UPPER_LEFT_LEG": load("res://Visuals/Characters/Player/pants(Pant1_Upper_left_leg) _0001.png"),
		"LOWER_RIGHT_LEG": load("res://Visuals/Characters/Player/pants(Pant1_Lower_right_leg) _0001.png"),
		"UPPER_RIGHT_LEG": load("res://Visuals/Characters/Player/pants(Pant1_Upper_right_leg) _0001.png")
	},
	{
		"LOWER_BODY": load("res://Visuals/Characters/Player/pants(Pant1_Lower_body) _0001.png"),
		"LOWER_LEFT_LEG": null,
		"UPPER_LEFT_LEG": load("res://Visuals/Characters/Player/pants(Pant1_Upper_left_leg) _0001.png"),
		"LOWER_RIGHT_LEG": null,
		"UPPER_RIGHT_LEG": load("res://Visuals/Characters/Player/pants(Pant1_Upper_right_leg) _0001.png")
	}
]

var pant_style_id = 0
var pant_color : String


func modulate_pant(color: Color):
	pant_color = "#"+color.to_html(false)
	%Player.get_node("%Lower_Body_Pant").modulate = color
	%Player.get_node("%Lower_Left_Leg_Pant").modulate = color
	%Player.get_node("%Upper_Left_Leg_Pant").modulate = color
	%Player.get_node("%Lower_Right_Leg_Pant").modulate = color
	%Player.get_node("%Upper_Right_Leg_Pant").modulate = color


func change_pant(id: int):
	pant_style_id = id % PANT_STYLES.size()
	%Player.get_node("%Lower_Body_Pant").texture = PANT_STYLES[pant_style_id]["LOWER_BODY"]
	%Player.get_node("%Lower_Left_Leg_Pant").texture = PANT_STYLES[pant_style_id]["LOWER_LEFT_LEG"]
	%Player.get_node("%Upper_Left_Leg_Pant").texture = PANT_STYLES[pant_style_id]["UPPER_LEFT_LEG"]
	%Player.get_node("%Lower_Right_Leg_Pant").texture = PANT_STYLES[pant_style_id]["LOWER_RIGHT_LEG"]
	%Player.get_node("%Upper_Right_Leg_Pant").texture = PANT_STYLES[pant_style_id]["UPPER_RIGHT_LEG"]


func _on_pant_color_picker_color_changed(color: Color) -> void:
	modulate_pant(color)


func _on_prev_pant_style_pressed() -> void:
	change_pant(pant_style_id-1)


func _on_next_pant_style_pressed() -> void:
	change_pant(pant_style_id+1)

# BACK TO MAIN MENU


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Visuals/GUI-s/main_menu.tscn")

# SAVE


func _on_save_button_pressed() -> void:
	var data = {
		"HAIR_STYLE": hair_style_id,
		"HAIR_COLOR": hair_color,
		"SHIRT_STYLE": shirt_style_id,
		"SHIRT_COLOR": shirt_color,
		"PANT_STYLE": pant_style_id,
		"PANT_COLOR": pant_color
	}
	print(data)
	Global.save_character(data)
