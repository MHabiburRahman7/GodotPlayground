extends Node

class_name NotificationSystem

signal push_global_notification(icon_path: String, message: String)
signal push_global_notification_with_delay(icon_path: String, message: String, delay_in_second: float)
signal clear_notification()

func push_notification(icon_path: String, message: String) -> void:
	push_global_notification.emit(icon_path, message)

func push_notification_with_delay(icon_path: String, message: String, delay_in_second: float) -> void:
	push_global_notification_with_delay.emit(icon_path, message, delay_in_second)

func push_clear_notification() -> void:
	clear_notification.emit()
