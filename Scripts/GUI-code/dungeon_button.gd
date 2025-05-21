extends HBoxContainer
class_name DungeonSelector

signal dungeon_delete(uid: String)

var dungeon: DungeonData;

func _ready() -> void:
	%PlayButton.text = dungeon.name
	update_lang()

func update_lang():
	%DeleteButton.text = Lang.LANG[Global.lang]["delete"]

func _on_play_button_pressed() -> void:
	Global.loaded_dungeon = dungeon
	get_tree().change_scene_to_file("res://Objects/Worlds/dungeon_editor.tscn")


func _on_delete_button_pressed() -> void:
	dungeon_delete.emit(dungeon.uid)
