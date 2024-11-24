extends Control




func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Visuals/GUI-s/world_selector.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_character_creator_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Visuals/GUI-s/character_creator.tscn")
