extends Control
class_name InventoryPanel

@export var slot_scene: PackedScene
@onready var grid := $Panel/GridContainer

var inventory: Inventory
signal item_selected(item: ItemInstance)
signal item_added()

func bind_inventory(inv: Inventory) -> void:
	inventory = inv
	refresh()

func refresh() -> void:
	_clear_grid()

	for item in inventory.items:
		_create_slot(item)

func _create_slot(item: ItemInstance) -> void:
	var slot := slot_scene.instantiate() as InventorySlot
	slot.set_item(item)
	slot.pressed.connect(_on_slot_pressed)
	grid.add_child(slot)

func _clear_grid() -> void:
	if grid == null:
		print("Grid for inventory is null")
	else :
		for child in grid.get_children():
			child.queue_free()

func _on_slot_pressed(item: ItemInstance) -> void:
	emit_signal("item_selected", item)
