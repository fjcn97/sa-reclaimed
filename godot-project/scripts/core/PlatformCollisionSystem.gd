class_name PlatformCollisionSystem
extends RefCounted

static func resolve(level: LevelState, player: PlayerState, previous_world_x: float, previous_world_y: float, velocity_y: float, gravity_inverted: bool, player_layer: int, player_half_width: float, player_half_height: float) -> float:
	var landed := false
	for entity in level.entities:
		if not entity.active or entity.enemy_profile != 7:
			continue
		var player_left: float = player.world_x - player_half_width
		var player_right: float = player.world_x + player_half_width
		var player_top: float = player.world_y - player_half_height
		var player_bottom: float = player.world_y + player_half_height
		var old_top: float = entity.previous_world_y - entity.height * 0.5
		var current_top: float = entity.world_y - entity.height * 0.5
		var current_bottom: float = entity.world_y + entity.height * 0.5
		var overlaps_horizontally: bool = player_right > entity.world_x - entity.width * 0.5 and player_left < entity.world_x + entity.width * 0.5
		if not overlaps_horizontally:
			continue
		if not gravity_inverted:
			if player.is_grounded and absf(player_bottom - old_top) <= 6.0:
				player.world_y += entity.world_y - entity.previous_world_y
			elif velocity_y >= 0.0 and player_bottom >= current_top and previous_world_y + player_half_height <= old_top:
				player.world_y = current_top - player_half_height
				velocity_y = 0.0
				player.speed_y = 0.0
				player.is_grounded = true
				player.char_state = 0
				landed = true
		else:
			if player.is_grounded and absf(player_top - current_bottom) <= 6.0:
				player.world_y += entity.world_y - entity.previous_world_y
			elif velocity_y <= 0.0 and player_top <= current_bottom and previous_world_y - player_half_height >= old_top + entity.height:
				player.world_y = current_bottom + player_half_height
				velocity_y = 0.0
				player.speed_y = 0.0
				player.is_grounded = true
				player.char_state = 0
				landed = true
	for platform in level.platforms:
		if not platform.active:
			continue
		if platform.collision_layer >= 0 and platform.collision_layer != player_layer:
			continue
		var player_left: float = player.world_x - player_half_width
		var player_right: float = player.world_x + player_half_width
		var player_top: float = player.world_y - player_half_height
		var player_bottom: float = player.world_y + player_half_height
		var prev_left: float = previous_world_x - player_half_width
		var prev_right: float = previous_world_x + player_half_width
		var prev_top: float = previous_world_y - player_half_height
		var prev_bottom: float = previous_world_y + player_half_height
		var platform_left: float = platform.x1
		var platform_right: float = platform.x2
		var platform_top: float = platform.top_y
		if platform.sloped and platform_right > platform_left:
			var slope_ratio := clampf((player.world_x - platform_left) / (platform_right - platform_left), 0.0, 1.0)
			platform_top = lerpf(platform.slope_start_y, platform.slope_end_y, slope_ratio)
		var platform_bottom: float = platform_top + platform.thickness
		var overlaps_horizontally: bool = player_right > platform_left and player_left < platform_right
		var overlaps_vertically: bool = player_bottom > platform_top and player_top < platform_bottom

		if not gravity_inverted:
			if velocity_y >= 0.0 and overlaps_horizontally and prev_bottom <= platform_top and player_bottom >= platform_top:
				player.world_y = platform_top - player_half_height
				velocity_y = 0.0
				player.speed_y = 0.0
				player.is_grounded = true
				player.char_state = 0
				_set_surface_rotation(player, platform)
				_start_crumbling_platform(platform)
				if platform.arrow_mode:
					platform.arrow_active = true
				if platform.speeding_mode:
					platform.speeding_active = true
					platform.speeding_player_attached = true
				landed = true
				break

			if velocity_y < 0.0 and overlaps_horizontally and prev_top >= platform_bottom and player_top <= platform_bottom:
				player.world_y = platform_bottom + player_half_height
				velocity_y = 0.0
				player.speed_y = 0.0
		else:
			if velocity_y <= 0.0 and overlaps_horizontally and prev_top >= platform_bottom and player_top <= platform_bottom:
				player.world_y = platform_bottom + player_half_height
				velocity_y = 0.0
				player.speed_y = 0.0
				player.is_grounded = true
				player.char_state = 0
				_set_surface_rotation(player, platform)
				_start_crumbling_platform(platform)
				if platform.arrow_mode:
					platform.arrow_active = true
				if platform.speeding_mode:
					platform.speeding_active = true
					platform.speeding_player_attached = true
				landed = true
				break

			if velocity_y > 0.0 and overlaps_horizontally and prev_bottom <= platform_top and player_bottom >= platform_top:
				player.world_y = platform_top - player_half_height
				velocity_y = 0.0
				player.speed_y = 0.0

		if overlaps_vertically and player.is_grounded:
			if previous_world_x + player_half_width <= platform_left and player_right >= platform_left:
				player.world_x = platform_left - player_half_width
			elif previous_world_x - player_half_width >= platform_right and player_left <= platform_right:
				player.world_x = platform_right + player_half_width

	if not landed and not gravity_inverted and player.world_y >= level.ground_y:
		player.world_y = level.ground_y
		velocity_y = 0.0
		player.speed_y = 0.0
		player.is_grounded = true
		player.char_state = 0
	if not landed and gravity_inverted and player.world_y <= level.min_y + player_half_height:
		player.world_y = level.min_y + player_half_height
		velocity_y = 0.0
		player.speed_y = 0.0
		player.is_grounded = true
		player.char_state = 0
	return velocity_y

static func _start_crumbling_platform(platform: PlatformState) -> void:
	if platform.crumble_delay < 0.0 or platform.crumble_phase != 0:
		return
	platform.crumble_timer = platform.crumble_delay
	platform.crumble_phase = 1

static func _set_surface_rotation(player: PlayerState, platform: PlatformState) -> void:
	if not platform.sloped or platform.x2 <= platform.x1:
		player.rotation = 0
		return
	var angle := rad_to_deg(atan2(platform.slope_end_y - platform.slope_start_y, platform.x2 - platform.x1))
	player.rotation = int(clampf(angle / 5.0, -16.0, 16.0))
