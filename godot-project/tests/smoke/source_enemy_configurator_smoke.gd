extends SceneTree

const CONFIGURATOR := preload("res://scripts/core/SourceEnemyConfigurator.gd")
const ENTITY_STATE := preload("res://scripts/core/EntityState.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var fields: Array = ["ENEMY", "0", "0", "0", "0", "2", "1", "10", "6"]
	var buzzer = ENTITY_STATE.new()
	buzzer.world_x = 120.0
	buzzer.world_y = 240.0
	CONFIGURATOR.configure(buzzer, "BUZZER", {"fields": fields})
	_check(buzzer.origin_x == 120.0 and buzzer.origin_y == 240.0, "Configurator anchors imported enemy origins")
	_check(buzzer.velocity_x == 45.0 and buzzer.buzzer_attack_timer == 0.0, "Configurator initializes buzzer motion")
	_check(buzzer.patrol_min_x == 136.0 and buzzer.patrol_max_x == 216.0, "Configurator derives source patrol bounds")

	var balloon = ENTITY_STATE.new()
	balloon.world_x = 300.0
	balloon.world_y = 180.0
	CONFIGURATOR.configure(balloon, "BALLOON", {"fields": fields})
	_check(balloon.velocity_x == 30.0 and balloon.state_timer == 2.0, "Configurator initializes balloon timing")
	_check(balloon.balloon_amplitude_x == 40.0 and balloon.balloon_amplitude_y == 24.0, "Configurator imports balloon amplitudes")

	var kiki = ENTITY_STATE.new()
	kiki.world_x = 500.0
	kiki.world_y = 200.0
	CONFIGURATOR.configure(kiki, "KIKI", {"fields": []})
	_check(kiki.kiki_vertical_min == 152.0 and kiki.kiki_vertical_max == 248.0, "Configurator initializes Kiki movement bounds")

	print("SOURCE_ENEMY_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("SOURCE_ENEMY_FAIL: " + label)
