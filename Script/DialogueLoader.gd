extends Node

class_name DialogueLoader

static func load_dialogue(path: String) -> Dictionary:
	# Loads a JSON dialogue file and returns a parsed Dictionary
	if not FileAccess.file_exists(path):
		push_error("Dialogue file not found: " + path)
		return {}

	var file := FileAccess.open(path, FileAccess.READ)
	var text := file.get_as_text()

	var result = JSON.parse_string(text)
	if result == null:
		push_error("Failed to parse JSON: " + path)
		return {}

	return result
