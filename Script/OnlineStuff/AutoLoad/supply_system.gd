extends Node

# Provides supply ordering for packaging materials requested by the mobile phone UI.
# Maintains a lightweight catalog, emits signals when deliveries are requested or arrive,
# and schedules simulated delivery timers so order packing can stay stocked.
class_name SupplySystem

signal item_ordered(item_id, amount)
signal item_arrived(item_id, amount)

signal item_orderedv2(item: ItemInstance, amount: int, delay: float)
signal item_arrivedv2(delivery: DeliveryInstance, amount: int, rack_id: String)

@export var catalog_path: String = "res://Database/item/supply_item_catalogv2.json"
var catalog: Dictionary = {}
var catalogv2 : Array[ItemInstance]

@export var centralized_delivery_time : float = 3
@export var default_dropzone_inventory_id = "delivery_drop"

var _notif_system : NotificationSystem = null

func _ready() -> void:
	#_load_catalog()
	_load_catalogv2()
	_notif_system = NotificationSystemSingleton

func _load_catalogv2() -> void:
	if not FileAccess.file_exists(catalog_path):
		push_error("Supply catalog missing at '%s'" % catalog_path)
		return

	var file: FileAccess = FileAccess.open(catalog_path, FileAccess.READ)
	if not file:
		push_error("Failed to open supply catalog: %s" % catalog_path)
		return

	var raw: String = file.get_as_text()
	file.close()

	var json = JSON.new()
	var error = json.parse(raw)
	if error != OK:
		push_error("Failed to parse catalog '%s': %s" % json.get_error_message())
		return

	var parsed = json.data
	if parsed == null:
		push_error("Catalog '%s' must contain a Dictionary root" % catalog_path)
		
	for data in parsed:
		var temp_data = ItemData.new()
		temp_data.id = data.id
		temp_data.base_price = data.price
		temp_data.name = data.name
		temp_data.category = "SUPPLY"
		
		# Validation for icon
		# If doesnt exist, hardcoded to default godot icon for now 
		var temp_icon_path = ""
		if data.icon_path != "" && FileAccess.file_exists(data.icon_path):
			temp_icon_path = data.icon_path
		else:
			temp_icon_path = "res://icon.svg"
		temp_data.icon = load(temp_icon_path)
		var temp_instance = ItemInstance.new(temp_data)
		catalogv2.append(temp_instance)

func _load_catalog() -> void:
	if not FileAccess.file_exists(catalog_path):
		push_error("Supply catalog missing at '%s'" % catalog_path)
		return

	var file: FileAccess = FileAccess.open(catalog_path, FileAccess.READ)
	if not file:
		push_error("Failed to open supply catalog: %s" % catalog_path)
		return

	var raw: String = file.get_as_text()
	file.close()

	var json = JSON.new()
	var error = json.parse(raw)
	if error != OK:
		push_error("Failed to parse catalog '%s': %s" % json.get_error_message())
		return

	var parsed = json.data
	if parsed is Dictionary:
		catalog = parsed as Dictionary
	else:
		push_error("Catalog '%s' must contain a Dictionary root" % catalog_path)

# Pending deliveries
var pending_orders: Array = []

func orderv2(item: ItemInstance, amount: int = 1) -> bool:
	if not catalogv2.has(item):
		return false
	
	# (Money check can go here later)
	
	item_orderedv2.emit(item, amount, centralized_delivery_time)
	return true

func set_delivery_done(delivery: DeliveryInstance) -> void:
	#Push notification
	var _notif_message = "Delivery done for %s to %s"
	var _delivery_icon_path = ""
	_notif_system.push_notification(_delivery_icon_path, _notif_message)
	
	#change state if needed
	
	#trigger this back to delivery_system
	item_arrivedv2.emit(delivery, 1, default_dropzone_inventory_id)

func order(item_id: String, amount: int = 1) -> bool:
	if not catalog.has(item_id):
		return false

	# (Money check can go here later)

	var data = catalog[item_id]
	var delivery_time = data.delivery_time

	item_ordered.emit(item_id, amount)

	#_schedule_delivery(item_id, amount, delivery_time)
	return true

#DEprecated, already handled in delivery_system
#func _schedule_delivery(item_id: String, amount: int, delay: float):
	#var timer = get_tree().create_timer(delay)
	#timer.timeout.connect(func():
		#item_arrived.emit(item_id, amount)
	#)
