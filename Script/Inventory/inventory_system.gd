extends Node

# Acts as a registry for inventory containers across the wider game manager.
# Allows systems to register and look up inventories by ID so items can be moved or queried.
class_name InventorySystem

var inventories := {}

func register_inventory(id: String, inventory: Inventory):
	if(inventories.has(id)):
		print("InventorySystem: inventory, ", id, " already registered")
	else:
		inventories[id] = inventory
		print("InventorySystem: Inventory added ", id)

func get_inventory(id: String) -> Inventory:
	print("got inventory: ", id)
	return inventories.get(id)

func get_inventoryv2(id: String) -> Array:
	return [inventories.get(id), id]
