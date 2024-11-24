extends HBoxContainer
class_name WorldSelector

signal world_delete(uid: String)

var world: WorldData;

func _ready() -> void:
	%PlayButton.text = world.name

func _on_play_button_pressed() -> void:
	Global.loaded_world = world
	get_tree().change_scene_to_file("res://Worlds/test_world.tscn")


func _on_delete_button_pressed() -> void:
	world_delete.emit(world.uid)
