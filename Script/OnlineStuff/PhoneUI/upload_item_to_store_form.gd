class_name UploadItemToStoreForm
extends Control

@export var _name_input : TextEdit
@export var _price_input : TextEdit
@export var _qty_input : TextEdit
@export var _image_path_input : TextEdit
@export var _status_label : Label

var _temp_item_name : String
var _temp_price : float
var _temp_qty : float
var _temp_image_path : String

func _reset_temp_names() -> void:
	_temp_item_name = ""
	_temp_price = 0
	_temp_qty = 0
	_temp_image_path = "" 

func _on_button_cancel_pressed() -> void:
	_reset_temp_names()
	#should be back to previous screen (Listing)
	pass

func _on_button_submit_pressed() -> void:
	_reset_temp_names()
	
	_temp_item_name = _name_input.text.strip_edges()
	if _temp_item_name == "":
		_set_status("Item name is required.")
		return
	if !_price_input.text.is_valid_float():
		_set_status("Price should be number")
		return
	else:
		_temp_price = float(_price_input.value)
		
	if !_qty_input.text.is_valid_float():
		_set_status("Quantity should be number")
		return
	else:
		_temp_qty = float(_qty_input.value)

	_temp_image_path = _image_path_input.text.strip_edges()

	_set_status("Item Added!")

func _set_status(value: String) -> void:
	_status_label.text = value


func _on_submit_button_pressed() -> void:
	pass # Replace with function body.


func _on_cancel_button_pressed() -> void:
	pass # Replace with function body.
