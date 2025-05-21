extends Control
class_name CraftPreview

var recipe: Recipe
var mouse_in: bool

signal clicked(recipe: Recipe)

func _ready():
	recipe = Items.recipes[1]
	
	print(recipe.export_payload())
	
	
	%Result.texture = recipe.result.texture
	%Item1.texture = Items.get_item_by_including_string(recipe.item1name)[0].texture
	%Item2.texture = Items.get_item_by_including_string(recipe.item2name)[0].texture
	%Item1Amount.text = var_to_str(recipe.item1cost)
	%Item2Amount.text = var_to_str(recipe.item2cost)

func _on_mouse_entered() -> void:
	self.mouse_in = true
	%Panel.modulate = "#ffffff"


func _on_mouse_exited() -> void:
	self.mouse_in = false
	%Panel.modulate = "#000000"
