class_name TimeAttackLobbyPresenter
extends RefCounted

## Presentation queries for the time-attack lobby.
##
## Session state owns lobby selection; this class turns it into screen text
## and colors.

static func title(bridge: Object) -> String:
	if bridge.get_time_attack_session_state().boss_mode:
		return bridge.language_text("BOSS TIME ATTACK", "BOSS-ZEITANGRIFF", "ATTAQUE BOSS", "ATAQUE AL JEFE", "ATTACCO BOSS")
	return bridge.language_text("TIME ATTACK", "ZEITANGRIFF", "CONTRE-LA-MONTRE", "CONTRARRELOJ", "ATTACCO A TEMPO")

static func prompt(bridge: Object) -> String:
	if not bridge.get_title_navigation_state().notice_text.is_empty():
		return bridge.get_title_notice_text()
	return bridge.language_text("TRY AGAIN", "NOCH EINMAL", "REESSAYER", "INTENTAR DE NUEVO", "RIPROVA")

static func detail(bridge: Object) -> String:
	return "%s SELECT   %s CONFIRM   LEFT/RIGHT %s   %s BACK" % [bridge.get_navigation_label(), bridge.get_confirm_label(), bridge.language_text("COURSE", "KURS", "PARCOURS", "FASE", "CORSO"), bridge.get_secondary_label()]

static func summary_text(bridge: Object) -> String:
	return "CHARACTER\n%s\n\nCOURSE\n%s\n\nBEST\n%s" % [bridge.get_selected_character_name(), bridge.get_selected_level_text(), record_text(bridge)]

static func character_text(bridge: Object) -> String:
	return "%s\n%s" % [bridge.language_text("CHARACTER", "CHARAKTER", "PERSONNAGE", "PERSONAJE", "PERSONAGGIO"), bridge.get_selected_character_name()]

static func course_text(bridge: Object) -> String:
	return "%s\n%s\n%s" % [bridge.language_text("COURSE", "KURS", "PARCOURS", "FASE", "CORSO"), bridge.get_selected_level_text(), course_badge_text(bridge)]

static func mode_text(bridge: Object) -> String:
	var mode_label: String = bridge.language_text("BOSS ATTACK", "BOSS-ANGRIFF", "ATTAQUE BOSS", "ATAQUE AL JEFE", "ATTACCO BOSS") if bridge.get_time_attack_session_state().boss_mode else bridge.language_text("ZONE ATTACK", "ZONEN-ANGRIFF", "ATTAQUE DE ZONE", "ATAQUE DE ZONA", "ATTACCO ZONA")
	return "%s\n%s\n%s" % [bridge.language_text("MODE", "MODUS", "MODE", "MODO", "MODALITA"), mode_label, focus_text(bridge)]

static func record_text(bridge: Object) -> String:
	var selected_character: int = bridge.get_character_selection_state().selected_index
	var record_key: String = bridge.get_time_attack_record_key(selected_character, bridge.get_selected_level_index(), 0, bridge.get_time_attack_session_state().boss_mode)
	var best_time: float = bridge.get_time_attack_best_time(record_key)
	if best_time < 0.0:
		return "NO RECORD"
	return bridge.get_formatted_time(best_time)

static func record_label_text(bridge: Object) -> String:
	return "%s\n%s" % [bridge.language_text("BEST", "BESTE", "MEILLEUR", "MEJOR", "MIGLIORE"), record_text(bridge)]

static func course_badge_text(bridge: Object) -> String:
	var course_index: int = bridge.get_selected_level_index()
	var zone_text := "FINAL ZONE" if course_index == bridge.get_level_count() - 2 else ("TRUE AREA 53" if course_index == bridge.get_level_count() - 1 else "ZONE %d" % [int(course_index / 2) + 1])
	if bridge.get_time_attack_session_state().boss_mode:
		return "%s   BOSS" % zone_text
	return "%s   ACT %d" % [zone_text, (course_index % 2) + 1]

static func focus_text(bridge: Object) -> String:
	match bridge.get_time_attack_session_state().lobby_cursor:
		0:
			return bridge.language_text("RUN READY", "LAUF BEREIT", "COURSE PRET", "FASE LISTA", "CORSA PRONTA")
		1:
			return bridge.language_text("CHANGE RUNNER", "CHARAKTER WECHSELN", "CHANGER DE PERSONNAGE", "CAMBIAR PERSONAJE", "CAMBIA PERSONAGGIO")
		2:
			return bridge.language_text("CHANGE COURSE", "KURS WECHSELN", "CHANGER DE PARCOURS", "CAMBIAR FASE", "CAMBIA CORSO")
		3:
			return bridge.language_text("BACK TO MENU", "ZUM MENUE", "RETOUR AU MENU", "VOLVER AL MENU", "TORNA AL MENU")
	return "STANDBY"

static func character_accent_color(bridge: Object) -> Color:
	var palette: Array = bridge.get_player_visual_palette()
	var variant := clampi(bridge.get_character_selection_state().selected_index, 0, palette.size() - 1)
	var color: Color = palette[variant]
	if bridge.get_time_attack_session_state().boss_mode:
		return Color(minf(1.0, color.r + 0.14), maxf(0.0, color.g - 0.12), maxf(0.0, color.b - 0.08), 1.0)
	return color

static func emblem_text(bridge: Object) -> String:
	var compact_name: String = bridge.get_selected_character_name().replace(" ", "")
	return compact_name.left(2) if compact_name.length() >= 2 else compact_name

static func chrome_colors(bridge: Object) -> Dictionary:
	if bridge.get_time_attack_session_state().boss_mode:
		return {"accent": Color(0.78, 0.30, 0.22, 0.74), "card": Color(0.18, 0.10, 0.14, 0.96), "selected": Color(0.42, 0.20, 0.24, 0.98)}
	return {"accent": Color(0.34, 0.68, 1.0, 0.74), "card": Color(0.09, 0.15, 0.28, 0.96), "selected": Color(0.18, 0.30, 0.48, 0.98)}
