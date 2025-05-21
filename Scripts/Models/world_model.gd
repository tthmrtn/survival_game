class_name WorldData

var name: String = ""
var uid: String = ""
var seed: int = 0

var player_data: PlayerData = PlayerData.new()
var modified_blocks: Dictionary = {}

func apply_payload(data):
	self.name = data["name"]
	self.uid = data["uid"]
	self.seed = data["seed"]
	self.player_data.apply_payload(data["player_data"])
	self.modified_blocks = data["modified_blocks"]

func export_payload():
	var payload: Dictionary
	payload["name"] = self.name
	payload["uid"] = self.uid
	payload["seed"] = self.seed
	payload["player_data"] = self.player_data.export_payload()
	payload["modified_blocks"] = self.modified_blocks
	
	return payload
