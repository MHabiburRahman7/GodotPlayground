extends Node
class_name SupplySystem

signal item_ordered(item_id, amount)
signal item_arrived(item_id, amount)

# Simple catalog (later: Resources / JSON)
var catalog := {
	"item_stock": {
		"name": "Item Stock",
		"price": 50,
		"delivery_time": 5.0
	},
	"bubble_wrap": {
		"name": "Bubble Wrap",
		"price": 10,
		"delivery_time": 3.0
	},
	"cardboard_box": {
		"name": "Cardboard Box",
		"price": 20,
		"delivery_time": 4.0
	}
}

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
