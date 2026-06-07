extends Control

class_name GlobalNotificationSlotUI

@export var _icon: TextureRect
@export var _message: Label

var MESSAGE_CHAR_LIMIT : int = 12
var MESSAGE_SEPARATOR : String = "\n"
var _notification_lifetime_in_seconds : float = 2.5

var _is_self_destruct_set: bool = false

func init(in_icon_path: String, in_message, delay_in_seconds : float = -1) -> void:
	if delay_in_seconds > 0:
		_notification_lifetime_in_seconds = delay_in_seconds
	
	_set_icon(in_icon_path)
	_set_message(in_message)

func _ready() -> void:
	#NOTE: special case, idk how but get_tree is instantiated late
	# so this function must be under _ready
	_set_self_destruct()

func _set_icon(in_icon_path: String) -> void:
	var icon_path = in_icon_path
	if icon_path == "" || !FileAccess.file_exists(icon_path):
		icon_path = "res://icon.svg"
	
	_icon.texture = load(icon_path)	

func _set_message(message: String)-> void:
	var chunks: Array[String] = []
	# Loop through the string, jumping by N characters each time
	for i in range(0, message.length(), MESSAGE_CHAR_LIMIT):
		chunks.append(message.substr(i, MESSAGE_CHAR_LIMIT))
	# Join all segments using the designated separator
	var final_message = MESSAGE_SEPARATOR.join(chunks)
	_message.text = final_message

func _set_self_destruct() -> void:
	if _is_self_destruct_set:
		return
	
	_is_self_destruct_set = true
	await get_tree().create_timer(_notification_lifetime_in_seconds).timeout
	queue_free()

func _on_button_button_up() -> void:
	queue_free()
