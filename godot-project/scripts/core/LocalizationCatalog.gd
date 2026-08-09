class_name LocalizationCatalog
extends RefCounted

static func language_items() -> Array:
	return ["JAPANESE", "ENGLISH", "GERMAN", "FRENCH", "SPANISH", "ITALIAN"]

static func text(language_index: int, english: String, german: String, french: String, spanish: String, italian: String) -> String:
	match language_index:
		0:
			return japanese_text(english)
		2:
			return german
		3:
			return french
		4:
			return spanish
		5:
			return italian
	return english

static func japanese_text(english: String) -> String:
	# Keep unmigrated longer sentences readable until their source text tables
	# are ported individually.
	match english:
		"SINGLE PLAYER": return "ひとりであそぶ"
		"MULTI PLAYER": return "みんなであそぶ"
		"PLAY MODE": return "プレイモード"
		"GAME START": return "ゲームスタート"
		"TIME ATTACK": return "タイムアタック"
		"OPTIONS": return "オプション"
		"TINY CHAO GARDEN": return "ちびチャオガーデン"
		"PLAYER DATA": return "プレイヤーデータ"
		"DIFFICULTY": return "なんいど"
		"TIME LIMIT": return "じかんせいげん"
		"LANGUAGE": return "げんご"
		"JAPANESE": return "にほんご"
		"ENGLISH": return "えいご"
		"GERMAN": return "ドイツご"
		"FRENCH": return "フランスご"
		"SPANISH": return "スペインご"
		"ITALIAN": return "イタリアご"
		"UP/DOWN": return "うえ/した"
		"TO CHANGE": return "で へんこう"
		"TO CONFIRM": return "で けってい"
		"TO GO BACK": return "で もどる"
		"BUTTON CONFIG": return "ボタンせってい"
		"SOUND TEST": return "サウンドテスト"
		"DELETE GAME DATA": return "ゲームデータをけす"
		"EXIT", "BACK": return "もどる"
		"NORMAL": return "ノーマル"
		"EASY": return "イージー"
		"ON": return "オン"
		"OFF": return "オフ"
		"NAME ENTRY": return "なまえをいれる"
		"TIME RECORDS": return "タイムレコード"
		"MULTI-PAK RECORDS": return "マルチパックレコード"
		"START": return "スタート"
		"SELECT": return "せんたく"
		"CONFIRM": return "けってい"
		"CANCEL": return "キャンセル"
		"CONTINUE": return "つづける"
		"QUIT": return "おわる"
		"RETURN TO TITLE": return "タイトルにもどる"
		"READY": return "じゅんびオーケー"
		"LOCKED": return "ロック"
		"SPECIAL": return "スペシャル"
	return english

static func status_text(language_index: int, status: String, confirm_label: String, secondary_label: String) -> String:
	if status.is_empty() or language_index == 1:
		return status
	if status.begins_with("CONFIRM RESET?"):
		return "%s %s %s %s %s" % [
			text(language_index, "CONFIRM RESET?", "RESET BESTAETIGEN?", "CONFIRMER RESET ?", "CONFIRMAR REINICIO?", "CONFERMA RESET?"),
			confirm_label,
			text(language_index, "YES", "JA", "OUI", "SI", "SI"),
			secondary_label,
			text(language_index, "NO", "NEIN", "NON", "NO", "NO"),
		]
	if status.begins_with("PLAYER LAYER: "):
		var layer := status.trim_prefix("PLAYER LAYER: ")
		var layer_text := text(language_index, layer, "HINTEN", "ARRIERE", "ATRAS", "DIETRO") if layer == "BACK" else text(language_index, layer, "VORNE", "AVANT", "DELANTE", "DAVANTI")
		return "%s: %s" % [text(language_index, "PLAYER LAYER", "SPIELEREBENE", "CALQUE JOUEUR", "CAPA DEL JUGADOR", "LIVELLO GIOCATORE"), layer_text]
	if status.begins_with(" "):
		return status
	if status.ends_with(" UNLOCKED"):
		return "%s %s" % [status.trim_suffix(" UNLOCKED"), text(language_index, "UNLOCKED", "FREIGESCHALTET", "DEVERROUILLE", "DESBLOQUEADO", "SBLOCCATO")]
	match status:
		"READY!": return text(language_index, status, "BEREIT!", "PRET !", "LISTO!", "PRONTO!")
		"GO!": return text(language_index, status, "LOS!", "GO !", "YA!", "VIA!")
		"BOSS READY": return text(language_index, status, "BOSS BEREIT", "BOSS PRET", "JEFE LISTO", "BOSS PRONTO")
		"DEFEAT THE BOSS": return text(language_index, status, "BESIEGE DEN BOSS", "BATTEZ LE BOSS", "DERROTA AL JEFE", "SCONFIGGI IL BOSS")
		"OUTRUN RIVALS": return text(language_index, status, "HAENGE DIE RIVALEN AB", "DISTANCEZ LES RIVAUX", "DEJA ATRAS A LOS RIVALES", "SUPERA I RIVALI")
		"REACH THE GOAL": return text(language_index, status, "ERREICHE DAS ZIEL", "ATTEIGNEZ L'ARRIVEE", "LLEGA A LA META", "RAGGIUNGI IL TRAGUARDO")
		"TIME OVER": return text(language_index, status, "ZEIT ABGELAUFEN", "TEMPS ECOULE", "TIEMPO AGOTADO", "TEMPO SCADUTO")
		"GAME OVER": return text(language_index, status, "GAME OVER", "GAME OVER", "FIN DE LA PARTIDA", "GAME OVER")
		"BOSS CLEAR - START OR A TO REPLAY": return text(language_index, status, "BOSS GESCHAFFT - START ODER A ZUM WIEDERHOLEN", "BOSS TERMINE - START OU A POUR REJOUER", "JEFE COMPLETADO - START O A PARA REPETIR", "BOSS COMPLETATO - START O A PER RIPETERE")
		"STAGE CLEAR - START OR A TO REPLAY": return text(language_index, status, "STUFE GESCHAFFT - START ODER A ZUM WIEDERHOLEN", "STAGE TERMINE - START OU A POUR REJOUER", "FASE COMPLETADA - START O A PARA REPETIR", "STAGE COMPLETATO - START O A PER RIPETERE")
		"OPTIONS": return text(language_index, status, "OPTIONEN", "OPTIONS", "OPCIONES", "OPZIONI")
		"SELECT PROFILE LANGUAGE": return text(language_index, status, "PROFILERSPRACHE WAEHLEN", "CHOISIR LA LANGUE DU PROFIL", "ELIGE IDIOMA DEL PERFIL", "SCEGLI LINGUA PROFILO")
		"NAME ENTRY": return text(language_index, status, "NAMEN EINGEBEN", "SAISIE DU NOM", "INTRODUCIR NOMBRE", "INSERISCI NOME")
		"VERSUS RECORDS": return text(language_index, status, "VS-REKORDE", "RECORDS VS", "RECORDS VS", "RECORD VS")
		"PLAYER DATA": return text(language_index, status, "SPIELERDATEN", "DONNEES JOUEUR", "DATOS DEL JUGADOR", "DATI GIOCATORE")
		"SAVE DATA DELETED": return text(language_index, status, "SPEICHERDATEN GELOESCHT", "DONNEES EFFACEES", "DATOS BORRADOS", "DATI CANCELLATI")
		"PROFILE NAME REQUIRED": return text(language_index, status, "PROFILNAME ERFORDERLICH", "NOM DE PROFIL REQUIS", "NOMBRE DE PERFIL REQUERIDO", "NOME PROFILO RICHIESTO")
		"NAME SAVED": return text(language_index, status, "NAME GESPEICHERT", "NOM ENREGISTRE", "NOMBRE GUARDADO", "NOME SALVATO")
		"CHARACTER SELECT": return text(language_index, status, "CHARAKTER WAEHLEN", "CHOIX DU PERSONNAGE", "SELECCION DE PERSONAJE", "SCELTA PERSONAGGIO")
		"CHARACTER LOCKED": return text(language_index, status, "CHARAKTER GESPERRT", "PERSONNAGE VERROUILLE", "PERSONAJE BLOQUEADO", "PERSONAGGIO BLOCCATO")
		"SPECIAL STAGE READY": return text(language_index, status, "SPECIAL-STAGE BEREIT", "STAGE SPECIAL PRET", "FASE ESPECIAL LISTA", "SPECIAL STAGE PRONTA")
		"SPECIAL STAGE RUN": return text(language_index, status, "SPECIAL-STAGE-LAUF", "COURSE SPECIALE", "RECORRIDO ESPECIAL", "CORSA SPECIALE")
		"SPECIAL STAGE RESULTS": return text(language_index, status, "SPECIAL-STAGE-ERGEBNIS", "RESULTAT SPECIAL", "RESULTADO ESPECIAL", "RISULTATO SPECIALE")
		"SPECIAL STAGE JUMP": return text(language_index, status, "SPECIAL-STAGE SPRUNG", "SAUT SPECIAL", "SALTO ESPECIAL", "SALTO SPECIALE")
		"COPYRIGHT": return text(language_index, status, "URHEBERRECHT", "DROITS D'AUTEUR", "DERECHOS DE AUTOR", "DIRITTI D'AUTORE")
		"DEMO PLAYBACK": return text(language_index, status, "DEMO-WIEDERGABE", "LECTURE DE LA DEMO", "REPRODUCCION DE DEMO", "RIPRODUZIONE DEMO")
		"ALL CHAOS EMERALDS COLLECTED": return text(language_index, status, "ALLE CHAOS-EMERALDS GESAMMELT", "TOUS LES EMERAUDES DU CHAOS COLLECTEES", "TODAS LAS ESMERALDAS DEL CAOS REUNIDAS", "TUTTI I CHAOS EMERALD RACCOLTI")
		"COLLECT ALL CHAOS EMERALDS": return text(language_index, status, "SAMMLE ALLE CHAOS-EMERALDS", "COLLECTEZ TOUTES LES EMERAUDES DU CHAOS", "REUNE TODAS LAS ESMERALDAS DEL CAOS", "RACCOGLI TUTTI I CHAOS EMERALD")
		"TO BE CONTINUED": return text(language_index, status, "FORTSETZUNG FOLGT", "A SUIVRE", "CONTINUARA", "CONTINUA")
		"PRESENTED BY SEGA": return text(language_index, status, "PRASENTIERT VON SEGA", "PRESENTE PAR SEGA", "PRESENTADO POR SEGA", "PRESENTATO DA SEGA")
		"CREATED BY SONIC TEAM": return text(language_index, status, "ERSTELLT VON SONIC TEAM", "CREE PAR SONIC TEAM", "CREADO POR SONIC TEAM", "CREATO DA SONIC TEAM")
		"LEFT/RIGHT MOVE   A CARE   B EXIT": return text(language_index, status, "LINKS/RECHTS BEWEGEN   A PFLEGEN   B ENDE", "GAUCHE/DROITE DEPLACER   A SOIGNER   B QUITTER", "IZQ/DER MOVER   A CUIDAR   B SALIR", "SINISTRA/DESTRA MUOVI   A CURA   B ESCI")
		"TRUE AREA 53 INTRO": return text(language_index, status, "TRUE AREA 53 INTRO", "INTRO TRUE AREA 53", "INTRO TRUE AREA 53", "INTRO TRUE AREA 53")
		"GUARD ROBO HIT - 10 RINGS LOST": return text(language_index, status, "GUARD ROBO GETROFFEN - 10 RINGE VERLOREN", "ROBO GARDE TOUCHE - 10 ANNEAUX PERDUS", "ROBO GUARDIA GOLPEADO - 10 ANILLOS PERDIDOS", "GUARD ROBO COLPITO - 10 ANELLI PERSI")
		"GUARD ROBO HIT - NO RINGS": return text(language_index, status, "GUARD ROBO GETROFFEN - KEINE RINGE", "ROBO GARDE TOUCHE - AUCUN ANNEAU", "ROBO GUARDIA GOLPEADO - SIN ANILLOS", "GUARD ROBO COLPITO - NESSUN ANELLO")
	return status

static func touch_label(language_index: int, label: String) -> String:
	match label:
		"Left": return text(language_index, "Left", "Links", "Gauche", "Izq", "Sinistra")
		"Right": return text(language_index, "Right", "Rechts", "Droite", "Der", "Destra")
		"Up": return text(language_index, "Up", "Hoch", "Haut", "Arriba", "Su")
		"Down": return text(language_index, "Down", "Runter", "Bas", "Abajo", "Giu")
		"Start": return text(language_index, "Start", "Start", "Depart", "Inicio", "Avvio")
		"Options": return text(language_index, "Options", "Optionen", "Options", "Opciones", "Opzioni")
		"Back": return text(language_index, "Back", "Zurueck", "Retour", "Atras", "Indietro")
		"Open": return text(language_index, "Open", "Oeffnen", "Ouvrir", "Abrir", "Apri")
		"Prev": return text(language_index, "Prev", "Zurueck", "Prec", "Ant", "Prec")
		"Next": return text(language_index, "Next", "Weiter", "Suiv", "Sig", "Succ")
		"Off": return text(language_index, "Off", "Aus", "Non", "No", "No")
		"On": return text(language_index, "On", "An", "Oui", "Si", "Si")
		"Zone": return text(language_index, "Zone", "Zone", "Zone", "Zona", "Zona")
		"Boss": return text(language_index, "Boss", "Boss", "Boss", "Jefe", "Boss")
		"Yes": return text(language_index, "Yes", "Ja", "Oui", "Si", "Si")
		"No": return text(language_index, "No", "Nein", "Non", "No", "No")
		"Apply": return text(language_index, "Apply", "Anwenden", "Appliquer", "Aplicar", "Applica")
		"Play": return text(language_index, "Play", "Abspielen", "Lire", "Reproducir", "Riproduci")
		"Stop": return text(language_index, "Stop", "Stopp", "Stop", "Parar", "Stop")
		"View": return text(language_index, "View", "Ansehen", "Voir", "Ver", "Vedi")
		"Pick": return text(language_index, "Pick", "Waehlen", "Choisir", "Elegir", "Scegli")
		"Delete": return text(language_index, "Delete", "Loeschen", "Suppr", "Borrar", "Elimina")
		"Continue": return text(language_index, "Continue", "Weiter", "Continuer", "Continuar", "Continua")
		"Rematch": return text(language_index, "Rematch", "Rueckspiel", "Rejouer", "Revancha", "Rivincita")
		"Skip": return text(language_index, "Skip", "Ueberspringen", "Passer", "Omitir", "Salta")
		"Fast": return text(language_index, "Fast", "Schnell", "Rapide", "Rapido", "Veloce")
		"Wait": return text(language_index, "Wait", "Warten", "Attendre", "Espera", "Attendi")
		"Lobby": return text(language_index, "Lobby", "Lobby", "Salle", "Sala", "Stanza")
		"Enter": return text(language_index, "Enter", "Eingabe", "Entrer", "Entrar", "Invio")
		"Select": return text(language_index, "Select", "Waehlen", "Selectionner", "Seleccionar", "Seleziona")
		"Restart": return text(language_index, "Restart", "Neustart", "Recommencer", "Reiniciar", "Riavvia")
		"Title": return text(language_index, "Title", "Titel", "Titre", "Titulo", "Titolo")
		"Link": return text(language_index, "Link", "Link", "Lien", "Enlace", "Collegamento")
		"Scan": return text(language_index, "Scan", "Suchen", "Scanner", "Buscar", "Scansione")
		"Send": return text(language_index, "Send", "Senden", "Envoyer", "Enviar", "Invia")
		"Sync": return text(language_index, "Sync", "Sync", "Sync", "Sincronizar", "Sincronizza")
		"Results": return text(language_index, "Results", "Ergebnisse", "Resultats", "Resultados", "Risultati")
		"Character": return text(language_index, "Character", "Charakter", "Personnage", "Personaje", "Personaggio")
		"Course": return text(language_index, "Course", "Kurs", "Parcours", "Fase", "Corso")
		"Lock": return text(language_index, "Lock", "Sperren", "Verrouiller", "Bloquear", "Blocca")
		"Auto": return text(language_index, "Auto", "Auto", "Auto", "Auto", "Auto")
		"Advance": return text(language_index, "Advance", "Weiter", "Avancer", "Avanzar", "Avanti")
	return label
