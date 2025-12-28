extends Node

##for testing inventory
func _input(event):
	if event.is_action_pressed("load_outer_home"):
		Global.get_game_controller().change_2d_scene("res://Scenes/Maps/OutsideHome.tscn")
	if event.is_action_pressed("load_inside_home"):
		Global.get_game_controller().change_2d_scene("res://Scenes/Maps/InsideHome.tscn")
