# res://Script/ItemProcessing/packing_ui_v2.gd
extends Control
class_name PackingUIV2
# Path to your JSON recipe database
const RECIPE_DB_PATH : String = "res://Database/item/packing_recipe.json"
# Sub‑scene packeds
@onready var _input_panel    : InputPanelUiV2      = $VBoxContainer/HBoxContainer/InputPanelUiV2
@onready var _require_panel  : ItemRequirementUI    = $VBoxContainer/HBoxContainer/ItemRequirementUi
@onready var _title_label    : Label               = $VBoxContainer/TitleLabel
# All recipes loaded from JSON
var _all_recipes    : Array[RecipeInstance] = []

signal packing_done(packed_item: ItemInstance)

func _ready() -> void:
	_title_label.text = "Packing Table"
	_load_recipes()
	_input_panel.init(_all_recipes)
	_input_panel.select_recipe.connect(_on_recipe_selected)
	#_require_panel.start_packing.connect(_on_start_packing)
	_require_panel.start_packing.connect(_on_start_packing_v2)
	_require_panel.visible = false    # hide until a recipe is picked

# Load & parse the JSON database into RecipeInstance objects
func _load_recipes() -> void:
	var file := FileAccess.open(RECIPE_DB_PATH, FileAccess.ModeFlags.READ)
	if file == null:
		push_error("Cannot open recipe DB: %s" % RECIPE_DB_PATH)
		return
	
	var json = JSON.new()
	var error := json.parse(file.get_as_text())
	file.close()
	if error != OK:
		push_error("Failed to parse recipes JSON: %s" % error)
		return
	# Expecting an Array of Dictionaries
	for dict_recipe in json.data as Array:
		# extract the required_items sub‑array
		var req_items : Array[ItemInstance] = []
		var req_amounts : Array[int] = []
		for rr in dict_recipe.get("required_items", []):
			var item_id : String = str(rr.get("id", ""))
			var item_name : String = str(rr.get("name", ""))
			var item_amount : int = int(rr.get("amount", 1))
			var item_data := ItemData.new()
			item_data.id        = item_id
			item_data.name      = item_name
			item_data.stackable = true
			item_data.base_price = 0
			item_data.category  = "SUPPLY"
			var inst := ItemInstance.new(item_data)
			req_items.append(inst)
			req_amounts.append(item_amount)
		# create RecipeInstance (time_required is hard‑coded or from JSON if you add it)
		var rec := RecipeInstance.new(
			dict_recipe.id,
			dict_recipe.name,
			dict_recipe.get("time_required", 1),
			req_items,
			req_amounts,
			dict_recipe.get("icon_path", "")
		)
		_all_recipes.append(rec)
# Called when the player clicks a recipe slot
func _on_recipe_selected(recipe : RecipeInstance) -> void:
	# Gather how many of each required supply they own
	var backpack : Inventory = InventorySystemSingleton.get_inventory("backpack")
	var have_counts := {}
	for item in recipe.required_items:
		var cnt : int = 0		
		for owned in backpack.items:
			if owned.data.id == item.data.id:
				cnt += 1
		have_counts[item.data.id] = cnt
	# Build two parallel arrays: names, required amounts, current amounts
	var names : Array[String] = []
	var reqs  : Array[int]    = []
	var curs  : Array[int]    = []
	for idx in range(recipe.required_items.size()):
		var item_data: ItemInstance = recipe.required_items[idx]
		names.append(item_data.data.name)
		# Guard against missing or mismatched amounts array
		var needed_amount: int = 1
		if idx < recipe.required_amounts.size():
			needed_amount = recipe.required_amounts[idx]
		reqs.append(needed_amount)
		curs.append(have_counts.get(item_data.data.id, 0))
	_require_panel.init_requirement(recipe, names, reqs, curs)

func _do_packing(recipe: RecipeInstance) -> ItemInstance:
	var backpack       : Inventory = InventorySystemSingleton.get_inventory("backpack")
	# remove each required ingredient
	for idx in range(recipe.required_items.size()):
		var ingredient := recipe.required_items[idx]
		var needed_amount : int = recipe.required_amounts[idx]
		# remove `needed_amount` matching items
		for i in range(needed_amount):
			var removed : bool = false
			for owned in backpack.items:
				if owned.data.id == ingredient.data.id:
					backpack.remove_item(owned)
					removed = true
					break
			if not removed:
				push_error("Missing required item: %s" % ingredient.data.name)
				return null
				break
	# create the finished product and send to courier
	var prod_data := ItemData.new()
	prod_data.id        = recipe.id
	prod_data.name      = recipe.name
	prod_data.stackable = false
	prod_data.base_price = 0
	prod_data.category  = "STORE"
	return ItemInstance.new(prod_data)

# Called when the “Pack” button is pressed and requirements are met
func _on_start_packing(recipe : RecipeInstance) -> void:
	var courier_center : Inventory = InventorySystemSingleton.get_inventory("courier_center")
	var finished := _do_packing(recipe)
	courier_center.add_item(finished)
	# clear out the requirement panel until next selection
	_require_panel._clear()
	_require_panel.visible = false

func _on_start_packing_v2(recipe : RecipeInstance) -> void:
	var finished : ItemInstance = _do_packing(recipe)
	if finished == null:
		return
	packing_done.emit(finished)
	_require_panel._clear()
	_require_panel.visible = false
