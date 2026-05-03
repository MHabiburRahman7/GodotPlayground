extends Node


# Utility singleton for saving and loading JSON-formatted dictionaries to disk.
static func save_dict_as_json(path: String, data: Dictionary) -> Error:
	# Ensure directory exists.
	var dir_path: String = path.get_base_dir()
	if dir_path != "" and not DirAccess.dir_exists_absolute(dir_path):
		var dir_err: Error = DirAccess.make_dir_recursive_absolute(dir_path)
		if dir_err != OK:
			push_warning("PersistenceManager: failed to create directory %s" % dir_path)
	# Open file for writing.
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_warning("PersistenceManager: unable to open %s for writing" % path)
		return ERR_CANT_OPEN
	# Serialize dictionary as pretty JSON.
	var json_text: String = JSON.stringify(data, "\t")
	file.store_string(json_text)
	file.close()
	
	#stored to:
	#print("Saving catalog to: ", ProjectSettings.globalize_path("user://store_catalog.json"))
	return OK

static func load_dict_from_json(path: String) -> Dictionary:
	# Return empty dict if file does not exist.
	if not FileAccess.file_exists(path):
		return {}
	# Open file for reading.
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("PersistenceManager: unable to open %s for reading" % path)
		return {}
	var text: String = file.get_as_text()
	file.close()
	if text.strip_edges(true, true) == "":
		return {}
	
	var my_json = JSON.new()
	var result = my_json.parse(text)
	if result != OK:
		push_warning("PersistenceManager: JSON parse error in %s: %s" % [path, result.error_string])
		return {}
	
	var data = my_json.get_data()
	if typeof(data) != TYPE_DICTIONARY:
		push_warning("PersistenceManager: Expected Dictionary in %s, got %s" % [path, typeof(result.result)])
		return {}
	return data
