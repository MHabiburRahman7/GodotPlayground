class_name ActiveStoreList
extends Control

#Id 0 fpr nothing
#Id 1 fpr upload_form
#Id 2 for _store_listing

@export var _upload_form : Control
@export var _store_listing : Control

var _current_view : int = 0

# Which sub‑view is showing?
enum ViewState {
	VIEW_NONE,  # initial “none” (if you ever need a neutral state)
	VIEW_FORM,  # the Upload form
	VIEW_LIST,  # the items listing
}

func _ready() -> void:
	var _upload_form_ctrl = _upload_form as UploadItemToStoreForm

	#Godot 4 explicit
	#it is similar if we remove the "Callable" part
	_upload_form_ctrl.store_item_submission_done.connect(Callable(self, "_on_form_done"))

	# Start in the list view
	change_to_list_view()
	
func _on_form_done() -> void:
	change_to_list_view()
	
func _hide_all() -> void:
	_upload_form.visible = false
	_store_listing.visible = false

func _set_active_view(to_be_active: int) -> void:
	_current_view = to_be_active
	_hide_all()
	match to_be_active:
		ViewState.VIEW_FORM:
			_upload_form.visible = true
		ViewState.VIEW_LIST:
			_store_listing.visible = true
		ViewState.VIEW_NONE:
			pass

func change_to_upload_view() -> void:
	_set_active_view(ViewState.VIEW_FORM)

func change_to_list_view() -> void:
	_set_active_view(ViewState.VIEW_LIST)

func change_to_none_view() -> void:
	_set_active_view(ViewState.VIEW_NONE)
