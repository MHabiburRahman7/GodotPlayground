extends Control
class_name StoreTabV2

@export var _active_store_list : Control

var _active_store_list_ctrl : ActiveStoreList

func _ready() -> void:
	_active_store_list_ctrl = _active_store_list as ActiveStoreList

func _on_upload_button_pressed() -> void:
	_active_store_list_ctrl.change_to_upload_view()

func _on_view_button_pressed() -> void:
	_active_store_list_ctrl.change_to_list_view()

func _on_delete_button_pressed() -> void:
	push_warning("Button did nothing for now")
	pass # Replace with function body.
