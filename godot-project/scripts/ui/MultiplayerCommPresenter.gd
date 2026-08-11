class_name MultiplayerCommPresenter
extends RefCounted

static func _state(bridge: Object):
	return bridge.get_multiplayer_frontend_state()

static func title(bridge: Object) -> String:
	var title_navigation = bridge.get_title_navigation_state()
	return bridge.language_text("COMMUNICATION", "KOMMUNIKATION", "COMMUNICATION", "COMUNICACION", "COMUNICAZIONE") if title_navigation.phase == bridge.TITLE_PHASE_MULTI_CONNECT else bridge.language_text("SINGLE-PAK SYNC", "SINGLE-PAK-SYNC", "SYNC SINGLE-PAK", "SYNC SINGLE-PAK", "SYNC SINGLE-PAK")

static func prompt(bridge: Object) -> String:
	var title_navigation = bridge.get_title_navigation_state()
	if not title_navigation.notice_text.is_empty():
		return bridge.get_title_notice_text()
	if title_navigation.phase == bridge.TITLE_PHASE_MULTI_CONNECT:
		if _state(bridge).pak_mode == 0:
			if _state(bridge).link_ready:
				return bridge.language_text("PRESS START ON THE HOST TO BEGIN", "START AM HOST ZUM BEGINN DRUECKEN", "APPUYEZ SUR START SUR L'HOTE", "PULSA START EN EL HOST PARA EMPEZAR", "PREMI START SULL'HOST PER INIZIARE")
			if bridge.get_multiplayer_link_count() > 1:
				return bridge.language_text("WAITING FOR THE HOST TO CONFIRM", "WARTE AUF HOST-BESTAETIGUNG", "EN ATTENTE DE LA CONFIRMATION DE L'HOTE", "ESPERANDO CONFIRMACION DEL HOST", "IN ATTESA DELLA CONFERMA DELL'HOST")
			return bridge.language_text("WAITING FOR OTHER PLAYERS", "WARTE AUF ANDERE SPIELER", "EN ATTENTE DES AUTRES JOUEURS", "ESPERANDO A OTROS JUGADORES", "IN ATTESA DEGLI ALTRI GIOCATORI")
		if not bridge.is_singlepak_transfer_started():
			return bridge.language_text("WAIT FOR CLIENT SYSTEMS TO JOIN", "WARTE AUF CLIENT-SYSTEME", "EN ATTENTE DES SYSTEMES CLIENTS", "ESPERANDO A LOS CLIENTES", "IN ATTESA DEI CLIENT")
		return bridge.language_text("SENDING THE CLIENT PROGRAM", "CLIENT-PROGRAMM WIRD GESENDET", "ENVOI DU PROGRAMME CLIENT", "ENVIANDO EL PROGRAMA CLIENTE", "INVIO DEL PROGRAMMA CLIENT")
	return bridge.language_text("WAIT FOR CLIENT BOOT TO COMPLETE", "WARTE AUF CLIENT-START", "ATTENDEZ LE DEMARRAGE DU CLIENT", "ESPERA EL ARRANQUE DEL CLIENTE", "ATTENDI L'AVVIO DEL CLIENT")

static func prompt_color(bridge: Object) -> Color:
	return Color(0.88, 0.44, 0.18, 1.0) if bridge.get_title_navigation_state().phase == bridge.TITLE_PHASE_MULTI_CONNECT else Color(0.72, 0.28, 0.22, 1.0)

static func detail(bridge: Object) -> String:
	var mode_name: String = bridge.get_multiplayer_pak_mode_name()
	if bridge.get_title_navigation_state().phase == bridge.TITLE_PHASE_MULTI_CONNECT:
		if _state(bridge).pak_mode == 0:
			if _state(bridge).link_ready:
				return bridge.language_text("MODE: %s   COURSE: %s\nROOM COMPLETE   %s CONFIRM TO START   %s BACK", "MODUS: %s   KURS: %s\nRAUM KOMPLETT   %s ZUM START BESTAETIGEN   %s ZURUECK", "MODE: %s   PARCOURS: %s\nSALLE COMPLETE   %s CONFIRMER POUR COMMENCER   %s RETOUR", "MODO: %s   FASE: %s\nSALA COMPLETA   %s CONFIRMA PARA EMPEZAR   %s ATRAS", "MODALITA: %s   ZONA: %s\nSTANZA COMPLETA   %s CONFERMA PER INIZIARE   %s INDIETRO") % [mode_name, bridge.get_multiplayer_session_course_text(), bridge.get_confirm_label(), bridge.get_secondary_label()]
			return bridge.language_text("MODE: %s   COURSE: %s\nBUILD THE LINK ROOM BEFORE STARTING\n%s SELECT   %s CONFIRM   %s BACK", "MODUS: %s   KURS: %s\nBAUE DEN VERBINDUNGSRAUM VOR DEM START\n%s AUSWAEHLEN   %s BESTAETIGEN   %s ZURUECK", "MODE: %s   PARCOURS: %s\nFORMEZ LA SALLE AVANT DE COMMENCER\n%s SELECTIONNER   %s CONFIRMER   %s RETOUR", "MODO: %s   FASE: %s\nCREA LA SALA ANTES DE EMPEZAR\n%s SELECCIONAR   %s CONFIRMAR   %s ATRAS", "MODALITA: %s   ZONA: %s\nCREA LA STANZA PRIMA DI INIZIARE\n%s SELEZIONA   %s CONFERMA   %s INDIETRO") % [mode_name, bridge.get_multiplayer_session_course_text(), bridge.get_navigation_label(), bridge.get_confirm_label(), bridge.get_secondary_label()]
		if not bridge.is_singlepak_transfer_started():
			return bridge.language_text("MODE: %s   COURSE: %s\nCLIENTS: %d   PRESS START AFTER THEY JOIN\n%s SELECT   %s CONFIRM   %s BACK", "MODUS: %s   KURS: %s\nCLIENTS: %d   START NACH BEITRITT DRUECKEN\n%s AUSWAEHLEN   %s BESTAETIGEN   %s ZURUECK", "MODE: %s   PARCOURS: %s\nCLIENTS: %d   APPUYEZ SUR START APRES LEUR ARRIVEE\n%s SELECTIONNER   %s CONFIRMER   %s RETOUR", "MODO: %s   FASE: %s\nCLIENTES: %d   PULSA START CUANDO ENTREN\n%s SELECCIONAR   %s CONFIRMAR   %s ATRAS", "MODALITA: %s   ZONA: %s\nCLIENT: %d   PREMI START DOPO L'ACCESSO\n%s SELEZIONA   %s CONFERMA   %s INDIETRO") % [mode_name, bridge.get_multiplayer_session_course_text(), max(0, bridge.get_multiplayer_link_count() - 1), bridge.get_navigation_label(), bridge.get_confirm_label(), bridge.get_secondary_label()]
		return bridge.language_text("MODE: %s   COURSE: %s\nCLIENTS: %d   DOWNLOAD: %d%%\nTRANSFER ACTIVE   %s BACK LOCKED", "MODUS: %s   KURS: %s\nCLIENTS: %d   DOWNLOAD: %d%%\nUEBERTRAGUNG AKTIV   %s ZURUECK GESPERRT", "MODE: %s   PARCOURS: %s\nCLIENTS: %d   TELECHARGEMENT: %d%%\nTRANSFERT ACTIF   %s RETOUR VERROUILLE", "MODO: %s   FASE: %s\nCLIENTES: %d   DESCARGA: %d%%\nTRANSFERENCIA ACTIVA   %s ATRAS BLOQUEADO", "MODALITA: %s   ZONA: %s\nCLIENT: %d   DOWNLOAD: %d%%\nTRASFERIMENTO ATTIVO   %s INDIETRO BLOCCATO") % [mode_name, bridge.get_multiplayer_session_course_text(), max(0, bridge.get_multiplayer_link_count() - 1), bridge.get_singlepak_download_progress(), bridge.get_secondary_label()]
	if bridge.is_singlepak_sync_ready():
		return bridge.language_text("COURSE: %s   SYNC STEP: %d/3\nCLIENT BOOT COMPLETE   %s CONFIRM TO START   %s BACK", "KURS: %s   SYNC-SCHRITT: %d/3\nCLIENT-START KOMPLETT   %s ZUM START BESTAETIGEN   %s ZURUECK", "PARCOURS: %s   ETAPE SYNC: %d/3\nDEMARRAGE CLIENT TERMINE   %s CONFIRMER POUR COMMENCER   %s RETOUR", "FASE: %s   PASO SYNC: %d/3\nARRANQUE DEL CLIENTE COMPLETO   %s CONFIRMA PARA EMPEZAR   %s ATRAS", "ZONA: %s   PASSO SYNC: %d/3\nAVVIO CLIENT COMPLETO   %s CONFERMA PER INIZIARE   %s INDIETRO") % [bridge.get_multiplayer_session_course_text(), bridge.get_singlepak_sync_step(), bridge.get_confirm_label(), bridge.get_secondary_label()]
	return bridge.language_text("COURSE: %s   SYNC STEP: %d/3\nDOWNLOAD: %d%%   WAIT FOR CLIENT BOOT\n%s SELECT   %s CONFIRM   %s BACK LOCKED", "KURS: %s   SYNC-SCHRITT: %d/3\nDOWNLOAD: %d%%   WARTE AUF CLIENT-START\n%s AUSWAEHLEN   %s BESTAETIGEN   %s ZURUECK GESPERRT", "PARCOURS: %s   ETAPE SYNC: %d/3\nTELECHARGEMENT: %d%%   ATTENDEZ LE DEMARRAGE CLIENT\n%s SELECTIONNER   %s CONFIRMER   %s RETOUR VERROUILLE", "FASE: %s   PASO SYNC: %d/3\nDESCARGA: %d%%   ESPERA EL ARRANQUE DEL CLIENTE\n%s SELECCIONAR   %s CONFIRMAR   %s ATRAS BLOQUEADO", "ZONA: %s   PASSO SYNC: %d/3\nDOWNLOAD: %d%%   ATTENDI AVVIO CLIENT\n%s SELEZIONA   %s CONFERMA   %s INDIETRO BLOCCATO") % [bridge.get_multiplayer_session_course_text(), bridge.get_singlepak_sync_step(), bridge.get_singlepak_download_progress(), bridge.get_navigation_label(), bridge.get_confirm_label(), bridge.get_secondary_label()]

static func info(bridge: Object) -> String:
	if bridge.get_title_navigation_state().phase == bridge.TITLE_PHASE_MULTI_CONNECT:
		if _state(bridge).pak_mode == 0:
			return bridge.language_text("FORM A MULTI-PAK ROOM FOR %s", "MULTI-PAK-RAUM FUER %s BILDEN", "FORMER UNE SALLE MULTI-PAK POUR %s", "CREAR UNA SALA MULTI-PAK PARA %s", "CREA UNA STANZA MULTI-PAK PER %s") % bridge.get_multiplayer_session_course_text()
		if not bridge.is_singlepak_transfer_started():
			return bridge.language_text("WAIT FOR CLIENTS, THEN SEND THE MULTIBOOT PROGRAM", "AUF CLIENTS WARTEN, DANN MULTIBOOT SENDEN", "ATTENDRE LES CLIENTS PUIS ENVOYER LE MULTIBOOT", "ESPERA A LOS CLIENTES Y ENVIA EL MULTIBOOT", "ATTENDI I CLIENT E INVIA IL MULTIBOOT")
		return bridge.language_text("TRANSFER THE CLIENT PROGRAM FOR %s", "CLIENT-PROGRAMM FUER %s UEBERTRAGEN", "TRANSFERER LE PROGRAMME CLIENT POUR %s", "TRANSFERIR EL PROGRAMA CLIENTE PARA %s", "TRASFERISCI IL PROGRAMMA CLIENT PER %s") % bridge.get_multiplayer_session_course_text()
	return bridge.language_text("WAIT FOR CLIENT BOOT AND FINAL SYNCHRONIZATION", "WARTE AUF CLIENT-START UND SYNC", "ATTENDRE LE DEMARRAGE ET LA SYNCHRONISATION", "ESPERA EL ARRANQUE Y LA SINCRONIZACION", "ATTENDI AVVIO E SINCRONIZZAZIONE DEL CLIENT")

static func summary(bridge: Object) -> String:
	var mode_label: String = bridge.language_text("MODE", "MODUS", "MODE", "MODO", "MODALITA")
	var players_label: String = bridge.language_text("PLAYERS", "SPIELER", "JOUEURS", "JUGADORES", "GIOCATORI")
	var clients_label: String = bridge.language_text("CLIENTS", "CLIENTS", "CLIENTS", "CLIENTES", "CLIENT")
	var course_label: String = bridge.language_text("COURSE", "KURS", "PARCOURS", "FASE", "ZONA")
	var state_label: String = bridge.language_text("STATE", "STATUS", "ETAT", "ESTADO", "STATO")
	var linked_label: String = bridge.language_text("LINKED", "VERBUNDEN", "LIES", "ENLAZADOS", "COLLEGATI")
	var ready_label: String = bridge.language_text("READY", "BEREIT", "PRETS", "LISTOS", "PRONTI")
	var waiting_label: String = bridge.language_text("WAITING", "WARTEN", "ATTENTE", "ESPERA", "ATTESA")
	var booting_label: String = bridge.language_text("BOOTING", "STARTET", "DEMARRAGE", "ARRANCANDO", "AVVIO")
	if bridge.get_title_navigation_state().phase == bridge.TITLE_PHASE_MULTI_CONNECT:
		if _state(bridge).pak_mode == 0:
			return "%s\nMULTI-PAK\n\n%s\n%d/4 %s\n\n%s\n%s" % [mode_label, players_label, bridge.get_multiplayer_link_count(), linked_label, course_label, bridge.get_selected_level_text()]
		return "%s\nSINGLE-PAK\n\n%s\n%d %s\n\n%s\n%s" % [mode_label, clients_label, max(0, bridge.get_multiplayer_link_count() - 1), ready_label, state_label, (waiting_label if not bridge.is_singlepak_transfer_started() else "DOWNLOAD %d%%" % bridge.get_singlepak_download_progress())]
	return bridge.language_text("SYNC STEP", "SYNC-SCHRITT", "ETAPE SYNC", "PASO SYNC", "PASSO SYNC") + "\n%d/3\n\n%s\n%s\n\n%s\n%s" % [bridge.get_singlepak_sync_step(), course_label, bridge.get_selected_level_text(), state_label, ready_label if bridge.get_singlepak_sync_step() >= 3 else booting_label]

static func signal_text(bridge: Object) -> String:
	return bridge.language_text("LINK", "LINK", "LIAISON", "ENLACE", "LINK") if bridge.get_title_navigation_state().phase == bridge.TITLE_PHASE_MULTI_CONNECT else bridge.language_text("SYNC", "SYNC", "SYNC", "SYNC", "SYNC")

static func section_text(bridge: Object) -> String:
	return bridge.language_text("PLAYER STATUS", "SPIELERSTATUS", "STATUT JOUEUR", "ESTADO DEL JUGADOR", "STATO GIOCATORE")

static func chrome_colors(bridge: Object) -> Dictionary:
	if bridge.get_title_navigation_state().phase == bridge.TITLE_PHASE_MULTI_CONNECT:
		if _state(bridge).pak_mode == 0:
			return {"accent": Color(0.90, 0.48, 0.22, 1.0), "card": Color(0.96, 0.90, 0.82, 0.98)}
		return {"accent": Color(0.84, 0.34, 0.24, 1.0), "card": Color(0.94, 0.86, 0.80, 0.98)}
	return {"accent": Color(0.76, 0.28, 0.22, 1.0), "card": Color(0.94, 0.84, 0.82, 0.98)}
