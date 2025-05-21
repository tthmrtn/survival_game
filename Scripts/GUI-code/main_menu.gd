extends Control

var tween: Tween

func _ready() -> void:
	Lang.lang_changed.connect(update_lang)
	update_lang()
	

func update_lang():
	%Play_Button.text = Lang.LANG[Global.lang]["play"]
	%Character_Creator_Button.text = Lang.LANG[Global.lang]["character_creator"]["character_creator"]
	%Exit_Button.text = Lang.LANG[Global.lang]["exit"]
	%Dungeon_Creator_Button.text = Lang.LANG[Global.lang]["dungeons"]["dungeon_selector"]
	%Lang_Button.text = var_to_str(Lang.LANG[Global.lang]["language"] + ": " + Lang.LANG_OPTIONS[Global.lang]).replace("\"", "")

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Visuals/GUI-s/world_selector.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_character_creator_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Visuals/GUI-s/character_creator.tscn")

func _on_dungeon_creator_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Visuals/GUI-s/dungeon_selector.tscn")

func _on_lang_button_pressed() -> void:
	if (Global.lang == "en"):
		Global.lang = "hu"
		Lang.lang_changed.emit()
	else:
		Global.lang = "en"
		Lang.lang_changed.emit()
	
	Global.data["lang"] = Global.lang
	Global.save()
