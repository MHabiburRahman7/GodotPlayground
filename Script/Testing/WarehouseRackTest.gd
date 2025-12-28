extends Node

var current_is_user_close := false
var is_user_close := false

var inventory := Inventory.new()
signal chest_opened(inventory: Inventory)
signal chest_closed()

func _ready() -> void:
	add_to_group("chests")
	inventory.capacity = 10  # test backpack

func _input(event):
	if(current_is_user_close):
		if event.is_action_pressed("use"):
			emit_signal("chest_opened", inventory)
			
func _process(delta: float) -> void:
	if (current_is_user_close != is_user_close):
		current_is_user_close = is_user_close
		print("changing current user close to: ", current_is_user_close)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") || body.name =="Player":
		is_user_close = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") || body.name =="Player":
		is_user_close = false
		emit_signal("chest_closed", inventory)
