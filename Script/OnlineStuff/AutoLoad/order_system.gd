extends Node

# Handles the order lifecycle used by the mobile phone systems and game manager.
# Creates orders, tracks their state transitions, and emits notifications so other systems can react.
class_name OrderSystem

signal order_created(order: Order, event_label: String)
signal order_updated(order: Order, event_label: String)

var active_orders: Array[Order] = []
var _next_id: int = 1

func create_order(item_id: String) -> void:
	var order: Order = Order.new(_next_id, item_id)
	_next_id += 1

	active_orders.append(order)
	order_created.emit(order, "Created")

func start_packing(order: Order) -> void:
	_set_order_state(order, Order.State.PACKING, "Packing")

func mark_sent(order: Order) -> void:
	_set_order_state(order, Order.State.SENT, "Sent")

func complete(order: Order) -> void:
	_set_order_state(order, Order.State.COMPLETED, "Completed")
	active_orders.erase(order)

func get_order_by_id(order_id: int) -> Order:
	for order in active_orders:
		if order.id == order_id:
			return order
	return null

func start_auto_orders() -> void:
	_spawn_loop()

# ---- For testing purpose -------------------------------------
#func _ready() -> void:
#	start_auto_orders()

func _spawn_loop() -> void:
	var timer = get_tree().create_timer(randf_range(6.0, 12.0))
	timer.timeout.connect(func() -> void:
		create_order("item_stock")
		_spawn_loop()
		print("order created!!!!")
	)

func _set_order_state(order: Order, new_state: int, event_label: String) -> void:
	order.state = new_state
	order_updated.emit(order, event_label)
