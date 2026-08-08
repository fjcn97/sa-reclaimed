extends SceneTree

const BRIDGE := preload("res://scripts/CoreBridge.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = BRIDGE.new()
	get_root().add_child(bridge)
	var profile_indices := [0, 2, 4, 6, 8, 10, 12, 14, 15]
	var expected_health := [8, 4, 8, 8, 8, 8, 8, 6, 12]
	for i in range(profile_indices.size()):
		bridge._selected_level_index = profile_indices[i]
		bridge._level_state.entities.clear()
		var boss = bridge._add_boss(bridge._level_state, 320.0, 300.0)
		_check(boss.boss_profile == i, "profile %d selects the source boss dispatch" % i)
		_check(boss.health == expected_health[i], "profile %d keeps source health" % i)

	bridge._selected_level_index = 2
	bridge._level_state.entities.clear()
	var bomber = bridge._add_boss(bridge._level_state, 320.0, 300.0)
	bomber.state_timer = 0.0
	bridge._update_enemy_motion(0.1)
	_check(bridge._level_state.entities.size() == 2, "bomber tank dispatch spawns its bomb")
	var bomb = bridge._level_state.entities[1]
	_check(bomb.type == bridge.ENTITY_PROJECTILE and bomb.enemy_profile == 5, "bomber bomb keeps its source projectile profile")

	bridge._level_state.entities.clear()
	var saucer = bridge._add_entity(bridge._level_state, bridge.ENTITY_BOSS, 320.0, 300.0)
	saucer.boss_profile = 4
	saucer.world_x = 320.0
	saucer.world_y = 300.0
	saucer.variant = 1
	saucer.effect_offset = 0.0
	bridge._player_state.world_x = 320.0
	bridge._player_state.world_y = 350.0
	_check(not bridge._saucer_beam_hits_player(saucer), "saucer beam rejects an off-axis player")
	saucer.effect_offset = 0.0
	bridge._player_state.world_x = 320.0 + 100.0
	bridge._player_state.world_y = 300.0 - 18.0 + 20.0
	_check(bridge._saucer_beam_hits_player(saucer), "saucer beam catches an aligned player")

	print("BOSS_BEHAVIOR_CHECKS=%d" % checks)
	bridge.queue_free()
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("BOSS_BEHAVIOR_FAIL: " + label)
