extends Control

class_name ItemRequirementSlotUI

@export var icon : TextureRect
@export var input_name_label : Label
@export var current_amount_label : Label
@export var required_amount_label : Label

func init(in_icon_path: String, input_item_name: String, owned_item_amount: int, required_item_amount: int) -> void:
	var icon_path = in_icon_path
	if icon_path == "":
		icon.texture = load("res://icon.svg")
	else: 
		icon.texture = load(in_icon_path)

	input_name_label.text = input_item_name
	current_amount_label.text = str(owned_item_amount)
	required_amount_label.text = "/ " + str(required_item_amount)
