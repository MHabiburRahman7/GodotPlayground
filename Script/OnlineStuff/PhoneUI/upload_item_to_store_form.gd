extends Control
class_name UploadItemToStoreForm

signal store_item_submission_done()

@export var _name_input: TextEdit
@export var _price_input: TextEdit
@export var _qty_input: TextEdit
@export var _image_path_input: TextEdit
@export var _status_label: Label

@export var store_system_path: NodePath = "/root/StoreSystemSingleton"
@onready var _store_system: StoreSystem = get_node(store_system_path) as StoreSystem

func _ready() -> void:
	_reset_form()
	if _store_system == null:
		push_warning("UplIoadItemToStoreForm: StoreSystemSingleton not found")

# Clears all input fields and status label
func _reset_form() -> void:
	_name_input.text = ""
	_price_input.text = ""
	_qty_input.text = ""
	_image_path_input.text = ""
	_status_label.text = ""

func _on_submit_button_pressed() -> void:
	# Validate inputs
	var name: String = _name_input.text.strip_edges()
	if name == "":
		_status_label.text = "Item name is required."
		return

	if not _price_input.text.is_valid_float():
		_status_label.text = "Price should be a number."
		return
	var price: float = float(_price_input.text)

	# Quantity is not stored in catalog but we validate it
	if not _qty_input.text.is_valid_float():
		_status_label.text = "Quantity should be a number."
		return

	var qty: int = int(_qty_input.text)

	var image_path: String = _image_path_input.text.strip_edges()

	if _store_system == null:
		_status_label.text = "Store service unavailable."
		return

	# Register the item in the store catalog
	var entry: StoreItemEntry = _store_system.register_item(name, price, qty, image_path)
	if entry == null:
		_status_label.text = "Failed to store the item."
		return

	_status_label.text = "%s stored (ID %d)." % [entry.display_name, entry.id]	
	# WAIT ~2 seconds here without blocking
	await get_tree().create_timer(2.0).timeout
	_reset_form()
	emit_signal("store_item_submission_done")

func _on_cancel_button_pressed() -> void:
	_reset_form()
	emit_signal("store_item_submission_done")
