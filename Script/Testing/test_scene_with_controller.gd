extends Node

#func _ready() -> void:
	#_prepare_inventories()
	#_prepare_dummy_items()

func _prepare_inventories() -> void:
	var warehouse_inv = Inventory.new()
	warehouse_inv.capacity = 10;
	InventorySystemSingleton.register_inventory("warehouse", warehouse_inv)
	
	var backpack_inv = Inventory.new()
	backpack_inv.capacity = 10;
	InventorySystemSingleton.register_inventory("backpack", backpack_inv)
	
	var rack_inv = Inventory.new()
	rack_inv.capacity = 10;
	InventorySystemSingleton.register_inventory("rack", rack_inv)

#Testing Purpose
func _prepare_dummy_items() -> void:
	var itemData = ItemData.new()
	itemData.base_price = 10
	itemData.name = "BubbleWrap"
	itemData.icon = load("res://icon.svg")
	var itemInstance = ItemInstance.new(itemData)
	
	var warehouse_inv = InventorySystemSingleton.get_inventory("warehouse")
	warehouse_inv.add_item(itemInstance)
	warehouse_inv.add_item(itemInstance)

##for testing scene
func _input(event):
	if event.is_action_pressed("load_outer_home"):
		Global.get_game_controller().change_2d_scene("res://Scenes/Maps/OutsideHome.tscn")
	if event.is_action_pressed("load_inside_home"):
		Global.get_game_controller().change_2d_scene("res://Scenes/Maps/InsideHome.tscn")
	if event.is_action_pressed("load_full_chain_test"):
		Global.get_game_controller().change_2d_scene("res://Scenes/Maps/full_chain_test.tscn")
