extends Control
class_name StoreFormController

var _store_system: StoreSystem = null

@onready var _form_container: Control = $StoreColumn/StoreForm
@onready var _upload_button: Button = $StoreColumn/UploadButton
@onready var _close_button: Button = $StoreColumn/StoreForm/CloseFormButton
@onready var _register_button: Button = $StoreColumn/StoreForm/RegisterButton
@onready var _status_label: Label = $StoreColumn/StoreForm/StatusLabel
@onready var _name_input: LineEdit = $StoreColumn/StoreForm/NameInput
@onready var _price_input: SpinBox = $StoreColumn/StoreForm/PriceInput
@onready var _sprite_input: LineEdit = $StoreColumn/StoreForm/SpriteInput
@onready var _store_list: VBoxContainer = $StoreColumn/StoreListScroll/StoreList

func _ready() -> void:
	_form_container.visible = false
	_upload_button.pressed.connect(Callable(self, "_on_upload_button_pressed"))
	_close_button.pressed.connect(Callable(self, "_on_close_form_pressed"))
	_register_button.pressed.connect(Callable(self, "_on_register_button_pressed"))
	if Engine.has_singleton("StoreSystemSingleton"):
		_store_system = Engine.get_singleton("StoreSystemSingleton") as StoreSystem
		_store_system.connect("store_item_registered", Callable(self, "_refresh_listing"))
	else:
		_status_label.text = "Store service unavailable."
		_upload_button.disabled = true
	_register_button.disabled = _store_system == null
	_refresh_listing()

func _on_upload_button_pressed() -> void:
	_form_container.visible = true
	_upload_button.disabled = true
	_name_input.grab_focus()

func _on_close_form_pressed() -> void:
	_form_container.visible = false
	_upload_button.disabled = false

func _on_register_button_pressed() -> void:
	if _store_system == null:
		_status_label.text = "Store service unavailable."
		return
	var name: String = _name_input.text.strip_edges()
	if name == "":
		_status_label.text = "Item name is required."
		return
	var entry: StoreItemEntry = _store_system.register_item(name, _price_input.value, _sprite_input.text.strip_edges())
	if entry == null:
		_status_label.text = "Failed to store the item."
		return
	_status_label.text = "%s stored (ID %d)." % [entry.display_name, entry.id]
	_clear_form()
	_refresh_listing()
	_form_container.visible = false
	_upload_button.disabled = false

func _refresh_listing() -> void:
	if _store_system == null:
		return
	for child in _store_list.get_children():
		child.queue_free()
	var entries: Array[StoreItemEntry] = _store_system.get_catalog()
	if entries.is_empty():
		_store_list.add_child(_create_placeholder_label("No items uploaded yet."))
		return
	for entry in entries:
		var label: Label = Label.new()
		var sprite_note: String = entry.sprite_path.strip_edges()
		if sprite_note == "":
			sprite_note = "(no sprite specified)"
		label.text = "%s — $%.2f — %s" % [entry.display_name, entry.price, sprite_note]
		_store_list.add_child(label)

func _create_placeholder_label(text: String) -> Label:
	var placeholder: Label = Label.new()
	placeholder.text = text
	placeholder.add_theme_color_override("font_color", Color.GRAY)
	return placeholder

func _clear_form() -> void:
	_name_input.text = ""
	_price_input.value = 1.0
	_sprite_input.text = ""
