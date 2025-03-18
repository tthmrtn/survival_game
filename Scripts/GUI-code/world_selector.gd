extends Control



func _ready() -> void:
	Global.update_worlds_array.connect(fetch_worlds)
	fetch_worlds()
	update_lang()

func update_lang():
	%MenuButton.text = Lang.LANG[Global.lang]["back_to_menu"]
	%NewWorldButton.text = Lang.LANG[Global.lang]["worlds"]["create_new_world"]
	%Label.text = Lang.LANG[Global.lang]["worlds"]["worlds"]

func _on_new_world_button_pressed() -> void:
	Global.create_new_world(%WorldName.text if %WorldName.text else "New world")
	%WorldName.text = ""
	fetch_worlds()


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Visuals/GUI-s/main_menu.tscn")

func fetch_worlds():
	for world in %WorldList.get_children():
		world.queue_free()
	
	if Global.data.has("worlds"):
		for world in Global.WORLDS:
			var world_button = preload("res://Visuals/GUI-s/world_button.tscn")
			var instance = world_button.instantiate()
			instance.world = world
			instance.world_delete.connect(_on_world_delete)
			%WorldList.add_child(instance)

func _on_world_delete(uid: String):
	Global.delete_world(uid)
