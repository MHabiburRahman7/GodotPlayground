extends Control
class_name StoreTab
const STORE_ITEM_SLOT_SCENE: PackedScene = preload("res://Scenes/OnlineStuff/ChildItems/store_item_slot.tscn")

var _store_system: StoreSystem = null

@onready var _form_container: PanelContainer = $StoreColumn/StoreViewPanel/StoreForm
@onready var _name_input: LineEdit = $StoreColumn/StoreViewPanel/StoreForm/StoreFormContent/NameInput
@onready var _price_input: SpinBox = $StoreColumn/StoreViewPanel/StoreForm/StoreFormContent/PriceInput
@onready var _sprite_input: LineEdit = $StoreColumn/StoreViewPanel/StoreViewPanel/StoreForm/StoreFormContent/SpriteInput
@onready var _register_button: Button = $StoreColumn/StoreViewPanel/StoreForm/StoreFormContent/RegisterButton
@onready var _close_button: Button = $StoreColumn/StoreForm/StoreFormContent/CloseFormButton
@onready var _status_label: Label = $StoreColumn/StoreForm/StoreFormContent/StatusLabel
@onready var _upload_button: Button = $StoreColumn/UploadButton
@onready var _store_list: VBoxContainer = $StoreColumn/StoreListScroll/StoreList

func _ready() -> void:
	_form_container.visible = false
	_upload_button.pressed.connect(Callable(self, "_on_upload_button_pressed"))
	_close_button.pressed.connect(Callable(self, "_on_close_button_pressed"))
	if Engine.has_singleton("StoreSystemSingleton"):
		_store_system = Engine.get_singleton("StoreSystemSingleton") as StoreSystem
	else:
		print("StoreSystemSingleton not available; using temporary store manager.")
		_store_system = StoreSystem.new()
		add_child(_store_system)
	_register_button.pressed.connect(Callable(self, "_on_register_button_pressed"))
	_store_system.connect("store_item_registered", Callable(self, "_on_item_registered"))
	_refresh_listing()

func _on_upload_button_pressed() -> void:
	_form_container.visible = true
	_set_status("")
	_name_input.grab_focus()

func _on_close_button_pressed() -> void:
	_hide_form()

func _on_register_button_pressed() -> void:
	if _store_system == null:
		_set_status("Store service unavailable.")
		return
	var name: String = _name_input.text.strip_edges()
	if name == "":
		_set_status("Item name is required.")
		return
	var price: float = _price_input.value
	var sprite_path: String = _sprite_input.text.strip_edges()
	var entry: StoreItemEntry = _store_system.register_item(name, price, sprite_path)
	if entry == null:
		_set_status("Failed to store the item.")
		return
	_set_status("%s stored (ID %d)." % [entry.display_name, entry.id])
	_clear_form()
	_hide_form()
	_refresh_listing()

func _on_item_registered(_item: StoreItemEntry) -> void:
	_refresh_listing()

func _refresh_listing() -> void:
	if _store_system == null:
		return
	var existing_children: Array = _store_list.get_children()
	for child in existing_children:
		child.queue_free()
	var entries: Array[StoreItemEntry] = _store_system.get_catalog()
	if entries.is_empty():
		var placeholder: Label = Label.new()
		placeholder.text = "No stored items yet."
		_store_list.add_child(placeholder)
		return
	for entry in entries:
		var slot: StoreItemSlot = STORE_ITEM_SLOT_SCENE.instantiate() as StoreItemSlot
		print("Creating ", entry.display_name)
		_store_list.add_child(slot)
		slot.set_entry(entry)

func _clear_form() -> void:
	_name_input.text = ""
	_price_input.value = 1.0
	_sprite_input.text = ""

func _set_status(value: String) -> void:
	_status_label.text = value

func _hide_form() -> void:
	_form_container.visible = false
