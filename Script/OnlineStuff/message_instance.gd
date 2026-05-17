class_name MessageInstance

var message_id: int
var sender_name: String
var message_title: String
var message_content: String
var received_time: String
var order_id: int
var ordered_item_name: String
var order_state_label: String

func _init(
	in_message_id: int,
	in_sender_name: String,
	in_message_title: String,
	in_message_content: String,
	in_received_time: String,
	in_order_id: int = -1,
	in_ordered_item_name: String = "",
	in_order_state_label: String = ""
) -> void:
	message_id = in_message_id
	sender_name = in_sender_name
	message_title = in_message_title
	message_content = in_message_content
	received_time = in_received_time
	order_id = in_order_id
	ordered_item_name = in_ordered_item_name
	order_state_label = in_order_state_label
