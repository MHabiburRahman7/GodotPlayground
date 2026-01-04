extends Node
class_name InventorySystem

var inventories := {}

func register_inventory(id: String, inventory: Inventory):
	inventories[id] = inventory
	print("Inventory added ", id)

func get_inventory(id: String) -> Inventory:
	print("got inventory: ", id)
	return inventories.get(id)

func get_inventoryv2(id: String) -> Array:
	return [inventories.get(id), id]
