class_name ActiveStoreListController
extends Control

#Id 0 fpr nothing
#Id 1 fpr upload_form
#Id 2 for _store_listing

@export var _upload_form : Control
@export var _store_listing : Control

var _currently_active_view : int = 0
var _id_len :int = 3

func _hide_all() -> void:
	_upload_form.visible = false
	_store_listing.visible = false

func _set_active_view(to_be_active_index: int) -> void:
	_hide_all()
	
	for id_index in _id_len:
		if (to_be_active_index == 1):
			_upload_form.visible = true
		elif (to_be_active_index == 2):
			_store_listing.visible = true

	_currently_active_view = to_be_active_index
