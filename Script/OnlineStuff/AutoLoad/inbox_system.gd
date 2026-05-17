extends Node

# Manages the inbox messaging pipeline for the mobile phone UI.
# Listens to OrderSystem events, builds timestamped MessageInstance entries with NPC senders,
# and emits signals whenever messages change so the UI can rebuild its slots.
class_name InboxSystem

signal message_added(message: MessageInstance)
signal message_removed(message: MessageInstance)

const MAX_MESSAGE_ID: int = 999999999999
const DEFAULT_MAX_MESSAGES: int = 5

var messages_list: Array[MessageInstance] = []
var latest_message_id: int = 0
var max_message_list: int = DEFAULT_MAX_MESSAGES

var _order_system: OrderSystem = null

func _ready() -> void:
	call_deferred("_connect_to_order_system")

func _connect_to_order_system() -> void:
	_order_system = _get_order_system()
	if _order_system == null:
		print("InboxSystem: OrderSystem singleton missing")
		return
	if not _order_system.order_created.is_connected(_on_order_created):
		_order_system.order_created.connect(_on_order_created)
	if not _order_system.order_updated.is_connected(_on_order_updated):
		_order_system.order_updated.connect(_on_order_updated)

func _get_order_system() -> OrderSystem:
	if Engine.has_singleton("OrderSystemSingleton"):
		return Engine.get_singleton("OrderSystemSingleton") as OrderSystem
	if get_tree().get_root().has_node("OrderSystemSingleton"):
		return get_tree().get_root().get_node("OrderSystemSingleton") as OrderSystem
	return null

func _on_order_created(order: OrderInstance, event_label: String) -> void:
	print("InboxSystem: order created event %s for order %d" % [event_label, order.id])
	register_order_event(order, event_label)

func _on_order_updated(order: OrderInstance, event_label: String) -> void:
	register_order_event(order, event_label)

func register_order_event(order: OrderInstance, event_label: String) -> void:
	print("InboxSystem: register_order_event for order %d event %s" % [order.id, event_label])
	var message_title: String = "Order #%d: %s" % [order.id, event_label]
	var message_content: String = "Item %s updated to %s." % [order.item_id, _state_to_label(order.state)]
	var message_time: String = _current_time_string()
	var new_message: MessageInstance = MessageInstance.new(
		_get_next_message_id(),
		_generate_sender_name(),
		message_title,
		message_content,
		message_time,
		order.id,
		order.data.data.name,
		_state_to_label(order.state)
	)
	_register_new_message(new_message)

func get_all_messages() -> Array[MessageInstance]:
	return messages_list.duplicate()

func remove_message(message_item: MessageInstance) -> void:
	var index: int = messages_list.find(message_item)
	if index != -1:
		messages_list.remove_at(index)
		emit_signal("message_removed", message_item)

func _register_new_message(message_item: MessageInstance) -> void:
	if messages_list.size() >= max_message_list:
		var oldest_message: MessageInstance = messages_list[0]
		messages_list.remove_at(0)
		emit_signal("message_removed", oldest_message)
	messages_list.append(message_item)
	emit_signal("message_added", message_item)

func _get_next_message_id() -> int:
	latest_message_id += 1
	if latest_message_id > MAX_MESSAGE_ID:
		latest_message_id = 0
	return latest_message_id

func get_message_by_id(message_id: int) -> MessageInstance:
	for message in messages_list:
		if message.id == message_id:
			return message
	return null

func _current_time_string() -> String:
	var now = Time.get_datetime_dict_from_system()
	return "%04d-%02d-%02d %02d:%02d" % [now.year, now.month, now.day, now.hour, now.minute]

func _generate_sender_name() -> String:
	return NPCGeneratorUtils.name_generator()

func _state_to_label(state: int) -> String:
	match state:
		OrderInstance.State.CREATED:
			return "Created"
		OrderInstance.State.PACKING:
			return "Packing"
		OrderInstance.State.SENT:
			return "Sent"
		OrderInstance.State.COMPLETED:
			return "Completed"
		_:
			return "Unknown"
