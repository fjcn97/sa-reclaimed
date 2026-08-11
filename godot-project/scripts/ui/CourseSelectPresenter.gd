class_name CourseSelectPresenter
extends RefCounted

## Presentation model for the course map and its selection cards.

static func title(bridge: Object) -> String:
	if bridge.is_multiplayer_course_select():
		return bridge.language_text("MULTIPLAYER COURSE", "MULTIPLAYER-KURS", "PARCOURS MULTIJOUEUR", "FASE MULTIJUGADOR", "CORSO MULTIGIOCATORE")
	return bridge.language_text("COURSE SELECT", "KURSAUSWAHL", "CHOIX DU PARCOURS", "SELECCION DE FASE", "SCELTA CORSO")

static func prompt(bridge: Object) -> String:
	if bridge.is_multiplayer_course_select():
		if bridge.is_course_select_starting():
			return bridge.language_text("LOCKING ROOM COURSE", "RAUM-KURS WIRD FESTGELEGT", "PARCOURS DE SALLE VERROUILLE", "FIJANDO FASE DE SALA", "BLOCCO CORSO STANZA")
		if bridge.is_course_select_busy():
			return bridge.language_text("SHIFTING ROOM COURSE", "RAUM-KURS WIRD VERSCHOBEN", "DEPLACEMENT DU PARCOURS", "CAMBIANDO FASE DE SALA", "SPOSTAMENTO CORSO STANZA")
		return bridge.language_text("SELECT A VS COURSE", "VS-KURS AUSWAEHLEN", "CHOISISSEZ UN PARCOURS VS", "ELIGE UNA FASE VS", "SCEGLI UN CORSO VS")
	if bridge.is_course_select_unlocking():
		match bridge.get_course_select_unlock_phase():
			bridge.COURSE_UNLOCK_PHASE_PATH:
				return bridge.language_text("OPENING NEW COURSE PATH", "NEUER KURSPFAD OEFFNET SICH", "OUVERTURE D'UN NOUVEAU PARCOURS", "ABRIENDO NUEVA RUTA", "APERTURA NUOVO PERCORSO")
			bridge.COURSE_UNLOCK_PHASE_SCROLL_BACK:
				return bridge.language_text("RETURNING TO COURSE MAP", "ZUR KURSKARTE ZURUECK", "RETOUR A LA CARTE", "VOLVIENDO AL MAPA", "RITORNO ALLA MAPPA")
			bridge.COURSE_UNLOCK_PHASE_SCROLL_NEXT:
				return bridge.language_text("TRAVELLING TO NEW COURSE", "ZUM NEUEN KURS", "DEPLACEMENT VERS LE NOUVEAU PARCOURS", "VIAJANDO A LA NUEVA FASE", "VIAGGIO AL NUOVO CORSO")
			bridge.COURSE_UNLOCK_PHASE_PAUSE:
				return bridge.language_text("NEW COURSE UNLOCKED", "NEUER KURS FREIGESCHALTET", "NOUVEAU PARCOURS DEBLOQUE", "NUEVA FASE DESBLOQUEADA", "NUOVO CORSO SBLOCCATO")
	if bridge.is_course_select_starting():
		return bridge.language_text("STARTING COURSE", "KURS STARTET", "DEMARRAGE DU PARCOURS", "INICIANDO FASE", "AVVIO CORSO")
	if bridge.is_course_select_busy():
		return bridge.language_text("LOCKING COURSE", "KURS WIRD FESTGELEGT", "PARCOURS VERROUILLE", "FIJANDO FASE", "BLOCCO CORSO")
	return bridge.language_text("SELECT A COURSE", "KURS AUSWAEHLEN", "CHOISISSEZ UN PARCOURS", "ELIGE UNA FASE", "SCEGLI UN CORSO")

static func detail(bridge: Object) -> String:
	var character_label: String = bridge.language_text("CHARACTER", "CHARAKTER", "PERSONNAGE", "PERSONAJE", "PERSONAGGIO")
	var mode_label: String = bridge.language_text("MODE", "MODUS", "MODE", "MODO", "MODALITA")
	var notice: String = bridge.get_title_notice_text()
	if notice.is_empty():
		if bridge.is_multiplayer_course_select():
			notice = "%s SELECT   %s LOCK   %s BACK" % [bridge.get_navigation_label(), bridge.get_confirm_label(), bridge.get_secondary_label()]
		else:
			notice = "%s SELECT   %s START   %s BACK" % [bridge.get_navigation_label(), bridge.get_confirm_label(), bridge.get_secondary_label()]
	return "%s\n%s: %s   %s: %s" % [notice, character_label, bridge.get_selected_character_name(), mode_label, type_label(bridge)]

static func summary_text(bridge: Object) -> String:
	var course_label: String = bridge.language_text("ROOM COURSE", "RAUM-KURS", "PARCOURS DE SALLE", "FASE DE SALA", "CORSO STANZA")
	var pak_label: String = bridge.language_text("PAK MODE", "PAK-MODUS", "MODE PAK", "MODO PAK", "MODALITA PAK")
	var runner_label: String = bridge.language_text("RUNNER", "LAEUFER", "COUREUR", "CORREDOR", "CORRIDORE")
	if bridge.is_multiplayer_course_select():
		return "%s\n%s\n\n%s\n%s\n\n%s\n%s" % [course_label, banner_text(bridge), pak_label, bridge.get_multiplayer_pak_mode_name(), runner_label, bridge.get_selected_character_name()]
	return "%s\n%s\n\n%s\n%s\n\n%s\n%s" % [bridge.language_text("CURRENT COURSE", "AKTUELLER KURS", "PARCOURS ACTUEL", "FASE ACTUAL", "CORSO ATTUALE"), banner_text(bridge), bridge.language_text("RECORD", "REKORD", "RECORD", "RECORD", "RECORD"), bridge.get_selected_level_description(), bridge.language_text("CHARACTER", "CHARAKTER", "PERSONNAGE", "PERSONAJE", "PERSONAGGIO"), bridge.get_selected_character_name()]

static func banner_text(bridge: Object) -> String:
	if bridge.is_multiplayer_course_select():
		return "%s VS" % bridge.get_selected_level_text()
	if bridge.get_time_attack_session_state().boss_mode:
		return "%s BOSS" % bridge.get_selected_level_text()
	return bridge.get_selected_level_text()

static func rows(bridge: Object) -> Array:
	var result: Array = []
	var window_size: int = mini(4, bridge.get_level_count())
	var first_index: int = clampi(bridge.get_selected_level_index() - 1, 0, maxi(0, bridge.get_level_count() - window_size))
	for index in range(first_index, first_index + window_size):
		var cleared: bool = index < bridge.get_profile_state().level_cleared_flags.size() and bool(bridge.get_profile_state().level_cleared_flags[index])
		var unlocked: bool = index <= bridge.get_profile_state().unlocked_level_index
		result.append({"index": index, "name": bridge.get_level_name_by_index(index), "value": bridge.get_selected_level_description() if index == bridge.get_selected_level_index() else "%s: %d" % [bridge.language_text("BEST", "BESTE", "RECORD", "MEJOR", "MIGLIORE"), bridge.get_level_best_score(index)], "status": bridge.get_level_status(index), "cleared": cleared, "unlocked": unlocked, "selected": index == bridge.get_selected_level_index()})
	return result

static func map_nodes(bridge: Object) -> Array:
	var nodes: Array = []
	var count: int = bridge.get_level_count()
	if count <= 0:
		return nodes
	var points: Array[Vector2] = [Vector2(62.0, 198.0), Vector2(138.0, 160.0), Vector2(214.0, 182.0), Vector2(270.0, 122.0), Vector2(246.0, 72.0), Vector2(166.0, 58.0), Vector2(92.0, 88.0), Vector2(54.0, 132.0), Vector2(78.0, 204.0), Vector2(156.0, 176.0), Vector2(232.0, 198.0), Vector2(286.0, 146.0), Vector2(260.0, 88.0), Vector2(184.0, 48.0), Vector2(104.0, 70.0), Vector2(48.0, 118.0)]
	for i in range(count):
		nodes.append({"index": i, "name": bridge.get_level_name_by_index(i), "position": points[i % points.size()], "selected": i == bridge.get_selected_level_index(), "unlocked": i <= bridge.get_profile_state().unlocked_level_index, "cleared": i < bridge.get_profile_state().level_cleared_flags.size() and bool(bridge.get_profile_state().level_cleared_flags[i])})
	return nodes

static func zone_label(bridge: Object) -> String:
	if bridge.is_multiplayer_course_select():
		return "VS %d" % [bridge.get_selected_level_index() + 1]
	if bridge.get_selected_level_index() >= bridge.get_level_count() - 2:
		return bridge.language_text("FINAL", "FINAL", "FINAL", "FINAL", "FINALE")
	return "%s %d" % [bridge.language_text("ZONE", "ZONE", "ZONE", "ZONA", "ZONA"), int(bridge.get_selected_level_index() / 2) + 1]

static func act_label(bridge: Object) -> String:
	if bridge.is_multiplayer_course_select():
		return bridge.language_text("MATCH", "MATCH", "MATCH", "PARTIDA", "PARTITA")
	if bridge.get_time_attack_session_state().boss_mode:
		return bridge.language_text("BOSS", "BOSS", "BOSS", "JEFE", "BOSS")
	if bridge.get_selected_level_index() >= bridge.get_level_count() - 2:
		return bridge.language_text("SPECIAL", "SPEZIAL", "SPECIAL", "ESPECIAL", "SPECIALE")
	return "%s %d" % [bridge.language_text("ACT", "AKT", "ACTE", "ACTO", "ATTO"), (bridge.get_selected_level_index() % 2) + 1]

static func type_label(bridge: Object) -> String:
	if bridge.is_multiplayer_course_select():
		return bridge.language_text("MULTIPLAYER", "MEHRSPIELER", "MULTIJOUEUR", "MULTIJUGADOR", "MULTIGIOCATORE")
	return bridge.language_text("BOSS ATTACK", "BOSS-ANGRIFF", "ATTAQUE BOSS", "ATAQUE DE JEFE", "ATTACCO BOSS") if bridge.get_time_attack_session_state().boss_mode else bridge.language_text("ZONE ATTACK", "ZONEN-ANGRIFF", "ATTAQUE ZONE", "ATAQUE DE ZONA", "ATTACCO ZONA")

static func emerald_rows(bridge: Object) -> Array:
	var badges: Array = []
	for i in range(7):
		var active: bool = false
		if not bridge.is_multiplayer_course_select():
			active = (bridge.get_selected_chaos_emerald_mask() & (1 << i)) != 0
		badges.append({"label": "E%d" % [i + 1], "active": active})
	return badges
