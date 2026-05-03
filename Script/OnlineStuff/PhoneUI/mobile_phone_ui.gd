extends Control
class_name MobilePhoneUI
@onready var tabs = $Background/Margin/Layout/Tabs

func open():
	visible = true
	get_tree().paused = true

func close():
	visible = false
	get_tree().paused = false

##deactivate this, only for testing purpose
#func _ready() -> void:
	#
