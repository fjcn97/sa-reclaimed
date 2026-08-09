class_name TimeAttackResultsPresenter
extends RefCounted

## Presentation queries for the time-attack results card.

static func progress(bridge: Object) -> float:
	if not bridge.is_time_attack_clear_screen():
		return 0.0
	return clampf(1.0 - (bridge._clear_input_lock_timer / 2.666), 0.0, 1.0)

static func title_text(bridge: Object) -> String:
	return bridge._language_text("TIME ATTACK RESULTS", "TIME ATTACK ERGEBNIS", "RESULTAT TIME ATTACK", "RESULTADOS TIME ATTACK", "RISULTATI TIME ATTACK")

static func time_text(bridge: Object) -> String:
	return bridge.get_formatted_time(bridge._clear_time_snapshot)

static func medal_text(bridge: Object) -> String:
	return bridge.get_clear_time_attack_medal_text()

static func record_text(bridge: Object) -> String:
	return bridge.get_clear_time_attack_record_status_text()

static func prompt_text(bridge: Object) -> String:
	return bridge.get_clear_footer_text()
