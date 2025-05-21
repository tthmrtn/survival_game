extends HBoxContainer
class_name WorldSelector

signal world_delete(uid: String)

var world: WorldData;

func _ready() -> void:
	%PlayButton.text = world.name
	update_lang()

func update_lang():
	%DeleteButton.text = Lang.LANG[Global.lang]["delete"]

func _on_play_button_pressed() -> void:
	Global.loaded_world = world
	print("WORLD BUTTON")
	print(world.export_payload())
	get_tree().change_scene_to_file("res://Objects/Worlds/test_world.tscn")


func _on_delete_button_pressed() -> void:
	world_delete.emit(world.uid)
