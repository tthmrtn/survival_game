extends Node2D

@export var background_layer : TileMapLayer
@export var main_layer : TileMapLayer
@export var foreground_layer : TileMapLayer

@export var blocks : BLOCKS

@export var selected_block : String = "DIRT"

func _input(event: InputEvent) -> void:
	if %Player.get_node("%InventoryDialog").visible:
		return
	
	if event is InputEventMouse:
		if Input.is_action_pressed("left_click"):
			main_layer.set_cell(main_layer.local_to_map(get_global_mouse_position()),0,blocks.BLOCK_IDS["AIR"])
		if Input.is_action_pressed("right_click"):
			main_layer.set_cell(main_layer.local_to_map(get_global_mouse_position()),0,blocks.BLOCK_IDS[selected_block])
