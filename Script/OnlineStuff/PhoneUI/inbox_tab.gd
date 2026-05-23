class_name InboxTab
extends Control

enum ViewState {
	LIST,
	DETAIL,
}

const INBOX_ITEM_SLOT_SCENE: PackedScene = preload("res://Scenes/OnlineStuff/ChildItems/inbox_item_slot.tscn")
@onready var list: VBoxContainer             = $ScrollContainer/OrderList
@onready var _detail_view: InboxMessageDetail = $InboxMessageDetail as InboxMessageDetail

signal message_order_accepted(message: MessageInstance, is_accepted: bool)
signal message_order_declined(message: MessageInstance, is_accepted: bool)

func _ready() -> void:
	_setup_view()

func _setup_view() -> void:
	if not _detail_view.close_requested.is_connected(_on_detail_closed):
		_detail_view.close_requested.connect(Callable(self, "_on_detail_closed"))
	if not _detail_view.decision_made.is_connected(_on_detail_decision):
		_detail_view.decision_made.connect(Callable(self, "_on_detail_decision"))
	_set_view(ViewState.LIST)

func populate(active_messages: Array[MessageInstance]) -> void:
	refresh(active_messages)

func refresh(active_messages: Array[MessageInstance]) -> void:
	for child in list.get_children():
		child.queue_free()
	var messages: Array[MessageInstance] = active_messages.duplicate()
	messages.sort_custom(Callable(self, "_compare_messages"))
	for message: MessageInstance in messages:
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

func _on_detail_closed() -> void:
	_set_view(ViewState.LIST)

func _on_detail_decision(message: MessageInstance, accepted: bool) -> void:
	if accepted:
		emit_signal("message_order_accepted", message, accepted)
	else:
		emit_signal("message_order_declined", message, accepted)
	_set_view(ViewState.LIST)

func _compare_messages(a: MessageInstance, b: MessageInstance) -> int:
	return b.message_id - a.message_id
