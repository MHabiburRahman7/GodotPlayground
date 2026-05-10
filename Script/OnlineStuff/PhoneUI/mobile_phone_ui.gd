extends Control
class_name MobilePhoneUI
@onready var tabs = $Background/Margin/Layout/Tabs

func open():
	visible = true
	#get_tree().paused = false

func close():
	visible = false
	#get_tree().paused = true
	
func _process(delta):
	#detect the input of open_phone_input
	if Input.is_action_just_pressed("open_phone_ui"):
		open() 

func _on_close_button_button_up() -> void:
	close()
