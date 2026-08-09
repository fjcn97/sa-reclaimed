class_name SaveProfileSanitizer
extends RefCounted

## Validates persisted profile values while keeping legacy save compatibility.

static func profile_name(raw_name: Variant) -> Array:
	var default_name := ["S", "O", "N", "I", "C", " "]
	if raw_name is not Array:
		return default_name
	var source: Array = raw_name
	var sanitized: Array = []
	for i in range(6):
		if i < source.size():
			var character := str(source[i]).to_upper()
			sanitized.append(" " if character.is_empty() else character.left(1))
		else:
			sanitized.append(" ")
	var joined := ""
	for character in sanitized:
		joined += str(character)
	return default_name if joined.strip_edges().is_empty() else sanitized

static func button_bindings(raw_bindings: Variant, valid: Array) -> Array:
	if raw_bindings is not Array:
		return valid.duplicate()
	var sanitized: Array = []
	for value in raw_bindings as Array:
		var action := str(value).strip_edges().to_upper()
		if valid.has(action) and not sanitized.has(action):
			sanitized.append(action)
	for action in valid:
		if not sanitized.has(action):
			sanitized.append(action)
	return sanitized.slice(0, 3)

static func multiplayer_identity(name: String) -> int:
	var normalized := name.strip_edges().to_upper().substr(0, 6)
	return posmod(normalized.hash(), 2147483646) + 1

static func multiplayer_rows(raw_rows: Variant, default_rows: Array) -> Array:
	if raw_rows is not Array:
		return default_rows.duplicate(true)
	var sanitized: Array = []
	for entry in raw_rows as Array:
		if entry is not Dictionary:
			continue
		var row: Dictionary = entry
		var name_text := str(row.get("name", "")).strip_edges().to_upper().substr(0, 6)
		if name_text.is_empty():
			continue
		var player_id := maxi(0, int(row.get("player_id", 0)))
		if player_id == 0:
			player_id = multiplayer_identity(name_text)
		sanitized.append({"player_id": player_id, "name": name_text, "wins": clampi(int(row.get("wins", 0)), 0, 99), "losses": clampi(int(row.get("losses", 0)), 0, 99), "draws": clampi(int(row.get("draws", 0)), 0, 99)})
		if sanitized.size() >= 10:
			break
	return default_rows.duplicate(true) if sanitized.is_empty() else sanitized

static func multiplayer_totals(raw_totals: Variant, default_totals: Dictionary) -> Dictionary:
	if raw_totals is not Dictionary:
		return default_totals.duplicate(true)
	var totals: Dictionary = raw_totals
	return {"wins": clampi(int(totals.get("wins", 0)), 0, 99), "losses": clampi(int(totals.get("losses", 0)), 0, 99), "draws": clampi(int(totals.get("draws", 0)), 0, 99)}

static func time_attack_best_times(raw_value: Variant) -> Dictionary:
	if raw_value is not Dictionary:
		return {}
	var sanitized: Dictionary = {}
	for key_variant in (raw_value as Dictionary).keys():
		var key := str(key_variant)
		if not key.is_empty():
			sanitized[key] = maxf(0.0, float((raw_value as Dictionary)[key_variant]))
	return sanitized

static func time_attack_record_tables(raw_value: Variant) -> Dictionary:
	if raw_value is not Dictionary:
		return {}
	var sanitized: Dictionary = {}
	for key_variant in (raw_value as Dictionary).keys():
		var key := str(key_variant)
		var value = (raw_value as Dictionary)[key_variant]
		if key.is_empty() or not value is Array:
			continue
		var records: Array = []
		for item in value as Array:
			var time := maxf(0.0, float(item))
			if time > 0.0:
				records.append(time)
			if records.size() >= 3:
				break
		if not records.is_empty():
			records.sort()
			sanitized[key] = records
	return sanitized

static func tiny_chao_roster(raw_value: Variant, defaults: Array) -> Array:
	if raw_value is not Array:
		return defaults.duplicate(true)
	var sanitized: Array = []
	for i in range(mini(3, (raw_value as Array).size())):
		var value = (raw_value as Array)[i]
		if value is Dictionary:
			var chao: Dictionary = value
			sanitized.append({"name": str(chao.get("name", "CHAO %d" % (i + 1))).substr(0, 12), "hunger": clampi(int(chao.get("hunger", 50)), 0, 100), "mood": clampi(int(chao.get("mood", 50)), 0, 100), "care": clampi(int(chao.get("care", 0)), 0, 999)})
	while sanitized.size() < 3:
		sanitized.append(defaults[sanitized.size()].duplicate(true))
	return sanitized
