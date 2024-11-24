class_name Block
extends Resource

@export var name : String
@export var id : int
@export var atlas_position : Vector2i

func _init(name: String, id: int, atlas_position: Vector2i) -> void:
	self.name = name
	self.id = id
	self.atlas_position = atlas_position
