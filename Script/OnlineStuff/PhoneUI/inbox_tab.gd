class_name InboxTab
extends Control

enum ViewState {
	LIST,
	DETAIL,
}

const INBOX_ITEM_SLOT_SCENE: PackedScene = preload("res://Scenes/OnlineStuff/ChildItems/inbox_item_slot.tscn")

@onready var list: VBoxContainer = $ScrollContainer/OrderList
@onready var _detail_view: InboxMessageDetail = $InboxMessageDetail as InboxMessageDetail

var _current_inbox_messages : Array[MessageInstance]
signal message_order_accepted(message: MessageInstance, is_accepted: bool)

func _ready() -> void:
	call_deferred("_setup_inbox_system")

func _setup_inbox_system() -> void:
	if not _detail_view.close_requested.is_connected(_on_detail_closed):
		_detail_view.close_requested.connect(Callable(self, "_on_detail_closed"))
	if not _detail_view.decision_made.is_connected(_on_detail_decision):
		_detail_view.decision_made.connect(Callable(self, "_on_detail_decision"))
	refresh()
	_set_view(ViewState.LIST)

func add_message(message: MessageInstance) -> void:
	_current_inbox_messages.append(message)
	refresh()
	
func remove_message(message: MessageInstance) -> void:
	if _current_inbox_messages != null:
		_current_inbox_messages.erase(message)
	refresh()

func refresh() -> void:
	for child in list.get_children():
		child.queue_free()

	var messages: Array[MessageInstance] = _current_inbox_messages
	print("InboxTab: refreshing, %d messages" % messages.size())
	messages.sort_custom(Callable(self, "_compare_messages"))

	for message: MessageInstance in messages:
		print("InboxTab: instantiating slot for message %s, order %s, state %s" % [message.message_title, message.order_id, message.order_state_label])
		var slot: InboxItemSlot = INBOX_ITEM_SLOT_SCENE.instantiate()
		slot.visible = true
		slot.set_message(message)
		slot.inbox_item_pressed.connect(Callable(self, "_on_slot_pressed"))
		list.add_child(slot)

func _set_view(state: ViewState) -> void:
	list.visible = (state == ViewState.LIST)
	_detail_view.visible = (state == ViewState.DETAIL)

func _on_slot_pressed(message: MessageInstance) -> void:
	_detail_view.set_message_detail(message)
	_set_view(ViewState.DETAIL)

func _on_message_added(message: MessageInstance) -> void:
	print("InboxTab: message added [title=%s order=%s state=%s]" % [message.message_title, message.order_id, message.order_state_label])
	refresh()

func _on_message_removed(message: MessageInstance) -> void:
	print("InboxTab: message removed [title=%s order=%s state=%s]" % [message.message_title, message.order_id, message.order_state_label])
	refresh()

func _on_detail_closed() -> void:
	_set_view(ViewState.LIST)

func _on_detail_decision(message: MessageInstance, accepted: bool) -> void:
	#Pass this to mobile_phone_ui
	if accepted:
		emit_signal("message_order_accepted", message, accepted)
	#_inbox_system.remove_message(message)
	_set_view(ViewState.LIST)

func _compare_messages(a: MessageInstance, b: MessageInstance) -> int:
	return b.message_id - a.message_id
