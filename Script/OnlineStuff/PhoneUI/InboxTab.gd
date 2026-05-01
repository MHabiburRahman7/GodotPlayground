extends Control

signal message_selected(message: MessageInstance)

const INBOX_ITEM_SLOT_SCENE: PackedScene = preload("res://Scenes/OnlineStuff/ChildItems/inbox_item_slot.tscn")

@onready var list: VBoxContainer = $OrderList
var _inbox_system: InboxSystem = null

func _ready() -> void:
	call_deferred("_setup_inbox_system")

func _setup_inbox_system() -> void:
	_inbox_system = _get_inbox_system()
	if _inbox_system == null:
		push_warning("InboxSystemSingleton is not registered. Inbox tab will remain empty.")
		return
	print("InboxTab: connected to InboxSystemSingleton")
	if not _inbox_system.message_added.is_connected(_on_message_added):
		_inbox_system.message_added.connect(_on_message_added)
	if not _inbox_system.message_removed.is_connected(_on_message_removed):
		_inbox_system.message_removed.connect(_on_message_removed)
	refresh()

func refresh() -> void:
	if _inbox_system == null:
		return

	for child in list.get_children():
		child.queue_free()

	var messages: Array[MessageInstance] = _inbox_system.get_all_messages()
	print("InboxTab: refreshing, %d messages" % messages.size())
	messages.sort_custom(Callable(self, "_compare_messages"))

	for message: MessageInstance in messages:
		print("InboxTab: instantiating slot for message %s, order %s, state %s" % [message.message_title, message.related_order_id, message.order_state_label])
		var slot: InboxItemSlot = INBOX_ITEM_SLOT_SCENE.instantiate()
		slot.visible = true
		slot.set_message(message)
		slot.inbox_item_pressed.connect(Callable(self, "_on_slot_pressed"))
		list.add_child(slot)

func _on_slot_pressed(message: MessageInstance) -> void:
	emit_signal("message_selected", message)

func _on_message_added(message: MessageInstance) -> void:
	print("InboxTab: message added [title=%s order=%s state=%s]" % [message.message_title, message.related_order_id, message.order_state_label])
	refresh()

func _on_message_removed(message: MessageInstance) -> void:
	print("InboxTab: message removed [title=%s order=%s state=%s]" % [message.message_title, message.related_order_id, message.order_state_label])
	refresh()

func _compare_messages(a: MessageInstance, b: MessageInstance) -> int:
	return b.message_id - a.message_id

func _get_inbox_system() -> InboxSystem:
	if Engine.has_singleton("InboxSystemSingleton"):
		return Engine.get_singleton("InboxSystemSingleton") as InboxSystem
	var root: Node = get_tree().get_root()
	if root.has_node("InboxSystemSingleton"):
		return root.get_node("InboxSystemSingleton") as InboxSystem
	return null
