class_name GameController extends Node

@export var world_2d : Node2D
@export var gui : Control
@export var transition_controller : SceneTransitionController

var current_2d_scene
var current_gui_scene

@onready var inventory_panel = $GUI/CanvasLayer/InventoryPanelMaster

func _ready() -> void:
	print("global_controller_ready")
	Global.set_game_controller(self)
	
	#if it's not production build, skip splash screen
	if OS.is_debug_build():
		current_gui_scene = null
	else:
		current_gui_scene = $GUI/SplashScreenManager
	

#to detect existing inventory object in a new scene
func scan_for_chest() -> void:
	for chest in get_tree().get_nodes_in_group("chests"):
		#chest.chest_opened.connect(_on_chest_opened)
		#chest.chest_openedv2.connect(_on_chest_openedv2)
		chest.chest_openedv3.connect(_on_chest_openedv3)
		chest.chest_closed.connect(_on_chest_closed)
		print("chest found and connected")

func _on_chest_opened(inventory: Inventory):
	inventory_panel.bind_inventory(inventory)
	inventory_panel.visible = !inventory_panel.visible

func _on_chest_openedv2(inventory_left: Inventory, inventory_right: Inventory) -> void:
	inventory_panel.open(inventory_left, inventory_right)
	
func _on_chest_openedv3(inventory_left: Inventory, name_left: String, inventory_right: Inventory, name_right: String) -> void:
	inventory_panel.openv2(inventory_left, name_left, inventory_right, name_right)

func _on_chest_closed():
	inventory_panel.visible = false

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
		
	scan_for_chest()
