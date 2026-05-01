extends Control

@onready var grid = $SupplyGrid
var supply_system: SupplySystem = null

func _ready():
	supply_system = _get_supply_system()
	if not supply_system:
		print("SupplySystemSingleton not available; supply tab disabled")
		return

	supply_system.item_arrived.connect(_on_item_arrived)
	populate()

func populate():
	if not supply_system:
		return

	for item_id in supply_system.catalog.keys():
		var data = supply_system.catalog[item_id]
		var btn = Button.new()
		btn.text = "%s ($%d)" % [data.name, data.price]
		var order_id = item_id
		btn.pressed.connect(func():
			supply_system.order(order_id)
		)
		grid.add_child(btn)

func _on_item_arrived(item_id, amount):
	print("Arrived:", item_id, amount)

func _get_supply_system() -> SupplySystem:
	if Engine.has_singleton("SupplySystemSingleton"):
		return Engine.get_singleton("SupplySystemSingleton")
	return null
