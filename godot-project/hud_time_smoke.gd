extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge._unlocked_level_index = 1
	bridge._selected_level_index = 0
	bridge.init_level(0, false, false)
	bridge._time_limit_enabled = false
	bridge._elapsed_time = 700.0
	_check(bridge.get_hud_time_text() == "9'59\"99", "hud timer clamps at source display maximum")
	_check(not bridge.is_hud_timer_warning(), "disabled limit does not warn")
	bridge._time_limit_enabled = true
	bridge._elapsed_time = 580.0
	_check(bridge.is_hud_timer_warning(), "timer warning starts at source threshold")
	bridge._language_index = 2
	bridge._player_state.shielded = true
	_check(bridge.get_hud_powerup_text() == "SCHILD", "hud powerup follows localization")
	_check(bridge.is_hud_shield_active(), "hud shield state is semantic")
	_check(bridge.get_hud_special_ring_text() == "SPEZIALRINGE  0/7", "special ring label follows localization")
	_check(bridge.get_hud_race_start_text() == "LOS!", "race start follows localization")
	_check(bridge.get_hud_titles()["score"] == "PUNKTE", "hud titles follow localization")
	bridge._status_text = "READY!"
	_check(bridge.get_status_text() == "BEREIT!", "gameplay status follows localization")
	bridge._status_text = "PLAYER DATA"
	_check(bridge.get_status_text() == "SPIELERDATEN", "menu status follows localization")
	bridge._status_text = "TO BE CONTINUED"
	_check(bridge.get_status_text() == "FORTSETZUNG FOLGT", "presentation status follows localization")
	bridge._status_text = "CONFIRM RESET? A YES, B NO"
	_check(bridge.get_status_text() == "RESET BESTAETIGEN? ENTER JA X NEIN", "confirmation status follows localization")
	bridge._status_text = "PLAYER LAYER: BACK"
	_check(bridge.get_status_text() == "SPIELEREBENE: HINTEN", "dynamic gameplay status follows localization")
	print("HUD_TIME_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("HUD_TIME_FAILED %s" % label)
