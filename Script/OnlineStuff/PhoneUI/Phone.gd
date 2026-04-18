extends Control

@onready var tabs = $Background/Margin/Layout/Tabs

func open():
	visible = true
	get_tree().paused = true

func close():
	visible = false
	get_tree().paused = false
