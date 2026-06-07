# DeliveryManagerSingleton buffers incoming supply deliveries until a delivery drop inventory registers.
# Once the drop is ready, buffered orders are flushed into it so they are not lost when the scene loads.
extends Node
class_name DeliveryManagerSingleton

#@export var default_drop_id: String = "delivery_drop"

# This class should contains
# 1. Supply System (for player to order supply)
# 2. Courier System (for player/courier to deiver their package)
# 3. Time Syetem (pretty obvious reason)

var _pending_items: Array[String] = []
var _arrived_deliveries: Array[DeliveryInstance] = []

var _supply_system : SupplySystem
var _time_system : TimeSystem
#TODO: Courier system

var _active_deliveries : Array[DeliveryInstance]
var _latest_delivery_id: int = -1
var MAX_DELIVERY_ID : int = 99999999999

func _ready() -> void:
	call_deferred("_setup_supply_system")
	call_deferred("_setup_time_system")
	call_deferred("_setup_courier_system")

func _generate_delivery_id() -> int:
	var _result = _latest_delivery_id + 1
	if _result > MAX_DELIVERY_ID:
		_result = 0
	
	_latest_delivery_id = _result
	return _result

func _setup_time_system() -> void:
	_time_system = TimeSystemSingleton as TimeSystem
	if _time_system != null:
		if not _time_system.minute_changed.is_connected(_on_minute_changed):
			_time_system.minute_changed.connect(_on_minute_changed)
	else:
		push_error("TimeSystem not found. cant proceed")

func _setup_supply_system() -> void:
	_supply_system = SupplySystemSingleton as SupplySystem
	if _supply_system != null:
		if not _supply_system.item_orderedv2.is_connected(_on_supply_ordered):
			_supply_system.item_orderedv2.connect(_on_supply_ordered)
		if not _supply_system.item_arrivedv2.is_connected(_on_supply_arrived) :
			_supply_system.item_arrivedv2.connect(_on_supply_arrived)
	else:
		push_warning("SupplySystemSingleton not found; buffering disabled")

func _setup_courier_system() -> void:
	pass

#currently listening delivery based on minute / most frequent
func _on_minute_changed(min: int) -> void:
	_process_delivery()

func _process_delivery() -> void:
	# temporary handler so it wont break the active for-loop
	var _completed_delivery : Array[DeliveryInstance] = []
	for _delivery in _active_deliveries:
		if _time_system.get_world_minutes() >= _delivery.arriving_time:
			_proceed_arrived_item(_delivery)
			_completed_delivery.append(_delivery)
	for _completed in _completed_delivery:
		_active_deliveries.erase(_completed)

func _proceed_arrived_item(delivery: DeliveryInstance, amount: int = 1) -> void:
	for i in amount:
		delivery.delivered_id = _generate_delivery_id()
		_arrived_deliveries.append(delivery)
	_process_back_to_system()

func _process_back_to_system() -> void:
	for _deliver in _arrived_deliveries:
		if _deliver.item.data.category == "SUPPLY":
			_supply_system.set_delivery_done(_deliver)
		#TODO - but store dont need to push to inventory
		# it simply erase after arrival
		elif _deliver.item.data.category == "STORE":
			pass

func _on_supply_arrived(delivery: DeliveryInstance, amount: int, rack_id: String) -> void:
	for i in amount:
		_push_to_inventory(delivery, rack_id) 

func _push_to_inventory(delivery: DeliveryInstance, warehouse_id : String) -> void:
	var inv: Inventory = InventorySystemSingleton.get_inventory(warehouse_id)
	if inv:
		inv.add_item(delivery.item)
		_arrived_deliveries.erase(delivery)
	
#func _on_item_arrived(item_id: String, amount: int) -> void:
	#for i in amount:
		#_pending_items.append(item_id)
	#_flush_if_ready()

func _on_supply_ordered(item: ItemInstance, amount: int, delay: float) -> void:
	#for now, assume that delay is always in minute
	var arrival_tinme = _calculate_arrival_time(0, 0, delay)
	var temp_delivery = DeliveryInstance.new(_generate_delivery_id(), item, arrival_tinme)
	_active_deliveries.append(temp_delivery)

func _calculate_arrival_time(in_day: int, in_hour: int, in_minute: int) -> int:
	var total_minute = _time_system.get_world_minutes() + (in_day * 24 * 60) + (in_hour * 60) + (in_minute * 1)
	return total_minute

#func register_drop(drop_id: String) -> void:
	#call_deferred("_flush_if_ready", drop_id)

#func _flush_if_ready(drop_id: String = default_drop_id) -> void:
	#var inv: Inventory = InventorySystemSingleton.get_inventory(drop_id)
	#if inv:
		#for item_id in _pending_items:
			#var data: ItemData = ItemData.new()
			#data.id = item_id
			#var entry: Dictionary = SupplySystemSingleton.catalog[item_id]
			#data.name = entry.name
			#data.base_price = entry.price
			#data.stackable = true
			#data.category = "supply"
			#var inst: ItemInstance = ItemInstance.new(data)
			#inv.add_item(inst)
		#_pending_items.clear()
