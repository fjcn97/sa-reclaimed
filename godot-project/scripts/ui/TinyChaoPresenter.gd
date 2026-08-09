class_name TinyChaoPresenter
extends RefCounted

## Presentation model for Tiny Chao Garden menus and the garden play view.

static func rows(bridge: Object) -> Array:
	if bridge._title_phase == bridge.TITLE_PHASE_TINY_CHAO_GARDEN_PLAY:
		var result: Array = []
		for i in range(bridge._tiny_chao_roster.size()):
			var chao: Dictionary = bridge._tiny_chao_roster[i]
			result.append({"name": str(chao.get("name", "CHAO")), "description": bridge._language_text("MOOD %03d%%   CARE %d", "STIMMUNG %03d%%   PFLEGE %d", "HUMEUR %03d%%   SOINS %d", "ANIMO %03d%%   CUIDADO %d", "UMORE %03d%%   CURA %d") % [int(chao.get("mood", 0)), int(chao.get("care", 0))], "status": (bridge._language_text("FRUIT %d", "FRUECHTE %d", "FRUITS %d", "FRUTA %d", "FRUTTA %d") % bridge._tiny_chao_fruit) if i == bridge._tiny_chao_selected_index else bridge._language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"), "ready": true, "back": false, "selected": i == bridge._tiny_chao_selected_index})
		return result
	if bridge._title_phase == bridge.TITLE_PHASE_TINY_CHAO_SETUP:
		return [{"name": bridge._language_text("ENTER GARDEN", "GARTEN OEFFNEN", "ENTRER DANS LE JARDIN", "ENTRAR AL JARDIN", "ENTRA NEL GIARDINO"), "description": bridge._language_text("PREPARE THE HANDOFF DATA", "UEBERGABEDATEN VORBEREITEN", "PREPARER LES DONNEES DE TRANSFERT", "PREPARAR DATOS DE ENTREGA", "PREPARA DATI PASSAGGIO"), "status": bridge._language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"), "ready": true, "back": false, "selected": bridge._title_menu_index == 0}, {"name": bridge._language_text("NEW SESSION", "NEUE SITZUNG", "NOUVELLE SESSION", "NUEVA SESION", "NUOVA SESSIONE"), "description": bridge._language_text("BUILD A FRESH LINK TOKEN", "NEUEN LINK-TOKEN ERSTELLEN", "CREER UN NOUVEAU JETON", "CREAR UN TOKEN NUEVO", "CREA UN NUOVO TOKEN LINK"), "status": bridge._tiny_chao_session_id, "ready": true, "back": false, "selected": bridge._title_menu_index == 1}, {"name": bridge._language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO"), "description": bridge._language_text("RETURN TO TINY CHAO GARDEN", "ZUM TINY CHAO GARTEN", "RETOUR AU JARDIN TINY CHAO", "VOLVER AL JARDIN TINY CHAO", "TORNA AL GIARDINO TINY CHAO"), "status": bridge._language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"), "ready": true, "back": true, "selected": bridge._title_menu_index == 2}]
	return [{"name": bridge._language_text("ENTER GARDEN", "GARTEN OEFFNEN", "ENTRER DANS LE JARDIN", "ENTRAR AL JARDIN", "ENTRA NEL GIARDINO"), "description": bridge._language_text("OPEN THE TINY CHAO GARDEN HANDOFF", "TINY CHAO GARTEN UEBERGABE OEFFNEN", "OUVRIR LE TRANSFERT DU JARDIN TINY CHAO", "ABRIR ENTREGA DEL JARDIN TINY CHAO", "APRI IL PASSAGGIO DEL GIARDINO TINY CHAO"), "status": bridge._language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"), "ready": true, "back": false, "selected": bridge._title_menu_index == 0}, {"name": bridge._language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO"), "description": bridge._language_text("RETURN TO SINGLE PLAYER", "ZUM EINZELSPIELER", "RETOUR AU MODE SOLO", "VOLVER A UN JUGADOR", "TORNA AL GIOCATORE SINGOLO"), "status": bridge._language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"), "ready": true, "back": true, "selected": bridge._title_menu_index == 1}]

static func title_text(bridge: Object) -> String:
	return bridge._language_text("TINY CHAO GARDEN", "TINY CHAO GARTEN", "JARDIN TINY CHAO", "JARDIN TINY CHAO", "GIARDINO TINY CHAO")

static func prompt_text(bridge: Object) -> String:
	var notice: String = bridge.get_title_notice_text()
	if not notice.is_empty():
		return notice
	if bridge._title_phase == bridge.TITLE_PHASE_TINY_CHAO_GARDEN_PLAY:
		return bridge._tiny_chao_action_text
	if bridge._title_phase == bridge.TITLE_PHASE_TINY_CHAO_SETUP:
		return bridge._language_text("PREPARE THE GARDEN HANDOFF", "GARTEN-UEBERGABE VORBEREITEN", "PREPARER LE TRANSFERT DU JARDIN", "PREPARAR ENTREGA DEL JARDIN", "PREPARA IL PASSAGGIO DEL GIARDINO")
	return bridge._language_text("OPEN THE TINY CHAO GARDEN", "TINY CHAO GARTEN OEFFNEN", "OUVRIR LE JARDIN TINY CHAO", "ABRIR EL JARDIN TINY CHAO", "APRI IL GIARDINO TINY CHAO")

static func detail_text(bridge: Object) -> String:
	if bridge._title_phase == bridge.TITLE_PHASE_TINY_CHAO_GARDEN_PLAY:
		return bridge._language_text("LEFT/RIGHT/UP/DOWN MOVE   %s CARE   %s EXIT", "LINKS/RECHTS/HOCH/RUNTER BEWEGEN   %s PFLEGEN   %s AUSGANG", "GAUCHE/DROITE/HAUT/BAS BOUGER   %s SOIN   %s SORTIE", "IZQ/DER/ARRIBA/ABAJO MOVER   %s CUIDAR   %s SALIR", "SINISTRA/DESTRA/SU/GIU MUOVI   %s CURA   %s ESCI") % [bridge.get_confirm_label(), bridge.get_secondary_label()]
	if bridge._title_phase == bridge.TITLE_PHASE_TINY_CHAO_SETUP:
		return bridge._language_text("PREPARE SCORE, LANGUAGE, AND SESSION DATA\n%s SELECT   %s CONFIRM   %s BACK", "PUNKTZAHL, SPRACHE UND SITZUNG VORBEREITEN\n%s AUSWAEHLEN   %s BESTAETIGEN   %s ZURUECK", "PREPARER SCORE, LANGUE ET SESSION\n%s SELECTIONNER   %s CONFIRMER   %s RETOUR", "PREPARAR PUNTOS, IDIOMA Y SESION\n%s SELECCIONAR   %s CONFIRMAR   %s ATRAS", "PREPARA PUNTEGGIO, LINGUA E SESSIONE\n%s SELEZIONA   %s CONFERMA   %s INDIETRO") % [bridge.get_navigation_label(), bridge.get_confirm_label(), bridge.get_secondary_label()]
	return bridge._language_text("THIS BRANCH DIRECTLY HANDS OFF TO TINY CHAO GARDEN\n%s SELECT   %s CONFIRM   %s BACK", "DIESER ZWEIG UEBERGIBT DIREKT AN DEN TINY CHAO GARTEN\n%s AUSWAEHLEN   %s BESTAETIGEN   %s ZURUECK", "CE BRANCHE PASSE DIRECTEMENT AU JARDIN TINY CHAO\n%s SELECTIONNER   %s CONFIRMER   %s RETOUR", "ESTA RAMA PASA DIRECTAMENTE AL JARDIN TINY CHAO\n%s SELECCIONAR   %s CONFIRMAR   %s ATRAS", "QUESTO RAMO PASSA DIRETTAMENTE AL GIARDINO TINY CHAO\n%s SELEZIONA   %s CONFERMA   %s INDIETRO") % [bridge.get_navigation_label(), bridge.get_confirm_label(), bridge.get_secondary_label()]

static func summary_text(bridge: Object) -> String:
	if bridge._title_phase == bridge.TITLE_PHASE_TINY_CHAO_GARDEN_PLAY:
		var selected_name: String = str(bridge._tiny_chao_roster[bridge._tiny_chao_selected_index].get("name", "CHAO")) if not bridge._tiny_chao_roster.is_empty() else "CHAO"
		return bridge._language_text("%s STATUS\nHUNGER: %d%%\nMOOD: %d%%\nCARE: %d\nFRUIT: %d", "%s STATUS\nHUNGER: %d%%\nSTIMMUNG: %d%%\nPFLEGE: %d\nFRUECHTE: %d", "%s STATUT\nFAIM: %d%%\nHUMEUR: %d%%\nSOINS: %d\nFRUITS: %d", "%s ESTADO\nHAMBRE: %d%%\nANIMO: %d%%\nCUIDADO: %d\nFRUTA: %d", "%s STATO\nFAME: %d%%\nUMORE: %d%%\nCURA: %d\nFRUTTA: %d") % [selected_name, bridge._tiny_chao_hunger, bridge._tiny_chao_mood, bridge._tiny_chao_care_count, bridge._tiny_chao_fruit]
	if bridge._title_phase == bridge.TITLE_PHASE_TINY_CHAO_SETUP:
		return bridge._language_text("HANDOFF READY\nTOKEN: %s\nPROFILE: %s", "UEBERGABE BEREIT\nTOKEN: %s\nPROFIL: %s", "TRANSFERT PRET\nJETON: %s\nPROFIL: %s", "ENTREGA LISTA\nTOKEN: %s\nPERFIL: %s", "PASSAGGIO PRONTO\nTOKEN: %s\nPROFILO: %s") % [bridge._tiny_chao_session_id, bridge.get_profile_name_text()]
	return bridge._language_text("DIRECT BRANCH\nUNLOCKED: %s\nPROFILE: %s", "DIREKTZWEIG\nFREIGESCHALTET: %s\nPROFIL: %s", "BRANCHE DIRECTE\nDEVERROUILLE: %s\nPROFIL: %s", "RAMA DIRECTA\nDESBLOQUEADO: %s\nPERFIL: %s", "RAMO DIRETTO\nSBLOCCATO: %s\nPROFILO: %s") % [bridge._language_text("YES", "JA", "OUI", "SI", "SI") if bridge._tiny_chao_unlocked else bridge._language_text("NO", "NEIN", "NON", "NO", "NO"), bridge.get_profile_name_text()]

static func status_title(bridge: Object) -> String:
	return bridge._language_text("GARDEN STATUS", "GARTENSTATUS", "STATUT DU JARDIN", "ESTADO DEL JARDIN", "STATO DEL GIARDINO")

static func badge_text(_bridge: Object) -> String:
	return "CHAO"

static func info_rows(bridge: Object) -> Array:
	if bridge._title_phase == bridge.TITLE_PHASE_TINY_CHAO_GARDEN_PLAY:
		return ["SELECTED  %s" % (bridge._tiny_chao_roster[bridge._tiny_chao_selected_index].get("name", "CHAO") if not bridge._tiny_chao_roster.is_empty() else "CHAO"), "POSITION  %+.2f, %+.2f" % [bridge._tiny_chao_play_x, bridge._tiny_chao_play_y], "HUNGER   %03d%%   MOOD %03d%%" % [bridge._tiny_chao_hunger, bridge._tiny_chao_mood], "SESSION  %s" % bridge._tiny_chao_session_id]
	var setup_phase: bool = bridge._title_phase == bridge.TITLE_PHASE_TINY_CHAO_SETUP
	return ["SCORE  %d" % bridge.get_profile_score(), "LANG   %s" % language_text(bridge), "TOKEN  %s" % bridge._tiny_chao_session_id, "MODE   %s" % ("HANDOFF" if setup_phase else "DIRECT")]

static func language_text(bridge: Object) -> String:
	match bridge._language_index:
		0:
			return "JAPANESE"
		2:
			return "GERMAN"
		3:
			return "FRENCH"
		4:
			return "SPANISH"
	return "ENGLISH"
