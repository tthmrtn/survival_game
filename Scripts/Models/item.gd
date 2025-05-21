extends Resource
class_name Item

signal amount_updated()

@export var name : String
@export var texture : Texture2D
@export var max_amount : int
var type : String
var special : Dictionary

@export var amount : int = 0

func _init(name: String, texture: Texture2D, max_amount: int, type: String, special: Dictionary = {}) -> void:
	self.name = name
	self.texture = texture
	self.max_amount = max_amount
	self.type = type
	self.amount = 0
	self.special = special
	print(special)

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

func apply_payload(data):
	self.name = data["name"]
	self.amount = data["amount"]
	self.type = data["type"]
	self.special = data["special"]



func export_payload():
	return {"name": self.name, "amount": self.amount, "type": self.type, "special": self.special}

func copy():
	return Item.new(self.name, self.texture, self.max_amount, self.type, self.special)
