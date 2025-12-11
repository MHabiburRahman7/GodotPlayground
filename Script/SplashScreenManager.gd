extends Control

#@export var load_scene : PackedScene
@export var in_time: float = 0.5
@export var fade_in_time: float = 1.5
@export var pause_time: float = 1.5
@export var fade_out_time: float = 1.5
@export var out_time: float = 0.5
@export var splash_screen_container : Node

var splash_screens: Array

func _ready() -> void:
	get_screens()
	fade()
	
func fade() -> void:
	for screen in splash_screens:
		var tween = self.create_tween()
		tween.tween_interval(in_time)
		tween.tween_property(screen, "modulate:a", 1.0, fade_in_time)
		tween.tween_interval(pause_time)
		tween.tween_property(screen, "modulate:a", 0.0, fade_out_time)
		tween.tween_interval(out_time)
		await tween.finished
	move_to_main_menu_scene()
	#get_tree().change_scene_to_packed(load_scene)

func get_screens() -> void:
	splash_screens = splash_screen_container.get_children()
	for screen in splash_screens:
		screen.modulate.a = 0.0

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_pressed():
		#move_to_main_menu_scene()
		#get_tree().change_scene_to_packed(load_scene)

func move_to_main_menu_scene() -> void:
	var controller = Global.get_game_controller()
	if controller:
		controller.change_2d_scene("res://Scenes/UI/MainMenu.tscn")
	else:
		print("no no no, not good")
	
