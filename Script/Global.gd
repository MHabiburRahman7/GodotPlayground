extends Node

var global_controller : GameController
var debug : Debug

func set_game_controller(controller):
	global_controller = controller
	print("game controller is set")

func get_game_controller():
	if global_controller:
		return global_controller
	else:
		print("Global controller is null!")

#func _process(_delta) -> void:
	#var current = global_controller
	#if current:
		#print("Global controller is set:", current)
	#else:
		#print("Global controller is null")
