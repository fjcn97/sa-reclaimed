extends SceneTree

const BRIDGE := preload("res://scripts/CoreBridge.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = BRIDGE.new()
	get_root().add_child(bridge)
	bridge._unlocked_level_index = 15
	var requested_mode := -1
	var requested_level := -1
	var args := OS.get_cmdline_user_args()
	if args.size() >= 1:
		requested_mode = int(args[0])
	if args.size() >= 2:
		requested_level = int(args[1])
	for boss_mode in [false, true]:
		if requested_mode >= 0 and int(boss_mode) != requested_mode:
			continue
		bridge._time_attack_boss_mode = boss_mode
		for level_id in range(16 if not boss_mode else 7):
			if requested_level >= 0 and level_id != requested_level:
				continue
			bridge.init_level(level_id, boss_mode, false)
			var manifest: Dictionary = bridge.get_source_map_manifest()
			var entities: Array = bridge.get_entities()
			_check(bool(manifest.get("valid", false)), "source manifest loads for %s course %d" % ["boss" if boss_mode else "zone", level_id])
			_check(not entities.is_empty(), "runtime entity list is populated for %s course %d" % ["boss" if boss_mode else "zone", level_id])
			bridge._update_enemy_motion(1.0 / 60.0)
			var active_count := 0
			for entity in entities:
				if entity.active:
					active_count += 1
			_check(active_count > 0, "runtime update retains active entities for %s course %d" % ["boss" if boss_mode else "zone", level_id])
		print("RUNTIME_SOURCE_CHECKS=%d" % checks)
	bridge.queue_free()
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("RUNTIME_SOURCE_FAIL: " + label)
