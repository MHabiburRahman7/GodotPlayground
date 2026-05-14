# DeliveryManagerSingleton buffers incoming supply deliveries until a delivery drop inventory registers.
# Once the drop is ready, buffered orders are flushed into it so they are not lost when the scene loads.
extends Node
class_name DeliveryManagerSingleton

@export var default_drop_id: String = "delivery_drop"

var _pending_items: Array[String] = []

func _ready() -> void:
	if SupplySystemSingleton:
		SupplySystemSingleton.item_arrived.connect(_on_item_arrived)
	else:
		push_warning("SupplySystemSingleton not found; buffering disabled")

func _on_item_arrived(item_id: String, amount: int) -> void:
	for i in amount:
		_pending_items.append(item_id)
	_flush_if_ready()

func register_drop(drop_id: String) -> void:
	call_deferred("_flush_if_ready", drop_id)

func _flush_if_ready(drop_id: String = default_drop_id) -> void:
	var inv: Inventory = InventorySystemSingleton.get_inventory(drop_id)
	if inv:
		for item_id in _pending_items:
			var data: ItemData = ItemData.new()
			data.id = item_id
			var entry: Dictionary = SupplySystemSingleton.catalog[item_id]
			data.name = entry.name
			data.base_price = entry.price
			data.stackable = true
			data.category = "supply"
			var inst: ItemInstance = ItemInstance.new(data)
			inv.add_item(inst)
		_pending_items.clear()
