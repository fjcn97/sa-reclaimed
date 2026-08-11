class_name PlayModePresenter
extends RefCounted

const MENU_INPUT_HELP := preload("res://scripts/ui/MenuInputHelp.gd")

## Presentation model for the Play Mode menu.

static func rows(bridge: Object) -> Array:
	var title_navigation = bridge.get_title_navigation_state()
	return [{"name": bridge.language_text("SINGLE PLAYER", "EINZELSPIELER", "JOUEUR SOLO", "UN JUGADOR", "GIOCATORE SINGOLO"), "description": bridge.language_text("STORY, STAGES AND SOLO PROGRESSION", "GESCHICHTE, LEVELS UND SOLO-FORTSCHRITT", "HISTOIRE, NIVEAUX ET PROGRESSION SOLO", "HISTORIA, FASES Y PROGRESO EN SOLITARIO", "STORIA, LIVELLI E PROGRESSIONE SOLA"), "status": bridge.language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"), "available": true, "selected": title_navigation.menu_index == 0}, {"name": bridge.language_text("MULTI PLAYER", "MEHRSPIELER", "MULTIJOUEUR", "MULTIJUGADOR", "MULTIGIOCATORE"), "description": bridge.language_text("LINK RACES, BATTLES AND SHARED RESULTS", "LINK-RENNEN, KAEMPFE UND GEMEINSAME ERGEBNISSE", "COURSES, COMBATS ET RESULTATS PARTAGES", "CARRERAS, BATALLAS Y RESULTADOS COMPARTIDOS", "GARE, SFIDE E RISULTATI CONDIVISI"), "status": bridge.language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO") if bridge.has_profile_name() else bridge.language_text("NAME REQ", "NAME NOETIG", "NOM REQUIS", "NOMBRE REQUERIDO", "NOME RICHIESTO"), "available": bridge.has_profile_name(), "selected": title_navigation.menu_index == 1}]

static func title_text(bridge: Object) -> String:
	return bridge.language_text("PLAY MODE", "SPIELMODUS", "MODE DE JEU", "MODO DE JUEGO", "MODALITA DI GIOCO")

static func prompt_text(bridge: Object) -> String:
	if not bridge.get_title_navigation_state().notice_text.is_empty():
		return bridge.get_title_notice_text()
	return bridge.language_text("SELECT A PLAY STYLE", "SPIELART AUSWAEHLEN", "CHOISIR UN MODE", "SELECCIONA UN MODO", "SCEGLI UNA MODALITA")

static func detail_text(bridge: Object) -> String:
	return MENU_INPUT_HELP.select_confirm(bridge)

static func info_text(bridge: Object) -> String:
	if bridge.get_title_navigation_state().menu_index == 0:
		return bridge.language_text("START THE SINGLE-PLAYER FRONT END", "EINZELSPIELER-MENUE STARTEN", "LANCER LE MENU SOLO", "INICIAR EL MENU EN SOLITARIO", "AVVIA IL MENU GIOCATORE SINGOLO")
	return bridge.language_text("OPEN THE MULTIPLAYER MODE SELECT", "MEHRSPIELER-MODUS OEFFNEN", "OUVRIR LE CHOIX MULTIJOUEUR", "ABRIR SELECCION MULTIJUGADOR", "APRI LA SELEZIONE MULTIGIOCATORE")

static func summary_text(bridge: Object) -> String:
	if bridge.get_title_navigation_state().menu_index == 0:
		return "%s\n%s: %s\n%s: %s" % [bridge.language_text("SINGLE PLAYER", "EINZELSPIELER", "JOUEUR SOLO", "UN JUGADOR", "GIOCATORE SINGOLO"), bridge.language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), bridge.get_profile_name_text(), bridge.language_text("START POINT", "STARTPUNKT", "POINT DE DEPART", "PUNTO DE INICIO", "PUNTO DI PARTENZA"), bridge.get_selected_level_text()]
	return "%s\n%s: %s\n%s: %s" % [bridge.language_text("MULTIPLAYER", "MEHRSPIELER", "MULTIJOUEUR", "MULTIJUGADOR", "MULTIGIOCATORE"), bridge.language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), bridge.get_profile_name_text(), bridge.language_text("NAME STATUS", "NAMENSSTATUS", "STATUT DU NOM", "ESTADO DEL NOMBRE", "STATO NOME"), bridge.language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO") if bridge.has_profile_name() else bridge.language_text("REQUIRED", "ERFORDERLICH", "REQUIS", "REQUERIDO", "RICHIESTO")]

static func badge_text(bridge: Object) -> String:
	return "SOLO" if bridge.get_title_navigation_state().menu_index == 0 else "VS"

static func chrome_colors(bridge: Object) -> Dictionary:
	if bridge.get_title_navigation_state().menu_index == 0:
		return {"panel": Color(0.04, 0.09, 0.19, 0.94), "accent": Color(0.17, 0.56, 0.92, 0.72), "badge": Color(0.10, 0.20, 0.34, 0.95), "summary": Color(0.07, 0.14, 0.25, 0.95)}
	return {"panel": Color(0.11, 0.08, 0.14, 0.95), "accent": Color(0.92, 0.42, 0.22, 0.78), "badge": Color(0.30, 0.12, 0.12, 0.96), "summary": Color(0.24, 0.10, 0.12, 0.95)}
