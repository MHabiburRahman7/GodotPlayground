extends Control
class_name InboxMessageDetail

signal close_requested
signal decision_made(message: MessageInstance, accepted: bool)

@onready var _close_button: Button = $MessageDetailContainer/Header/CloseButton
@onready var _sender_label: Label = $MessageDetailContainer/Body/SenderLabel
@onready var _ordered_item_label: Label = $MessageDetailContainer/Body/OrderedItemLabel
@onready var _qty_label: Label = $MessageDetailContainer/Body/QtyLabel
@onready var _message_label: Label = $MessageDetailContainer/Body/MessageLabel
@onready var _order_status_label: Label = $MessageDetailContainer/Body/OrderStatusLabel
@onready var _accept_button: Button = $MessageDetailContainer/Body/OrderDecision/AcceptButton
@onready var _decline_button: Button = $MessageDetailContainer/Body/OrderDecision/DeclineButton

var _message_instance: MessageInstance = null
var sender_prefix :String = "From: "
var order_item_prefix :String = "Ordered Item: "
var Qty_prefix: String = "Qty: "
var message_prefix : String = "Message: "
var order_status_prefix : String = "Status: "

func _ready() -> void:
	_close_button.pressed.connect(Callable(self, "_on_close_pressed"))
	_accept_button.pressed.connect(Callable(self, "_on_accept_pressed"))
	_decline_button.pressed.connect(Callable(self, "_on_decline_pressed"))

func set_message_detail(message: MessageInstance) -> void:
	_message_instance = message
	_sender_label.text = sender_prefix + message.sender_name
	_ordered_item_label.text = order_item_prefix + message.ordered_item_name
	_qty_label.visible = false
	_message_label.text = message_prefix + message.message_content
	_order_status_label.text = order_status_prefix + message.order_state_label
	visible = true
	
	#If it is already answered, Only show decline button

func _on_close_button_pressed() -> void:
	visible = false
	emit_signal("close_requested")

func _on_accept_button_button_up() -> void:
	emit_signal("decision_made", _message_instance, true)
	
func _on_decline_button_button_up() -> void:
	emit_signal("decision_made", _message_instance, false)
