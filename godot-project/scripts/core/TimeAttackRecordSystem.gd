class_name TimeAttackRecordSystem
extends RefCounted

## Owns time-attack record keys, tables, and top-three insertion.

static func record_key(character_index: int, course_index: int, act_index: int, boss_mode: bool) -> String:
	return "%d:%d:%d:%d" % [character_index, course_index, act_index if not boss_mode else 0, 1 if boss_mode else 0]

static func record_table(tables: Dictionary, best_times: Dictionary, key: String) -> Array:
	if tables.has(key) and tables[key] is Array:
		return (tables[key] as Array).duplicate()
	if best_times.has(key):
		return [float(best_times[key])]
	return []

static func best_time(tables: Dictionary, best_times: Dictionary, key: String) -> float:
	var records := record_table(tables, best_times, key)
	if not records.is_empty():
		return float(records[0])
	if not best_times.has(key):
		return -1.0
	return float(best_times[key])

static func store_result(tables: Dictionary, best_times: Dictionary, key: String, clear_time: float) -> Dictionary:
	var records := record_table(tables, best_times, key)
	var previous_best := float(records[0]) if not records.is_empty() else -1.0
	var insert_at := records.size()
	for i in range(records.size()):
		if clear_time < float(records[i]):
			insert_at = i
			break
	if insert_at >= 3:
		return {"updated": false, "previous_best": previous_best, "rank": 0, "new_best": false}
	records.insert(insert_at, clear_time)
	if records.size() > 3:
		records.resize(3)
	tables[key] = records
	best_times[key] = float(records[0])
	return {"updated": true, "previous_best": previous_best, "rank": insert_at + 1, "new_best": insert_at == 0}
