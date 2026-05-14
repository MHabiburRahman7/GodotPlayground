extends Control

class_name InventoryPanelMaster

@onready var panel_left: InventoryPanel = $InventoryPanelLeft
@onready var panel_right: InventoryPanel = $InventoryPanelRight

var inventory_left: Inventory
var inventory_right: Inventory

var selected_item: ItemInstance
var selected_from_left := true

func _ready() -> void:
	_prepare_button_signals()

#Public API
func open(left: Inventory, right: Inventory) -> void:
	inventory_left = left
	inventory_right = right

	panel_left.bind_inventory(inventory_left)
	panel_right.bind_inventory(inventory_right)

	selected_item = null
	visible = true

func openv2(left: Inventory, name_left: String, right: Inventory, name_right: String) -> void:
	inventory_left = left
	inventory_right = right

	panel_left.bind_inventoryv2(inventory_left, name_left)
	panel_right.bind_inventoryv2(inventory_right, name_right)

	selected_item = null
	visible = true

func close() -> void:
	visible = false
	selected_item = null 
	
func is_open() -> bool:
	var is_left_open = panel_left.visible
	var is_right_open = panel_right.visible
	return is_left_open && is_right_open
	
#Transfer Button Logic
func _prepare_button_signals() -> void:
	panel_left.item_selected.connect(_on_left_selected)
	panel_right.item_selected.connect(_on_right_selected)

func _on_left_selected(item: ItemInstance):
	selected_item = item
	selected_from_left = true

func _on_right_selected(item: ItemInstance):
	selected_item = item
	selected_from_left = false

# Item Transfer
func _on_button_to_right_pressed():
	print("InventoryPanelMaster: button to right pressed")
	if not selected_item:
		return
	if not selected_from_left:
		return
	_transfer(selected_item, inventory_left, inventory_right)

func _on_button_to_left_pressed():
	print("InventoryPanelMaster: button to left pressed")
	if not selected_item:
		return
	if selected_from_left:
		return
	_transfer(selected_item, inventory_right, inventory_left)

func _transfer(item: ItemInstance, from: Inventory, to: Inventory):
	if not to.can_add(item):
		return

	from.remove_item(item)
	to.add_item(item)

	selected_item = null
	panel_left.refresh()
	panel_right.refresh()
