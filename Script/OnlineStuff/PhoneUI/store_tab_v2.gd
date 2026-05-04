extends Control
class_name StoreTabV2

@export var _active_store_list : Control

var _active_store_list_ctrl : ActiveStoreList

func _ready() -> void:
	_active_store_list_ctrl = _active_store_list as ActiveStoreList

func _on_upload_button_pressed() -> void:
	_active_store_list_ctrl.change_to_upload_view()
	_active_store_list_ctrl.trigger_reset_selected_items()

func _on_view_button_pressed() -> void:
	_active_store_list_ctrl.change_to_list_view()
	_active_store_list_ctrl.trigger_reset_selected_items()

func _on_delete_button_pressed() -> void:
	_active_store_list_ctrl.trigger_remove_selected_items()
	_active_store_list_ctrl.trigger_reset_selected_items()
