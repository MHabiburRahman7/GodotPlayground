class_name ItemInstance

var data: ItemData
var state: ItemState

func _init(_data: ItemData):
	data = _data
	state = ItemState.new()
