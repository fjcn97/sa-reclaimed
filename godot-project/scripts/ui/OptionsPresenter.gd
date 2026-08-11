class_name OptionsPresenter
extends RefCounted

const MENU_INPUT_HELP := preload("res://scripts/ui/MenuInputHelp.gd")

## Presentation data for the options and player-data screens.
## State changes remain owned by CoreBridge; these methods only format the
## current state for the screen views.

static func language_rows(bridge: Object) -> Array:
	var profile: ProfileState = bridge.get_profile_state()
	var languages: Array = [
		bridge.language_text("JAPANESE", "JAPANISCH", "JAPONAIS", "JAPONES", "GIAPPONESE"),
		bridge.language_text("ENGLISH", "ENGLISCH", "ANGLAIS", "INGLES", "INGLESE"),
		bridge.language_text("GERMAN", "DEUTSCH", "ALLEMAND", "ALEMAN", "TEDESCO"),
		bridge.language_text("FRENCH", "FRANZOESISCH", "FRANCAIS", "FRANCES", "FRANCESE"),
		bridge.language_text("SPANISH", "SPANISCH", "ESPAGNOL", "ESPANOL", "SPAGNOLO"),
		bridge.language_text("ITALIAN", "ITALIENISCH", "ITALIEN", "ITALIANO", "ITALIANO"),
	]
	var rows: Array = []
	for i in range(languages.size()):
		rows.append({
			"label": str(languages[i]),
			"status": bridge.language_text("CURRENT", "AKTUELL", "ACTUEL", "ACTUAL", "ATTUALE") if i == profile.language_index else bridge.language_text("AVAILABLE", "VERFUEGBAR", "DISPONIBLE", "DISPONIBLE", "DISPONIBILE"),
			"current": i == profile.language_index,
			"selected": i == profile.pending_language_index,
		})
	return rows

static func menu_items(bridge: Object) -> Array:
	var items := ["PLAYER DATA", "DIFFICULTY", "TIME LIMIT", "LANGUAGE", "BUTTON CONFIG", "DELETE GAME DATA", "EXIT"]
	if bridge.get_profile_state().sound_test_unlocked:
		items.insert(5, "SOUND TEST")
	return items

static func display_items(bridge: Object) -> Array:
	var items: Array = [
		bridge.language_text("PLAYER DATA", "SPIELERDATEN", "DONNEES JOUEUR", "DATOS DEL JUGADOR", "DATI GIOCATORE"),
		bridge.language_text("DIFFICULTY", "SCHWIERIGKEIT", "DIFFICULTE", "DIFICULTAD", "DIFFICOLTA"),
		bridge.language_text("TIME LIMIT", "ZEITLIMIT", "LIMITE DE TEMPS", "LIMITE DE TIEMPO", "LIMITE DI TEMPO"),
		bridge.language_text("LANGUAGE", "SPRACHE", "LANGUE", "IDIOMA", "LINGUA"),
		bridge.language_text("BUTTON CONFIG", "TASTENBELEGUNG", "CONFIG BOUTONS", "CONFIG BOTONES", "CONFIG TASTI"),
		bridge.language_text("DELETE GAME DATA", "SPIELDATEN LOESCHEN", "SUPPRIMER DONNEES", "BORRAR DATOS", "CANCELLA DATI"),
		bridge.language_text("EXIT", "BEENDEN", "QUITTER", "SALIR", "ESCI"),
	]
	if bridge.get_profile_state().sound_test_unlocked:
		items.insert(5, bridge.language_text("SOUND TEST", "MUSIKTEST", "TEST SON", "PRUEBA DE SONIDO", "TEST AUDIO"))
	return items

static func player_data_menu_items(bridge: Object) -> Array:
	return [
		bridge.language_text("NAME ENTRY", "NAMEN EINGEBEN", "SAISIE DU NOM", "NOMBRE", "INSERISCI NOME"),
		bridge.language_text("TIME RECORDS", "ZEITREKORDE", "RECORDS DE TEMPS", "RECORDS DE TIEMPO", "RECORD TEMPI"),
		bridge.language_text("MULTI-PAK RECORDS", "MULTI-PAK REKORDE", "RECORDS MULTI-PAK", "RECORDS MULTI-PAK", "RECORD MULTI-PAK"),
		bridge.language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO"),
	]

static func screen_title(bridge: Object) -> String:
	if bridge.is_save_reset_pending():
		return "CONFIRM RESET"
	var navigation: OptionsNavigationState = bridge.get_options_navigation_state()
	match navigation.mode:
		bridge.OPTIONS_MODE_MAIN:
			return bridge.language_text("OPTIONS", "OPTIONEN", "OPTIONS", "OPCIONES", "OPZIONI")
		bridge.OPTIONS_MODE_PLAYER_DATA:
			return bridge.language_text("PLAYER DATA", "SPIELERDATEN", "DONNEES JOUEUR", "DATOS DEL JUGADOR", "DATI GIOCATORE")
		bridge.OPTIONS_MODE_LANGUAGE:
			return bridge.language_text("LANGUAGE", "SPRACHE", "LANGUE", "IDIOMA", "LINGUA")
		bridge.OPTIONS_MODE_BUTTON_CONFIG:
			return bridge.language_text("BUTTON CONFIG", "TASTENBELEGUNG", "CONFIG BOUTONS", "CONFIG BOTONES", "CONFIG TASTI")
		bridge.OPTIONS_MODE_SOUND_TEST:
			return bridge.language_text("SOUND TEST", "MUSIKTEST", "TEST SON", "PRUEBA DE SONIDO", "TEST AUDIO")
		bridge.OPTIONS_MODE_DIFFICULTY:
			return bridge.language_text("DIFFICULTY", "SCHWIERIGKEIT", "DIFFICULTE", "DIFICULTAD", "DIFFICOLTA")
		bridge.OPTIONS_MODE_TIME_LIMIT:
			return bridge.language_text("TIME LIMIT", "ZEITLIMIT", "LIMITE DE TEMPS", "LIMITE DE TIEMPO", "LIMITE DI TEMPO")
		bridge.OPTIONS_MODE_DELETE_CONFIRM, bridge.OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			return bridge.language_text("DELETE GAME DATA", "SPIELDATEN LOESCHEN", "SUPPRIMER DONNEES", "BORRAR DATOS", "CANCELLA DATI")
		bridge.OPTIONS_MODE_TIME_RECORDS:
			return bridge.language_text("TIME RECORDS", "ZEITREKORDE", "RECORDS DE TEMPS", "RECORDS DE TIEMPO", "RECORD TEMPI")
		bridge.OPTIONS_MODE_MULTI_RECORDS:
			return bridge.language_text("MULTI-PAK RECORDS", "MULTI-PAK REKORDE", "RECORDS MULTI-PAK", "RECORDS MULTI-PAK", "RECORD MULTI-PAK")
		bridge.OPTIONS_MODE_NAME_ENTRY:
			return bridge.language_text("NAME ENTRY", "NAMEN EINGEBEN", "SAISIE DU NOM", "NOMBRE", "INSERISCI NOME")
	return "OPTIONS"

static func screen_subtitle(bridge: Object) -> String:
	if bridge.is_save_reset_pending():
		return bridge.language_text("SAVE DATA WILL BE ERASED", "SPEICHERDATEN WERDEN GELOESCHT", "DONNEES EFFACEES", "DATOS SERAN BORRADOS", "DATI VERRANNO CANCELLATI")
	var navigation: OptionsNavigationState = bridge.get_options_navigation_state()
	match navigation.mode:
		bridge.OPTIONS_MODE_MAIN:
			return bridge.language_text("GAME SETTINGS", "SPIELEINSTELLUNGEN", "PARAMETRES DE JEU", "AJUSTES DEL JUEGO", "IMPOSTAZIONI GIOCO")
		bridge.OPTIONS_MODE_PLAYER_DATA:
			return bridge.language_text("PROFILE AND RECORDS", "PROFIL UND REKORDE", "PROFIL ET RECORDS", "PERFIL Y RECORDS", "PROFILO E RECORD")
		bridge.OPTIONS_MODE_LANGUAGE:
			return bridge.language_text("SELECT DISPLAY LANGUAGE", "ANZEIGESPRACHE WAEHLEN", "CHOISIR LA LANGUE", "ELEGIR IDIOMA", "SCEGLI LINGUA")
		bridge.OPTIONS_MODE_BUTTON_CONFIG:
			return bridge.language_text("ASSIGN ACTION BUTTONS", "AKTIONSTASTEN ZUWEISEN", "ASSIGNER LES BOUTONS", "ASIGNAR BOTONES", "ASSEGNA PULSANTI")
		bridge.OPTIONS_MODE_SOUND_TEST:
			return bridge.language_text("THE ORIGINAL JUKEBOX", "DIE ORIGINALE JUKEBOX", "LE JUKEBOX ORIGINAL", "LA JUKEBOX ORIGINAL", "IL JUKEBOX ORIGINALE")
		bridge.OPTIONS_MODE_DIFFICULTY:
			return bridge.language_text("SELECT DIFFICULTY", "SCHWIERIGKEIT WAEHLEN", "CHOISIR LA DIFFICULTE", "ELEGIR DIFICULTAD", "SCEGLI DIFFICOLTA")
		bridge.OPTIONS_MODE_TIME_LIMIT:
			return bridge.language_text("TOGGLE TIME LIMIT", "ZEITLIMIT UMSCHALTEN", "GERER LA LIMITE", "CAMBIAR LIMITE", "CAMBIA LIMITE")
		bridge.OPTIONS_MODE_DELETE_CONFIRM:
			return bridge.language_text("DELETE ALL SAVE DATA?", "ALLE SPEICHERDATEN LOESCHEN?", "EFFACER TOUTES LES DONNEES?", "BORRAR TODOS LOS DATOS?", "CANCELLARE TUTTI I DATI?")
		bridge.OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			return bridge.language_text("THIS CANNOT BE UNDONE", "DIES KANN NICHT RUECKGAENGIG GEMACHT WERDEN", "ACTION IRREVERSIBLE", "NO SE PUEDE DESHACER", "AZIONE IRREVERSIBILE")
		bridge.OPTIONS_MODE_TIME_RECORDS:
			return bridge.language_text("BEST CLEAR TIMES", "BESTE ABSCHLUSSZEITEN", "MEILLEURS TEMPS", "MEJORES TIEMPOS", "MIGLIORI TEMPI")
		bridge.OPTIONS_MODE_MULTI_RECORDS:
			return bridge.language_text("VERSUS RECORD SUMMARY", "VERSUS-REKORDUEBERSICHT", "RESUME DES RECORDS VS", "RESUMEN DE RECORDS VS", "RIEPILOGO RECORD VS")
		bridge.OPTIONS_MODE_NAME_ENTRY:
			return bridge.language_text("EDIT PROFILE NAME", "PROFILNAMEN BEARBEITEN", "MODIFIER LE NOM", "EDITAR NOMBRE", "MODIFICA NOME")
	return bridge.language_text("GAME SETTINGS", "SPIELEINSTELLUNGEN", "PARAMETRES DE JEU", "AJUSTES DEL JUEGO", "IMPOSTAZIONI GIOCO")

static func summary_text(bridge: Object) -> String:
	if bridge.is_save_reset_pending():
		return bridge.get_save_detail_text()
	var navigation: OptionsNavigationState = bridge.get_options_navigation_state()
	var profile: ProfileState = bridge.get_profile_state()
	match navigation.mode:
		bridge.OPTIONS_MODE_MAIN:
			return "%s: %s   %s: %s   %s: %s" % [bridge.language_text("DIFFICULTY", "SCHWIERIGKEIT", "DIFFICULTE", "DIFICULTAD", "DIFFICOLTA"), bridge.get_difficulty_text(), bridge.language_text("TIME LIMIT", "ZEITLIMIT", "LIMITE DE TEMPS", "LIMITE DE TIEMPO", "LIMITE DI TEMPO"), bridge.language_text("ON", "AN", "OUI", "SI", "SI") if profile.time_limit_enabled else bridge.language_text("OFF", "AUS", "NON", "NO", "NO"), bridge.language_text("LANGUAGE", "SPRACHE", "LANGUE", "IDIOMA", "LINGUA"), bridge.get_language_text()]
		bridge.OPTIONS_MODE_PLAYER_DATA:
			return "%s: %s   %s: MAIN" % [bridge.language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), bridge.get_profile_name_text(), bridge.language_text("SAVE SLOT", "SPEICHERPLATZ", "EMPLACEMENT", "RANURA", "SLOT SALVATAGGIO")]
		bridge.OPTIONS_MODE_LANGUAGE:
			return "%s: %s" % [bridge.language_text("CURRENT LANGUAGE", "AKTUELLE SPRACHE", "LANGUE ACTUELLE", "IDIOMA ACTUAL", "LINGUA ATTUALE"), bridge.get_language_text()]
		bridge.OPTIONS_MODE_BUTTON_CONFIG:
			return "%s: %s   A=%s   B=%s" % [bridge.language_text("FACE BUTTONS", "GESICHTSTASTEN", "BOUTONS", "BOTONES", "PULSANTI"), bridge.get_button_config_focus_label(), profile.button_bindings[0], profile.button_bindings[1]]
		bridge.OPTIONS_MODE_SOUND_TEST:
			return bridge.get_sound_test_summary_text().replace("\n", "   ")
		bridge.OPTIONS_MODE_DIFFICULTY:
			return "%s: %s   %s: %s" % [bridge.language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), bridge.get_profile_name_text(), bridge.language_text("CURRENT", "AKTUELL", "ACTUEL", "ACTUAL", "ATTUALE"), bridge.get_difficulty_text()]
		bridge.OPTIONS_MODE_TIME_LIMIT:
			return "%s: %s   %s: %s" % [bridge.language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), bridge.get_profile_name_text(), bridge.language_text("CURRENT", "AKTUELL", "ACTUEL", "ACTUAL", "ATTUALE"), bridge.language_text("ON", "AN", "OUI", "SI", "SI") if profile.time_limit_enabled else bridge.language_text("OFF", "AUS", "NON", "NO", "NO")]
		bridge.OPTIONS_MODE_DELETE_CONFIRM:
			return "%s: %s   %s" % [bridge.language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), bridge.get_profile_name_text(), bridge.language_text("DELETE ALL PROGRESS?", "ALLEN FORTSCHRITT LOESCHEN?", "EFFACER LA PROGRESSION?", "BORRAR PROGRESO?", "CANCELLARE PROGRESSI?")]
		bridge.OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			return bridge.language_text("UNLOCKS, RECORDS, AND PROFILE SETTINGS WILL RESET", "FREISCHALTUNGEN, REKORDE UND PROFIL WERDEN ZURUECKGESETZT", "PROGRESSION, RECORDS ET PROFIL SERONT REINITIALISES", "DESBLOQUEOS, RECORDS Y PERFIL SE REINICIARAN", "SBLOCCHI, RECORD E PROFILO VERRANNO AZZERATI")
		bridge.OPTIONS_MODE_TIME_RECORDS:
			return bridge.language_text("VIEW PERSONAL BESTS FOR EACH CHARACTER", "PERSOENLICHE BESTZEITEN ANZEIGEN", "VOIR LES RECORDS DE CHAQUE PERSONNAGE", "VER MEJORES MARCAS POR PERSONAJE", "VEDI I RECORD DI OGNI PERSONAGGIO")
		bridge.OPTIONS_MODE_MULTI_RECORDS:
			return bridge.language_text("LOCAL MULTIPLAYER HISTORY", "LOKALE MEHRSPIELER-HISTORIE", "HISTORIQUE MULTIJOUEUR LOCAL", "HISTORIAL MULTIJUGADOR LOCAL", "CRONOLOGIA MULTIGIOCATORE LOCALE")
		bridge.OPTIONS_MODE_NAME_ENTRY:
			return "%s: %s" % [bridge.language_text("CURRENT NAME", "AKTUELLER NAME", "NOM ACTUEL", "NOMBRE ACTUAL", "NOME ATTUALE"), bridge.get_profile_name_text()]
	return ""

static func main_title(bridge: Object) -> String:
	return bridge.language_text("OPTIONS", "OPTIONEN", "OPTIONS", "OPCIONES", "OPZIONI")

static func main_prompt(bridge: Object) -> String:
	return bridge.language_text("SELECT AN OPTION", "OPTION WAEHLEN", "CHOISIR UNE OPTION", "ELIGE UNA OPCION", "SCEGLI UN'OPZIONE")

static func main_detail(bridge: Object) -> String:
	return MENU_INPUT_HELP.select_confirm(bridge)

static func player_data_title(bridge: Object) -> String:
	return bridge.language_text("PLAYER DATA", "SPIELERDATEN", "DONNEES JOUEUR", "DATOS DEL JUGADOR", "DATI GIOCATORE")

static func player_data_prompt(bridge: Object) -> String:
	return bridge.language_text("SELECT PLAYER DATA", "SPIELERDATEN WAEHLEN", "CHOISIR LES DONNEES", "ELIGE DATOS", "SCEGLI DATI GIOCATORE")

static func player_data_detail(bridge: Object) -> String:
	return MENU_INPUT_HELP.select_confirm(bridge)

static func player_data_header(bridge: Object) -> String:
	return "%s  %s" % [bridge.language_text("PROFILE NAME", "PROFILNAME", "NOM DU PROFIL", "NOMBRE DEL PERFIL", "NOME PROFILO"), bridge.get_profile_name_text()]

static func player_data_slot(bridge: Object) -> String:
	return "%s: MAIN" % bridge.language_text("SAVE SLOT", "SPEICHERPLATZ", "EMPLACEMENT", "RANURA", "SLOT SALVATAGGIO")

static func player_data_summary(bridge: Object) -> String:
	var profile: ProfileState = bridge.get_profile_state()
	var total_best := 0
	for score in profile.best_scores:
		total_best += int(score)
	return "%s\n%s: %s\n%s: %d" % [bridge.language_text("PLAYER DATA", "SPIELERDATEN", "DONNEES JOUEUR", "DATOS DEL JUGADOR", "DATI GIOCATORE"), bridge.language_text("LANGUAGE", "SPRACHE", "LANGUE", "IDIOMA", "LINGUA"), bridge.get_language_text(), bridge.language_text("BEST TOTAL", "BESTSUMME", "TOTAL RECORD", "TOTAL MEJORES", "TOTALE RECORD"), total_best]

static func difficulty_title(bridge: Object) -> String:
	return bridge.language_text("DIFFICULTY", "SCHWIERIGKEIT", "DIFFICULTE", "DIFICULTAD", "DIFFICOLTA")

static func difficulty_prompt(bridge: Object) -> String:
	return MENU_INPUT_HELP.horizontal_switch(bridge)

static func difficulty_summary(bridge: Object) -> String:
	return "%s\n%s\n\n%s\n%s" % [bridge.language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), bridge.get_profile_name_text(), bridge.language_text("CURRENT", "AKTUELL", "ACTUEL", "ACTUAL", "ATTUALE"), bridge.get_difficulty_text()]

static func difficulty_detail(bridge: Object) -> String:
	return "%s   %s = %s   %s = %s" % [bridge.language_text("LEFT/RIGHT = CHANGE", "LINKS/RECHTS = AENDERN", "GAUCHE/DROITE = CHANGER", "IZQ/DER = CAMBIAR", "SINISTRA/DESTRA = CAMBIA"), bridge.get_confirm_label(), bridge.language_text("CONFIRM", "BESTAETIGEN", "VALIDER", "CONFIRMAR", "CONFERMA"), bridge.get_secondary_label(), bridge.language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO")]

static func difficulty_rows(bridge: Object) -> Array:
	var profile: ProfileState = bridge.get_profile_state()
	return [{"label": bridge.language_text("NORMAL", "NORMAL", "NORMAL", "NORMAL", "NORMALE"), "status": bridge.language_text("STANDARD RUN", "STANDARDLAUF", "COURSE STANDARD", "CARRERA ESTANDAR", "CORSA STANDARD"), "selected": profile.difficulty_index == 0}, {"label": bridge.language_text("HARD", "SCHWER", "DIFFICILE", "DIFICIL", "DIFFICILE"), "status": bridge.language_text("HIGHER ENEMY PRESSURE", "HOEHERER GEGNERDRUCK", "PRESSION ENNEMIE ELEVEE", "MAYOR PRESION ENEMIGA", "MAGGIORE PRESSIONE NEMICA"), "selected": profile.difficulty_index == 1}, {"label": bridge.language_text("EASY", "EINFACH", "FACILE", "FACIL", "FACILE"), "status": bridge.language_text("LOWER ENEMY PRESSURE", "WENIGER GEGNERDRUCK", "MOINS D'ENNEMIS", "MENOS ENEMIGOS", "MENO NEMICI"), "selected": profile.difficulty_index == 2}]

static func difficulty_chrome_colors(_bridge: Object) -> Dictionary:
	return {"accent": Color(0.94, 0.62, 0.24, 1.0), "card": Color(0.98, 0.92, 0.84, 0.98)}

static func time_limit_title(bridge: Object) -> String:
	return bridge.language_text("TIME LIMIT", "ZEITLIMIT", "LIMITE DE TEMPS", "LIMITE DE TIEMPO", "LIMITE DI TEMPO")

static func time_limit_prompt(bridge: Object) -> String:
	return difficulty_prompt(bridge)

static func time_limit_summary(bridge: Object) -> String:
	var profile: ProfileState = bridge.get_profile_state()
	var value: String = bridge.language_text("ON", "AN", "OUI", "SI", "SI") if profile.time_limit_enabled else bridge.language_text("OFF", "AUS", "NON", "NO", "NO")
	return "%s\n%s\n\n%s\n%s" % [bridge.language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), bridge.get_profile_name_text(), bridge.language_text("CURRENT", "AKTUELL", "ACTUEL", "ACTUAL", "ATTUALE"), value]

static func time_limit_detail(bridge: Object) -> String:
	return difficulty_detail(bridge)

static func time_limit_rows(bridge: Object) -> Array:
	var profile: ProfileState = bridge.get_profile_state()
	return [{"label": bridge.language_text("ON", "AN", "OUI", "SI", "SI"), "status": bridge.language_text("CLASSIC COUNTDOWN", "KLASSISCHER COUNTDOWN", "COMPTE A REBOURS CLASSIQUE", "CUENTA ATRAS CLASICA", "CONTO ALLA ROVESCIA CLASSICO"), "selected": profile.time_limit_enabled}, {"label": bridge.language_text("OFF", "AUS", "NON", "NO", "NO"), "status": bridge.language_text("FREE RUN MODE", "FREIER LAUF", "MODE LIBRE", "MODO LIBRE", "MODALITA LIBERA"), "selected": not profile.time_limit_enabled}]

static func time_limit_chrome_colors(_bridge: Object) -> Dictionary:
	return {"accent": Color(0.38, 0.82, 0.52, 1.0), "card": Color(0.88, 0.98, 0.90, 0.98)}

static func delete_confirm_title(bridge: Object) -> String:
	return bridge.language_text("DELETE GAME DATA", "SPIELDATEN LOESCHEN", "SUPPRIMER DONNEES", "BORRAR DATOS", "CANCELLA DATI")

static func delete_confirm_prompt(bridge: Object) -> String:
	return MENU_INPUT_HELP.choose_confirm(bridge)

static func delete_confirm_summary(bridge: Object) -> String:
	var navigation: OptionsNavigationState = bridge.get_options_navigation_state()
	if navigation.mode == bridge.OPTIONS_MODE_DELETE_CONFIRM_FINAL:
		return "%s\n%s\n\n%s\n%s" % [bridge.language_text("FINAL CHECK", "LETZTE PRUEFUNG", "VERIFICATION FINALE", "COMPROBACION FINAL", "CONTROLLO FINALE"), bridge.language_text("ALL RECORDS RESET", "ALLE REKORDE ZURUECKGESETZT", "TOUS LES RECORDS EFFACES", "TODOS LOS RECORDS BORRADOS", "TUTTI I RECORD AZZERATI"), bridge.language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), bridge.get_profile_name_text()]
	return "%s\n%s" % [bridge.language_text("ERASE PROFILE", "PROFIL LOESCHEN", "EFFACER LE PROFIL", "BORRAR PERFIL", "CANCELLA PROFILO"), bridge.get_profile_name_text()]

static func delete_confirm_detail(bridge: Object) -> String:
	return MENU_INPUT_HELP.choose_confirm(bridge)

static func delete_confirm_rows(bridge: Object) -> Array:
	var navigation: OptionsNavigationState = bridge.get_options_navigation_state()
	return [{"label": bridge.language_text("YES", "JA", "OUI", "SI", "SI"), "status": bridge.language_text("ERASE SAVE DATA", "SPEICHERDATEN LOESCHEN", "EFFACER LES DONNEES", "BORRAR DATOS", "CANCELLA DATI"), "selected": navigation.delete_confirm_index == 0}, {"label": bridge.language_text("NO", "NEIN", "NON", "NO", "NO"), "status": bridge.language_text("KEEP CURRENT DATA", "AKTUELLE DATEN BEHALTEN", "GARDER LES DONNEES", "CONSERVAR DATOS", "MANTIENI DATI"), "selected": navigation.delete_confirm_index == 1}]

static func delete_confirm_chrome_colors(bridge: Object) -> Dictionary:
	if bridge.get_options_navigation_state().mode == bridge.OPTIONS_MODE_DELETE_CONFIRM_FINAL:
		return {"accent": Color(0.98, 0.28, 0.18, 1.0), "card": Color(0.16, 0.06, 0.06, 0.96), "text": Color(0.98, 0.92, 0.92, 1.0)}
	return {"accent": Color(0.94, 0.42, 0.20, 1.0), "card": Color(0.98, 0.90, 0.86, 0.98), "text": Color(0.18, 0.12, 0.12, 1.0)}

static func language_summary(bridge: Object) -> String:
	return ""

static func language_title(bridge: Object) -> String:
	return bridge.language_text("LANGUAGE", "SPRACHE", "LANGUE", "IDIOMA", "LINGUA")

static func language_prompt(bridge: Object) -> String:
	return bridge.language_text("SELECT A LANGUAGE", "SPRACHE AUSWAEHLEN", "CHOISIR UNE LANGUE", "SELECCIONA UN IDIOMA", "SCEGLI UNA LINGUA")

static func language_detail(bridge: Object) -> String:
	return MENU_INPUT_HELP.language_preview(bridge)

static func language_chrome_colors(_bridge: Object) -> Dictionary:
	return {"accent": Color(0.24, 0.80, 0.96, 1.0), "card": Color(0.86, 0.94, 1.0, 0.98)}

static func button_config_summary(bridge: Object) -> String:
	var profile: ProfileState = bridge.get_profile_state()
	return "%s\n\nA  %s\nB  %s\nR  %s" % [bridge.language_text("ASSIGN EACH ACTION", "JEDE AKTION ZUWEISEN", "ASSIGNER CHAQUE ACTION", "ASIGNAR CADA ACCION", "ASSEGNA OGNI AZIONE"), profile.button_bindings[0], profile.button_bindings[1], profile.button_bindings[2]]

static func button_config_title(bridge: Object) -> String:
	return bridge.language_text("BUTTON CONFIG", "TASTENBELEGUNG", "CONFIG BOUTONS", "CONFIG BOTONES", "CONFIG TASTI")

static func button_config_prompt(bridge: Object) -> String:
	return MENU_INPUT_HELP.horizontal_switch(bridge)

static func button_config_detail(bridge: Object) -> String:
	return "%s %s   %s   %s = %s   %s = %s" % [bridge.language_text("LAYOUT", "LAYOUT", "CONFIGURATION", "CONFIGURACION", "LAYOUT"), bridge.get_button_config_focus_label(), bridge.language_text("LEFT/RIGHT = SWITCH", "LINKS/RECHTS = WECHSELN", "GAUCHE/DROITE = CHANGER", "IZQ/DER = CAMBIAR", "SINISTRA/DESTRA = CAMBIA"), bridge.get_confirm_label(), bridge.language_text("ACCEPT", "ANNEHMEN", "ACCEPTER", "ACEPTAR", "ACCETTA"), bridge.get_secondary_label(), bridge.language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO")]

static func button_config_chrome_colors(_bridge: Object) -> Dictionary:
	return {"accent": Color(0.92, 0.48, 0.20, 1.0), "card": Color(0.98, 0.90, 0.84, 0.98)}

static func button_config_badge(bridge: Object) -> String:
	return bridge.language_text("INPUT", "EINGABE", "ENTREE", "ENTRADA", "INPUT")
