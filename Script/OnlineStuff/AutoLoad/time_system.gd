extends Node
class_name TimeSystem

# Centralized time manager
signal minute_changed(minute: int)
signal hour_changed(hour: int)
signal day_changed(day: int)

const MINUTES_PER_DAY := 1440

# 1.0 --> 1 real second = 1 in-game minute
@export var real_seconds_per_game_minute := 1.0

var total_minutes : int = 480 # Start at 08:00 Day 1
var current_day : int = 1

var time_scale := 1.0

var _timer := 0.0

func _process(delta):
	_timer += delta * time_scale

	if _timer >= real_seconds_per_game_minute:
		_timer -= real_seconds_per_game_minute
		advance_minute()

func advance_minute():
	total_minutes += 1

	minute_changed.emit(get_minute())

	if get_minute() == 0:
		hour_changed.emit(get_hour())

	if total_minutes >= MINUTES_PER_DAY:
		total_minutes = 0
		current_day += 1
		day_changed.emit(current_day)

func get_hour() -> int:
	return total_minutes / 60

func get_minute() -> int:
	return total_minutes % 60

func get_day() -> int:
	return current_day

func get_time_string() -> String:
	return "%02d:%02d" % [get_hour(), get_minute()]

func get_world_minutes() -> int:
	return ((current_day - 1) * MINUTES_PER_DAY) + total_minutes

func set_time_scale(in_time_scale : int) -> void:
	time_scale = in_time_scale
