extends Control

class_name TimePanelUI

@export var _clock_panel_ui : ClockPanelUI
@export var _day_panel_ui : DayPanelUI

@onready var _time_system : TimeSystem = TimeSystemSingleton
#for debugging
@export var _time_scale: int = 1

# NOTE: it shoudl be placed on setting later
@export var is_using_24_hour_format : bool = true
var AM_PM_HOUR_BORDER : int = 12
var MIDNIGHT_HOUR : int = 24

enum AMPMState
{
	AM,
	PM
}

enum DayNightState
{
	Day,
	Night
}

var _night_start_hour : int = 18
var _night_end_hour: int = 5

func _init() -> void:
	if _time_system == null:
		#Only for testing purpose, instantiate manually
		if OS.is_debug_build():
			_time_system = TimeSystem.new()

func _ready() -> void:
	#needs to be done on ready because when init, all UI is Nil
	if _time_system != null:
		_time_system.minute_changed.connect(_on_minute_changed)
		_time_system.hour_changed.connect(_on_hour_changed)
		_time_system.day_changed.connect(_on_day_changed)
	
	_init_clock_panel()
	_init_day_panel()

func _init_clock_panel() -> void:
	var hour = _time_system.get_hour()
	var minute = _time_system.get_minute()
	_set_hour_ui(hour)
	_set_minute_ui(minute)
	_set_day_light_ui(hour)

func _init_day_panel() -> void:
	var day = _time_system.get_day()
	_set_day_ui(day)

func _on_minute_changed(minute: int) -> void:
	_set_minute_ui(minute)

func _on_hour_changed(hour: int) -> void:
	_set_hour_ui(hour)
	_set_day_light_ui(hour)

func _on_day_changed(day: int) -> void:
	_set_day_ui(day)
	
func _set_hour_ui(hour: int) -> void:
	if is_using_24_hour_format:
			_clock_panel_ui.set_hour(hour % MIDNIGHT_HOUR)
			_clock_panel_ui.set_am_pm("  ")
	else:
		var new_hour = hour % AM_PM_HOUR_BORDER
		_clock_panel_ui.set_hour(new_hour)
		
		#calculate AM-PM diff
		var state = AMPMState.AM	
		if hour >= AM_PM_HOUR_BORDER:
			state = AMPMState.PM	
		var new_state = AMPMState.find_key(state)
		_clock_panel_ui.set_am_pm(new_state)

func _set_minute_ui(minute : int) -> void:
	_clock_panel_ui.set_minute(minute)

func _set_day_ui(day: int) -> void:
	_day_panel_ui.set_date(day)

func _set_day_light_ui(hour: int) -> void:
	if hour >= _night_start_hour && hour <= _night_end_hour:
		_day_panel_ui.set_day_night("Night")
	else:
		_day_panel_ui.set_day_night("Daylight")

func _process(delta: float) -> void:
	if OS.is_debug_build():
		_time_system.set_time_scale(_time_scale)
