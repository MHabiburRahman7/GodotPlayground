extends Control
class_name InventoryPanel

@export var slot_scene: PackedScene
@onready var grid := $OuterContainer/ScrollContainer/GridContainer
@onready var inventory_label = $OuterContainer/Label

var inventory: Inventory
signal item_selected(item: ItemInstance)

func bind_inventoryv2(inv: Inventory, name: String) -> void:
	inventory = inv
	inventory_label.text = name
	_clear_grid()
	refresh()

#Only to fill the remaining empty slots
func _create_empty_slots(start_index: int) -> void:
	var _curr_itt : int = start_index
	for i in inventory.capacity:
		if _curr_itt >= inventory.capacity:
			break

		var _temp_slot = slot_scene.instantiate() as InventorySlot
		_temp_slot.clear()
		grid.add_child(_temp_slot)
		_curr_itt += 1

func refresh() -> void:
	if inventory == null:
		return
		
	_clear_grid()
	var _current_item_num :int = 0
	if(inventory.items != null):
		for item in inventory.items:
			_create_slot(item)
			_current_item_num += 1
	_create_empty_slots(_current_item_num)

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
