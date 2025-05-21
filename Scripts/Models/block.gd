class_name Block
extends Resource

@export var name : String
@export var id : int
@export var atlas_position : Vector2i
@export var health : int
var layer: int
var special: Dictionary

func _init(name: String, id: int, atlas_position: Vector2i, health: int, layer: int = 0, special: Dictionary = {}) -> void:
	self.name = name
	self.id = id
	self.atlas_position = atlas_position
	self.health = health
	self.layer = layer
	self.special = special
