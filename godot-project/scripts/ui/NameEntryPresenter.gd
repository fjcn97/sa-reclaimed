class_name NameEntryPresenter
extends RefCounted

static func summary_text(bridge: Object) -> String:
	if bridge.is_name_entry_control_cursor():
		return "%s\n%s\n\n%s\n%s" % [bridge.language_text("CONTROL", "STEUERUNG", "CONTROLE", "CONTROL", "CONTROLLO"), bridge.get_name_entry_control_label(), bridge.language_text("NAME", "NAME", "NOM", "NOMBRE", "NOME"), bridge.get_profile_name_text()]
	return "%s %d %s\n%s\n\n%s\n%s" % [bridge.language_text("LETTER", "BUCHSTABE", "LETTRE", "LETRA", "LETTERA"), bridge.get_options_navigation_state().name_entry_menu_index + 1, bridge.language_text("ACTIVE", "AKTIV", "ACTIVE", "ACTIVA", "ATTIVA"), bridge.get_profile_name_text(), bridge.language_text("CHARACTER", "CHARAKTER", "PERSONNAGE", "PERSONAJE", "PERSONAGGIO"), bridge.get_name_entry_selected_character()]

static func detail_text(bridge: Object) -> String:
	return bridge.language_text("BACKSPACE / DELETE TO DELETE   ESC TO GO BACK", "RUECKTASTE / ENTF ZUM LOESCHEN   ESC ZURUECK", "RETOUR ARRIERE / SUPPR POUR EFFACER   ESC RETOUR", "RETROCESO / SUPR PARA BORRAR   ESC VOLVER", "BACKSPACE / CANC PER ELIMINARE   ESC INDIETRO")

static func title_text(bridge: Object) -> String:
	return bridge.language_text("NAME ENTRY", "NAMEN EINGEBEN", "SAISIE DU NOM", "NOMBRE", "INSERISCI NOME")

static func prompt_text(bridge: Object) -> String:
	return ""

static func guide_text(bridge: Object) -> String:
	# The streamlined keyboard has no secondary board heading.
	return ""

static func preview_title_text(bridge: Object) -> String:
	return bridge.language_text("LIVE NAME PREVIEW", "NAMENSVORSCHAU", "APERCU DU NOM", "VISTA PREVIA DEL NOMBRE", "ANTEPRIMA NOME")

static func chrome_colors(bridge: Object) -> Dictionary:
	if bridge.get_multiplayer_frontend_state().return_to_multiplayer_after_name_entry:
		return {"accent": Color(0.94, 0.56, 0.26, 1.0), "card": Color(0.98, 0.90, 0.84, 0.98)}
	return {"accent": Color(0.22, 0.78, 0.96, 1.0), "card": Color(0.86, 0.94, 1.0, 0.98)}

static func control_label(bridge: Object) -> String:
	match bridge.get_options_navigation_state().name_entry_cursor_row:
		bridge.NAME_ENTRY_CONTROL_ROW_BACK:
			return bridge.language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO")
		bridge.NAME_ENTRY_CONTROL_ROW_FORWARD:
			return bridge.language_text("FORWARD", "VOR", "AVANCER", "AVANZAR", "AVANTI")
		bridge.NAME_ENTRY_CONTROL_ROW_END:
			return bridge.language_text("END", "ENDE", "FIN", "FIN", "FINE")
	return bridge.language_text("BOARD", "TAFEL", "TABLEAU", "TABLERO", "TAVOLA")

static func control_rows(bridge: Object) -> Array:
	return [bridge.language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO"), bridge.language_text("FORWARD", "VOR", "AVANCER", "AVANZAR", "AVANTI"), bridge.language_text("END", "ENDE", "FIN", "FIN", "FINE")]
