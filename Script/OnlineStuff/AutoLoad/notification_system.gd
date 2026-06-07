extends Node

class_name NotificationSystem

signal global_notification_pushed(icon_path: String, message: String)
signal global_notification_with_delay_pushed(icon_path: String, message: String, delay_in_second: float)
signal clear_notification()

func push_notification(icon_path: String, message: String) -> void:
	global_notification_pushed.emit(icon_path, message)

func push_notification_with_delay(icon_path: String, message: String, delay_in_second: float) -> void:
	global_notification_with_delay_pushed.emit(icon_path, message, delay_in_second)

func push_clear_notification() -> void:
	clear_notification.emit()
