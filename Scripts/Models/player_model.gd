class_name PlayerData

var health: int = 0
var player_position: Vector2 = Vector2(0,0)
var inventory: Inventory = Inventory.new()

var STATS = {
	"health": 0,
	"attack": 0,
	"movement_speed": 0,
	"hunger_fullness": 0
}

var exp: int = 0

func apply_payload(data):
	self.health = data["health"]
	self.player_position = Vector2(data["position"]["x"], data["position"]["y"])
	self.inventory.apply_payload(data["inventory"])
	self.STATS = data["stats"]
	self.exp = data["exp"]

func export_payload():
	var payload: Dictionary
	payload["health"] = self.health
	payload["position"] = {"x":self.player_position.x, "y": self.player_position.y}
	payload["inventory"] = self.inventory.export_payload()
	payload["stats"] = self.STATS
	payload["exp"] = self.exp
	return payload
