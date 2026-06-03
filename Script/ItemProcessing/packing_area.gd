extends Node

class_name PackingArea

#THis part needs to be centralized
var PLAYER_NODE_NAME :String = "Player"

signal player_start_packing()
signal player_end_packing()

var is_player_inside: bool = false

func _ready() -> void:
	add_to_group("packing")
	is_player_inside = false

func _process(delta: float) -> void:
	if is_player_inside:
		if Input.is_action_pressed("use"):
			print("PackingArea: Emitting use function")
			player_start_packing.emit()

func _on_collision_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	# Check if the exact name of the node matches
	if body.name.to_lower() == PLAYER_NODE_NAME.to_lower():
		is_player_inside = true
		print("PackingArea: The player has entered the area!")

func _on_collision_area_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == PLAYER_NODE_NAME:
		is_player_inside = false
		print("PackingArea: The player has exited the area!")
		player_end_packing.emit()
