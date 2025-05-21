extends Node

var PANT_STYLES = [
	{
		"LOWER_BODY": "res://Visuals/Characters/Player/pants(Pant1_Lower_body) _0001.png",
		"LOWER_LEFT_LEG": "res://Visuals/Characters/Player/pants(Pant1_Lower_left_leg) _0001.png",
		"UPPER_LEFT_LEG": "res://Visuals/Characters/Player/pants(Pant1_Upper_left_leg) _0001.png",
		"LOWER_RIGHT_LEG": "res://Visuals/Characters/Player/pants(Pant1_Lower_right_leg) _0001.png",
		"UPPER_RIGHT_LEG": "res://Visuals/Characters/Player/pants(Pant1_Upper_right_leg) _0001.png"
	},
	{
		"LOWER_BODY": "res://Visuals/Characters/Player/pants(Pant1_Lower_body) _0001.png",
		"LOWER_LEFT_LEG": null,
		"UPPER_LEFT_LEG": "res://Visuals/Characters/Player/pants(Pant1_Upper_left_leg) _0001.png",
		"LOWER_RIGHT_LEG": null,
		"UPPER_RIGHT_LEG": "res://Visuals/Characters/Player/pants(Pant1_Upper_right_leg) _0001.png"
	}
]


var SHIRT_STYLES = [
	{
		"UPPER_RIGHT_ARM": "res://Visuals/Characters/Player/player(Shirt1_Upper_right_arm) _0001.png",
		"UPPER_LEFT_ARM": "res://Visuals/Characters/Player/player(Shirt1_Upper_left_arm) _0001.png",
		"UPPER_BODY": "res://Visuals/Characters/Player/player(Shirt1_Upper_body) _0001.png",
		"MID_BODY": "res://Visuals/Characters/Player/player(Shirt1_Mid_body) _0001.png"
	},
	{
		"UPPER_RIGHT_ARM": null,
		"UPPER_LEFT_ARM": null,
		"UPPER_BODY": "res://Visuals/Characters/Player/player(Shirt1_Upper_body) _0001.png",
		"MID_BODY": "res://Visuals/Characters/Player/player(Shirt1_Mid_body) _0001.png"
	}
]

var HAIR_STYLES = [
	"res://Visuals/Characters/Player/player(Hair1) _0001.png",
	"res://Visuals/Characters/Player/player(Hair2) _0001.png",
	"res://Visuals/Characters/Player/player(Hair3) _0001.png"
]

var HELMET_STYLES = []

var CHESTPLATE_STYLES = {
	"none": {
		"UPPER_RIGHT_ARM": null,
		"UPPER_LEFT_ARM": null,
		"UPPER_BODY": null,
		"MID_BODY": null
	},
	"Iron Armor" : {
		"UPPER_RIGHT_ARM": "res://Visuals/Characters/Player/ironarmor(Armor1_Upper_Right_Arm).png",
		"UPPER_LEFT_ARM": "res://Visuals/Characters/Player/ironarmor(Armor1_Upper_Left_Arm).png",
		"UPPER_BODY": "res://Visuals/Characters/Player/ironarmor(Armor1_Upper_Body).png",
		"MID_BODY": "res://Visuals/Characters/Player/ironarmor(Armor1_Mid_Body).png"
	}
}

var LEGGING_STYLES = []
