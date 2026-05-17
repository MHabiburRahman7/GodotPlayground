extends Control

class_name SupplyTab
@onready var grid = $SupplyGrid

	#_supply_system.item_arrived.connect(_on_item_arrived)
	#populate()

signal order_supply_item(supply_item: ItemInstance)

const SUPPLY_ITEM_SLOT_SCENE: PackedScene = preload("res://Scenes/OnlineStuff/ChildItems/supply_item_slot.tscn")

func populatev2(supply_items : Array[ItemInstance]) -> void:
	for item in supply_items:
		#var btn = Button.new()
		#btn.text = "%s ($%d)" % [item.name, item.price]
		#btn.pressed.connect(func():
			##_supply_system.orderv2(item)
			#emit("order_supply_item")
		#)
		#grid.add_child(btn)
		var slot: SupplyItemSlot = SUPPLY_ITEM_SLOT_SCENE.instantiate()
		slot.visible = true
		slot.set_item(item)
		slot.supply_item_pressed.connect(_on_slot_pressed)
		grid.add_child(slot)

#func populate():
	#for item in supply_items:
		#var btn = Button.new()
		#btn.text = "%s ($%d)" % [item.name, item.price]
		#var order_id = item.id
		#btn.pressed.connect(func():
			#_supply_system.order(order_id)
		#)
		#grid.add_child(btn)

#func _on_item_arrived(item_id, amount):
	#print("Arrived:", item_id, amount)

func _on_slot_pressed(item: ItemInstance) -> void:
	if item != null:
		emit_signal("order_supply_item", item)
