class_name Item
extends Resource

@export var name : String
@export var texture : Texture2D
@export var max_amount : int
@export var equippable : bool

var amount : int = 0

func _init(name: String, texture: Texture2D, max_amount: int, equippable: bool) -> void:
	self.name = name
	self.texture = texture
	self.max_amount = max_amount
	self.equippable = equippable

func add_amount(added: int):
	if (amount+added > max_amount):
		amount = clamp(amount+added, 0, max_amount)
		return (amount+added)-max_amount
	else:
		amount += added
		return 0
