class_name CharacterSelectPresenter
extends RefCounted

const MENU_INPUT_HELP := preload("res://scripts/ui/MenuInputHelp.gd")

## Presentation model for the character carousel.

static func _selected_index(bridge: Object) -> int:
	return bridge.get_character_selection_state().selected_index

static func _context(bridge: Object) -> int:
	return bridge.get_character_selection_state().context

static func selected_name(bridge: Object) -> String:
	return bridge.get_character_names()[_selected_index(bridge)]

static func description(bridge: Object, index: int) -> String:
	match clampi(index, 0, bridge.get_character_description_count() - 1):
		0:
			return bridge.language_text("BALANCED SPEED TYPE", "AUSGEGLICHENER TEMPO-TYP", "TYPE VITESSE EQUILIBRE", "TIPO VELOCIDAD EQUILIBRADO", "TIPO VELOCITA BILANCIATO")
		1:
			return bridge.language_text("FLIGHT AND CHEESE SUPPORT", "FLUG UND CHEESE-HILFE", "VOL ET SOUTIEN DE CHEESE", "VUELO Y APOYO DE CHEESE", "VOLO E SUPPORTO DI CHEESE")
		2:
			return bridge.language_text("FLIGHT AND TECHNICAL ROUTES", "FLUG UND TECHNISCHE WEGE", "VOL ET PARCOURS TECHNIQUES", "VUELO Y RUTAS TECNICAS", "VOLO E PERCORSI TECNICI")
		3:
			return bridge.language_text("POWER AND CLIMB ROUTES", "KRAFT UND KLETTERWEGE", "FORCE ET PARCOURS VERTICAUX", "FUERZA Y RUTAS VERTICALES", "FORZA E PERCORSI VERTICALI")
	return bridge.language_text("HAMMER TECHNIQUE", "HAMMER-TECHNIK", "TECHNIQUE DU MARTEAU", "TECNICA DEL MARTILLO", "TECNICA DEL MARTELLO")

static func status_text(bridge: Object, index: int) -> String:
	if not bridge.is_character_select_character_available(index):
		return bridge.language_text("LOCKED", "GESPERRT", "VERROUILLE", "BLOQUEADO", "BLOCCATO")
	if index == bridge.CHARACTER_NAMES_AMY_INDEX():
		return bridge.language_text("SPECIAL", "SPEZIAL", "SPECIAL", "ESPECIAL", "SPECIALE")
	return bridge.language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO")

static func rows(bridge: Object) -> Array:
	var result: Array = []
	for index_variant in bridge.get_character_select_available_indices():
		var index: int = int(index_variant)
		result.append({"name": str(bridge.get_character_names()[index]), "description": description(bridge, index), "status": status_text(bridge, index), "available": bridge.is_character_select_character_available(index), "selected": index == _selected_index(bridge)})
	return result

static func summary_text(bridge: Object) -> String:
	var selected_index := _selected_index(bridge)
	return "%s\n%s\n\n%s\n%s\n\n%s\n%s" % [bridge.language_text("RUNNER", "LAEUFER", "COUREUR", "CORREDOR", "CORRIDORE"), selected_name(bridge), bridge.language_text("STYLE", "STIL", "STYLE", "ESTILO", "STILE"), description(bridge, selected_index), bridge.language_text("STATE", "STATUS", "ETAT", "ESTADO", "STATO"), status_text(bridge, selected_index)]

static func chrome_colors(bridge: Object) -> Dictionary:
	match _context(bridge):
		bridge.CHARACTER_SELECT_CONTEXT_TIME_ATTACK_ZONE:
			return {"chip": Color(0.18, 0.38, 0.86, 0.96), "glow_ready": Color(0.30, 0.78, 0.98, 0.34), "glow_locked": Color(0.42, 0.44, 0.52, 0.26)}
		bridge.CHARACTER_SELECT_CONTEXT_TIME_ATTACK_BOSS:
			return {"chip": Color(0.78, 0.24, 0.20, 0.96), "glow_ready": Color(0.96, 0.58, 0.30, 0.30), "glow_locked": Color(0.42, 0.44, 0.52, 0.26)}
		bridge.CHARACTER_SELECT_CONTEXT_MULTIPLAYER:
			return {"chip": Color(0.84, 0.34, 0.20, 0.96), "glow_ready": Color(0.98, 0.70, 0.28, 0.30), "glow_locked": Color(0.42, 0.44, 0.52, 0.26)}
	return {"chip": Color(0.20, 0.62, 0.42, 0.96), "glow_ready": Color(0.30, 0.78, 0.98, 0.34), "glow_locked": Color(0.42, 0.44, 0.52, 0.26)}

static func context_label(bridge: Object) -> String:
	match _context(bridge):
		bridge.CHARACTER_SELECT_CONTEXT_TIME_ATTACK_ZONE:
			return bridge.language_text("ZONE ATTACK", "ZONEN-ANGRIFF", "ATTAQUE ZONE", "ATAQUE DE ZONA", "ATTACCO ZONA")
		bridge.CHARACTER_SELECT_CONTEXT_TIME_ATTACK_BOSS:
			return bridge.language_text("BOSS ATTACK", "BOSS-ANGRIFF", "ATTAQUE BOSS", "ATAQUE DE JEFE", "ATTACCO BOSS")
		bridge.CHARACTER_SELECT_CONTEXT_MULTIPLAYER:
			return bridge.language_text("MULTIPLAYER", "MEHRSPIELER", "MULTIJOUEUR", "MULTIJUGADOR", "MULTIGIOCATORE")
	return bridge.language_text("GAME START", "SPIELSTART", "DEBUT DU JEU", "INICIO", "INIZIO")

static func title_text(bridge: Object) -> String:
	match _context(bridge):
		bridge.CHARACTER_SELECT_CONTEXT_TIME_ATTACK_ZONE:
			return bridge.language_text("TIME ATTACK", "ZEITANGRIFF", "CONTRE LA MONTRE", "CONTRARRELOJ", "ATTACCO A TEMPO")
		bridge.CHARACTER_SELECT_CONTEXT_TIME_ATTACK_BOSS:
			return bridge.language_text("BOSS ATTACK", "BOSS-ANGRIFF", "ATTAQUE BOSS", "ATAQUE DE JEFE", "ATTACCO BOSS")
		bridge.CHARACTER_SELECT_CONTEXT_MULTIPLAYER:
			return bridge.language_text("MULTIPLAYER", "MEHRSPIELER", "MULTIJOUEUR", "MULTIJUGADOR", "MULTIGIOCATORE")
	return bridge.language_text("CHARACTER SELECT", "CHARAKTERWAHL", "CHOIX DU PERSONNAGE", "SELECCION DE PERSONAJE", "SCELTA PERSONAGGIO")

static func prompt_text(bridge: Object) -> String:
	if not bridge.get_title_navigation_state().notice_text.is_empty():
		return bridge.get_title_notice_text()
	match _context(bridge):
		bridge.CHARACTER_SELECT_CONTEXT_TIME_ATTACK_ZONE:
			return bridge.language_text("SELECT A RUNNER", "WAHLE EINEN LAUFER", "CHOISISSEZ UN COUREUR", "ELIGE UN CORREDOR", "SCEGLI UN CORRIDORE")
		bridge.CHARACTER_SELECT_CONTEXT_TIME_ATTACK_BOSS:
			return bridge.language_text("SELECT A BOSS CHALLENGER", "WAHLE EINEN BOSS-HELDEN", "CHOISISSEZ UN DEFI BOSS", "ELIGE UN RETADOR", "SCEGLI UNO SFIDANTE BOSS")
		bridge.CHARACTER_SELECT_CONTEXT_MULTIPLAYER:
			return bridge.language_text("SELECT A REMATCH RUNNER", "WAHLE EINEN RUCKKAMPF-LAUFER", "CHOISISSEZ UN COUREUR POUR LA REVANCHE", "ELIGE UN CORREDOR PARA LA REVANCHA", "SCEGLI UN CORRIDORE PER LA RIVINCITA")
	return ""

static func detail_text(bridge: Object) -> String:
	var action_text := MENU_INPUT_HELP.confirm_back(bridge)
	var description_text: String = description(bridge, _selected_index(bridge))
	match _context(bridge):
		bridge.CHARACTER_SELECT_CONTEXT_TIME_ATTACK_ZONE:
			return description_text + "\n" + bridge.language_text("ZONE RECORD ATTACK", "ZONEN-REKORDANGRIFF", "RECORD ZONE", "RECORD DE ZONA", "RECORD ZONA") + "\n" + action_text
		bridge.CHARACTER_SELECT_CONTEXT_TIME_ATTACK_BOSS:
			return description_text + "\n" + bridge.language_text("BOSS RECORD ATTACK", "BOSS-REKORDANGRIFF", "RECORD BOSS", "RECORD DE JEFE", "RECORD BOSS") + "\n" + action_text
		bridge.CHARACTER_SELECT_CONTEXT_MULTIPLAYER:
			return description_text + "\n" + bridge.language_text("LOCK THE REMATCH CHARACTER", "RUCKKAMPF-CHARAKTER FESTLEGEN", "VERROUILLEZ LE PERSONNAGE", "FIJA EL PERSONAJE", "BLOCCA IL PERSONAGGIO") + "\n" + action_text
	return description_text + "\n" + action_text
