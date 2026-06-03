extends Control

class_name ItemRequirementUI

const RECIPE_SLOT_SCENE: PackedScene = preload("res://Scenes/ItemProcessing/item_requirement_slot_ui.tscn")
@export var final_product_name_label : Label
@export var required_time_label : Label
@export var packing_button : Button
@export var requirement_root : VBoxContainer

var _can_packing: bool = false
var _in_recipe: RecipeInstance
var _time_unit_suffix = " hours"

#TODO: triggered ater packing button is clicked, 
# do the backpack item's process (current - requirement) in the controller
# this class will remain the view only
signal start_packing(recipe : RecipeInstance)

func _ready() -> void:
	_clear()
	
func _clear() -> void:	
	for n in requirement_root.get_children():
		n.queue_free()
	final_product_name_label.text = ""
	required_time_label.text = str(0) + _time_unit_suffix
	visible = false
	packing_button.disabled = true

func init_requirement(item_recipe: RecipeInstance, required_items_names: Array[String], required_item_amount: Array[int], currently_have_items_amount: Array[int]) -> void:
	_clear()
	_in_recipe = item_recipe
	
	var _counter = 0
	var _item_amount_diff = 0
	_can_packing = true
	
	for item in required_items_names:
		var slot: ItemRequirementSlotUI = RECIPE_SLOT_SCENE.instantiate()
		
		var current_amount = currently_have_items_amount[_counter]
		var req_amount = required_item_amount[_counter]
		slot.visible = true
		slot.init("", item, current_amount, req_amount)
		
		_item_amount_diff = current_amount - req_amount
		if _item_amount_diff < 0:
			_can_packing = false
		requirement_root.add_child(slot)
		_counter += 1
	
	visible = true
	packing_button.disabled = _can_packing

func _on_packing_button_button_up() -> void:
	if _can_packing:
		start_packing.emit(_in_recipe)
