#see ItemBehavior as reference
extends ItemBehavior
class_name ItemSellableBehavior

@export var base_price : int

func execute(context) -> void:
	print("Item sellable behavior execute")
	pass

func send_to_courier() -> void:
	print("Item sellable behavior send_to_courier")
	pass
