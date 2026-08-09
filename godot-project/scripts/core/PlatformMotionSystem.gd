class_name PlatformMotionSystem
extends RefCounted

static func update(level: LevelState, player: PlayerState, delta: float, player_half_width: float, player_half_height: float, gravity_inverted: bool, velocity_y: float) -> float:
	for platform in level.platforms:
		if not platform.active:
			continue
		if platform.speeding_mode:
			if platform.speeding_wait_timer > 0.0:
				platform.speeding_wait_timer = maxf(0.0, platform.speeding_wait_timer - delta)
				continue
			if platform.speeding_returning:
				platform.x1 = move_toward(platform.x1, platform.speeding_base_x, 60.0 * delta)
				platform.x2 = platform.x1 + 54.0
				platform.top_y = move_toward(platform.top_y, platform.speeding_base_y, 60.0 * delta)
				platform.bottom_y = platform.top_y + platform.thickness
				if is_equal_approx(platform.x1, platform.speeding_base_x) and is_equal_approx(platform.top_y, platform.speeding_base_y):
					platform.speeding_returning = false
					platform.speeding_phase = 0
					platform.speeding_target_x = platform.speeding_first_x
					platform.speeding_target_y = platform.speeding_first_y
				continue
			if not platform.speeding_active:
				continue
			var old_speeding_x: float = platform.x1
			var old_speeding_y: float = platform.top_y
			platform.x1 = move_toward(platform.x1, platform.speeding_target_x - 27.0, 120.0 * delta)
			platform.x2 = platform.x1 + 54.0
			platform.top_y = move_toward(platform.top_y, platform.speeding_target_y, 120.0 * delta)
			platform.bottom_y = platform.top_y + platform.thickness
			if platform.speeding_player_attached:
				player.world_x += platform.x1 - old_speeding_x
				player.world_y += platform.top_y - old_speeding_y
			if is_equal_approx(platform.x1, platform.speeding_target_x - 27.0) and is_equal_approx(platform.top_y, platform.speeding_target_y):
				if platform.speeding_phase == 0:
					platform.speeding_phase = 1
					platform.speeding_target_x = platform.speeding_final_x
					platform.speeding_target_y = platform.speeding_final_y
				else:
					if platform.speeding_player_attached:
						player.speed_x = 90.0
						velocity_y = -18.0
						player.speed_y = velocity_y
						player.is_grounded = false
					platform.speeding_player_attached = false
					platform.speeding_active = false
					platform.speeding_wait_timer = 1.0
					platform.speeding_returning = true
			continue
		if platform.arrow_mode:
			if not platform.arrow_active:
				continue
			var old_x1: float = platform.x1
			platform.x1 = move_toward(platform.x1, platform.arrow_target_x, platform.arrow_speed * delta)
			platform.x2 += platform.x1 - old_x1
			platform.top_y = move_toward(platform.top_y, platform.arrow_target_y, platform.arrow_speed * delta)
			platform.bottom_y = platform.top_y + platform.thickness
			if is_equal_approx(platform.x1, platform.arrow_target_x) and is_equal_approx(platform.top_y, platform.arrow_target_y):
				platform.arrow_active = false
			continue
		if platform.crumble_timer >= 0.0:
			if platform.crumble_phase == 1:
				platform.crumble_timer = maxf(0.0, platform.crumble_timer - delta)
				if platform.crumble_timer <= 0.0:
					platform.crumble_phase = 2
					platform.crumble_break_timer = 32.0 / 60.0
			elif platform.crumble_phase == 2:
				platform.crumble_break_timer = maxf(0.0, platform.crumble_break_timer - delta)
				if platform.crumble_break_timer <= 0.0:
					platform.crumble_phase = 3
					platform.active = false
					continue
		if not platform.moving:
			continue
		var old_x1: float = platform.x1
		var old_top_y: float = platform.top_y
		platform.motion_phase += platform.motion_speed * delta
		var offset: float = sin(platform.motion_phase) * platform.motion_amplitude
		if platform.motion_axis == 0:
			platform.x1 = old_x1 + (offset - sin(platform.motion_phase - platform.motion_speed * delta) * platform.motion_amplitude)
			platform.x2 = platform.x2 + (platform.x1 - old_x1)
		else:
			platform.top_y = old_top_y + (offset - sin(platform.motion_phase - platform.motion_speed * delta) * platform.motion_amplitude)
			platform.bottom_y = platform.top_y + platform.thickness
		var delta_x: float = platform.x1 - old_x1
		var delta_y: float = platform.top_y - old_top_y
		var player_bottom: float = player.world_y + player_half_height
		var player_top: float = player.world_y - player_half_height
		var was_over: bool = player.world_x + player_half_width > old_x1 and player.world_x - player_half_width < platform.x2 - delta_x
		var was_standing: bool = (not gravity_inverted and absf(player_bottom - old_top_y) <= 6.0) or (gravity_inverted and absf(player_top - (old_top_y + platform.thickness)) <= 6.0)
		if player.is_grounded and was_over and was_standing:
			player.world_x += delta_x
			player.world_y += delta_y
	return velocity_y
