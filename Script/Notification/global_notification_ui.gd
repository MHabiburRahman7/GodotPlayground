extends Control

class_name GlobalNotificationUI

var _global_notif_system : NotificationSystemSingleton

@export var _notif_list : VBoxContainer
@export var NOTIFICATION_SLOT_SCENE : PackedScene

#for testing
@export var press_to_create_dummy_one : bool = false
@export var press_to_create_dummy_one_with_delay : bool = false

func _init() -> void:
	if _global_notif_system == null:
		if OS.is_debug_build():
			_global_notif_system = NotificationSystem.new()

# NOTE: There is a possibility of very first notification is missing
# The solution is create a simple buffer, later
func _ready() -> void:
	_global_notif_system.push_global_notification.connect(_on_notif_pushed)
	_global_notif_system.push_global_notification_with_delay.connect(_on_notif_with_delay_pushed)
	_global_notif_system.clear_notification.connect(_clear_notification)
	_clear_notification()

func _on_notif_pushed(path: String, message: String) -> void:
	_create_notif(path, message)

func _on_notif_with_delay_pushed(path: String, message: String, delay: float) -> void:
	_create_notif(path, message, delay)

func _clear_notification() -> void:
	for slot in _notif_list.get_children():
		slot.queue_free()

func _create_notif(path: String, message: String, delay: float = -1) -> void:
	var slot : GlobalNotificationSlotUI = NOTIFICATION_SLOT_SCENE.instantiate()
	slot.init(path, message, delay)
	_notif_list.add_child(slot)

#for testing purpose
func _process(delta: float) -> void:
	if press_to_create_dummy_one:
		press_to_create_dummy_one = false
		_create_notif("", "TESTING VERY LONG MESSAGE AAHAHAH")
	
	if press_to_create_dummy_one_with_delay:
		press_to_create_dummy_one_with_delay = false
		_create_notif("", "TESTING VERY LONG MESSAGE AAHAHAH", 10)
