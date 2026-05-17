class_name AcceptedOrderTab

# Fundamentally similar with inbox_tab
# However it only contains messages with active/accepted orders
extends Control

const INBOX_ITEM_SLOT_SCENE: PackedScene = preload("res://Scenes/OnlineStuff/ChildItems/inbox_item_slot.tscn")

var _active_order_lists : Array[MessageInstance]
@onready var list: VBoxContainer = $ScrollContainer/ActiveOrderList
@onready var _detail_view: InboxMessageDetail = $InboxMessageDetail as InboxMessageDetail

signal message_order_declined(message: MessageInstance)

enum ViewState {
	LIST,
	DETAIL,
}

func _ready() -> void:
	call_deferred("_setup_accepted_order_system")

func add_new_active_order(message: MessageInstance) -> void:
	_active_order_lists.append(message)
	refresh()

# TODO: updated when order is completed
func remove_active_oder(message: MessageInstance) -> void:
	if _active_order_lists != null:
		_active_order_lists.erase(message)
		refresh()

func _setup_accepted_order_system() -> void:
	#setup see detail button
	if not _detail_view.close_requested.is_connected(_on_detail_closed):
		_detail_view.close_requested.connect(Callable(self, "_on_detail_closed"))
	if not _detail_view.decision_made.is_connected(_on_detail_decision_made):
		_detail_view.decision_made.connect(Callable(self, "_on_detail_decision_made"))
	refresh()
	_set_view(ViewState.LIST)

func refresh() -> void:
	for child in list.get_children():
		child.queue_free()

	var messages: Array[MessageInstance] = _active_order_lists
	print("ActiveOrderTab: refreshing, %d messages" % messages.size())
	messages.sort_custom(Callable(self, "_compare_messages"))

	for message: MessageInstance in messages:
		print("ActiveOrderTab: instantiating slot for message %s, order %s, state %s" % [message.message_title, message.order_id, message.order_state_label])
		var slot: InboxItemSlot = INBOX_ITEM_SLOT_SCENE.instantiate()
		slot.visible = true
		slot.set_message(message)
		slot.inbox_item_pressed.connect(Callable(self, "_on_slot_pressed"))
		list.add_child(slot)

func _on_slot_pressed(message: MessageInstance) -> void:
	_detail_view.set_message_detail(message)

func _compare_messages(a: MessageInstance, b: MessageInstance) -> int:
	return b.message_id - a.message_id
	
func _set_view(state: ViewState) -> void:
	list.visible = (state == ViewState.LIST)
	_detail_view.visible = (state == ViewState.DETAIL)
	
func _on_detail_closed() -> void:
	_set_view(ViewState.LIST)
	
func _on_detail_decision_made(message: MessageInstance, accepted: bool) -> void:
	if !accepted:
		emit_signal("message_order_declined", message, accepted)
