class_name PausePresenter
extends RefCounted

static func pause_text(bridge: Object) -> String:
	return bridge.language_text("TAP TO RESUME", "ZUM FORTSETZEN TIPPEN", "TOUCHER POUR REPRENDRE", "TOCA PARA CONTINUAR", "TOCCA PER RIPRENDERE") if bridge.is_touch_device() else bridge.language_text("PRESS ENTER TO RESUME", "ENTER ZUM FORTSETZEN DRUECKEN", "APPUYEZ SUR ENTREE POUR REPRENDRE", "PULSA ENTER PARA CONTINUAR", "PREMI INVIO PER RIPRENDERE")

static func title_text(bridge: Object) -> String:
	return bridge.language_text("PAUSE", "PAUSE", "PAUSE", "PAUSA", "PAUSA")

static func prompt_text(bridge: Object) -> String:
	return bridge.language_text("STAGE SUSPENDED", "SPIELSTUFE ANGEHALTEN", "STAGE EN PAUSE", "FASE SUSPENDIDA", "STAGE SOSPESO")

static func detail_text(bridge: Object) -> String:
	if bridge.get_run_mode_state().from_time_attack or bridge.get_run_mode_state().from_multiplayer:
		return bridge.language_text("%s SELECT   %s CONFIRM   %s RESUME", "%s AUSWAEHLEN   %s BESTAETIGEN   %s FORTSETZEN", "%s SELECTIONNER   %s CONFIRMER   %s REPRENDRE", "%s SELECCIONAR   %s CONFIRMAR   %s CONTINUAR", "%s SELEZIONA   %s CONFERMA   %s RIPRENDI") % [bridge.get_navigation_label(), bridge.get_confirm_label(), bridge.get_secondary_label()]
	return bridge.language_text("%s SELECT   %s CONFIRM   START RESUME", "%s AUSWAEHLEN   %s BESTAETIGEN   START FORTSETZEN", "%s SELECTIONNER   %s CONFIRMER   START REPRENDRE", "%s SELECCIONAR   %s CONFIRMAR   START CONTINUAR", "%s SELEZIONA   %s CONFERMA   START RIPRENDI") % [bridge.get_navigation_label(), bridge.get_confirm_label()]

static func summary_text(bridge: Object) -> String:
	var selected: int = bridge.get_pause_menu_state().menu_index
	var rows: Array = menu_rows(bridge)
	if selected > 0 and selected < rows.size():
		return bridge.language_text("LEAVE THE STAGE\n%s", "SPIELSTUFE VERLASSEN\n%s", "QUITTER LE STAGE\n%s", "SALIR DE LA FASE\n%s", "LASCIA LO STAGE\n%s") % str(rows[selected].get("value", ""))
	return bridge.language_text("RETURN TO THE CURRENT STAGE", "ZUR AKTUELLEN SPIELSTUFE", "RETOURNER AU STAGE", "VOLVER A LA FASE ACTUAL", "TORNA ALLO STAGE ATTUALE")

static func badge_text(bridge: Object) -> String:
	return bridge.language_text("PAUSED", "PAUSIERT", "EN PAUSE", "EN PAUSA", "IN PAUSA")

static func chrome_colors(_bridge: Object) -> Dictionary:
	return {"accent": Color(0.98, 0.76, 0.20, 0.98), "card": Color(0.10, 0.13, 0.22, 0.98)}

static func menu_rows(bridge: Object) -> Array:
	var run_mode = bridge.get_run_mode_state()
	var continue_label: String = bridge.language_text("CONTINUE", "WEITER", "CONTINUER", "CONTINUAR", "CONTINUA")
	var quit_label: String = bridge.language_text("QUIT", "BEENDEN", "QUITTER", "SALIR", "ESCI")
	var stage_label: String = bridge.language_text("RETURN TO STAGE", "ZURUCK ZUM SPIEL", "RETOUR AU STAGE", "VOLVER A LA FASE", "TORNA ALLO STAGE")
	var exit_label: String = bridge.language_text("RETURN TO TITLE", "ZURUCK ZUM TITEL", "RETOUR AU TITRE", "VOLVER AL TITULO", "TORNA AL TITOLO")
	if run_mode.from_time_attack:
		exit_label = bridge.language_text("RETURN TO TIME ATTACK", "ZURUCK ZU TIME ATTACK", "RETOUR AU TIME ATTACK", "VOLVER A TIME ATTACK", "TORNA A TIME ATTACK")
	elif run_mode.from_multiplayer:
		exit_label = bridge.language_text("RETURN TO MULTIPLAYER", "ZURUCK ZUM MULTIPLAYER", "RETOUR AU MULTIJOUEUR", "VOLVER A MULTIJUGADOR", "TORNA AL MULTIPLAYER")
	return [{"label": continue_label, "value": stage_label}, {"label": quit_label, "value": exit_label}]
