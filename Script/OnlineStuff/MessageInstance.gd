class_name MessageInstance

var message_id: int
var sender_name: String
var message_title: String
var message_content: String
var received_time: String
var related_order_id: int
var order_item_id: String
var order_state_label: String

func _init(
	in_message_id: int,
	in_sender_name: String,
	in_message_title: String,
	in_message_content: String,
	in_received_time: String,
	in_related_order_id: int = -1,
	in_order_item_id: String = "",
	in_order_state_label: String = ""
) -> void:
	message_id = in_message_id
	sender_name = in_sender_name
	message_title = in_message_title
	message_content = in_message_content
	received_time = in_received_time
	related_order_id = in_related_order_id
	order_item_id = in_order_item_id
	order_state_label = in_order_state_label
