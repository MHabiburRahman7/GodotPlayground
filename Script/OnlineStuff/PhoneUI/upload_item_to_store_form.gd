extends Control
class_name UploadItemToStoreForm

signal submitted(entry: StoreItemEntry)
signal cancelled()

@export var _name_input: TextEdit
@export var _price_input: TextEdit
@export var _qty_input: TextEdit
@export var _image_path_input: TextEdit
@export var _status_label: Label

var _store_system: StoreSystem = null

func _ready() -> void:
	# Acquire StoreSystem singleton for registration calls
	if Engine.has_singleton("StoreSystemSingleton"):
		_store_system = Engine.get_singleton("StoreSystemSingleton") as StoreSystem
	else:
		push_warning("UploadItemToStoreForm: StoreSystemSingleton not found")

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

	# We capture qty for potential future use but don't store it yet
	var qty: float = float(_qty_input.text)

	var image_path: String = _image_path_input.text.strip_edges()

	if _store_system == null:
		_status_label.text = "Store service unavailable."
		return

	# Register the item in the store catalog
	var entry: StoreItemEntry = _store_system.register_item(name, price, image_path)
	if entry == null:
		_status_label.text = "Failed to store the item."
		return

	_status_label.text = "%s stored (ID %d)." % [entry.display_name, entry.id]
	emit_signal("submitted", entry)

func _on_cancel_button_pressed() -> void:
	_reset_form()
	emit_signal("cancelled")
