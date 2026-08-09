class_name RecordsViewModel
extends RefCounted

## Builds records-screen data from bridge state; renderers consume only these
## small, presentation-ready values.
static func time_summary(bridge: Object) -> String:
	var characters: Array = bridge.get_time_records_character_rows()
	var character := str(characters[clampi(bridge._time_records_character_index, 0, characters.size() - 1)]) if not characters.is_empty() else "SONIC"
	if bridge._time_records_context == bridge.TIME_RECORDS_CONTEXT_TIME_ATTACK:
		return "%s: %s\n%s: %s\n%s: %s" % [bridge._language_text("MODE", "MODUS", "MODE", "MODO", "MODALITA"), bridge._language_text("BOSS ATTACK", "BOSS-ANGRIFF", "ATTAQUE BOSS", "ATAQUE BOSS", "ATTACCO BOSS") if bridge._time_records_boss_mode else bridge._language_text("ZONE ATTACK", "ZONEN-ANGRIFF", "ATTAQUE ZONE", "ATAQUE ZONA", "ATTACCO ZONA"), bridge._language_text("CHARACTER", "CHARAKTER", "PERSONNAGE", "PERSONAJE", "PERSONAGGIO"), character, bridge._language_text("COURSE", "KURS", "PARCOURS", "FASE", "CORSO"), bridge.get_time_records_course_title_text()]
	if bridge._time_records_view == bridge.TIME_RECORDS_VIEW_MODE_CHOICE:
		return "%s: %s\n%s\n%s: %s" % [bridge._language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), bridge.get_profile_name_text(), bridge._language_text("SELECT RECORD MODE", "REKORDMODUS WAEHLEN", "CHOISIR LE MODE", "ELEGIR MODO", "SCEGLI MODALITA RECORD"), bridge._language_text("CURRENT", "AKTUELL", "ACTUEL", "ACTUAL", "ATTUALE"), bridge._language_text("BOSS", "BOSS", "BOSS", "JEFE", "BOSS") if bridge._time_records_boss_mode else bridge._language_text("ZONE", "ZONE", "ZONE", "ZONA", "ZONA")]
	return "%s: %s\n%s: %s\n%s: %s" % [bridge._language_text("CHARACTER", "CHARAKTER", "PERSONNAGE", "PERSONAJE", "PERSONAGGIO"), character, bridge._language_text("COURSE", "KURS", "PARCOURS", "FASE", "CORSO"), bridge.get_time_records_course_title_text(), bridge._language_text("TYPE", "TYP", "TYPE", "TIPO", "TIPO"), bridge._language_text("BOSS", "BOSS", "BOSS", "JEFE", "BOSS") if bridge._time_records_boss_mode else bridge._language_text("ACT", "AKT", "ACTE", "ACTO", "ATTO")]

static func multiplayer_columns(bridge: Object) -> Array:
	return [bridge._language_text("W", "S", "V", "G", "V"), bridge._language_text("L", "N", "D", "P", "S"), bridge._language_text("D", "U", "N", "E", "P")]

static func multiplayer_summary(bridge: Object) -> String:
	var totals: Dictionary = bridge._multiplayer_record_totals
	var columns := multiplayer_columns(bridge)
	return "%s: %s\n%s\n%s %02d  %s %02d  %s %02d" % [bridge._language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), bridge.get_profile_name_text(), bridge._language_text("VERSUS TOTALS", "VERSUS-SUMME", "TOTAUX VS", "TOTALES VS", "TOTALI VS"), columns[0], totals["wins"], columns[1], totals["losses"], columns[2], totals["draws"]]

static func multiplayer_player_row(bridge: Object) -> Dictionary:
	var totals: Dictionary = bridge._multiplayer_record_totals
	return {"name": bridge.get_profile_name_text(), "wins": totals["wins"], "losses": totals["losses"], "draws": totals["draws"]}

static func multiplayer_scroll_max(bridge: Object) -> int:
	return max(0, bridge._multi_record_rows.size() - 4)

static func multiplayer_visible_rows(bridge: Object) -> Array:
	var rows: Array = []
	var start := clampi(bridge._multi_records_menu_index, 0, multiplayer_scroll_max(bridge))
	for i in range(start, mini(start + 4, bridge._multi_record_rows.size())):
		var row: Dictionary = bridge._multi_record_rows[i] as Dictionary
		rows.append({"name": str(row.get("name", "")), "wins": int(row.get("wins", 0)), "losses": int(row.get("losses", 0)), "draws": int(row.get("draws", 0))})
	return rows

static func multiplayer_scroll_hint(bridge: Object) -> String:
	if multiplayer_visible_rows(bridge).is_empty(): return bridge._language_text("NO DATA", "KEINE DATEN", "AUCUNE DONNEE", "SIN DATOS", "NESSUN DATO")
	var up := bridge._multi_records_menu_index > 0
	var down := bridge._multi_records_menu_index < multiplayer_scroll_max(bridge)
	if up and down: return bridge._language_text("UP/DOWN", "HOCH/RUNTER", "HAUT/BAS", "ARRIBA/ABAJO", "SU/GIU")
	if up: return bridge._language_text("UP", "HOCH", "HAUT", "ARRIBA", "SU")
	if down: return bridge._language_text("DOWN", "RUNTER", "BAS", "ABAJO", "GIU")
	return ""
