extends Control
class_name StoreItemSlot

# Node references
@onready var name_label: Label = $Background/ItemNameValue
@onready var price_label: Label = $Background/PriceValue
@onready var qty_label: Label = $Background/QtyValue
@onready var sprite_node: Sprite2D = $Background/ItemSprite

var entry: StoreItemEntry = null

signal store_item_pressed(entry: StoreItemEntry)

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

func clear() -> void:
	entry = null
	name_label.text = ""
	price_label.text = ""
	sprite_node.texture = null

func _on_button_pressed() -> void:
	if entry:
		emit_signal("store_item_pressed", entry)
