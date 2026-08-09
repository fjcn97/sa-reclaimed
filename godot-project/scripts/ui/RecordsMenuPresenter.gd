class_name RecordsMenuPresenter
extends RefCounted

const MENU_INPUT_HELP := preload("res://scripts/ui/MenuInputHelp.gd")

## Presentation-only text and palette for the records screens.

static func time_records_prompt(bridge: Object) -> String:
	if bridge._time_records_context == bridge.TIME_RECORDS_CONTEXT_TIME_ATTACK:
		return MENU_INPUT_HELP.records_course_start(bridge)
	if bridge._time_records_view == bridge.TIME_RECORDS_VIEW_MODE_CHOICE:
		return MENU_INPUT_HELP.records_mode_open(bridge)
	return MENU_INPUT_HELP.records_character_course(bridge)

static func time_records_detail(bridge: Object) -> String:
	if bridge._time_records_context == bridge.TIME_RECORDS_CONTEXT_TIME_ATTACK:
		return "%s   %s %s   ESC %s" % [bridge._language_text("LEFT/RIGHT", "LINKS/RECHTS", "GAUCHE/DROITE", "IZQ/DER", "SINISTRA/DESTRA"), bridge.get_confirm_label(), bridge._language_text("TO START", "ZUM STARTEN", "POUR DEMARRER", "PARA INICIAR", "PER AVVIARE"), bridge._language_text("TO GO BACK", "ZURUECK", "POUR RETOURNER", "PARA VOLVER", "PER TORNARE")]
	if bridge._time_records_view == bridge.TIME_RECORDS_VIEW_MODE_CHOICE:
		return MENU_INPUT_HELP.records_mode_open(bridge)
	return MENU_INPUT_HELP.records_character_course(bridge)

static func multiplayer_records_prompt(bridge: Object) -> String:
	return MENU_INPUT_HELP.scroll_back(bridge)

static func multiplayer_records_detail(bridge: Object) -> String:
	return MENU_INPUT_HELP.scroll_back(bridge)
