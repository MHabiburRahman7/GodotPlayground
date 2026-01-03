extends Control
class_name InventorySlot

@export var icon: TextureRect
@export var name_label: Label

var item: ItemInstance = null

signal pressed(item: ItemInstance)

func set_item(item_instance: ItemInstance) -> void:
	item = item_instance
	icon.texture = item.data.icon
	name_label.text = item.data.name

func clear():
	item = null
	icon.texture = null
	name_label.text = ""

func _on_button_pressed():
	if item:
		emit_signal("pressed", item)
