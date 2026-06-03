class_name RecipeInstance

var id : String
var name : String
var time_required : int
var required_items : Array[ItemInstance]
var required_amounts : Array[int]
var icon_path: String

func _init(recipe_id: String, recipe_name : String, recipe_time: int, recipe_items: Array[ItemInstance], recipe_amounts: Array[int], in_icon_path : String = "") -> void:
	id = recipe_id
	name = recipe_name
	time_required = recipe_time
	required_items = recipe_items
	required_amounts = recipe_amounts
	icon_path = in_icon_path
