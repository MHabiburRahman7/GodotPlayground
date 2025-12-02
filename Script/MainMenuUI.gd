extends Control

func _on_start_button_button_down() -> void:
	var controller = Global.get_game_controller()
	if controller:
		controller.change_2d_scene("res://Scenes/Maps/OutsideHome.tscn")
		
func _on_exit_button_button_down() -> void:
	get_tree().quit()
