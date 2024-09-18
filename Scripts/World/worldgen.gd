extends TileMapLayer

@export var noise : FastNoiseLite
var x_length : int = 600 #World Length
var y_depth : int = 256 #World Depth
var height : int = 256 #World Height

var bottom_of_world = 60

@export var biomenoise : FastNoiseLite
@export var plainsnoise : FastNoiseLite
@export var seanoise : FastNoiseLite
@export var desertNoise : FastNoiseLite

const SEA_LEVEL : int = 0

func _ready():
	randomize()
	noise.seed = randi()
	
	for x in range(-x_length,x_length):
		var y = ceil(noise.get_noise_1d(x) * height)
		
		
		if (y > SEA_LEVEL-2 || biomenoise.get_noise_1d(x) < 0):
			self.set_cell(Vector2i(x,y),0, Vector2i(0,1))
		else:
			self.set_cell(Vector2i(x,y),0, Vector2i(0,0))
		for y2 in range(1,4):
			if (y > SEA_LEVEL-2 || biomenoise.get_noise_1d(x) < 0):
				self.set_cell(Vector2i(x,y+y2),0, Vector2i(0,1))
			else:
				self.set_cell(Vector2i(x,y+y2),0, Vector2i(1,0))
		for bottom in range(y+4, bottom_of_world):
			self.set_cell(Vector2i(x,bottom), 0, Vector2i(2,0))
		if y > 0:
			for water in range(0,y):
				set_cell(Vector2i(x,water), 0, Vector2i(3,0))
	%Player.position.y = noise.get_noise_1d(%Player.position.x) * height * 4
	
func _input(_event: InputEvent) -> void:
	var mouse_pos : Vector2 = get_global_mouse_position()
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().reload_current_scene()
	if Input.is_action_pressed("left_click"):
		set_cell(Vector2(local_to_map(mouse_pos)), -1)
	elif Input.is_action_pressed("right_click"):
		if get_cell_atlas_coords(local_to_map(mouse_pos)) == Vector2i(-1,-1):
			set_cell(Vector2(local_to_map(mouse_pos)), 0, Vector2i(1,0))

func _process(_delta: float) -> void:
	pass

func update():
	pass
