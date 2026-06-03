extends Control
class_name InputPanelUiV2

const RECIPE_SLOT_SCENE: PackedScene = preload("res://Scenes/ItemProcessing/recipe_slot_ui.tscn")
@onready var _container : GridContainer = $Container
signal select_recipe(recipe: RecipeInstance)

func init(in_recipes: Array[RecipeInstance]) -> void: 
	for rec in in_recipes:
		add_recipe(rec)

func add_recipe(in_recipe: RecipeInstance) -> void:
	var slot: RecipeSlotUI = RECIPE_SLOT_SCENE.instantiate()
	slot.visible = true
	slot.init(in_recipe)
	slot.select_recipe.connect(_on_recipe_selected)
	_container.add_child(slot)
	
func remove_recipe(in_recipe: RecipeInstance) -> void:
	for recipe in _container.get_children():
		var _n : RecipeSlotUI = recipe
		if _n.get_recipe() == in_recipe:
			_n.queue_free()
			break
			
func _on_recipe_selected(in_recipe: RecipeInstance) -> void:
	print("PackingUI: selecting %s" %in_recipe.name)
	select_recipe.emit(in_recipe)
