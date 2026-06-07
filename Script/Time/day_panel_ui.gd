extends Control

class_name DayPanelUI

@export var _date_label : Label
@export var _day_night_label : Label

var DAY_PREFIX : String = "DAY "
var MAX_DATE_NUMBER : int = 9999

#func set_date_day(date : int, day_night : DayNightState) -> void:
	#_set_date(date)
	#_set_day_night(day_night)

func reset_date_night() -> void:
	set_date(0)
	set_day_night("Day")
	
func set_date(in_date: int) -> void:
	var date : int = _compensate_overflow(in_date)
	_date_label.text = DAY_PREFIX + str(date)

func set_day_night(state: String) -> void:
	_day_night_label.text = state

# Note: this is just temporary solution
# The final solution is either making it Year - month - date, or else
func _compensate_overflow(current_date: int) -> int:
	return current_date % MAX_DATE_NUMBER

### --- testing purpose ---
#func _ready() -> void:
	#reset_date_night()
	#for i in range(10):
		#var new_date : int = 1 * (10 ** i) 
		#var state : DayNightState = i % 2
		#set_date_day(new_date, state)
		#await get_tree().create_timer(1.0, false).timeout
