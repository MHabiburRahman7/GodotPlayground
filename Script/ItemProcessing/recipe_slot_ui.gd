extends Control

class_name RecipeSlotUI

signal select_recipe(recipe: RecipeInstance)

@export var _icon : TextureRect
var _recipe : RecipeInstance

func init(_in_recipe : RecipeInstance) -> void:
	var icon_path = _in_recipe.icon_path
	if icon_path == "":
		_icon.texture = load("res://icon.svg")
	else:
		_icon.texture = load(icon_path)
	_recipe = _in_recipe

func get_recipe() -> RecipeInstance:
	return _recipe

func _on_recipe_button_button_up() -> void:
	select_recipe.emit(_recipe)
