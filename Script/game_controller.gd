class_name GameController extends Node

@export var world_2d : Node2D
@export var gui : Control
@export var transition_controller : SceneTransitionController

var current_2d_scene
var current_gui_scene

func _ready() -> void:
	print("global_controller_ready")
	Global.set_game_controller(self)
	current_gui_scene = $GUI/SplashScreenManager

func change_gui_scene(new_scene: String, 
	delete: bool = true, 
	keep_running: bool = false,
	transition: bool = true,
	transition_in: String = "FadeIn",
	transition_out: String = "FadeOut",
	seconds: float = 1.0) -> void:
	
	print("changing gui scene")
		
	if transition:
		transition_controller.transition(transition_out, seconds)
		await transition_controller.animation_player.animation_finished
	if current_gui_scene != null:
		if delete:
			current_gui_scene.queue_free()
		elif keep_running:
			current_gui_scene.visible = false
		else:
			gui.remove_child(current_gui_scene)
	var temp_new_scene = load(new_scene).Instantiate()
	gui.add_child(temp_new_scene)
	current_gui_scene = temp_new_scene
	if transition:
		transition_controller.transition(transition_in, seconds)
	
func change_2d_scene(new_scene: String, 
	delete: bool = true, 
	keep_running: bool = false,
	transition: bool = true,
	transition_in: String = "FadeIn",
	transition_out: String = "FadeOut",
	seconds: float = 1.0) -> void:
	
	print("changing 2d scene")
		
	if transition:
		transition_controller.transition(transition_out, seconds)
		await transition_controller.animation_player.animation_finished
	if current_2d_scene != null:
		if delete:
			current_2d_scene.queue_free()
		elif keep_running:
			current_2d_scene.visible = false
		else:
			gui.remove_child(current_2d_scene)
	var temp_new_scene = load(new_scene).instantiate()
	world_2d.add_child(temp_new_scene)
	current_2d_scene = temp_new_scene
	if transition:
		transition_controller.transition(transition_in, seconds)
