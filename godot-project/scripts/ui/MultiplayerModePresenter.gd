class_name MultiplayerModePresenter
extends RefCounted

static func rows(bridge: Object) -> Array:
	var multi_pak: String = bridge._language_text("MULTI-PAK", "MULTI-PAK", "MULTI-PAK", "MULTI-PAK", "MULTI-PAK")
	var single_pak: String = bridge._language_text("SINGLE-PAK", "SINGLE-PAK", "SINGLE-PAK", "SINGLE-PAK", "SINGLE-PAK")
	var ready: String = bridge._language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO")
	var name_required: String = bridge._language_text("NAME REQ", "NAME NOETIG", "NOM REQUIS", "NOMBRE REQ", "NOME RICHIESTO")
	var has_name: bool = bridge.has_profile_name()
	return [
		{"name": multi_pak, "description": bridge._language_text("2-4 PLAYERS USING ONE GAME PAK EACH", "2-4 SPIELER MIT JE EINEM GAME PAK", "2-4 JOUEURS AVEC UN GAME PAK CHACUN", "2-4 JUGADORES CON UN GAME PAK CADA UNO", "2-4 GIOCATORI CON UN GAME PAK CIASCUNO"), "status": ready if has_name else name_required, "available": has_name, "selected": bridge._title_menu_index == 0},
		{"name": single_pak, "description": bridge._language_text("HOST A DOWNLOAD MATCH FROM ONE GAME PAK", "DOWNLOAD-MATCH MIT EINEM GAME PAK HOSTEN", "HEBER UNE PARTIE TELECHARGEE DEPUIS UN GAME PAK", "ALBERGAR UNA PARTIDA DESCARGADA DESDE UN GAME PAK", "OSPITA UNA PARTITA DOWNLOAD DA UN GAME PAK"), "status": ready if has_name else name_required, "available": has_name, "selected": bridge._title_menu_index == 1},
	]

static func title_text(bridge: Object) -> String:
	return bridge._language_text("SELECT PAK MODE", "PAK-MODUS", "MODE PAK", "MODO PAK", "MODALITA PAK")

static func prompt_text(bridge: Object) -> String:
	if not bridge._title_notice_text.is_empty():
		return bridge.get_title_notice_text()
	return bridge._language_text("CHOOSE A LINK STYLE", "LINK-ART AUSWAEHLEN", "CHOISIR UN MODE DE LIAISON", "ELIGE UN TIPO DE ENLACE", "SCEGLI UN TIPO DI COLLEGAMENTO")

static func summary_text(bridge: Object) -> String:
	var mode_label: String = bridge._language_text("MODE", "MODUS", "MODE", "MODO", "MODALITA")
	var players_label: String = bridge._language_text("PLAYERS", "SPIELER", "JOUEURS", "JUGADORES", "GIOCATORI")
	var profile_label: String = bridge._language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO")
	if bridge._title_menu_index == 0:
		return "%s\nMULTI-PAK\n\n%s\n2-4 LINKED SYSTEMS\n\n%s\n%s" % [mode_label, players_label, profile_label, bridge.get_profile_name_text()]
	return "%s\nSINGLE-PAK\n\n%s\n1 HOST + CLIENT DOWNLOADS\n\n%s\n%s" % [mode_label, players_label, profile_label, bridge.get_profile_name_text()]

static func detail_text(bridge: Object) -> String:
	if bridge.has_profile_name():
		return "%s SELECT   %s CONFIRM   %s BACK" % [bridge.get_navigation_label(), bridge.get_confirm_label(), bridge.get_secondary_label()]
	return "PROFILE NAME REQUIRED BEFORE LINK PLAY\n%s SELECT   %s CONFIRM   %s BACK" % [bridge.get_navigation_label(), bridge.get_confirm_label(), bridge.get_secondary_label()]

static func info_text(bridge: Object) -> String:
	if bridge._title_menu_index == 0:
		return bridge._language_text("ONE GAME PAK PER PLAYER.\nSTART A STANDARD LINK SESSION.", "EIN GAME PAK PRO SPIELER.\nSTANDARD-LINKSESSION STARTEN.", "UN GAME PAK PAR JOUEUR.\nLANCER UNE SESSION STANDARD.", "UN GAME PAK POR JUGADOR.\nINICIA UNA SESION ESTANDAR.", "UN GAME PAK PER GIOCATORE.\nAVVIA UNA SESSIONE STANDARD.")
	return bridge._language_text("THE HOST SENDS THE CLIENT PROGRAM.\nBEST FOR QUICK LOCAL MATCHES.", "DER HOST SENDT DAS CLIENT-PROGRAMM.\nIDEAL FUER SCHNELLE LOKALE PARTIEN.", "L'HOTE ENVOIE LE PROGRAMME CLIENT.\nIDEAL POUR DES PARTIES LOCALES RAPIDES.", "EL HOST ENVIA EL PROGRAMA CLIENT.\nIDEAL PARA PARTIDAS LOCALES RAPIDAS.", "L'HOST INVIA IL PROGRAMMA CLIENT.\nIDEALE PER PARTITE LOCALI RAPIDE.")

static func badge_text(bridge: Object) -> String:
	return "LINK" if bridge._title_menu_index == 0 else "DL"

static func chrome_colors(bridge: Object) -> Dictionary:
	if bridge._title_menu_index == 0:
		return {"accent": Color(0.95, 0.52, 0.18, 1.0), "badge": Color(0.96, 0.72, 0.18, 1.0), "summary": Color(0.96, 0.94, 0.88, 0.98)}
	return {"accent": Color(0.86, 0.38, 0.24, 1.0), "badge": Color(0.88, 0.50, 0.22, 1.0), "summary": Color(0.96, 0.90, 0.84, 0.98)}
