class_name Item
extends Resource

signal amount_updated()

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
	self.amount = 0

func add_amount(added: int): 
	if (self.amount+added > self.max_amount):
		var old_amount = self.amount
		self.amount = clamp(self.amount+added, 0, self.max_amount)
		amount_updated.emit()
		return (old_amount+added)-self.max_amount
	else:
		self.amount += added
		amount_updated.emit()
		return 0

func export_payload():
	return {"name": self.name, "amount": self.amount}

func copy():
	return Item.new(self.name, self.texture, self.max_amount, self.equippable)
