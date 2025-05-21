extends Area2D
class_name Attackbox_Component

@export var damage: int = 10

var in_range : Array[Hurtbox_Component] = [];

@export var selfHurtbox : Hurtbox_Component


func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area is Hurtbox_Component && area != selfHurtbox:
		in_range.push_back(area)
	
	print(in_range)




func _on_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area is Hurtbox_Component:
		in_range.erase(area)
	
	print(in_range)

func deal_damage():
	for area in in_range:
		area.take_damage(damage)
