class_name RecordsMenuPresenter
extends RefCounted

const MENU_INPUT_HELP := preload("res://scripts/ui/MenuInputHelp.gd")

## Presentation-only text and palette for the records screens.

static func time_records_prompt(bridge: Object) -> String:
	if bridge.get_options_navigation_state().time_records_context == bridge.TIME_RECORDS_CONTEXT_TIME_ATTACK:
		return MENU_INPUT_HELP.records_course_start(bridge)
	if bridge.get_options_navigation_state().time_records_view == bridge.TIME_RECORDS_VIEW_MODE_CHOICE:
		return MENU_INPUT_HELP.records_mode_open(bridge)
	return MENU_INPUT_HELP.records_character_course(bridge)

static func time_records_title(bridge: Object) -> String:
	return bridge.language_text("TIME RECORDS", "ZEITREKORDE", "RECORDS DE TEMPS", "RECORDS DE TIEMPO", "RECORD TEMPI")

static func time_records_chrome(bridge: Object) -> Dictionary:
	if bridge.get_options_navigation_state().time_records_context == bridge.TIME_RECORDS_CONTEXT_TIME_ATTACK:
		return {"accent": Color(0.92, 0.60, 0.22, 1.0), "card": Color(0.98, 0.94, 0.86, 0.98), "stage": Color(0.20, 0.12, 0.10, 0.94)}
	if bridge.get_options_navigation_state().time_records_view == bridge.TIME_RECORDS_VIEW_MODE_CHOICE:
		return {"accent": Color(0.26, 0.52, 0.96, 1.0), "card": Color(0.88, 0.93, 1.0, 0.98), "stage": Color(0.08, 0.12, 0.22, 0.94)}
	return {"accent": Color(0.20, 0.38, 0.86, 1.0), "card": Color(0.92, 0.96, 1.0, 0.98), "stage": Color(0.08, 0.12, 0.22, 0.94)}

static func time_records_detail(bridge: Object) -> String:
	if bridge.get_options_navigation_state().time_records_context == bridge.TIME_RECORDS_CONTEXT_TIME_ATTACK:
		return "%s   %s %s   ESC %s" % [bridge.language_text("LEFT/RIGHT", "LINKS/RECHTS", "GAUCHE/DROITE", "IZQ/DER", "SINISTRA/DESTRA"), bridge.get_confirm_label(), bridge.language_text("TO START", "ZUM STARTEN", "POUR DEMARRER", "PARA INICIAR", "PER AVVIARE"), bridge.language_text("TO GO BACK", "ZURUECK", "POUR RETOURNER", "PARA VOLVER", "PER TORNARE")]
	if bridge.get_options_navigation_state().time_records_view == bridge.TIME_RECORDS_VIEW_MODE_CHOICE:
		return MENU_INPUT_HELP.records_mode_open(bridge)
	return MENU_INPUT_HELP.records_character_course(bridge)

static func time_records_character(bridge: Object) -> String:
	var rows: Array = bridge.get_time_records_character_rows()
	return "SONIC" if rows.is_empty() else rows[clampi(bridge.get_options_navigation_state().time_records_character_index, 0, rows.size() - 1)]

static func time_records_course_heading(bridge: Object) -> String:
	if bridge.get_options_navigation_state().time_records_view == bridge.TIME_RECORDS_VIEW_MODE_CHOICE:
		return bridge.language_text("MODE SELECT", "MODUS WAEHLEN", "CHOIX DU MODE", "ELEGIR MODO", "SCELTA MODALITA")
	var zone_number: int = bridge.get_options_navigation_state().time_records_course_index + 1
	if bridge.get_options_navigation_state().time_records_boss_mode:
		return "%s %d   %s" % [bridge.language_text("ZONE", "ZONE", "ZONE", "ZONA", "ZONA"), zone_number, bridge.language_text("BOSS", "BOSS", "BOSS", "JEFE", "BOSS")]
	return "%s %d   %s %d" % [bridge.language_text("ZONE", "ZONE", "ZONE", "ZONA", "ZONA"), zone_number, bridge.language_text("ACT", "AKT", "ACTE", "ACTO", "ATTO"), bridge.get_options_navigation_state().time_records_act_index + 1]

static func time_records_course_subtitle(bridge: Object) -> String:
	if bridge.get_options_navigation_state().time_records_view == bridge.TIME_RECORDS_VIEW_MODE_CHOICE:
		return bridge.language_text("CHOOSE ZONE OR BOSS RECORDS", "ZONEN- ODER BOSS-REKORDE WAEHLEN", "CHOISIR RECORDS ZONE OU BOSS", "ELEGIR RECORDS DE ZONA O JEFE", "SCEGLI RECORD ZONA O BOSS")
	var course_name: String = bridge.get_level_name_by_index(bridge.get_time_records_level_index())
	return "%s %s" % [course_name, bridge.language_text("BOSS ROUTE", "BOSS-ROUTE", "PARCOURS BOSS", "RUTA DE JEFE", "PERCORSO BOSS")] if bridge.get_options_navigation_state().time_records_boss_mode else course_name

static func time_records_best_label(bridge: Object, index: int) -> String:
	return "%s %d" % [bridge.language_text("BEST", "BESTE", "MEILLEUR", "MEJOR", "MIGLIORE"), index + 1]

static func multiplayer_records_prompt(bridge: Object) -> String:
	return MENU_INPUT_HELP.scroll_back(bridge)

static func multiplayer_records_detail(bridge: Object) -> String:
	return MENU_INPUT_HELP.scroll_back(bridge)

static func multiplayer_records_title(bridge: Object) -> String:
	return bridge.language_text("VS RECORDS", "VS-REKORDE", "RECORDS VS", "RECORDS VS", "RECORD VS")

static func multiplayer_records_chrome(_bridge: Object) -> Dictionary:
	return {"accent": Color(0.92, 0.48, 0.20, 1.0), "card": Color(0.98, 0.90, 0.84, 0.98)}
