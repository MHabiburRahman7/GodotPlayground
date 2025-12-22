extends Control

@export var slot_scene: PackedScene
@onready var grid = $Panel/GridContainer

var inventory: Inventory

func bind_inventory(inv: Inventory):
	inventory = inv
	refresh()
	
func clear_grid():
	for child in grid.get_children():
		child.queue_free()

func refresh():
	clear_grid()

	for item in inventory.items:
		var slot = slot_scene.instantiate() as InventorySlot
		slot.set_item(item)
		grid.add_child(slot)
