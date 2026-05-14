extends Control
class_name SupplyItemSlot

@export var icon: TextureRect
@export var name_label: Label
@export var price_label: Label

var item: ItemInstance = null

signal supply_item_pressed(item: ItemInstance)

func set_item(item_instance: ItemInstance) -> void:
	item = item_instance
	icon.texture = item.data.icon
	name_label.text = item.data.name
	price_label.text = str(item.data.base_price)

func clear():
	item = null
	icon.texture = null
	name_label.text = ""
	price_label.text = ""

func _on_button_pressed():
	if item:
		emit_signal("supply_item_pressed", item)
