extends Node2D
class_name MobSpawner

@export var can_aggressive_mobs_spawn: bool = false
@export var can_passive_mobs_spawn: bool = true

@export var aggressive_limit : int = 20

@export var passive_limit: int = 20

@export var range: int = 10

const MOBS = {
	"passive" = [
		{
			"name": "Pig",
			"path": "res://Objects/Characters/Pig.tscn"
		}
	],
	"aggressive" = [
		{
			"name": "Ground",
			"path": "res://Objects/Characters/ground_enemy_base.tscn"
		},
		{
			"name": "Flying",
			"path":"res://Objects/Characters/flying_enemy.tscn"
		}
	]
}

var count_down = 0;
var tick = 0;

func _physics_process(delta: float) -> void:
	if (count_down == 0):
		count_down = randi()%3+5
		spawn()
	
	tick += 1
	
	if (tick % 60 == 0):
		count_down -= 1

func spawn():
	var aggressive : bool = randi() % 2 == 1
	if can_aggressive_mobs_spawn && !can_passive_mobs_spawn:
		aggressive = true
	elif !can_aggressive_mobs_spawn && can_aggressive_mobs_spawn:
		aggressive = false
	
	
	if aggressive:
		var rand: String = MOBS["aggressive"][randi() % MOBS["aggressive"].size()]["path"]
		var mob = Global.load_resource(rand)
		var mobInstance = mob.instantiate()
		mobInstance.position = self.position + Vector2(randi() * 100 % 1000,-100)
		
		self.add_child(mobInstance)
		
		
	else:
		var rand = MOBS["passive"][randi() % MOBS["passive"].size()]["path"]
		var mob = Global.load_resource(rand)
		var mobInstance = mob.instantiate()
		mobInstance.position = self.position + Vector2(randi() * 100 % 1000,-100)
		
		self.add_child(mobInstance)
