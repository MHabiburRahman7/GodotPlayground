extends Node
class_name StoreListingController
@export var _store_list_container: VBoxContainer
# Packed scene for displaying each store entry
const STORE_ITEM_SLOT_SCENE: PackedScene = preload(
    "res://Scenes/OnlineStuff/ChildItems/store_item_slot.tscn"
)
var _store_system: StoreSystem = null
func _ready() -> void:
	# Grab the StoreSystem singleton (or create a local one if missing)
	if Engine.has_singleton("StoreSystemSingleton"):
		_store_system = Engine.get_singleton("StoreSystemSingleton") as StoreSystem
	else:
		push_warning("StoreListingController: StoreSystemSingleton not available; creating fallback.")
		_store_system = StoreSystem.new()
		add_child(_store_system)
	# When a new item is registered, re‑populate the list
	_store_system.connect("store_item_registered", Callable(self, "refresh_list"))
	# Initial fill
	refresh_list()
func initialize() -> void:
	# Alias for external callers to trigger the initial refresh
	refresh_list()
func refresh_list() -> void:
	# Clear out any existing slots
	for child in _store_list_container.get_children():
		child.queue_free()
	var entries: Array[StoreItemEntry] = _store_system.get_catalog()
	if entries.is_empty():
		# Show a placeholder if there are no items
		var placeholder := Label.new()
		placeholder.text = "No stored items yet."
		_store_list_container.add_child(placeholder)
		return
	# Otherwise, instance a StoreItemSlot for each entry
	for entry in entries:
		var slot := STORE_ITEM_SLOT_SCENE.instantiate() as StoreItemSlot
		_store_list_container.add_child(slot)
		slot.set_entry(entry)
func _add_new_item() -> void:
	# (Optional stub for programmatic additions)
	pass
func _remove_item() -> void:
	# (Optional stub for removal logic)
	pass
