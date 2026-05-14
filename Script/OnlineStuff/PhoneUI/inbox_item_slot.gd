extends Control
class_name InboxItemSlot

@export var sender_label: Label
@export var message_title_label: Label
@export var date_label: Label

var message: MessageInstance = null

signal inbox_item_pressed(message: MessageInstance)

func set_message(message_item: MessageInstance) -> void:
	message = message_item
	sender_label.text = message.sender_name
	message_title_label.text = message.message_title
	date_label.text = message.received_time

func clear():
	message = null
	sender_label.text = ""
	message_title_label.text = ""
	date_label.text = ""

func _on_button_pressed():
	if message:
		emit_signal("inbox_item_pressed", message)
