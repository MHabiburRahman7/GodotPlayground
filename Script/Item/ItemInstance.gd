class_name ItemInstance

var data: ItemData
var state: ItemState
var behaviors: Array[ItemBehavior]

func _init(_data: ItemData):
	data = _data
	state = ItemState.new()

func get_behavior(behavior_class: GDScript) -> ItemBehavior:
	for b in behaviors:
		if b.get_script() == behavior_class:
			return b
	return null
