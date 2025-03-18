class_name PlayerData

var health: int = 0
var player_position: Vector2 = Vector2(0,0)
var inventory: Inventory = Inventory.new()

func apply_payload(data):
	self.health = data["health"]
	self.player_position = Vector2(data["position"]["x"], data["position"]["y"])
	self.inventory.apply_payload(data["inventory"])

func export_payload():
	var payload: Dictionary
	payload["health"] = self.health
	payload["position"] = {"x":self.player_position.x, "y": self.player_position.y}
	payload["inventory"] = self.inventory.export_payload()
	return payload
