extends CharacterBody2D

@export var move_speed: float = 200.0
@export var starting_direction : Vector2 = Vector2(0,1) 

#caps and letter matters based on the scene
@onready var animation_tree = $AnimationTree 
@onready var state_machine = animation_tree.get("parameters/playback")

##for testing inventory
#@export var inventory_panel: Control
#var inventory := Inventory.new()
#@export var test_item_data: ItemData

func _ready() -> void:
	_update_animation_param(starting_direction)

	##for testing inventory
	#inventory.capacity = 10  # test backpack
	#inventory_panel.bind_inventory(inventory)
	#inventory_panel.visible = false
	
##for testing inventory
#func _input(event):
	#if event.is_action_pressed("inventory_toggle"):
		#inventory_panel.visible = !inventory_panel.visible
	#
	#if event.is_action_pressed("ui_accept"):
		#var item = ItemInstance.new(test_item_data)
		#inventory.add_item(item)
		#inventory_panel.refresh()

	#lets do this later
	#add_to_group("player")


func _physics_process(_delta: float) -> void:
	var input_vec := Vector2.ZERO

	input_vec.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vec.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vec = input_vec.normalized()
	
	_update_animation_param(input_vec)

	velocity = input_vec * move_speed
	#print("input vec x:", input_vec.x
		#, " input y: ", input_vec.y
		#, " velocity: ", velocity
		#, " pos: ", global_position)
	
	move_and_slide()
	_pick_new_state()
	
func _update_animation_param(move_input : Vector2) -> void:
	#Dont change animation param if there's no input
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Idle/blend_position", move_input)
		animation_tree.set("parameters/Walk/blend_position", move_input)
		
func _pick_new_state() -> void:
	if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
