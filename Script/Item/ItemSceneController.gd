extends Node

var item : ItemInstance

func _ready() -> void:
	var item_data: ItemData = preload("res://Resources/Item/TestItem.tres")
	item = ItemInstance.new(item_data)
	item.behaviors.append(ItemPackedBehavior.new())
	item.behaviors.append(ItemPhotoBehavior.new())
	item.behaviors.append(ItemUsableBehavior.new())
	item.behaviors.append(ItemSellableBehavior.new())
	print("behavior lists:", item.behaviors.size())

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		print("item state is_reserved", item.state.is_reserved)
		print("item state condition", item.state.condition)
		print("item state quality", item.state.quality)
		
		print("item behavior Packed: ", item.get_behavior(ItemPackedBehavior).is_packed)
		print("item behavior Photo: ", item.get_behavior(ItemPhotoBehavior).has_photo)
		item.get_behavior(ItemUsableBehavior).execute("")
		item.get_behavior(ItemUsableBehavior).apply_effect()
		print("item behavior base price: ", item.get_behavior(ItemSellableBehavior).base_price)
		item.get_behavior(ItemSellableBehavior).execute("")
		item.get_behavior(ItemSellableBehavior).send_to_courier()
		
