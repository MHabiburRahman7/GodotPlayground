extends Node

# controller where an item is scattered in the world

@export var item_data: ItemData
var item : ItemInstance
var is_user_close := false

func _ready() -> void:
	item = ItemInstance.new(item_data)

func _process(delta: float) -> void:
	_can_interact()
	
func _can_interact() -> void:
	if is_user_close:
		if Input.is_action_just_pressed("ui_accept"):
			print("ItemSceneController: transferring item :", item.data.name)
			
			# Transfer it to the Player's Inventory 
			
			# Destroy the current node
			queue_free() # Safely deletes the node at the end of the frame
			

func _on_interactable_area_2d_body_entered(body: Node2D) -> void:
	print("ItemSceneController: attempting to fetch item :", item.data.name)
	if body.is_in_group("player") || body.name =="Player":
		print("ItemSceneController: Player entered area with: ", body.name)
		is_user_close = true
		

func _on_interactable_area_2d_body_exited(body: Node2D) -> void:
	print("ItemSceneController: someone exited the item :", item.data.name)
	
	if body.is_in_group("player") || body.name =="Player":
		print("Player exited: ", body.name)
		is_user_close = false
