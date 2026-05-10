extends Control
class_name InventoryPanel

@export var slot_scene: PackedScene
@onready var grid := $Panel/GridContainer
@onready var inventory_label = $Panel/Label

var inventory: Inventory
signal item_selected(item: ItemInstance)

func bind_inventory(inv: Inventory) -> void:
	inventory = inv
	refresh()

func bind_inventoryv2(inv: Inventory, name: String) -> void:
	inventory = inv
	inventory_label.text = name
	refresh()

func refresh() -> void:
	if inventory == null:
		return
	_clear_grid()

	if(inventory.items != null):
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
	print("on slot pressed for: ", item.data.name)
	emit_signal("item_selected", item)
