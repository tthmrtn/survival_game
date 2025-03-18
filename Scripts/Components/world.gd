extends Node2D

var tick: int;

enum DAY_PHASES {
	DAY,
	NIGHT,
}

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://Visuals/GUI-s/main_menu.tscn")

func _physics_process(delta: float) -> void:
	tick += 1
	if tick%60 == 0:
		display_time(tick)

var day_length = 86400

var day_night_ratio = 2/3

var test_length = 9.0

var day_phase : DAY_PHASES

func display_time(tick):
	var secnum = floor(tick/60)
	
	var minute = ("00000"+var_to_str(secnum%60))
	var hour = ("00000"+var_to_str(floori(secnum/60)))
	
	var day_progress = (secnum / test_length)
	day_progress -= int(day_progress)
	
	var darkness = 0.0 if day_progress < 2.0/3.0 else 0.6
	day_phase = DAY_PHASES.DAY if day_progress < 2.0/3.0 else DAY_PHASES.NIGHT
	
	%CanvasModulate.color = Color("#ffffff").darkened(darkness)
	
	%Time.text = hour.substr(hour.length()-2, -1)+":"+minute.substr(minute.length()-2, -1)
