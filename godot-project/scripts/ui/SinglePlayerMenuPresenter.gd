class_name SinglePlayerMenuPresenter
extends RefCounted

## Presentation model for the single-player mode menu.

static func rows(bridge: Object) -> Array:
	var result: Array = [{"name": bridge._language_text("GAME START", "SPIELSTART", "DEBUT DU JEU", "INICIO", "INIZIO"), "description": bridge._language_text("BEGIN THE MAIN ADVENTURE", "DAS HAUPTABENTEUER STARTEN", "COMMENCER L'AVENTURE PRINCIPALE", "COMENZAR LA AVENTURA PRINCIPAL", "INIZIA L'AVVENTURA PRINCIPALE"), "status": bridge._language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"), "available": true, "selected": bridge._title_menu_index == 0}, {"name": bridge._language_text("TIME ATTACK", "ZEITANGRIFF", "CONTRE LA MONTRE", "CONTRARRELOJ", "ATTACCO A TEMPO"), "description": bridge._language_text("RACE FOR THE FASTEST CLEAR TIME", "UM DIE SCHNELLSTE ABSCHLUSSZEIT RENNEN", "COURIR POUR LE MEILLEUR TEMPS", "CORRE POR EL MEJOR TIEMPO", "CORRI PER IL TEMPO MIGLIORE"), "status": bridge._language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"), "available": true, "selected": bridge._title_menu_index == 1}, {"name": bridge._language_text("OPTIONS", "OPTIONEN", "OPTIONS", "OPCIONES", "OPZIONI"), "description": bridge._language_text("ADJUST SAVE DATA AND SYSTEM SETTINGS", "SPEICHER- UND SYSTEMEINSTELLUNGEN AENDERN", "REGLER LES DONNEES ET LE SYSTEME", "AJUSTAR DATOS Y SISTEMA", "REGOLA DATI E IMPOSTAZIONI"), "status": bridge._language_text("SETUP", "EINSTELLUNGEN", "CONFIGURATION", "AJUSTES", "CONFIGURA"), "available": true, "selected": bridge._title_menu_index == 2}]
	if bridge.is_tiny_chao_unlocked():
		result.append({"name": bridge._language_text("TINY CHAO GARDEN", "KLEINER CHAO-GARTEN", "MINI JARDIN CHAO", "JARDIN CHAO", "GIARDINO CHAO"), "description": bridge._language_text("OPEN THE HANDHELD CHAO GARDEN LINK", "CHAO-GARTEN-LINK OEFFNEN", "OUVRIR LE LIEN DU JARDIN CHAO", "ABRIR EL ENLACE DEL JARDIN CHAO", "APRI IL COLLEGAMENTO GIARDINO CHAO"), "status": bridge._language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"), "available": true, "selected": bridge._title_menu_index == 3})
	return result

static func title_text(bridge: Object) -> String:
	return bridge._language_text("SINGLE PLAYER", "EINZELSPIELER", "JOUEUR SOLO", "UN JUGADOR", "GIOCATORE SINGOLO")

static func prompt_text(bridge: Object) -> String:
	if not bridge._title_notice_text.is_empty():
		return bridge.get_title_notice_text()
	return bridge._language_text("SELECT A MODE", "MODUS AUSWAEHLEN", "CHOISIR UN MODE", "SELECCIONA UN MODO", "SCEGLI UNA MODALITA")

static func detail_text(bridge: Object) -> String:
	return "%s TO SELECT   %s TO CONFIRM" % [bridge.get_navigation_label(), bridge.get_confirm_label()]

static func info_text(bridge: Object) -> String:
	match bridge._title_menu_index:
		0:
			return bridge._language_text("START A STANDARD STORY RUN", "STANDARD-GESCHICHTE STARTEN", "LANCER UNE AVENTURE STANDARD", "INICIAR UNA HISTORIA ESTANDAR", "AVVIA UNA STORIA STANDARD")
		1:
			return bridge._language_text("REPLAY CLEARED STAGES FOR BEST TIMES", "GESCHAFFTE LEVELS FUER BESTZEITEN SPIELEN", "REJOUER LES NIVEAUX POUR LES RECORDS", "REPITE FASES PARA MEJORES TIEMPOS", "RIGIOCA I LIVELLI PER I RECORD")
		2:
			return bridge._language_text("PROFILE, SAVE, SOUND, AND CONTROL SETTINGS", "PROFIL-, SPEICHER-, TON- UND STEUERUNGSOPTIONEN", "PROFIL, SAUVEGARDE, SON ET COMMANDES", "PERFIL, DATOS, SONIDO Y CONTROLES", "PROFILO, SALVATAGGI, AUDIO E COMANDI")
		3:
			if bridge.is_tiny_chao_unlocked():
				return bridge._language_text("DIRECT HANDOFF TO TINY CHAO GARDEN", "DIREKTE UEBERGABE ZUM CHAO-GARTEN", "TRANSFERT DIRECT AU JARDIN CHAO", "ENLACE DIRECTO AL JARDIN CHAO", "COLLEGAMENTO DIRETTO AL GIARDINO CHAO")
	return bridge._language_text("SELECT A MODE", "MODUS WAEHLEN", "CHOISIR UN MODE", "SELECCIONA UN MODO", "SCEGLI UNA MODALITA")

static func summary_title(bridge: Object) -> String:
	match bridge._title_menu_index:
		0:
			return bridge._language_text("GAME START", "SPIELSTART", "DEBUT DU JEU", "INICIO", "INIZIO")
		1:
			return bridge._language_text("TIME ATTACK", "ZEITANGRIFF", "CONTRE LA MONTRE", "CONTRARRELOJ", "ATTACCO A TEMPO")
		2:
			return bridge._language_text("OPTIONS", "OPTIONEN", "OPTIONS", "OPCIONES", "OPZIONI")
		3:
			if bridge.is_tiny_chao_unlocked():
				return bridge._language_text("TINY CHAO GARDEN", "KLEINER CHAO-GARTEN", "MINI JARDIN CHAO", "JARDIN CHAO", "GIARDINO CHAO")
	return bridge._language_text("SINGLE PLAYER", "EINZELSPIELER", "JOUEUR SOLO", "UN JUGADOR", "GIOCATORE SINGOLO")

static func summary_text(bridge: Object) -> String:
	match bridge._title_menu_index:
		0:
			return "%s\n%s: %s\n%s: %s" % [bridge._language_text("MAIN GAME", "HAUPTSPIEL", "JEU PRINCIPAL", "JUEGO PRINCIPAL", "GIOCO PRINCIPALE"), bridge._language_text("CURRENT RUNNER", "AKTUELLER CHARAKTER", "PERSONNAGE ACTUEL", "PERSONAJE ACTUAL", "PERSONAGGIO ATTUALE"), bridge.get_selected_character_name(), bridge._language_text("START POINT", "STARTPUNKT", "POINT DE DEPART", "PUNTO DE INICIO", "PUNTO DI PARTENZA"), bridge.get_selected_level_text()]
		1:
			return "%s\n%s: %s\n%s: SOLO" % [bridge._language_text("TIME ATTACK", "ZEITANGRIFF", "CONTRE-LA-MONTRE", "CONTRARRELOJ", "ATTACCO A TEMPO"), bridge._language_text("BOSS ATTACK", "BOSS-ANGRIFF", "ATTAQUE BOSS", "ATAQUE BOSS", "ATTACCO BOSS"), bridge._language_text("UNLOCKED", "FREIGESCHALTET", "DEBLOQUE", "DESBLOQUEADO", "SBLOCCATO") if bridge._boss_time_attack_unlocked else bridge._language_text("LOCKED", "GESPERRT", "VERROUILLE", "BLOQUEADO", "BLOCCATO"), bridge._language_text("BEST MODE", "BESTER MODUS", "MEILLEUR MODE", "MEJOR MODO", "MODALITA MIGLIORE")]
		2:
			return "%s\n%s: %s\n%s: %s" % [bridge._language_text("SAVE OPTIONS", "SPEICHEROPTIONEN", "OPTIONS DE SAUVEGARDE", "OPCIONES DE DATOS", "OPZIONI SALVATAGGIO"), bridge._language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), bridge.get_profile_name_text(), bridge._language_text("LANGUAGE", "SPRACHE", "LANGUE", "IDIOMA", "LINGUA"), bridge.get_language_text()]
		3:
			if bridge.is_tiny_chao_unlocked():
				return "%s\n%s: %s\n%s: %s" % [bridge._language_text("TINY CHAO GARDEN", "KLEINER CHAO-GARTEN", "MINI JARDIN CHAO", "JARDIN CHAO", "GIARDINO CHAO"), bridge._language_text("SESSION ID", "SITZUNGS-ID", "ID SESSION", "ID DE SESION", "ID SESSIONE"), bridge._tiny_chao_session_id, bridge._language_text("STATUS", "STATUS", "STATUT", "ESTADO", "STATO"), bridge._language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO")]
	return ""

static func chrome_colors(bridge: Object) -> Dictionary:
	match bridge._title_menu_index:
		1:
			return {"header": Color(0.12, 0.18, 0.34, 0.96), "summary": Color(0.08, 0.14, 0.28, 0.96)}
		2:
			return {"header": Color(0.15, 0.16, 0.26, 0.96), "summary": Color(0.10, 0.11, 0.20, 0.96)}
		3:
			if bridge.is_tiny_chao_unlocked():
				return {"header": Color(0.08, 0.20, 0.18, 0.96), "summary": Color(0.06, 0.16, 0.14, 0.96)}
	return {"header": Color(0.09, 0.16, 0.31, 0.95), "summary": Color(0.07, 0.13, 0.23, 0.95)}
