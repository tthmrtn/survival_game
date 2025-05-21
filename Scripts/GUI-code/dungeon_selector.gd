extends Control

func _ready() -> void:
	Global.update_dungeons_array.connect(fetch_dungeons)
	fetch_dungeons()
	update_lang()

func update_lang():
	%MenuButton.text = Lang.LANG[Global.lang]["back_to_menu"]
	%NewDungeonButton.text = Lang.LANG[Global.lang]["dungeons"]["create_new_dungeon"]
	%Label.text = Lang.LANG[Global.lang]["dungeons"]["dungeons"]


func _on_new_dungeon_button_pressed() -> void:
	Global.create_new_dungeon(%DungeonName.text if %DungeonName.text else "New dungeon")
	%DungeonName.text = ""
	fetch_dungeons()

func fetch_dungeons():
	for world in %DungeonList.get_children():
		world.queue_free()
	
	if Global.data.has("dungeons"):
		for dungeon in Global.DUNGEONS:
			var dungeon_button = preload("res://Visuals/GUI-s/dungeon_button.tscn")
			var instance = dungeon_button.instantiate()
			instance.dungeon = dungeon
			instance.dungeon_delete.connect(_on_dungeon_delete)
			%DungeonList.add_child(instance)

func _on_dungeon_delete(uid: String):
	Global.delete_dungeon(uid)


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Visuals/GUI-s/main_menu.tscn")
