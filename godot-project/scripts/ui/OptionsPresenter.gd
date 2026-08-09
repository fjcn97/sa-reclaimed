class_name OptionsPresenter
extends RefCounted

const MENU_INPUT_HELP := preload("res://scripts/ui/MenuInputHelp.gd")

## Presentation data for the options and player-data screens.
## State changes remain owned by CoreBridge; these methods only format the
## current state for the screen views.

static func language_rows(bridge: Object) -> Array:
	var languages: Array = [
		bridge._language_text("JAPANESE", "JAPANISCH", "JAPONAIS", "JAPONES", "GIAPPONESE"),
		bridge._language_text("ENGLISH", "ENGLISCH", "ANGLAIS", "INGLES", "INGLESE"),
		bridge._language_text("GERMAN", "DEUTSCH", "ALLEMAND", "ALEMAN", "TEDESCO"),
		bridge._language_text("FRENCH", "FRANZOESISCH", "FRANCAIS", "FRANCES", "FRANCESE"),
		bridge._language_text("SPANISH", "SPANISCH", "ESPAGNOL", "ESPANOL", "SPAGNOLO"),
		bridge._language_text("ITALIAN", "ITALIENISCH", "ITALIEN", "ITALIANO", "ITALIANO"),
	]
	var rows: Array = []
	for i in range(languages.size()):
		rows.append({
			"label": str(languages[i]),
			"status": bridge._language_text("CURRENT", "AKTUELL", "ACTUEL", "ACTUAL", "ATTUALE") if i == bridge._language_index else bridge._language_text("AVAILABLE", "VERFUEGBAR", "DISPONIBLE", "DISPONIBLE", "DISPONIBILE"),
			"current": i == bridge._language_index,
			"selected": i == bridge._pending_language_index,
		})
	return rows

static func menu_items(bridge: Object) -> Array:
	var items := ["PLAYER DATA", "DIFFICULTY", "TIME LIMIT", "LANGUAGE", "BUTTON CONFIG", "DELETE GAME DATA", "EXIT"]
	if bridge._sound_test_unlocked:
		items.insert(5, "SOUND TEST")
	return items

static func display_items(bridge: Object) -> Array:
	var items: Array = [
		bridge._language_text("PLAYER DATA", "SPIELERDATEN", "DONNEES JOUEUR", "DATOS DEL JUGADOR", "DATI GIOCATORE"),
		bridge._language_text("DIFFICULTY", "SCHWIERIGKEIT", "DIFFICULTE", "DIFICULTAD", "DIFFICOLTA"),
		bridge._language_text("TIME LIMIT", "ZEITLIMIT", "LIMITE DE TEMPS", "LIMITE DE TIEMPO", "LIMITE DI TEMPO"),
		bridge._language_text("LANGUAGE", "SPRACHE", "LANGUE", "IDIOMA", "LINGUA"),
		bridge._language_text("BUTTON CONFIG", "TASTENBELEGUNG", "CONFIG BOUTONS", "CONFIG BOTONES", "CONFIG TASTI"),
		bridge._language_text("DELETE GAME DATA", "SPIELDATEN LOESCHEN", "SUPPRIMER DONNEES", "BORRAR DATOS", "CANCELLA DATI"),
		bridge._language_text("EXIT", "BEENDEN", "QUITTER", "SALIR", "ESCI"),
	]
	if bridge._sound_test_unlocked:
		items.insert(5, bridge._language_text("SOUND TEST", "MUSIKTEST", "TEST SON", "PRUEBA DE SONIDO", "TEST AUDIO"))
	return items

static func player_data_menu_items(bridge: Object) -> Array:
	return [
		bridge._language_text("NAME ENTRY", "NAMEN EINGEBEN", "SAISIE DU NOM", "NOMBRE", "INSERISCI NOME"),
		bridge._language_text("TIME RECORDS", "ZEITREKORDE", "RECORDS DE TEMPS", "RECORDS DE TIEMPO", "RECORD TEMPI"),
		bridge._language_text("MULTI-PAK RECORDS", "MULTI-PAK REKORDE", "RECORDS MULTI-PAK", "RECORDS MULTI-PAK", "RECORD MULTI-PAK"),
		bridge._language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO"),
	]

static func screen_title(bridge: Object) -> String:
	if bridge._save_reset_pending:
		return "CONFIRM RESET"
	match bridge._options_mode:
		bridge.OPTIONS_MODE_MAIN:
			return bridge._language_text("OPTIONS", "OPTIONEN", "OPTIONS", "OPCIONES", "OPZIONI")
		bridge.OPTIONS_MODE_PLAYER_DATA:
			return bridge._language_text("PLAYER DATA", "SPIELERDATEN", "DONNEES JOUEUR", "DATOS DEL JUGADOR", "DATI GIOCATORE")
		bridge.OPTIONS_MODE_LANGUAGE:
			return bridge._language_text("LANGUAGE", "SPRACHE", "LANGUE", "IDIOMA", "LINGUA")
		bridge.OPTIONS_MODE_BUTTON_CONFIG:
			return bridge._language_text("BUTTON CONFIG", "TASTENBELEGUNG", "CONFIG BOUTONS", "CONFIG BOTONES", "CONFIG TASTI")
		bridge.OPTIONS_MODE_SOUND_TEST:
			return bridge._language_text("SOUND TEST", "MUSIKTEST", "TEST SON", "PRUEBA DE SONIDO", "TEST AUDIO")
		bridge.OPTIONS_MODE_DIFFICULTY:
			return bridge._language_text("DIFFICULTY", "SCHWIERIGKEIT", "DIFFICULTE", "DIFICULTAD", "DIFFICOLTA")
		bridge.OPTIONS_MODE_TIME_LIMIT:
			return bridge._language_text("TIME LIMIT", "ZEITLIMIT", "LIMITE DE TEMPS", "LIMITE DE TIEMPO", "LIMITE DI TEMPO")
		bridge.OPTIONS_MODE_DELETE_CONFIRM, bridge.OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			return bridge._language_text("DELETE GAME DATA", "SPIELDATEN LOESCHEN", "SUPPRIMER DONNEES", "BORRAR DATOS", "CANCELLA DATI")
		bridge.OPTIONS_MODE_TIME_RECORDS:
			return bridge._language_text("TIME RECORDS", "ZEITREKORDE", "RECORDS DE TEMPS", "RECORDS DE TIEMPO", "RECORD TEMPI")
		bridge.OPTIONS_MODE_MULTI_RECORDS:
			return bridge._language_text("MULTI-PAK RECORDS", "MULTI-PAK REKORDE", "RECORDS MULTI-PAK", "RECORDS MULTI-PAK", "RECORD MULTI-PAK")
		bridge.OPTIONS_MODE_NAME_ENTRY:
			return bridge._language_text("NAME ENTRY", "NAMEN EINGEBEN", "SAISIE DU NOM", "NOMBRE", "INSERISCI NOME")
	return "OPTIONS"

static func screen_subtitle(bridge: Object) -> String:
	if bridge._save_reset_pending:
		return bridge._language_text("SAVE DATA WILL BE ERASED", "SPEICHERDATEN WERDEN GELOESCHT", "DONNEES EFFACEES", "DATOS SERAN BORRADOS", "DATI VERRANNO CANCELLATI")
	match bridge._options_mode:
		bridge.OPTIONS_MODE_MAIN:
			return bridge._language_text("GAME SETTINGS", "SPIELEINSTELLUNGEN", "PARAMETRES DE JEU", "AJUSTES DEL JUEGO", "IMPOSTAZIONI GIOCO")
		bridge.OPTIONS_MODE_PLAYER_DATA:
			return bridge._language_text("PROFILE AND RECORDS", "PROFIL UND REKORDE", "PROFIL ET RECORDS", "PERFIL Y RECORDS", "PROFILO E RECORD")
		bridge.OPTIONS_MODE_LANGUAGE:
			return bridge._language_text("SELECT DISPLAY LANGUAGE", "ANZEIGESPRACHE WAEHLEN", "CHOISIR LA LANGUE", "ELEGIR IDIOMA", "SCEGLI LINGUA")
		bridge.OPTIONS_MODE_BUTTON_CONFIG:
			return bridge._language_text("ASSIGN ACTION BUTTONS", "AKTIONSTASTEN ZUWEISEN", "ASSIGNER LES BOUTONS", "ASIGNAR BOTONES", "ASSEGNA PULSANTI")
		bridge.OPTIONS_MODE_SOUND_TEST:
			return bridge._language_text("THE ORIGINAL JUKEBOX", "DIE ORIGINALE JUKEBOX", "LE JUKEBOX ORIGINAL", "LA JUKEBOX ORIGINAL", "IL JUKEBOX ORIGINALE")
		bridge.OPTIONS_MODE_DIFFICULTY:
			return bridge._language_text("SELECT DIFFICULTY", "SCHWIERIGKEIT WAEHLEN", "CHOISIR LA DIFFICULTE", "ELEGIR DIFICULTAD", "SCEGLI DIFFICOLTA")
		bridge.OPTIONS_MODE_TIME_LIMIT:
			return bridge._language_text("TOGGLE TIME LIMIT", "ZEITLIMIT UMSCHALTEN", "GERER LA LIMITE", "CAMBIAR LIMITE", "CAMBIA LIMITE")
		bridge.OPTIONS_MODE_DELETE_CONFIRM:
			return bridge._language_text("DELETE ALL SAVE DATA?", "ALLE SPEICHERDATEN LOESCHEN?", "EFFACER TOUTES LES DONNEES?", "BORRAR TODOS LOS DATOS?", "CANCELLARE TUTTI I DATI?")
		bridge.OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			return bridge._language_text("THIS CANNOT BE UNDONE", "DIES KANN NICHT RUECKGAENGIG GEMACHT WERDEN", "ACTION IRREVERSIBLE", "NO SE PUEDE DESHACER", "AZIONE IRREVERSIBILE")
		bridge.OPTIONS_MODE_TIME_RECORDS:
			return bridge._language_text("BEST CLEAR TIMES", "BESTE ABSCHLUSSZEITEN", "MEILLEURS TEMPS", "MEJORES TIEMPOS", "MIGLIORI TEMPI")
		bridge.OPTIONS_MODE_MULTI_RECORDS:
			return bridge._language_text("VERSUS RECORD SUMMARY", "VERSUS-REKORDUEBERSICHT", "RESUME DES RECORDS VS", "RESUMEN DE RECORDS VS", "RIEPILOGO RECORD VS")
		bridge.OPTIONS_MODE_NAME_ENTRY:
			return bridge._language_text("EDIT PROFILE NAME", "PROFILNAMEN BEARBEITEN", "MODIFIER LE NOM", "EDITAR NOMBRE", "MODIFICA NOME")
	return bridge._language_text("GAME SETTINGS", "SPIELEINSTELLUNGEN", "PARAMETRES DE JEU", "AJUSTES DEL JUEGO", "IMPOSTAZIONI GIOCO")

static func summary_text(bridge: Object) -> String:
	if bridge._save_reset_pending:
		return bridge.get_save_detail_text()
	match bridge._options_mode:
		bridge.OPTIONS_MODE_MAIN:
			return "%s: %s   %s: %s   %s: %s" % [bridge._language_text("DIFFICULTY", "SCHWIERIGKEIT", "DIFFICULTE", "DIFICULTAD", "DIFFICOLTA"), bridge.get_difficulty_text(), bridge._language_text("TIME LIMIT", "ZEITLIMIT", "LIMITE DE TEMPS", "LIMITE DE TIEMPO", "LIMITE DI TEMPO"), bridge._language_text("ON", "AN", "OUI", "SI", "SI") if bridge._time_limit_enabled else bridge._language_text("OFF", "AUS", "NON", "NO", "NO"), bridge._language_text("LANGUAGE", "SPRACHE", "LANGUE", "IDIOMA", "LINGUA"), bridge.get_language_text()]
		bridge.OPTIONS_MODE_PLAYER_DATA:
			return "%s: %s   %s: MAIN" % [bridge._language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), bridge.get_profile_name_text(), bridge._language_text("SAVE SLOT", "SPEICHERPLATZ", "EMPLACEMENT", "RANURA", "SLOT SALVATAGGIO")]
		bridge.OPTIONS_MODE_LANGUAGE:
			return "%s: %s" % [bridge._language_text("CURRENT LANGUAGE", "AKTUELLE SPRACHE", "LANGUE ACTUELLE", "IDIOMA ACTUAL", "LINGUA ATTUALE"), bridge.get_language_text()]
		bridge.OPTIONS_MODE_BUTTON_CONFIG:
			return "%s: %s   A=%s   B=%s" % [bridge._language_text("FACE BUTTONS", "GESICHTSTASTEN", "BOUTONS", "BOTONES", "PULSANTI"), bridge.get_button_config_focus_label(), bridge._button_bindings[0], bridge._button_bindings[1]]
		bridge.OPTIONS_MODE_SOUND_TEST:
			return bridge.get_sound_test_summary_text().replace("\n", "   ")
		bridge.OPTIONS_MODE_DIFFICULTY:
			return "%s: %s   %s: %s" % [bridge._language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), bridge.get_profile_name_text(), bridge._language_text("CURRENT", "AKTUELL", "ACTUEL", "ACTUAL", "ATTUALE"), bridge.get_difficulty_text()]
		bridge.OPTIONS_MODE_TIME_LIMIT:
			return "%s: %s   %s: %s" % [bridge._language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), bridge.get_profile_name_text(), bridge._language_text("CURRENT", "AKTUELL", "ACTUEL", "ACTUAL", "ATTUALE"), bridge._language_text("ON", "AN", "OUI", "SI", "SI") if bridge._time_limit_enabled else bridge._language_text("OFF", "AUS", "NON", "NO", "NO")]
		bridge.OPTIONS_MODE_DELETE_CONFIRM:
			return "%s: %s   %s" % [bridge._language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), bridge.get_profile_name_text(), bridge._language_text("DELETE ALL PROGRESS?", "ALLEN FORTSCHRITT LOESCHEN?", "EFFACER LA PROGRESSION?", "BORRAR PROGRESO?", "CANCELLARE PROGRESSI?")]
		bridge.OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			return bridge._language_text("UNLOCKS, RECORDS, AND PROFILE SETTINGS WILL RESET", "FREISCHALTUNGEN, REKORDE UND PROFIL WERDEN ZURUECKGESETZT", "PROGRESSION, RECORDS ET PROFIL SERONT REINITIALISES", "DESBLOQUEOS, RECORDS Y PERFIL SE REINICIARAN", "SBLOCCHI, RECORD E PROFILO VERRANNO AZZERATI")
		bridge.OPTIONS_MODE_TIME_RECORDS:
			return bridge._language_text("VIEW PERSONAL BESTS FOR EACH CHARACTER", "PERSOENLICHE BESTZEITEN ANZEIGEN", "VOIR LES RECORDS DE CHAQUE PERSONNAGE", "VER MEJORES MARCAS POR PERSONAJE", "VEDI I RECORD DI OGNI PERSONAGGIO")
		bridge.OPTIONS_MODE_MULTI_RECORDS:
			return bridge._language_text("LOCAL MULTIPLAYER HISTORY", "LOKALE MEHRSPIELER-HISTORIE", "HISTORIQUE MULTIJOUEUR LOCAL", "HISTORIAL MULTIJUGADOR LOCAL", "CRONOLOGIA MULTIGIOCATORE LOCALE")
		bridge.OPTIONS_MODE_NAME_ENTRY:
			return "%s: %s" % [bridge._language_text("CURRENT NAME", "AKTUELLER NAME", "NOM ACTUEL", "NOMBRE ACTUAL", "NOME ATTUALE"), bridge.get_profile_name_text()]
	return ""

static func main_title(bridge: Object) -> String:
	return bridge._language_text("OPTIONS", "OPTIONEN", "OPTIONS", "OPCIONES", "OPZIONI")

static func main_prompt(bridge: Object) -> String:
	return bridge._language_text("SELECT AN OPTION", "OPTION WAEHLEN", "CHOISIR UNE OPTION", "ELIGE UNA OPCION", "SCEGLI UN'OPZIONE")

static func main_detail(bridge: Object) -> String:
	return MENU_INPUT_HELP.select_confirm(bridge)

static func player_data_title(bridge: Object) -> String:
	return bridge._language_text("PLAYER DATA", "SPIELERDATEN", "DONNEES JOUEUR", "DATOS DEL JUGADOR", "DATI GIOCATORE")

static func player_data_prompt(bridge: Object) -> String:
	return bridge._language_text("SELECT PLAYER DATA", "SPIELERDATEN WAEHLEN", "CHOISIR LES DONNEES", "ELIGE DATOS", "SCEGLI DATI GIOCATORE")

static func player_data_detail(bridge: Object) -> String:
	return MENU_INPUT_HELP.select_confirm(bridge)

static func player_data_header(bridge: Object) -> String:
	return "%s  %s" % [bridge._language_text("PROFILE NAME", "PROFILNAME", "NOM DU PROFIL", "NOMBRE DEL PERFIL", "NOME PROFILO"), bridge.get_profile_name_text()]

static func player_data_slot(bridge: Object) -> String:
	return "%s: MAIN" % bridge._language_text("SAVE SLOT", "SPEICHERPLATZ", "EMPLACEMENT", "RANURA", "SLOT SALVATAGGIO")

static func player_data_summary(bridge: Object) -> String:
	var total_best := 0
	for score in bridge._best_scores:
		total_best += int(score)
	return "%s\n%s: %s\n%s: %d" % [bridge._language_text("PLAYER DATA", "SPIELERDATEN", "DONNEES JOUEUR", "DATOS DEL JUGADOR", "DATI GIOCATORE"), bridge._language_text("LANGUAGE", "SPRACHE", "LANGUE", "IDIOMA", "LINGUA"), bridge.get_language_text(), bridge._language_text("BEST TOTAL", "BESTSUMME", "TOTAL RECORD", "TOTAL MEJORES", "TOTALE RECORD"), total_best]

static func difficulty_title(bridge: Object) -> String:
	return bridge._language_text("DIFFICULTY", "SCHWIERIGKEIT", "DIFFICULTE", "DIFICULTAD", "DIFFICOLTA")

static func difficulty_prompt(bridge: Object) -> String:
	return MENU_INPUT_HELP.horizontal_switch(bridge)

static func difficulty_summary(bridge: Object) -> String:
	return "%s\n%s\n\n%s\n%s" % [bridge._language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), bridge.get_profile_name_text(), bridge._language_text("CURRENT", "AKTUELL", "ACTUEL", "ACTUAL", "ATTUALE"), bridge.get_difficulty_text()]

static func difficulty_detail(bridge: Object) -> String:
	return "%s   %s = %s   %s = %s" % [bridge._language_text("LEFT/RIGHT = CHANGE", "LINKS/RECHTS = AENDERN", "GAUCHE/DROITE = CHANGER", "IZQ/DER = CAMBIAR", "SINISTRA/DESTRA = CAMBIA"), bridge.get_confirm_label(), bridge._language_text("CONFIRM", "BESTAETIGEN", "VALIDER", "CONFIRMAR", "CONFERMA"), bridge.get_secondary_label(), bridge._language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO")]

static func difficulty_rows(bridge: Object) -> Array:
	return [{"label": bridge._language_text("NORMAL", "NORMAL", "NORMAL", "NORMAL", "NORMALE"), "status": bridge._language_text("STANDARD RUN", "STANDARDLAUF", "COURSE STANDARD", "CARRERA ESTANDAR", "CORSA STANDARD"), "selected": bridge._difficulty_index == 0}, {"label": bridge._language_text("HARD", "SCHWER", "DIFFICILE", "DIFICIL", "DIFFICILE"), "status": bridge._language_text("HIGHER ENEMY PRESSURE", "HOEHERER GEGNERDRUCK", "PRESSION ENNEMIE ELEVEE", "MAYOR PRESION ENEMIGA", "MAGGIORE PRESSIONE NEMICA"), "selected": bridge._difficulty_index == 1}, {"label": bridge._language_text("EASY", "EINFACH", "FACILE", "FACIL", "FACILE"), "status": bridge._language_text("LOWER ENEMY PRESSURE", "WENIGER GEGNERDRUCK", "MOINS D'ENNEMIS", "MENOS ENEMIGOS", "MENO NEMICI"), "selected": bridge._difficulty_index == 2}]

static func difficulty_chrome_colors(_bridge: Object) -> Dictionary:
	return {"accent": Color(0.94, 0.62, 0.24, 1.0), "card": Color(0.98, 0.92, 0.84, 0.98)}

static func time_limit_title(bridge: Object) -> String:
	return bridge._language_text("TIME LIMIT", "ZEITLIMIT", "LIMITE DE TEMPS", "LIMITE DE TIEMPO", "LIMITE DI TEMPO")

static func time_limit_prompt(bridge: Object) -> String:
	return difficulty_prompt(bridge)

static func time_limit_summary(bridge: Object) -> String:
	var value: String = bridge._language_text("ON", "AN", "OUI", "SI", "SI") if bridge._time_limit_enabled else bridge._language_text("OFF", "AUS", "NON", "NO", "NO")
	return "%s\n%s\n\n%s\n%s" % [bridge._language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), bridge.get_profile_name_text(), bridge._language_text("CURRENT", "AKTUELL", "ACTUEL", "ACTUAL", "ATTUALE"), value]

static func time_limit_detail(bridge: Object) -> String:
	return difficulty_detail(bridge)

static func time_limit_rows(bridge: Object) -> Array:
	return [{"label": bridge._language_text("ON", "AN", "OUI", "SI", "SI"), "status": bridge._language_text("CLASSIC COUNTDOWN", "KLASSISCHER COUNTDOWN", "COMPTE A REBOURS CLASSIQUE", "CUENTA ATRAS CLASICA", "CONTO ALLA ROVESCIA CLASSICO"), "selected": bridge._time_limit_enabled}, {"label": bridge._language_text("OFF", "AUS", "NON", "NO", "NO"), "status": bridge._language_text("FREE RUN MODE", "FREIER LAUF", "MODE LIBRE", "MODO LIBRE", "MODALITA LIBERA"), "selected": not bridge._time_limit_enabled}]

static func time_limit_chrome_colors(_bridge: Object) -> Dictionary:
	return {"accent": Color(0.38, 0.82, 0.52, 1.0), "card": Color(0.88, 0.98, 0.90, 0.98)}

static func delete_confirm_title(bridge: Object) -> String:
	return bridge._language_text("DELETE GAME DATA", "SPIELDATEN LOESCHEN", "SUPPRIMER DONNEES", "BORRAR DATOS", "CANCELLA DATI")

static func delete_confirm_prompt(bridge: Object) -> String:
	return MENU_INPUT_HELP.choose_confirm(bridge)

static func delete_confirm_summary(bridge: Object) -> String:
	if bridge._options_mode == bridge.OPTIONS_MODE_DELETE_CONFIRM_FINAL:
		return "%s\n%s\n\n%s\n%s" % [bridge._language_text("FINAL CHECK", "LETZTE PRUEFUNG", "VERIFICATION FINALE", "COMPROBACION FINAL", "CONTROLLO FINALE"), bridge._language_text("ALL RECORDS RESET", "ALLE REKORDE ZURUECKGESETZT", "TOUS LES RECORDS EFFACES", "TODOS LOS RECORDS BORRADOS", "TUTTI I RECORD AZZERATI"), bridge._language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), bridge.get_profile_name_text()]
	return "%s\n%s" % [bridge._language_text("ERASE PROFILE", "PROFIL LOESCHEN", "EFFACER LE PROFIL", "BORRAR PERFIL", "CANCELLA PROFILO"), bridge.get_profile_name_text()]

static func delete_confirm_detail(bridge: Object) -> String:
	return MENU_INPUT_HELP.choose_confirm(bridge)

static func delete_confirm_rows(bridge: Object) -> Array:
	return [{"label": bridge._language_text("YES", "JA", "OUI", "SI", "SI"), "status": bridge._language_text("ERASE SAVE DATA", "SPEICHERDATEN LOESCHEN", "EFFACER LES DONNEES", "BORRAR DATOS", "CANCELLA DATI"), "selected": bridge._delete_confirm_index == 0}, {"label": bridge._language_text("NO", "NEIN", "NON", "NO", "NO"), "status": bridge._language_text("KEEP CURRENT DATA", "AKTUELLE DATEN BEHALTEN", "GARDER LES DONNEES", "CONSERVAR DATOS", "MANTIENI DATI"), "selected": bridge._delete_confirm_index == 1}]

static func delete_confirm_chrome_colors(bridge: Object) -> Dictionary:
	if bridge._options_mode == bridge.OPTIONS_MODE_DELETE_CONFIRM_FINAL:
		return {"accent": Color(0.98, 0.28, 0.18, 1.0), "card": Color(0.16, 0.06, 0.06, 0.96), "text": Color(0.98, 0.92, 0.92, 1.0)}
	return {"accent": Color(0.94, 0.42, 0.20, 1.0), "card": Color(0.98, 0.90, 0.86, 0.98), "text": Color(0.18, 0.12, 0.12, 1.0)}

static func language_summary(bridge: Object) -> String:
	return ""

static func language_title(bridge: Object) -> String:
	return bridge._language_text("LANGUAGE", "SPRACHE", "LANGUE", "IDIOMA", "LINGUA")

static func language_prompt(bridge: Object) -> String:
	return bridge._language_text("SELECT A LANGUAGE", "SPRACHE AUSWAEHLEN", "CHOISIR UNE LANGUE", "SELECCIONA UN IDIOMA", "SCEGLI UNA LINGUA")

static func language_detail(bridge: Object) -> String:
	return MENU_INPUT_HELP.language_preview(bridge)

static func language_chrome_colors(_bridge: Object) -> Dictionary:
	return {"accent": Color(0.24, 0.80, 0.96, 1.0), "card": Color(0.86, 0.94, 1.0, 0.98)}

static func button_config_summary(bridge: Object) -> String:
	return "%s\n\nA  %s\nB  %s\nR  %s" % [bridge._language_text("ASSIGN EACH ACTION", "JEDE AKTION ZUWEISEN", "ASSIGNER CHAQUE ACTION", "ASIGNAR CADA ACCION", "ASSEGNA OGNI AZIONE"), bridge._button_bindings[0], bridge._button_bindings[1], bridge._button_bindings[2]]

static func button_config_title(bridge: Object) -> String:
	return bridge._language_text("BUTTON CONFIG", "TASTENBELEGUNG", "CONFIG BOUTONS", "CONFIG BOTONES", "CONFIG TASTI")

static func button_config_prompt(bridge: Object) -> String:
	return MENU_INPUT_HELP.horizontal_switch(bridge)

static func button_config_detail(bridge: Object) -> String:
	return "%s %s   %s   %s = %s   %s = %s" % [bridge._language_text("LAYOUT", "LAYOUT", "CONFIGURATION", "CONFIGURACION", "LAYOUT"), bridge.get_button_config_focus_label(), bridge._language_text("LEFT/RIGHT = SWITCH", "LINKS/RECHTS = WECHSELN", "GAUCHE/DROITE = CHANGER", "IZQ/DER = CAMBIAR", "SINISTRA/DESTRA = CAMBIA"), bridge.get_confirm_label(), bridge._language_text("ACCEPT", "ANNEHMEN", "ACCEPTER", "ACEPTAR", "ACCETTA"), bridge.get_secondary_label(), bridge._language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO")]

static func button_config_chrome_colors(_bridge: Object) -> Dictionary:
	return {"accent": Color(0.92, 0.48, 0.20, 1.0), "card": Color(0.98, 0.90, 0.84, 0.98)}

static func button_config_badge(bridge: Object) -> String:
	return bridge._language_text("INPUT", "EINGABE", "ENTREE", "ENTRADA", "INPUT")
