extends Node

# Provides supply ordering for packaging materials requested by the mobile phone UI.
# Maintains a lightweight catalog, emits signals when deliveries are requested or arrive,
# and schedules simulated delivery timers so order packing can stay stocked.
class_name SupplySystem

signal item_ordered(item_id, amount)
signal item_arrived(item_id, amount)

@export var catalog_path: String = "res://Database/item/supply_item_catalog.json"
var catalog: Dictionary = {}

func _ready() -> void:
	_load_catalog()

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

func order(item_id: String, amount: int = 1) -> bool:
	if not catalog.has(item_id):
		return false

	# (Money check can go here later)

	var data = catalog[item_id]
	var delivery_time = data.delivery_time

	item_ordered.emit(item_id, amount)

	_schedule_delivery(item_id, amount, delivery_time)
	return true


func _schedule_delivery(item_id: String, amount: int, delay: float):
	var timer = get_tree().create_timer(delay)
	timer.timeout.connect(func():
		item_arrived.emit(item_id, amount)
	)
