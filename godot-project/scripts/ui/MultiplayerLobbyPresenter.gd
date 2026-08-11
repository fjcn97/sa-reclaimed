class_name MultiplayerLobbyPresenter
extends RefCounted

## Presentation model for the multiplayer room and its linked-player rows.

static func _state(bridge: Object) -> Object:
	return bridge.get_multiplayer_lobby_state()

static func items(bridge: Object) -> Array:
	return [bridge.language_text("YES", "JA", "OUI", "SI", "SI"), bridge.language_text("NO", "NEIN", "NON", "NO", "NO")]

static func title(bridge: Object) -> String:
	return bridge.language_text("CONTINUE?", "WEITER?", "CONTINUER?", "CONTINUAR?", "CONTINUARE?")

static func prompt(bridge: Object) -> String:
	var notice: String = bridge.get_title_notice_text()
	if not notice.is_empty():
		return notice
	if _state(bridge).waiting:
		return bridge.language_text("WAITING FOR ALL LINKED PLAYERS", "WARTE AUF ALLE VERBUNDENEN SPIELER", "EN ATTENTE DE TOUS LES JOUEURS", "ESPERANDO A TODOS LOS JUGADORES", "IN ATTESA DI TUTTI I GIOCATORI")
	if _state(bridge).cursor == 0:
		return bridge.language_text("HOST WILL START ANOTHER MATCH ON %s", "HOST STARTET EIN WEITERES MATCH AUF %s", "L'HOTE RELANCERA UNE PARTIE SUR %s", "EL HOST INICIARA OTRA PARTIDA EN %s", "L'HOST AVVIERA UN'ALTRA PARTITA SU %s") % bridge.get_multiplayer_session_course_text()
	return bridge.language_text("HOST WILL CLOSE THE ROOM AFTER %s", "HOST SCHLIESST DEN RAUM NACH %s", "L'HOTE FERMERA LA SALLE APRES %s", "EL HOST CERRARA LA SALA TRAS %s", "L'HOST CHIUDERA LA STANZA DOPO %s") % bridge.get_multiplayer_session_course_text()

static func detail(bridge: Object) -> String:
	if _state(bridge).waiting:
		return bridge.language_text("COURSE: %s   SYSTEMS: %d/4   HOST: P1\nDECISION SENT   HOLD FOR LINKED PLAYERS", "KURS: %s   SYSTEME: %d/4   HOST: P1\nENTSCHEIDUNG GESENDET   AUF VERBUNDENE SPIELER WARTEN", "PARCOURS: %s   SYSTEMES: %d/4   HOTE: P1\nDECISION ENVOYEE   ATTENTE DES JOUEURS", "FASE: %s   SISTEMAS: %d/4   HOST: P1\nDECISION ENVIADA   ESPERA A LOS JUGADORES", "CORSO: %s   SISTEMI: %d/4   HOST: P1\nDECISIONE INVIATA   ATTENDI I GIOCATORI") % [bridge.get_multiplayer_session_course_text(), bridge.get_multiplayer_link_count()]
	return bridge.language_text("COURSE: %s   SYSTEMS: %d/4   HOST: P1\nLEFT/RIGHT CHOICE   %s CONFIRM   %s BACK", "KURS: %s   SYSTEME: %d/4   HOST: P1\nLINKS/RECHTS WAHL   %s BESTAETIGEN   %s ZURUECK", "PARCOURS: %s   SYSTEMES: %d/4   HOTE: P1\nCHOIX GAUCHE/DROITE   %s CONFIRMER   %s RETOUR", "FASE: %s   SISTEMAS: %d/4   HOST: P1\nELECCION IZQ/DER   %s CONFIRMAR   %s ATRAS", "CORSO: %s   SISTEMI: %d/4   HOST: P1\nSCELTA SINISTRA/DESTRA   %s CONFERMA   %s INDIETRO") % [bridge.get_multiplayer_session_course_text(), bridge.get_multiplayer_link_count(), bridge.get_confirm_label(), bridge.get_secondary_label()]

static func info_text(bridge: Object) -> String:
	if _state(bridge).waiting:
		return bridge.language_text("SYNCING THE HOST DECISION WITH EVERY LINKED SYSTEM", "HOST-ENTSCHEIDUNG WIRD MIT SYSTEMEN SYNCHRONISIERT", "SYNCHRONISATION DE LA DECISION DE L'HOTE", "SINCRONIZANDO DECISION DEL HOST", "SINCRONIZZAZIONE DECISIONE HOST")
	if _state(bridge).cursor == 0:
		return bridge.language_text("SEND A CONTINUE VOTE TO EVERY LINKED SYSTEM", "FORTSETZUNGSSTIMME AN SYSTEME SENDEN", "ENVOYER UN VOTE CONTINUER AUX SYSTEMES", "ENVIAR VOTO DE CONTINUAR A LOS SISTEMAS", "INVIA VOTO CONTINUA AI SISTEMI")
	return bridge.language_text("SEND AN EXIT VOTE AND RETURN TO RESULTS", "AUSSTIEGSSTIMME SENDEN UND ZU ERGEBNISSEN", "ENVOYER UN VOTE DE SORTIE ET RETOURNER AUX RESULTATS", "ENVIAR VOTO DE SALIDA Y VOLVER A RESULTADOS", "INVIA VOTO USCITA E TORNA AI RISULTATI")

static func summary_text(bridge: Object) -> String:
	var partners: int = max(0, bridge.get_multiplayer_link_count() - 1)
	var choice: String = bridge.language_text("YES", "JA", "OUI", "SI", "SI") if _state(bridge).cursor == 0 else bridge.language_text("NO", "NEIN", "NON", "NO", "NO")
	var choice_label: String = bridge.language_text("CHOICE", "WAHL", "CHOIX", "ELECCION", "SCELTA")
	var state_label: String = bridge.language_text("STATE", "STATUS", "ETAT", "ESTADO", "STATO")
	var partners_label: String = bridge.language_text("PARTNERS", "PARTNER", "PARTENAIRES", "SOCIOS", "PARTNER")
	if _state(bridge).waiting:
		return "%s\n%s\n\n%s\n%s\n\n%s\n%d" % [choice_label, choice, state_label, bridge.language_text("WAITING", "WARTEN", "ATTENTE", "ESPERA", "ATTESA"), partners_label, partners]
	var next_label: String = bridge.language_text("NEXT", "NAECHSTER SCHRITT", "SUIVANT", "SIGUIENTE", "PROSSIMO")
	var next_step: String = bridge.language_text("START REMATCH", "RUECKSPIEL STARTEN", "LANCER LA REVANCHE", "INICIAR REVANCHA", "AVVIA RIVINCITA") if _state(bridge).cursor == 0 else bridge.language_text("SHOW END RESULTS", "ENDRESULTATE ZEIGEN", "AFFICHER LES RESULTATS FINAUX", "MOSTRAR RESULTADOS FINALES", "MOSTRA RISULTATI FINALI")
	return "%s\n%s\n\n%s\n%s\n\n%s\n%d" % [choice_label, choice, next_label, next_step, partners_label, partners]

static func badge_text(bridge: Object) -> String:
	return bridge.language_text("YES", "JA", "OUI", "SI", "SI") if _state(bridge).cursor == 0 else bridge.language_text("NO", "NEIN", "NON", "NO", "NO")

static func section_text(bridge: Object) -> String:
	return bridge.language_text("NEXT PACKET", "NAECHSTES PAKET", "PROCHAIN PAQUET", "SIGUIENTE PAQUETE", "PROSSIMO PACCHETTO")

static func chrome_colors(bridge: Object) -> Dictionary:
	if _state(bridge).waiting:
		return {"accent": Color(0.92, 0.64, 0.24, 1.0), "badge": Color(1.0, 0.88, 0.48, 0.96), "summary": Color(0.96, 0.92, 0.84, 0.98)}
	if _state(bridge).cursor == 0:
		return {"accent": Color(0.95, 0.54, 0.24, 1.0), "badge": Color(0.98, 0.84, 0.44, 0.96), "summary": Color(0.94, 0.94, 0.88, 0.98)}
	return {"accent": Color(0.82, 0.34, 0.24, 1.0), "badge": Color(0.92, 0.62, 0.36, 0.96), "summary": Color(0.92, 0.88, 0.84, 0.98)}

static func option_rows(bridge: Object) -> Array:
	var item_list: Array = items(bridge)
	var rows: Array = []
	for i in range(item_list.size()):
		rows.append({"label": str(item_list[i]), "status": (bridge.language_text("WAIT", "WARTEN", "ATTENTE", "ESPERA", "ATTESA") if i == _state(bridge).cursor else bridge.language_text("HOLD", "HALTEN", "MAINTIEN", "MANTENER", "MANTIENI")) if _state(bridge).waiting else (bridge.language_text("REMATCH", "RUECKSPIEL", "REVANCHE", "REVANCHA", "RIVINCITA") if i == 0 else bridge.language_text("RESULTS", "ERGEBNISSE", "RESULTATS", "RESULTADOS", "RISULTATI")), "selected": i == _state(bridge).cursor})
	return rows

static func player_rows(bridge: Object) -> Array:
	bridge.ensure_multiplayer_session_arrays()
	var multiplayer = bridge.get_multiplayer_frontend_state()
	var rows: Array = []
	for i in range(multiplayer.link_connected.size()):
		var character_name: String = str(bridge.get_character_names()[clampi(int(multiplayer.player_characters[i]), 0, bridge.get_character_names().size() - 1)])
		var rank_value: int = int(multiplayer.player_ranks[i]) if i < multiplayer.player_ranks.size() else -1
		var rank_text: String = "  P%d" % [rank_value + 1] if rank_value >= 0 and bool(multiplayer.link_connected[i]) else ""
		var connected: bool = bool(multiplayer.link_connected[i])
		var status_text: String = ""
		if i == 0:
			status_text = bridge.language_text("HOST  %s  SENDING %s%s", "HOST  %s  SENDET %s%s", "HOTE  %s  ENVOIE %s%s", "HOST  %s  ENVIANDO %s%s", "HOST  %s  INVIA %s%s") % [character_name, bridge.language_text("REMATCH", "RUECKSPIEL", "REVANCHE", "REVANCHA", "RIVINCITA") if _state(bridge).cursor == 0 else bridge.language_text("EXIT", "AUSSTIEG", "SORTIE", "SALIDA", "USCITA"), rank_text] if _state(bridge).waiting else bridge.language_text("HOST  %s  SELECTING%s", "HOST  %s  WAEHLT%s", "HOTE  %s  CHOISIT%s", "HOST  %s  ELIGIENDO%s", "HOST  %s  SCEGLIE%s") % [character_name, rank_text]
		elif connected:
			status_text = (bridge.language_text("%s  READY TO %s%s", "%s  BEREIT FUER %s%s", "%s  PRET POUR %s%s", "%s  LISTO PARA %s%s", "%s  PRONTO PER %s%s") % [character_name, bridge.language_text("REMATCH", "RUECKSPIEL", "REVANCHE", "REVANCHA", "RIVINCITA") if _state(bridge).cursor == 0 else bridge.language_text("EXIT", "AUSSTIEG", "SORTIE", "SALIDA", "USCITA"), rank_text]) if _state(bridge).waiting else bridge.language_text("%s  LINK OK%s", "%s  LINK OK%s", "%s  LIAISON OK%s", "%s  ENLACE OK%s", "%s  LINK OK%s") % [character_name, rank_text]
		else:
			status_text = bridge.language_text("%s  WAITING FOR LINK", "%s  WARTE AUF LINK", "%s  ATTENTE DE LIAISON", "%s  ESPERANDO ENLACE", "%s  IN ATTESA DEL LINK") % character_name
		rows.append({"name": bridge.get_multiplayer_link_player_name(i), "status": status_text, "connected": connected, "host": i == 0})
	return rows
