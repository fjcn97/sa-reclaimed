class_name GameOverPresenter
extends RefCounted

## Presentation state for the automatic Game Over sequence.

static func title_text(bridge: Object) -> String:
	return bridge.language_text("TIME OVER", "ZEIT ABGELAUFEN", "TEMPS ECOULE", "TIEMPO AGOTADO", "TEMPO SCADUTO") if bridge.get_game_over_state().time_over else bridge.language_text("GAME OVER", "GAME OVER", "GAME OVER", "FIN DE LA PARTIDA", "GAME OVER")

static func primary_word(bridge: Object) -> String:
	return bridge.language_text("TIME", "ZEIT", "TEMPS", "TIEMPO", "TEMPO") if bridge.get_game_over_state().time_over else bridge.language_text("GAME", "SPIEL", "JEU", "PARTIDA", "GIOCO")

static func secondary_word(bridge: Object) -> String:
	return bridge.language_text("OVER", "VORBEI", "TERMINE", "FIN", "FINE")

static func badge_text(bridge: Object) -> String:
	return bridge.language_text("TIME", "ZEIT", "TEMPS", "TIEMPO", "TEMPO") if bridge.get_game_over_state().time_over else bridge.language_text("OVER", "VORBEI", "TERMINE", "FIN", "FINE")

static func prompt_text(bridge: Object) -> String:
	if bridge.get_game_over_state().time_over:
		if bridge.get_run_mode_state().from_time_attack:
			return bridge.language_text("RETRY THE ATTACK", "ANGRIFF WIEDERHOLEN", "REESSAYER L'ATTAQUE", "REPETIR EL ATAQUE", "RIPROVA L'ATTACCO")
		return bridge.language_text("TIME LIMIT REACHED", "ZEITLIMIT ERREICHT", "LIMITE DE TEMPS ATTEINTE", "LIMITE DE TIEMPO ALCANZADO", "LIMITE DI TEMPO RAGGIUNTO")
	return bridge.language_text("ALL LIVES LOST", "ALLE LEBEN VERLOREN", "TOUTES LES VIES PERDUES", "TODAS LAS VIDAS PERDIDAS", "TUTTE LE VITE PERSE")

static func status_text(bridge: Object) -> String:
	if bridge.get_game_over_state().input_lock_timer > 0.0:
		return ""
	if bridge.get_run_mode_state().from_time_attack and bridge.get_game_over_state().time_over:
		return bridge.language_text("TIME ATTACK STANDBY", "TIME ATTACK BEREIT", "TIME ATTACK EN ATTENTE", "TIME ATTACK EN ESPERA", "TIME ATTACK IN ATTESA")
	return bridge.language_text("RESTARTING STAGE", "SPIELSTUFE WIRD NEUGESTARTET", "REDEMARRAGE DU STAGE", "REINICIANDO LA FASE", "RIAVVIO DELLO STAGE") if bridge.get_game_over_state().time_over else bridge.language_text("RETURNING TO TITLE", "ZURUECK ZUM TITEL", "RETOUR AU TITRE", "VOLVIENDO AL TITULO", "RITORNO AL TITOLO")

static func progress(bridge: Object) -> float:
	return bridge.get_game_over_state().progress()

static func slide_offset(bridge: Object) -> float:
	var current_progress := progress(bridge)
	if bridge.get_game_over_state().time_over:
		if current_progress < 0.38:
			return lerpf(420.0, 0.0, current_progress / 0.38)
		if current_progress < 0.72:
			return 0.0
		return lerpf(0.0, -280.0, (current_progress - 0.72) / 0.28)
	if current_progress < 0.46:
		return lerpf(520.0, 0.0, current_progress / 0.46)
	return 0.0

static func text_flash_alpha(bridge: Object) -> float:
	if bridge.get_game_over_state().input_lock_timer > 0.0:
		return 0.84 + sin(progress(bridge) * 28.0) * 0.16
	return 1.0
