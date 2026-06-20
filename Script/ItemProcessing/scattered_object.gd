extends Node

class_name ScatteredObject

@export var _icon : Sprite2D

var _stored_item : ItemInstance
var _is_player_inside : bool
var PLAYER_NODE_NAME : String = "Player"

func init(item : ItemInstance) -> void:
	_stored_item = item
	var _item_icon = _stored_item.data.icon
	if _item_icon != null:
		_icon.texture = _item_icon
	else:
		_icon.texture = load("res://icon.svg")

func _on_area_2d_body_entered(body):
	# Check if the exact name of the node matches
	if body.name.to_lower() == PLAYER_NODE_NAME.to_lower():
		_is_player_inside = true
		print("ScatteredObject: item picked up by player")
		var backpack : Inventory = InventorySystemSingleton.get_inventory("backpack")
		var result = backpack.add_item(_stored_item)
		if result:
			queue_free()
		else:
			print("ScatteredObject: cant fit to the backpack")

func _on_area_2d_body_exited(body):
	pass
	#if _is_player_inside:
		#if body.name.to_lower() == PLAYER_NODE_NAME.to_lower():
			#_is_player_inside = false
