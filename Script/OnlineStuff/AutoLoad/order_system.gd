extends Node

# Handles the order lifecycle used by the mobile phone systems and game manager.
# Creates orders, tracks their state transitions, and emits notifications so other systems can react.
class_name OrderSystem

signal order_created(order: OrderInstance, event_label: String)
signal order_updated(order: OrderInstance, event_label: String)

var active_orders: Array[OrderInstance] = []
var _next_id: int = 1

func create_order(_data: ItemInstance) -> void:
	var order: OrderInstance = OrderInstance.new(_next_id, _data)
	_next_id += 1

	active_orders.append(order)
	order_created.emit(order, "Created")

func start_packing(order: OrderInstance) -> void:
	_set_order_state(order, OrderInstance.State.PACKING, "Packing")

func mark_sent(order: OrderInstance) -> void:
	_set_order_state(order, OrderInstance.State.SENT, "Sent")

func complete(order: OrderInstance) -> void:
	_set_order_state(order, OrderInstance.State.COMPLETED, "Completed")
	active_orders.erase(order)

func get_order_by_id(order_id: int) -> OrderInstance:
	for order in active_orders:
		if order.id == order_id:
			return order
	return null

# ---- For testing purpose -------------------------------------
func _ready() -> void:
	# randomize() disabled; DemandSystem handles order timing
	# start_auto_orders() disabled; DemandSystem handles order timing
	pass # DemandSystem handles order spawning

#func _spawn_random_order() -> void:
	#var entries: Array[StoreItemEntry] = _store_system.get_catalog()
	#if entries.size() > 0:
		#var entry: StoreItemEntry = entries[randi() % entries.size()]
		#create_order(str(entry.id))
		#print("OrderSystem: spawned order for item %s" % str(entry.id))
#
#func _spawn_loop() -> void:
	#var timer = get_tree().create_timer(randf_range(2.0, 4.0))
	#timer.timeout.connect(func() -> void:
		#_spawn_random_order()
		#_spawn_loop()
	#)

func _set_order_state(order: OrderInstance, new_state: int, event_label: String) -> void:
	order.state = new_state
	order_updated.emit(order, event_label)
