extends Control

class_name SupplyTab
@export var supply_system_path: NodePath = "/root/SupplySystemSingleton"
@onready var _supply_system: SupplySystem = get_node(supply_system_path) as SupplySystem
@onready var grid = $SupplyGrid

func _ready():
	if not _supply_system:
		print("SupplySystemSingleton not available; supply tab disabled")
		return

	_supply_system.item_arrived.connect(_on_item_arrived)
	populate()

func populate():
	if not _supply_system:
		return

	for item_id in _supply_system.catalog.keys():
		var data = _supply_system.catalog[item_id]
		var btn = Button.new()
		btn.text = "%s ($%d)" % [data.name, data.price]
		var order_id = item_id
		btn.pressed.connect(func():
			_supply_system.order(order_id)
		)
		grid.add_child(btn)

func _on_item_arrived(item_id, amount):
	print("Arrived:", item_id, amount)
