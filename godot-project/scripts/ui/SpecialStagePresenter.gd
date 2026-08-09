class_name SpecialStagePresenter
extends RefCounted

## Presentation formatting for the special-stage intro, run, pause, and
## results views.

static func pause_text(bridge: Object) -> String:
	var resume_prefix := "> " if bridge._special_stage_pause_cursor == 0 else "  "
	var quit_prefix := "> " if bridge._special_stage_pause_cursor == 1 else "  "
	return bridge._language_text("PAUSED\n%sRESUME\n%sQUIT TO TITLE", "PAUSIERT\n%sFORTSETZEN\n%sZUM TITEL", "EN PAUSE\n%sREPRENDRE\n%sQUITTER VERS LE TITRE", "EN PAUSA\n%sCONTINUAR\n%sSALIR AL TITULO", "IN PAUSA\n%sRIPRENDI\n%sTORNA AL TITOLO") % [resume_prefix, quit_prefix]

static func title_text(bridge: Object) -> String:
	if bridge._special_stage_phase == 0:
		return bridge._language_text("SPECIAL STAGE", "SPECIAL STAGE", "SPECIAL STAGE", "SPECIAL STAGE", "SPECIAL STAGE")
	if bridge._special_stage_phase == 1:
		return bridge._language_text("SPECIAL STAGE RUN", "SPECIAL-STAGE-LAUF", "COURSE SPECIAL", "RECORRIDO ESPECIAL", "CORSA SPECIALE")
	return bridge._language_text("SPECIAL STAGE RESULTS", "SPECIAL-STAGE-ERGEBNIS", "RESULTAT SPECIAL", "RESULTADO ESPECIAL", "RISULTATO SPECIALE")

static func source_tilemap(bridge: Object) -> String:
	return "special_stage_%d_bg" % (clampi(bridge._special_stage_emerald_index, 0, 6) + 1)

static func prompt_text(bridge: Object) -> String:
	if bridge._special_stage_paused:
		return bridge._language_text("SPECIAL STAGE PAUSED", "SPECIAL STAGE PAUSIERT", "SPECIAL STAGE EN PAUSE", "SPECIAL STAGE EN PAUSA", "SPECIAL STAGE IN PAUSA")
	if bridge._special_stage_phase == 0:
		return bridge._language_text("CHAOS EMERALD CHALLENGE READY", "CHAOS-EMERALD-HERAUSFORDERUNG BEREIT", "DEFI EMERAUDE CHAOS PRET", "DESAFIO DE ESMERALDA DEL CAOS LISTO", "SFIDA CHAOS EMERALD PRONTA")
	if bridge._special_stage_phase == 1:
		return bridge._language_text("COLLECT RINGS   LANE %d / 3", "RINGE SAMMELN   SPUR %d / 3", "COLLECTEZ LES ANNEAUX   VOIE %d / 3", "RECOGE ANILLOS   CARRIL %d / 3", "RACCOGLI ANELLI   CORSIA %d / 3") % (bridge._special_stage_lane + 1)
	if bridge._special_stage_target_reached:
		return bridge._language_text("TARGET REACHED   EMERALD %02d", "ZIEL ERREICHT   EMERALD %02d", "CIBLE ATTEINTE   EMERAUDE %02d", "OBJETIVO ALCANZADO   ESMERALDA %02d", "OBIETTIVO RAGGIUNTO   SMERALDO %02d") % (bridge._special_stage_emerald_index + 1)
	return bridge._language_text("TARGET MISSED   TRY AGAIN", "ZIEL VERFEHLT   NOCH EINMAL", "CIBLE MANQUEE   REESSAYEZ", "OBJETIVO FALLIDO   INTENTA DE NUEVO", "OBIETTIVO MANCATO   RIPROVA")

static func detail_text(bridge: Object) -> String:
	if bridge._special_stage_paused:
		return bridge._language_text("%s RESUME   %s RESUME", "%s FORTSETZEN   %s FORTSETZEN", "%s REPRENDRE   %s REPRENDRE", "%s CONTINUAR   %s CONTINUAR", "%s RIPRENDI   %s RIPRENDI") % [bridge.get_confirm_label(), bridge.get_secondary_label()]
	if bridge._special_stage_phase == 0:
		return bridge._language_text("7 SPECIAL RINGS FOUND\n%s ENTER   %s SKIP", "7 SPEZIALRINGE GEFUNDEN\n%s EINGABE   %s UEBERSPRINGEN", "7 ANNEAUX SPECIAUX TROUVES\n%s ENTRER   %s PASSER", "7 ANILLOS ESPECIALES ENCONTRADOS\n%s ENTRAR   %s OMITIR", "7 ANELLI SPECIALI TROVATI\n%s INVIO   %s SALTA") % [bridge.get_confirm_label(), bridge.get_secondary_label()]
	if bridge._special_stage_phase == 1:
		return bridge._language_text("TIME %03d   RINGS %03d / %03d   %02d%% COMPLETE\nLEFT/RIGHT CHANGE LANES", "ZEIT %03d   RINGE %03d / %03d   %02d%% FERTIG\nLINKS/RECHTS SPUR WECHSELN", "TEMPS %03d   ANNEAUX %03d / %03d   %02d%% TERMINE\nGAUCHE/DROITE CHANGER DE VOIE", "TIEMPO %03d   ANILLOS %03d / %03d   %02d%% COMPLETO\nIZQ/DER CAMBIAR CARRIL", "TEMPO %03d   ANELLI %03d / %03d   %02d%% COMPLETO\nSINISTRA/DESTRA CAMBIA CORSIA") % [ceili(bridge._special_stage_timer), bridge._special_stage_ring_count, bridge._special_stage_run_target, int(bridge._special_stage_progress * 100.0)]
	return bridge._language_text("RINGS %03d   POINTS %05d\n%s CONTINUE   %s SKIP", "RINGE %03d   PUNKTE %05d\n%s WEITER   %s UEBERSPRINGEN", "ANNEAUX %03d   POINTS %05d\n%s CONTINUER   %s PASSER", "ANILLOS %03d   PUNTOS %05d\n%s CONTINUAR   %s OMITIR", "ANELLI %03d   PUNTI %05d\n%s CONTINUA   %s SALTA") % [bridge._special_stage_ring_count, bridge._special_stage_score, bridge.get_confirm_label(), bridge.get_secondary_label()]

static func run_display_text(bridge: Object, motion_label: String, robo_progress: int) -> String:
	return bridge._language_text("TIME %03d     RINGS %03d / %03d     CHAIN x%d     PROGRESS %02d%%     ROBO %02d%%     %s", "ZEIT %03d     RINGE %03d / %03d     KETTE x%d     FORTSCHRITT %02d%%     ROBO %02d%%     %s", "TEMPS %03d     ANNEAUX %03d / %03d     CHAINE x%d     PROGRES %02d%%     ROBO %02d%%     %s", "TIEMPO %03d     ANILLOS %03d / %03d     CADENA x%d     PROGRESO %02d%%     ROBO %02d%%     %s", "TEMPO %03d     ANELLI %03d / %03d     CATENA x%d     PROGRESSO %02d%%     ROBO %02d%%     %s") % [ceili(bridge._special_stage_timer), bridge._special_stage_ring_count, bridge._special_stage_run_target, bridge._special_stage_multiplier, int(bridge._special_stage_progress * 100.0), robo_progress, motion_label]

static func result_display_text(bridge: Object) -> String:
	return bridge._language_text("RINGS %03d    SCORE %05d", "RINGE %03d    PUNKTE %05d", "ANNEAUX %03d    SCORE %05d", "ANILLOS %03d    PUNTOS %05d", "ANELLI %03d    PUNTEGGIO %05d") % [bridge._special_stage_ring_count, bridge._special_stage_score]

static func motion_text(bridge: Object) -> String:
	if bridge.is_special_stage_jumping():
		return bridge._language_text("JUMP", "SPRUNG", "SAUT", "SALTO", "SALTO")
	return bridge._language_text("SPD %.1f", "GESCHW %.1f", "VIT %.1f", "VEL %.1f", "VEL %.1f") % bridge.get_special_stage_speed()

static func new_label(bridge: Object) -> String:
	return bridge._language_text("NEW", "NEU", "NOUVEAU", "NUEVO", "NUOVO")
