extends Node2D

class_name FullChainTestController

@export var delivery_drop_path: NodePath = "DeliveryDrop"
@export var supply_system_path: NodePath = "/root/SupplySystemSingleton"

@onready var delivery_drop: Node2D = get_node(delivery_drop_path) as Node2D
@onready var _delivery_sprite: Sprite2D = delivery_drop.get_node("Sprite2D") as Sprite2D
@onready var _supply_system: SupplySystem = get_node(supply_system_path) as SupplySystem
@onready var _player_inventory_panel: InventoryPanel = get_node("Player/InventoryPanel") as InventoryPanel

func _prepare_inventories() -> void:
	var delivery_drop_inv: Inventory = Inventory.new()
	delivery_drop_inv.capacity = 10
	InventorySystemSingleton.register_inventory("delivery_drop", delivery_drop_inv)
	
	#delivery_drop is default warehouse_id for supply_system
	#DeliveryManager.register_drop("delivery_drop")
	
	var warehouse_rack_inv: Inventory = Inventory.new()
	warehouse_rack_inv.capacity = 10
	InventorySystemSingleton.register_inventory("warehouse_rack", warehouse_rack_inv)
	var courier_center_inv: Inventory = Inventory.new()
	courier_center_inv.capacity = 10
	InventorySystemSingleton.register_inventory("courier_center", courier_center_inv)
	
	#NOTE: backpack is registered under the player's
	var backpack_inv: Inventory = Inventory.new()
	backpack_inv.capacity = 10
	InventorySystemSingleton.register_inventory("backpack", backpack_inv)


func _bind_backpack_inventory() -> void:
	var backpack_inventory: Inventory = InventorySystemSingleton.get_inventory("backpack")
	if backpack_inventory == null:
		push_warning("Backpack inventory not registered yet")
		return
	_player_inventory_panel.bind_inventoryv2(backpack_inventory, "backpack")

func _ready() -> void:
	_prepare_inventories()
	_bind_backpack_inventory()
	if _supply_system:
		_supply_system.item_arrived.connect(_on_item_arrived)
	else:
		push_warning("SupplySystemSingleton not found; drop zone arrival disabled")

#TODO: Currently the 0.5 seconds timeout is just a dummy. 
#It have to be integrated with TimeManager later 
func _on_item_arrived(item_id: String, amount: int) -> void:
	_delivery_sprite.modulate = Color(0, 1, 0)
	await get_tree().create_timer(0.5).timeout
	_delivery_sprite.modulate = Color(1, 1, 1)
