extends Node

# Manages the store catalog for the mobile phone UI.
# Registers StoreItemEntry records with name, price, sprite path, and timestamp,
# emits store_item_registered signals when items are added,
# and persists the catalog to disk as JSON via PersistenceManager.
class_name StoreSystem

signal store_item_updated()

const CATALOG_PATH: String = "user://store_catalog.json"

var catalog: Array[StoreItemEntry] = []
var _next_id: int = 1

var _temp_to_be_deleted : Array[int] = []

func _ready() -> void:
	_load_catalog()

func register_item(name: String, price: float, qty: int, sprite_path: String) -> StoreItemEntry:
	var cleaned_name: String = name.strip_edges()
	if cleaned_name == "":
		push_warning("Attempted to register a store item without a name.")
		return null
	var entry: StoreItemEntry = StoreItemEntry.new()
	entry.id = _next_id
	entry.display_name = cleaned_name
	entry.price = price
	entry.sprite_path = sprite_path.strip_edges()
	entry.created_at = _current_timestamp()
	entry.qty = qty
	entry.demand_weight = 1.0 # initial demand weight
	_next_id += 1
	catalog.append(entry)
	_save_catalog()
	emit_signal("store_item_updated")
	return entry

func get_item_by_name(name: String) -> StoreItemEntry:
	var search: String = name.strip_edges()
	for entry in catalog:
		if entry.display_name == search:
			return entry
	return null

func get_catalog() -> Array[StoreItemEntry]:
	return catalog.duplicate()

func get_catalog_entries() -> Array[StoreItemEntry]:
	# Returns direct references to catalog entries for dynamic weight adjustments
	return catalog

func clear_catalog() -> void:
	catalog.clear()
	_next_id = 1
	_save_catalog()

func _current_timestamp() -> String:
	var now: Dictionary = Time.get_datetime_dict_from_system()
	return "%04d-%02d-%02d %02d:%02d:%02d" % [now.year, now.month, now.day, now.hour, now.minute, now.second]

func _load_catalog() -> void:
	var saved_data: Dictionary = PersistenceManager.load_dict_from_json(CATALOG_PATH)
	if saved_data.is_empty():
		catalog = []
		_next_id = 1
		return
	_next_id = int(saved_data.get("next_id", 1))
	var entries: Array = saved_data.get("catalog", [])
	if typeof(entries) != TYPE_ARRAY:
		entries = []
	catalog = []
	for entry_data in entries:
		if typeof(entry_data) != TYPE_DICTIONARY:
			continue
		var entry: StoreItemEntry = StoreItemEntry.new()
		entry.id = int(entry_data.get("id", _next_id))
		entry.display_name = str(entry_data.get("display_name", ""))
		entry.price = float(entry_data.get("price", 0.0))
		entry.qty = int(entry_data.get("qty", 0))
		entry.sprite_path = str(entry_data.get("sprite_path", ""))
		entry.created_at = str(entry_data.get("created_at", _current_timestamp()))
		entry.demand_weight = float(entry_data.get("demand_weight", 1.0)) # apply saved weight or default
		catalog.append(entry)

func _save_catalog() -> void:
	var catalog_data: Array = []
	for entry in catalog:
		catalog_data.append(entry.to_dict())
	var payload: Dictionary = {
		"next_id": _next_id,
		"catalog": catalog_data,
	}
	var err: Error = PersistenceManager.save_dict_as_json(CATALOG_PATH, payload)
	if err != OK:
		push_warning("StoreSystem: failed to save catalog (code %d)" % err)

#for button item	
func on_item_selected_change(item_id: int, is_selected: bool) -> void:
	if is_selected:
		_temp_to_be_deleted.append(item_id)
	else:
		if _temp_to_be_deleted != null:
			for i in _temp_to_be_deleted:
				if i == item_id:
					_temp_to_be_deleted.remove_at(i)

func reset_deleted_item_list() -> void:
	_temp_to_be_deleted = []

#for delete button
func remove_selected_item() -> void:
	# Filter out the selected IDs in one go:
	catalog = catalog.filter(func(entry):
		return not _temp_to_be_deleted.has(entry.id)
	)
	_temp_to_be_deleted.clear()
	var payload = {
		"next_id": _next_id,
		"catalog": catalog.map(func(e): return e.to_dict()),  # if you have a to_dict() helper
	}
	var err: Error = PersistenceManager.save_dict_as_json(CATALOG_PATH, payload)
	if err != OK:
		push_warning("StoreSystem: failed to save catalog (code %d)" % err)
	
	emit_signal("store_item_updated")
	reset_deleted_item_list()
