class_name MultiplayerRecordSystem
extends RefCounted

## Owns persistent multiplayer record-table mutations.

static func insert_or_promote(rows: Array, name: String, player_id: int = 0) -> int:
	var normalized_name := name.strip_edges().to_upper().substr(0, 6)
	if normalized_name.is_empty():
		normalized_name = "PLAYER"
	var identity := maxi(0, player_id)
	if identity == 0:
		identity = SaveProfileSanitizer.multiplayer_identity(normalized_name)
	for i in range(rows.size()):
		var row: Dictionary = rows[i] as Dictionary
		var row_id := maxi(0, int(row.get("player_id", 0)))
		var same_identity := row_id == identity or (row_id == 0 and str(row.get("name", "")).to_upper() == normalized_name)
		if same_identity and str(row.get("name", "")).to_upper() == normalized_name:
			if i > 0:
				var existing := row.duplicate(true)
				rows.remove_at(i)
				rows.insert(0, existing)
			return 0
	rows.insert(0, {"player_id": identity, "name": normalized_name, "wins": 0, "losses": 0, "draws": 0})
	while rows.size() > 10:
		rows.pop_back()
	return 0

static func record_own_result(totals: Dictionary, result_key: String) -> void:
	match result_key:
		"WIN":
			totals["wins"] = mini(99, int(totals.get("wins", 0)) + 1)
		"LOSS":
			totals["losses"] = mini(99, int(totals.get("losses", 0)) + 1)
		"DRAW":
			totals["draws"] = mini(99, int(totals.get("draws", 0)) + 1)

static func record_result(rows: Array, name: String, result_key: String, player_id: int = 0) -> void:
	if name.strip_edges().is_empty():
		return
	var row_index := insert_or_promote(rows, name, player_id)
	var row: Dictionary = (rows[row_index] as Dictionary).duplicate(true)
	match result_key:
		"WIN":
			row["wins"] = mini(99, int(row.get("wins", 0)) + 1)
		"LOSS":
			row["losses"] = mini(99, int(row.get("losses", 0)) + 1)
		"DRAW":
			row["draws"] = mini(99, int(row.get("draws", 0)) + 1)
	rows[row_index] = row
