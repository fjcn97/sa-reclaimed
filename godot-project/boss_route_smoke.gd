extends SceneTree

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	var checked := 0
	for zone_index in range(7):
		# Match the original boss time-attack route instead of calling init_level in zone mode.
		bridge.open_time_attack_lobby(true)
		bridge._unlocked_level_index = 14
		bridge._selected_level_index = zone_index * 2
		bridge.init_level(zone_index * 2, true)
		var has_boss := false
		for entity_variant in bridge.get_entities():
			if entity_variant.type == 26:
				has_boss = true
				break
		if not has_boss:
			push_error("BOSS_ROUTE_FAILED zone_%d" % (zone_index + 1))
			quit(1)
			return
		checked += 1
		if zone_index == 0:
			for _step in range(16):
				bridge._update_enemy_motion(0.1)
			var hammer_state_seen := false
			for entity_variant in bridge.get_entities():
				if entity_variant.type == 26 and entity_variant.boss_profile == 0:
					hammer_state_seen = entity_variant.variant != 0 or entity_variant.target_x > 42.0
			if not hammer_state_seen:
				push_error("HAMMER_TANK_FAILED state=%d length=%f" % [0, 0.0])
				quit(1)
				return
			print("HAMMER_TANK_PROFILE=state_cycle")
		if zone_index == 1:
			for _step in range(27):
				bridge._update_enemy_motion(0.1)
			var bomber_shot_seen := false
			for entity_variant in bridge.get_entities():
				if entity_variant.type == 19 and entity_variant.enemy_profile == 5:
					bomber_shot_seen = true
			if not bomber_shot_seen:
				push_error("BOMBER_TANK_FAILED shot=false")
				quit(1)
				return
			print("BOMBER_TANK_PROFILE=cannon_shot")
		if zone_index == 2:
			for _step in range(24):
				bridge._update_enemy_motion(0.1)
			var totem_shot_seen := false
			for entity_variant in bridge.get_entities():
				if entity_variant.type == 19 and entity_variant.enemy_profile == 6:
					totem_shot_seen = true
			if not totem_shot_seen:
				push_error("TOTEM_BOSS_FAILED shot=false")
				quit(1)
				return
			print("TOTEM_BOSS_PROFILE=rotating_shot")
		if zone_index == 4:
			var saucer_beam_seen := false
			for _step in range(38):
				bridge._update_enemy_motion(0.1)
				for entity_variant in bridge.get_entities():
					if entity_variant.type == 26 and entity_variant.boss_profile == 4 and entity_variant.variant == 1:
						saucer_beam_seen = true
			if not saucer_beam_seen:
				push_error("SAUCER_BOSS_FAILED beam=false")
				quit(1)
				return
			print("SAUCER_BOSS_PROFILE=charge_beam")
		if zone_index == 5:
			for _step in range(24):
				bridge._update_enemy_motion(0.1)
			var go_round_shots := 0
			for entity_variant in bridge.get_entities():
				if entity_variant.type == 19 and entity_variant.enemy_profile == 7:
					go_round_shots += 1
			if go_round_shots < 3:
				push_error("GO_ROUND_BOSS_FAILED shots=%d" % go_round_shots)
				quit(1)
				return
			print("GO_ROUND_BOSS_PROFILE=three_shot")
		if zone_index == 6:
			for _step in range(28):
				bridge._update_enemy_motion(0.1)
			var frog_bomb_seen := false
			for entity_variant in bridge.get_entities():
				if entity_variant.type == 19 and entity_variant.enemy_profile == 8:
					frog_bomb_seen = true
			if not frog_bomb_seen:
				push_error("FROG_BOSS_FAILED bomb=false")
				quit(1)
				return
			print("FROG_BOSS_PROFILE=jump_bomb")
		if zone_index == 3:
			var aero_before_x := -1.0
			for entity_variant in bridge.get_entities():
				if entity_variant.type == 26:
					aero_before_x = entity_variant.world_x
					break
			for _step in range(24):
				bridge._update_enemy_motion(0.1)
			var aero_bomb_seen := false
			var aero_moved := false
			for entity_variant in bridge.get_entities():
				if entity_variant.type == 26:
					aero_moved = not is_equal_approx(entity_variant.world_x, aero_before_x)
				if entity_variant.type == 19 and entity_variant.enemy_profile == 4:
					aero_bomb_seen = true
			if not aero_moved or not aero_bomb_seen:
				push_error("AERO_EGG_FAILED moved=%s bomb=%s" % [aero_moved, aero_bomb_seen])
				quit(1)
				return
			print("AERO_EGG_PROFILE=movement+bomb")
	bridge.open_time_attack_lobby(true)
	bridge._unlocked_level_index = 14
	bridge._selected_level_index = 14
	bridge.init_level(14, true)
	var final_boss_seen := false
	for entity_variant in bridge.get_entities():
		if entity_variant.type == 26 and entity_variant.boss_profile == 7:
			final_boss_seen = true
	if not final_boss_seen:
		push_error("SUPER_ROBO_Z_FAILED boss=false")
		quit(1)
		return
	for _step in range(24):
		bridge._update_enemy_motion(0.1)
	var robo_shot_seen := false
	for entity_variant in bridge.get_entities():
		if entity_variant.type == 19 and entity_variant.enemy_profile == 9:
			robo_shot_seen = true
	if not robo_shot_seen:
		push_error("SUPER_ROBO_Z_FAILED shot=false")
		quit(1)
		return
	print("SUPER_ROBO_Z_PROFILE=towers+arms+clouds")
	bridge.open_time_attack_lobby(true)
	bridge._unlocked_level_index = 15
	bridge._selected_level_index = 15
	bridge.init_level(15, true)
	var true_area_boss_seen := false
	for entity_variant in bridge.get_entities():
		if entity_variant.type == 26 and entity_variant.boss_profile == 8:
			true_area_boss_seen = true
	if not true_area_boss_seen:
		push_error("TRUE_AREA_53_FAILED boss=false")
		quit(1)
		return
	for _step in range(22):
		bridge._update_enemy_motion(0.1)
	var true_area_shot_seen := false
	for entity_variant in bridge.get_entities():
		if entity_variant.type == 19 and entity_variant.enemy_profile == 10:
			true_area_shot_seen = true
	if not true_area_shot_seen:
		push_error("TRUE_AREA_53_FAILED shot=false")
		quit(1)
		return
	print("TRUE_AREA_53_PROFILE=segments+volleys")
	print("BOSS_ROUTES_CHECKED=%d" % checked)
	quit(0)
