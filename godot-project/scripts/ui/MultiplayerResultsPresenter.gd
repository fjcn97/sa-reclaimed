class_name MultiplayerResultsPresenter
extends RefCounted

## Presentation model for multiplayer results and post-match continuation.

static func _state(bridge: Object):
	return bridge.get_multiplayer_frontend_state()

static func title(bridge: Object) -> String:
	if _state(bridge).result_mode == bridge.MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION:
		return bridge.language_text("CHARACTERS SELECTED", "CHARAKTER GEWAEHLT", "PERSONNAGES CHOISIS", "PERSONAJES ELEGIDOS", "PERSONAGGI SCELTI")
	return bridge.language_text("MULTIPLAYER RESULTS", "MULTIPLAYER-ERGEBNIS", "RESULTATS MULTIJOUEUR", "RESULTADOS MULTIJUGADOR", "RISULTATI MULTIGIOCATORE")

static func prompt(bridge: Object) -> String:
	var seconds_left: int = ceili(bridge.get_singlepak_results_time_remaining())
	if _state(bridge).result_mode == bridge.MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION:
		if _state(bridge).result_snapshot.is_empty():
			return bridge.language_text("CHARACTER ORDER LOCKED IN", "CHARAKTERREIHENFOLGE FESTGELEGT", "ORDRE DES PERSONNAGES FIXE", "ORDEN DE PERSONAJES FIJADO", "ORDINE DEI PERSONAGGI FISSATO")
		return bridge.language_text("READY: %s ON %s   NEXT IN %d", "BEREIT: %s AUF %s   WEITER IN %d", "PRET: %s SUR %s   SUITE DANS %d", "LISTO: %s EN %s   SIGUIENTE EN %d", "PRONTO: %s SU %s   PROSSIMO TRA %d") % [str(_state(bridge).result_snapshot[0]["character"]), bridge.get_multiplayer_session_course_text(), seconds_left]
	if _state(bridge).result_snapshot.is_empty():
		return bridge.language_text("COLLECT RINGS SUMMARY", "RING-SAMMELERGEBNIS", "RESUME DES ANNEAUX", "RESUMEN DE ANILLOS", "RIEPILOGO ANELLI")
	return bridge.language_text("WINNER: %s   COURSE: %s   NEXT IN %d", "SIEGER: %s   KURS: %s   WEITER IN %d", "VAINQUEUR: %s   PARCOURS: %s   SUITE DANS %d", "GANADOR: %s   FASE: %s   SIGUIENTE EN %d", "VINCITORE: %s   CORSO: %s   PROSSIMO TRA %d") % [str(_state(bridge).result_snapshot[0]["name"]), bridge.get_multiplayer_session_course_text(), seconds_left]

static func detail(bridge: Object) -> String:
	if _state(bridge).result_mode == bridge.MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION:
		return bridge.language_text("AUTO ADVANCE TO COURSE SELECT   %s SKIP NOW", "AUTOMATISCH ZUR KURSWAHL   %s JETZT UEBERSPRINGEN", "PASSAGE AUTO AU CHOIX DU PARCOURS   %s PASSER", "AVANCE AUTO A SELECCION DE FASE   %s OMITIR", "AVANZAMENTO AUTO ALLA SCELTA CORSO   %s SALTA") % bridge.get_confirm_label()
	return bridge.language_text("AUTO ADVANCE TO PLAY AGAIN?   %s SKIP NOW", "AUTOMATISCH ERNEUT SPIELEN?   %s JETZT UEBERSPRINGEN", "REJOUER AUTOMATIQUEMENT?   %s PASSER", "JUGAR DE NUEVO AUTOMATICAMENTE?   %s OMITIR", "GIOCARE ANCORA AUTOMATICAMENTE?   %s SALTA") % bridge.get_confirm_label()

static func summary(bridge: Object) -> String:
	var mode_text: String = bridge.language_text("COURSE COMPLETE", "KURS BEENDET", "PARCOURS TERMINE", "FASE COMPLETADA", "CORSO COMPLETATO") if _state(bridge).result_mode == bridge.MULTIPLAYER_RESULTS_MODE_COURSE_COMPLETE else bridge.language_text("CHARACTER SELECTION", "CHARAKTERWAHL", "CHOIX DU PERSONNAGE", "SELECCION DE PERSONAJE", "SCELTA PERSONAGGIO")
	var mode_label: String = bridge.language_text("MODE", "MODUS", "MODE", "MODO", "MODALITA")
	var players_label: String = bridge.language_text("PLAYERS", "SPIELER", "JOUEURS", "JUGADORES", "GIOCATORI")
	if _state(bridge).result_snapshot.is_empty():
		return "%s\n%s\n\n%s\n0" % [mode_label, mode_text, players_label]
	var winner: Dictionary = _state(bridge).result_snapshot[0]
	if _state(bridge).result_mode == bridge.MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION:
		return "%s\n%s\n\n%s\n%s\n\n%s\n%s" % [mode_label, mode_text, bridge.language_text("LEAD PICK", "ERSTE WAHL", "PREMIER CHOIX", "PRIMERA ELECCION", "PRIMA SCELTA"), str(winner["character"]), bridge.language_text("NEXT STEP", "NAECHSTER SCHRITT", "ETAPE SUIVANTE", "SIGUIENTE PASO", "PROSSIMO PASSO"), bridge.language_text("COURSE SELECT", "KURSAUSWAHL", "CHOIX DU PARCOURS", "SELECCION DE FASE", "SELEZIONE CORSO")]
	return "%s\n%s\n\n%s\n%s\n\n%s\n%s" % [mode_label, mode_text, bridge.language_text("WINNER", "SIEGER", "VAINQUEUR", "GANADOR", "VINCITORE"), str(winner["name"]), bridge.language_text("NEXT STEP", "NAECHSTER SCHRITT", "ETAPE SUIVANTE", "SIGUIENTE PASO", "PROSSIMO PASSO"), bridge.language_text("PLAY AGAIN?", "NOCHMAL SPIELEN?", "REJOUER?", "JUGAR DE NUEVO?", "GIOCARE ANCORA?")]

static func badge(bridge: Object) -> String:
	return bridge.language_text("SEL", "AUS", "SEL", "SEL", "SEL") if _state(bridge).result_mode == bridge.MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION else "VS"

static func chrome_colors(bridge: Object) -> Dictionary:
	if _state(bridge).result_mode == bridge.MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION:
		return {"accent": Color(0.92, 0.42, 0.24, 1.0), "panel": Color(0.10, 0.14, 0.22, 0.96), "summary": Color(0.18, 0.12, 0.14, 0.98), "card": Color(0.16, 0.12, 0.16, 0.96), "selected": Color(0.40, 0.20, 0.18, 0.98)}
	return {"accent": Color(0.96, 0.68, 0.22, 1.0), "panel": Color(0.10, 0.14, 0.22, 0.96), "summary": Color(0.14, 0.18, 0.28, 0.98), "card": Color(0.12, 0.18, 0.30, 0.96), "selected": Color(0.20, 0.32, 0.50, 0.98)}

static func option_rows(bridge: Object) -> Array:
	var items: Array = bridge.get_singlepak_results_items()
	var rows: Array = []
	for i in range(items.size()):
		rows.append({"label": str(items[i]), "status": bridge.language_text("SELECTED", "AUSGEWAEHLT", "SELECTIONNE", "SELECCIONADO", "SELEZIONATO") if i == _state(bridge).results_cursor else (bridge.language_text("NEXT", "WEITER", "SUIVANT", "SIGUIENTE", "PROSSIMO") if i == 0 else bridge.language_text("RETURN", "ZURUECK", "RETOUR", "VOLVER", "RITORNO")), "selected": i == _state(bridge).results_cursor})
	return rows
