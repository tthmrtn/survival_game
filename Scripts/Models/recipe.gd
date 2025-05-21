class_name Recipe
extends Resource

var item1name: String
var item2name: String
var result: Item

# ITEMCOST FORMAT:
#		x >= 1: x amount
#		x <= 0: undefined amount (will craft all the available materials on the item stack)
var item1cost: int
var item2cost: int

# RESULTAMOUNT FORMAT: "Mode|Num"
# Mode: "+" -> return: Num amount
#	 	"*" -> return: (item1cost+item2cost) * Num amount
# Divider: "|"
var resultAmount: String

# RATIO FORMAT: ITEM1:ITEM2
# 		available formats:
#			N:M (any item1 with any item2. like logs together count all the logs as one)
#			1:1 (1 item1 to 1 item2, basically matches them (takes the lesser amount))
# Divider: ":"
var ratio: String

func _init(item1name: String, item1cost: int, item2name: String, item2cost, result: Item, resultAmount: String, ratio: String):
	self.item1name = item1name
	self.item1cost = item1cost
	self.item2name = item2name
	self.item2cost = item2cost
	self.result = result
	self.resultAmount = resultAmount

func canCraft(item1: Item, item2: Item):
	if !item1 || !item2: return false
	if item1.name.contains(self.item1name):
		if item2.name.contains(self.item2name):
			return item1.amount >= self.item1cost && item2.amount >= self.item2cost
	elif item2.name.contains(self.item1name):
		if item1.name.contains(self.item2name):
			return item2.amount >= self.item1cost && item1.amount >= self.item2cost
	return false;

func craft(item1: Item, item2: Item, sameItem: bool):
	if (!canCraft(item1, item2)):
		return {"res": null, "item1used": 0, "item2used": 0 }
	
	var temp1
	var temp2
	
	if item1.name.contains(self.item1name):
		temp1 = item1
		temp2 = item2
	else:
		temp1 = item2
		temp2 = item1
	
	var res = self.result.copy()
	var dependentOnInputItems = self.resultAmount.split("|")[0] == "+"
	if dependentOnInputItems:
		res.amount = int(resultAmount.split("|")[1])
		return {"res": res, "item1used": self.item1cost, "item2used": self.item2cost}
	else:
		if self.ratio == "1:1":
			res.amount = min(temp1.amount, temp2.amount) * int(resultAmount.split("|")[1])
			return {"res": res, "item1used": min(temp1.amount, temp2.amount), "item2used": min(temp1.amount, temp2.amount)}
		else:
			res.amount = (temp1.amount + (temp2.amount if !sameItem else 0)) * int(resultAmount.split("|")[1])
			return {"res": res, "item1used": temp1.amount, "item2used": (temp2.amount if !sameItem else 0)}

func export_payload():
	return {
		"item1name": self.item1name,
		"item1cost": self.item1cost,
		"item2name": self.item2name,
		"item2cost": self.item2cost,
		"result": self.result.export_payload(),
		"resultAmount": self.resultAmount,
		"ratio": self.ratio
	}
