extends Node2D

signal left_click_on_cell(coords: Vector2i, layer: TileMapLayer, cell_type: Block)
signal right_click_on_cell(coords: Vector2i, layer: TileMapLayer, cell_type: Block)

@export var background_layer : TileMapLayer
@export var main_layer : TileMapLayer
@export var foreground_layer : TileMapLayer

@export var selected_block : Block

func _ready() -> void:
	selected_block = Blocks.dark_stone
	(%Player.get_node("%InventoryDialog") as Inventory).block_changed.connect(_change_block)

func _change_block(block: Block):
	selected_block = block

func _input(event: InputEvent) -> void:
	if %Player.get_node("%InventoryDialog").visible:
		return
	
	if event is InputEventMouse:
		var cursor_position = main_layer.local_to_map(get_global_mouse_position())
		if Input.is_action_just_pressed("left_click"):
			if (get_top_layer(cursor_position)):
				get_top_layer(cursor_position).set_cell(cursor_position,0, Blocks.air.atlas_position)
		if Input.is_action_just_pressed("right_click"):
			if (get_first_free_layer(cursor_position)):
				right_click_on_cell.emit(cursor_position,get_top_layer(cursor_position), Blocks.get_block_by_atlas_coords(get_top_layer(cursor_position).get_cell_atlas_coords(cursor_position)))
				get_first_free_layer(cursor_position).set_cell(cursor_position, 0, selected_block.atlas_position)
		if Input.is_action_just_pressed("scroll_click"):
			selected_block = Blocks.get_block_by_atlas_coords(get_top_layer(cursor_position).get_cell_atlas_coords(cursor_position))


func get_top_layer(coords: Vector2i) -> TileMapLayer:
	if (foreground_layer.get_cell_atlas_coords(coords) != Vector2i(-1,-1)):
		return foreground_layer
	if (main_layer.get_cell_atlas_coords(coords) != Vector2i(-1,-1)):
		return main_layer
	if (background_layer.get_cell_atlas_coords(coords) != Vector2i(-1,-1)):
		return background_layer
	return null

func get_first_free_layer(coords: Vector2i) -> TileMapLayer:
	if (get_top_layer(coords) == main_layer):
		return foreground_layer
	if (get_top_layer(coords) == background_layer):
		return main_layer
	if (get_top_layer(coords) == null):
		return background_layer
	return null
