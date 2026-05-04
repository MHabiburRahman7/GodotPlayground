extends Control
class_name StoreItemSlot

# Node references
@onready var name_label: Label = $Background/ItemNameValue
@onready var price_label: Label = $Background/PriceValue
@onready var qty_label: Label = $Background/QtyValue
@onready var sprite_node: Sprite2D = $Background/ItemSprite
@onready var selected_box: CheckBox = $Background/SelectedValue

@export var store_system_path: NodePath = "/root/StoreSystemSingleton"
@onready var _store_system: StoreSystem = get_node(store_system_path) as StoreSystem

func _ready() -> void:
	if _store_system == null:
		push_warning("UploadItemToStoreForm: StoreSystemSingleton not found")
	selected_box.toggled.connect(_on_selected_toggled)

var entry: StoreItemEntry = null
var _is_selected = false

func _reset_button_status() -> void:
	_is_selected = false

func set_entry(item_entry: StoreItemEntry) -> void:
	entry = item_entry
	name_label.text = entry.display_name
	price_label.text = "$%.2f" % entry.price
	qty_label.text = "%d" % entry.qty
	if entry.sprite_path != "":
		var tex := load(entry.sprite_path)
		if tex is Texture2D:
			sprite_node.texture = tex
		else:
			sprite_node.texture = null
	else:
		sprite_node.texture = null
	_reset_button_status()

func clear() -> void:
	entry = null
	name_label.text = ""
	price_label.text = ""
	sprite_node.texture = null

func _on_selected_toggled(pressed: bool) -> void:
	if entry:
		_store_system.on_item_selected_change(entry.id, pressed)

func _on_button_pressed() -> void:
	_is_selected = !_is_selected
	selected_box.button_pressed = _is_selected

	print("StoreItemSlot: selected: id: %d is_selected: %d ", entry.id, _is_selected )
	_store_system.on_item_selected_change(entry.id, _is_selected)
