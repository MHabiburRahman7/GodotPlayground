extends Node
class_name StoreListing
@export var _store_list_container: VBoxContainer
# Packed scene for displaying each store entry
const STORE_ITEM_SLOT_SCENE: PackedScene = preload(
    "res://Scenes/OnlineStuff/ChildItems/store_item_slot.tscn"
)
@export var store_system_path: NodePath = "/root/StoreSystemSingleton"
@onready var _store_system: StoreSystem = get_node(store_system_path) as StoreSystem

func _ready() -> void:
	if _store_system == null:
		push_warning("UploadItemToStoreForm: StoreSystemSingleton not found")
		
	# When a new item is registered, re‑populate the list
	_store_system.connect("store_item_updated", Callable(self, "refresh_list"))
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
		print("ActiveStoreList: populated store item ", entry.display_name)

func trigger_remove_selected_items() -> void:
	_store_system.remove_selected_item()

func trigger_reset_selected_items() -> void:
	_store_system.reset_deleted_item_list()
