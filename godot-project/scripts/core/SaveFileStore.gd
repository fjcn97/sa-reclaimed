# SaveFileStore.gd
# Small persistence boundary shared by the gameplay bridge and validation tools.
class_name SaveFileStore
extends RefCounted

static func read_json_dictionary(path: String) -> Variant:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return null
	# Corrupt primaries are expected during backup recovery. Return null without
	# logging so callers can try the backup path quietly.
	var text := file.get_as_text().strip_edges()
	file.close()
	if text.is_empty() or not text.begins_with("{") or not text.ends_with("}"):
		return null
	var parsed = JSON.parse_string(text)
	return parsed if parsed is Dictionary else null

static func write_json_with_backup(path: String, payload: Dictionary) -> bool:
	var serialized := JSON.stringify(payload)
	var previous := FileAccess.open(path, FileAccess.READ)
	if previous:
		var previous_text := previous.get_as_text()
		previous.close()
		var backup := FileAccess.open(path + ".bak", FileAccess.WRITE)
		if backup:
			backup.store_string(previous_text)
			backup.close()
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(serialized)
	file.close()
	return true
