class_name DungeonData

var name: String = ""
var uid: String = ""

var modified_blocks: Dictionary = {}

var enterKey: String
var exitKey: String

func apply_payload(data):
	self.name = data["name"]
	self.uid = data["uid"]
	self.modified_blocks = data["modified_blocks"]
	
	update_endpoint_positions()

func export_payload():
	var payload: Dictionary
	payload["name"] = self.name
	payload["uid"] = self.uid
	payload["modified_blocks"] = self.modified_blocks
	
	return payload

func update_endpoint_positions():
	for key in modified_blocks.keys():
		if (modified_blocks[key] as Array[String]).has("Enter"):
			enterKey = key
		if (modified_blocks[key] as Array[String]).has("Exit"):
			exitKey = key
	

func get_structure_starting_from_position(position: Vector2i):
	var ret = {}
	update_endpoint_positions()
	
	var enterPos = key_to_vec(enterKey)
	
	ret["blocks"] = {}
	
	for key in modified_blocks.keys():
		ret["blocks"][vec_to_key(key_to_vec(key) - enterPos + position)] = modified_blocks[key]
	
	for key in ret["blocks"].keys():
		if (ret["blocks"][key] as Array[String]).has("Enter"):
			ret["enter"] = key
		if (ret["blocks"][key] as Array[String]).has("Exit"):
			ret["exit"] = key
	
	return ret


func key_to_vec(key: String) -> Vector2i:
	return Vector2i(str_to_var(key.split(",")[0]), str_to_var(key.split(",")[1]))

func vec_to_key(vec: Vector2i) -> String:
	return var_to_str(vec.x)+","+var_to_str(vec.y)
