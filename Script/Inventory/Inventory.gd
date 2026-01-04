extends RefCounted

class_name Inventory

signal item_added(item)
signal item_removed(item)

var capacity := 20
var items: Array[ItemInstance] = []

func can_add(item: ItemInstance) -> bool:
	return items.size() < capacity

func add_item(item: ItemInstance) -> bool:
	if not can_add(item):
		return false
	items.append(item)
	emit_signal("item_added", item)
	return true

func remove_item(item: ItemInstance) -> bool:
	if not items.has(item):
		return false
	items.erase(item)
	emit_signal("item_removed", item)
	return true
