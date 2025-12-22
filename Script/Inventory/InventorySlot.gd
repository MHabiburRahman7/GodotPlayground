extends Control

class_name InventorySlot

@export var this_texture = TextureRect
@export var this_label = Label

var this_item = ItemData

func set_item(item_instance: ItemInstance):
	this_texture.texture = item_instance.data.icon
	this_label.text = item_instance.data.name
	this_item = item_instance.data
