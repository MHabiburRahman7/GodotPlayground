extends Control

class_name ClockPanelUI

@export var _hour_label : Label
@export var _minute_label : Label
@export var _am_pm_label : Label

#func init_clock_24(hour: int, minute: int) -> void :
	#set_hour(hour)
	#set_minute(minute)
#
#func init_clock_12(hour: int, minute: int, am_pm: String) -> void :
	#set_hour(hour)
	#set_minute(minute)
	#set_am_pm(am_pm)

# Note: I'm note sure whether this two functsion needed or not. 
# I separate them just in case if I need to direct set hour and minute separately
func set_minute(minute: int) -> void:
	_minute_label.text = "%02d" % minute

func set_hour(hour: int) -> void:
	_hour_label.text = "%02d" % hour

func set_am_pm(state: String) -> void:
	_am_pm_label.text = state

#func _set_clock_base(hour: int, minute:int) -> void:
	#set_hour(hour)
	#set_minute(minute)
	#
	## It should make the same space as if "AM" or "PM" is visible
	#_am_pm_label.text = "  "

## --- testing purpose ---
#func _ready() -> void:
	#reset_clock()
	#await get_tree().create_timer(1.0, false).timeout
	#set_clock_24(1,0)
	#await get_tree().create_timer(1.0, false).timeout
	#set_clock_12(1,1, AMPMState.AM)
	#await get_tree().create_timer(1.0, false).timeout
	#set_clock_24(1,10)
	#await get_tree().create_timer(1.0, false).timeout
	#set_clock_12(10,0,AMPMState.PM)
	#await get_tree().create_timer(1.0, false).timeout
	#set_clock_24(10,20)
	#await get_tree().create_timer(1.0, false).timeout
	#set_clock_12(20,30, AMPMState.AM)
