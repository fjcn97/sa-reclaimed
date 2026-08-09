class_name ClearResultsPresenter
extends RefCounted

## Presentation data for normal and time-attack clear screens.

static func title_text(bridge: Object) -> String:
	if bridge._run_from_time_attack:
		return bridge._language_text("TIME ATTACK", "TIME ATTACK", "TIME ATTACK", "TIME ATTACK", "TIME ATTACK")
	if bridge.is_boss_course_result():
		return bridge._language_text("BOSS DESTROYED", "BOSS BESIEGT", "BOSS DETRUIT", "JEFE DESTRUIDO", "BOSS DISTRUTTO")
	return bridge._language_text("STAGE CLEAR", "STUFE GESCHAFFT", "STAGE TERMINE", "FASE COMPLETADA", "STAGE COMPLETATO")

static func prompt_text(bridge: Object) -> String:
	if bridge._run_from_time_attack:
		if not bridge.is_clear_input_ready():
			return bridge._language_text("RESULT DISPLAY", "ERGEBNISANZEIGE", "AFFICHAGE DU RESULTAT", "PRESENTACION DEL RESULTADO", "VISUALIZZAZIONE RISULTATO")
		return bridge._language_text("%s  %s", "%s  %s", "%s  %s", "%s  %s", "%s  %s") % [result_heading_text(bridge), bridge.get_formatted_time(bridge._clear_time_snapshot)]
	return bridge._language_text("TIME: %s", "ZEIT: %s", "TEMPS: %s", "TIEMPO: %s", "TEMPO: %s") % bridge.get_formatted_time(bridge._clear_time_snapshot)

static func detail_text(bridge: Object) -> String:
	if bridge._run_from_time_attack:
		if not bridge.is_clear_input_ready():
			return bridge._language_text("TIME ATTACK RESULT   PLEASE WAIT", "TIME ATTACK ERGEBNIS   BITTE WARTEN", "RESULTAT TIME ATTACK   PATIENTEZ", "RESULTADO TIME ATTACK   ESPERA", "RISULTATO TIME ATTACK   ATTENDI")
		return bridge._language_text("TIME: %s   RANK: %s\n%s\n%s = LOBBY", "ZEIT: %s   RANG: %s\n%s\n%s = LOBBY", "TEMPS: %s   RANG: %s\n%s\n%s = SALLE", "TIEMPO: %s   RANGO: %s\n%s\n%s = SALA", "TEMPO: %s   RANGO: %s\n%s\n%s = STANZA") % [bridge.get_formatted_time(bridge._clear_time_snapshot), bridge._clear_rank_text, time_attack_record_text(bridge), bridge.get_confirm_label()]
	if not bridge.is_clear_input_ready():
		return bridge._language_text("BONUS COUNTING\n%s TO FINISH COUNT", "BONUS WIRD GEZAEHLT\n%s ZUM ABSCHLIESSEN", "COMPTE DES BONUS\n%s POUR TERMINER", "CONTANDO BONOS\n%s PARA TERMINAR", "CONTEGGIO BONUS\n%s PER TERMINARE") % bridge.get_confirm_label()
	if bridge._selected_level_index < bridge._level_names.size() - 1:
		return bridge._language_text("SCORE: %d   RANK: %s\nNEXT COURSE: %s", "PUNKTZAHL: %d   RANG: %s\nNAECHSTER KURS: %s", "SCORE: %d   RANG: %s\nPROCHAIN PARCOURS: %s", "PUNTOS: %d   RANGO: %s\nSIGUIENTE FASE: %s", "PUNTEGGIO: %d   RANGO: %s\nPROSSIMA ZONA: %s") % [bridge._clear_total_display_score, bridge._clear_rank_text, bridge._level_names[bridge._selected_level_index + 1]]
	return bridge._language_text("SCORE: %d   RANK: %s\nCOURSE COMPLETE", "PUNKTZAHL: %d   RANG: %s\nKURS KOMPLETT", "SCORE: %d   RANG: %s\nPARCOURS TERMINE", "PUNTOS: %d   RANGO: %s\nFASE COMPLETA", "PUNTEGGIO: %d   RANGO: %s\nZONA COMPLETATA") % [bridge._clear_total_display_score, bridge._clear_rank_text]

static func footer_text(bridge: Object) -> String:
	if not bridge.is_clear_input_ready():
		if bridge._run_from_time_attack:
			return bridge._language_text("RESULT ANIMATION", "ERGEBNISANIMATION", "ANIMATION DU RESULTAT", "ANIMACION DEL RESULTADO", "ANIMAZIONE RISULTATO")
		return bridge._language_text("%s = FAST COUNT", "%s = SCHNELL ZAEHLEN", "%s = COMPTE RAPIDE", "%s = CUENTA RAPIDA", "%s = CONTEGGIO RAPIDO") % bridge.get_confirm_label()
	if bridge._run_from_time_attack:
		return bridge._language_text("%s = LOBBY   AUTO RETURN IN 10 SEC", "%s = LOBBY   AUTOMATISCH ZURUECK IN 10 SEK", "%s = SALLE   RETOUR AUTO DANS 10 S", "%s = SALA   VUELTA AUTO EN 10 S", "%s = STANZA   RITORNO AUTO IN 10 S") % bridge.get_confirm_label()
	return bridge._language_text("AUTO COURSE SELECT", "AUTOMATISCHE KURSAUSWAHL", "SELECTION AUTO DU PARCOURS", "SELECCION AUTOMATICA DE FASE", "SELEZIONE AUTOMATICA ZONA")

static func result_heading_text(bridge: Object) -> String:
	if not bridge._run_from_time_attack:
		return bridge._language_text("RESULT", "ERGEBNIS", "RESULTAT", "RESULTADO", "RISULTATO")
	return bridge._language_text("NEW RECORD", "NEUER REKORD", "NOUVEAU RECORD", "NUEVO RECORD", "NUOVO RECORD") if bridge._clear_new_best_time else bridge._language_text("RESULT", "ERGEBNIS", "RESULTAT", "RESULTADO", "RISULTATO")

static func result_badge_text(bridge: Object) -> String:
	if bridge._run_from_time_attack:
		return medal_text(bridge)
	return bridge._clear_rank_text

static func medal_text(bridge: Object) -> String:
	match bridge._clear_time_attack_record_rank:
		1:
			return bridge._language_text("GOLD", "GOLD", "OR", "ORO", "ORO")
		2:
			return bridge._language_text("SILVER", "SILBER", "ARGENT", "PLATA", "ARGENTO")
		3:
			return bridge._language_text("BRONZE", "BRONZE", "BRONZE", "BRONCE", "BRONZO")
	return bridge._language_text("TRY", "VERSUCH", "ESSAI", "INTENTO", "TENTATIVO")

static func counting_text(bridge: Object) -> String:
	return bridge._language_text("COUNTING", "ZAEHLEN", "COMPTE", "CONTANDO", "CONTEGGIO")

static func chrome_colors(bridge: Object) -> Dictionary:
	if bridge._run_from_time_attack:
		return {"accent": Color(0.66, 0.84, 1.0, 0.98), "header": Color(0.10, 0.20, 0.34, 0.98), "score": Color(0.08, 0.16, 0.28, 0.98), "badge": Color(0.82, 0.88, 0.96, 0.98)}
	if bridge.is_boss_course_result():
		return {"accent": Color(1.0, 0.38, 0.22, 0.98), "header": Color(0.30, 0.08, 0.04, 0.98), "score": Color(0.20, 0.06, 0.03, 0.98), "badge": Color(0.86, 0.24, 0.12, 0.98)}
	return {"accent": Color(0.96, 0.76, 0.20, 0.98), "header": Color(0.28, 0.18, 0.06, 0.98), "score": Color(0.18, 0.12, 0.04, 0.98), "badge": Color(0.72, 0.50, 0.14, 0.98)}

static func rows(bridge: Object) -> Array:
	if bridge._run_from_time_attack:
		return [{"label": bridge._language_text("TIME", "ZEIT", "TEMPS", "TIEMPO", "TEMPO"), "value": bridge.get_formatted_time(bridge._clear_time_snapshot)}, {"label": bridge._language_text("MEDAL", "MEDAILLE", "MEDAILLE", "MEDALLA", "MEDAGLIA"), "value": medal_text(bridge)}, {"label": bridge._language_text("BEST", "BESTE", "MEILLEUR", "MEJOR", "MIGLIORE"), "value": best_text(bridge)}, {"label": bridge._language_text("RECORD", "REKORD", "RECORD", "RECORD", "RECORD"), "value": record_status_text(bridge)}]
	var result: Array = [{"label": bridge._language_text("TIME BONUS", "ZEITBONUS", "BONUS TEMPS", "BONUS DE TIEMPO", "BONUS TEMPO"), "value": str(bridge._clear_time_bonus_remaining)}, {"label": bridge._language_text("RING BONUS", "RING-BONUS", "BONUS ANNEAUX", "BONUS DE ANILLOS", "BONUS ANELLI"), "value": str(bridge._clear_ring_bonus_remaining)}]
	if bridge._selected_level_index < bridge._level_names.size() - 2:
		result.append({"label": bridge._language_text("SP RING BONUS", "SP-RING-BONUS", "BONUS ANNEAUX SP", "BONUS ANILLOS SP", "BONUS ANELLI SP"), "value": str(bridge._clear_special_ring_bonus_remaining)})
	result.append({"label": bridge._language_text("TOTAL SCORE", "GESAMTPUNKTZAHL", "SCORE TOTAL", "PUNTOS TOTALES", "PUNTEGGIO TOTALE"), "value": str(bridge._clear_total_display_score)})
	return result

static func stage_label(bridge: Object) -> String:
	if bridge._run_from_time_attack and bridge._time_attack_boss_mode:
		return bridge._language_text("%s BOSS", "%s BOSS", "%s BOSS", "%s JEFE", "%s BOSS") % bridge.get_level_name_by_index(bridge._selected_level_index)
	if bridge._selected_level_index >= 0 and bridge._selected_level_index < bridge._level_names.size():
		return bridge._level_names[bridge._selected_level_index]
	return bridge._language_text("STAGE", "STUFE", "STAGE", "FASE", "STAGE")

static func time_attack_record_text(bridge: Object) -> String:
	if bridge._clear_new_best_time:
		return bridge._language_text("NEW RECORD", "NEUER REKORD", "NOUVEAU RECORD", "NUEVO RECORD", "NUOVO RECORD")
	if bridge._clear_rank_text == "A":
		return bridge._language_text("GREAT RUN", "TOLLER LAUF", "SUPER COURSE", "GRAN CARRERA", "GRANDE CORSA")
	if bridge._clear_rank_text == "B":
		return bridge._language_text("GOOD TIME", "GUTE ZEIT", "BON TEMPS", "BUEN TIEMPO", "BUON TEMPO")
	return bridge._language_text("TRY AGAIN", "NOCH EINMAL", "REESSAYER", "INTENTAR DE NUEVO", "RIPROVA")

static func record_status_text(bridge: Object) -> String:
	if not bridge._run_from_time_attack:
		return ""
	if bridge._clear_new_best_time:
		return bridge._language_text("RECORD UPDATED", "REKORD AKTUALISIERT", "RECORD MIS A JOUR", "RECORD ACTUALIZADO", "RECORD AGGIORNATO")
	if bridge._clear_previous_best_time >= 0.0:
		return bridge._language_text("BEST STANDS", "BESTE ZEIT BLEIBT", "MEILLEUR TEMPS CONSERVE", "MEJOR TIEMPO SE MANTIENE", "MIGLIOR TEMPO INVARIATO")
	return bridge._language_text("FIRST CLEAR", "ERSTER ABSCHLUSS", "PREMIER PARCOURS", "PRIMERA VICTORIA", "PRIMO COMPLETAMENTO")

static func best_text(bridge: Object) -> String:
	if not bridge._run_from_time_attack:
		return ""
	var best_time: float = bridge._get_time_attack_best_time(bridge._get_current_time_attack_record_key())
	if best_time >= 0.0:
		return bridge.get_formatted_time(best_time)
	return bridge._language_text("NO DATA", "KEINE DATEN", "AUCUNE DONNEE", "SIN DATOS", "NESSUN DATO")
