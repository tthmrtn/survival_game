extends Node2D
class_name TerrainMod

signal left_click_on_cell(coords: Vector2i, layer: TileMapLayer, cell_type: Block)
signal right_click_on_cell(coords: Vector2i, layer: TileMapLayer, cell_type: Block)
signal block_placed(coords: Vector2i, layer: TileMapLayer, cell_type: Block)

@export var background_layer : TileMapLayer
@export var main_layer : TileMapLayer
@export var foreground_layer : TileMapLayer

@export var selected_block : Block

var canbreak : bool = true

func _ready() -> void:
	selected_block = Blocks.dark_stone
	if (get_node_or_null("%Player")):
		block_placed.connect((%Player.get_node("%InventoryDialog") as Inventory).handle_block_placement)
		(%Player.get_node("%InventoryDialog") as Inventory).block_changed.connect(_change_block)
	
	
	if (is_instance_of(get_tree().current_scene, DungeonEditor)):
		var root = get_tree().current_scene as DungeonEditor
		root.block_changed.connect(_change_block)
		

func _change_block(block: Block):
	selected_block = block



func _input(event: InputEvent) -> void:
	if locked or get_node_or_null("%Player") and (%Player.get_node("%InventoryDialog").visible || (%Player as Player).mode == Player.INPUTMODE.FIGHTING):
		return
	
	if event is InputEventMouse:
		var cursor_position = main_layer.local_to_map(get_global_mouse_position())
		if Input.is_action_just_pressed("left_click") && canbreak:
			if get_node_or_null("%BreakingParticle"):
				%BreakingParticle.emitting = true
			
			if (get_top_layer(cursor_position)):
				block_placed.emit(cursor_position, get_top_layer(cursor_position), Blocks.air)
				get_top_layer(cursor_position).set_cell(cursor_position, selected_block.layer, Blocks.air.atlas_position)
			
			check_torches()
		if Input.is_action_just_pressed("right_click") && canbreak:
			if (get_first_free_layer(cursor_position)):
				if (Blocks.is_special_block(selected_block)):
					if (selected_block.name == "Enter"):
						if(%Main_Layer as TileMapLayer).get_used_cells_by_id(selected_block.layer, selected_block.atlas_position).size() > 0:
							return
							
					if (selected_block.name == "Exit"):
						if (%Main_Layer as TileMapLayer).get_used_cells_by_id(selected_block.layer, selected_block.atlas_position).size() > 0:
							return
					
					print(selected_block.name)
					%Main_Layer.set_cell(cursor_position, selected_block.layer, selected_block.atlas_position)
					block_placed.emit(cursor_position, %Main_Layer, selected_block)
					
					return
				
				
				if (get_top_layer(cursor_position)):
					right_click_on_cell.emit(cursor_position,get_top_layer(cursor_position), Blocks.get_block_by_atlas_coords(get_top_layer(cursor_position).get_cell_atlas_coords(cursor_position)))
				block_placed.emit(cursor_position, get_first_free_layer(cursor_position), selected_block)
				get_first_free_layer(cursor_position).set_cell(cursor_position, selected_block.layer, selected_block.atlas_position)
				check_torches()
				if (selected_block.name == Blocks.torch.name):
					var torch = preload("res://Objects/torch_light.tscn")
					var torchInstance = torch.instantiate()
					torchInstance.position = %Main_Layer.map_to_local(cursor_position)
					torchInstance.name = var_to_str(cursor_position.x)+","+var_to_str(cursor_position.y)
					print("ADDED TORCH")
					%Torches.add_child(torchInstance)
					
#					BUGOS AF
#					DE TÉNYLEG BUGOL
					#VALAMI OLYASMI BAJA VAN, AMITŐL NEM FELTÉTLEN RAKÓDIK LE A FÉNY HA TORCHOT RAKUNK
					
		if Input.is_action_just_pressed("scroll_click"):
			if (!is_instance_of(get_tree().current_scene, DungeonEditor)):
					if get_top_layer(cursor_position):
						selected_block = Blocks.get_block_by_atlas_coords(get_top_layer(cursor_position).get_cell_atlas_coords(cursor_position))
		
		if Input.is_action_just_released("left_click"):
			if get_node_or_null("%BreakingParticle"):
				%BreakingParticle.emitting = false
		
		

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

var locked: bool = false

func lock_input(lock: bool):
	print(lock)
	locked = lock

func _physics_process(delta: float) -> void:
	if get_node_or_null("%BreakingParticle"):
		var cursor_position = main_layer.local_to_map(get_global_mouse_position())
		if get_top_layer(cursor_position) == null:
			%BreakingParticle.emitting = false;
		%BreakingParticle.position = background_layer.local_to_map(get_global_mouse_position())*16 + Vector2i(8, 8)

func check_torches():
	var torches = main_layer.get_used_cells_by_id(0, Blocks.torch.atlas_position)
	
	print(torches)
	for torch in %Torches.get_children():
		print("CHECK FOR ", torch.name)
		if (!torch.name.contains("Node")):
			var x = str_to_var(torch.name.split(',')[0])
			var y = str_to_var(torch.name.split(',')[1])
			
			
			var candelete = true
			for p in torches:
				if Vector2i(x,y) == p:
					candelete = false
			
			if (candelete):
				torch.queue_free()
