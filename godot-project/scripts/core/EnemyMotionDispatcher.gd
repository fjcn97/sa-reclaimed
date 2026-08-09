class_name EnemyMotionDispatcher
extends RefCounted

const ENTITY_TYPES := preload("res://scripts/core/EntityTypes.gd")
const BOSS_MOTION_SYSTEM := preload("res://scripts/core/BossMotionSystem.gd")

static func update(bridge: Object, level: LevelState, delta: float) -> void:
	for entity in level.entities:
		if (entity.type != ENTITY_TYPES.ENTITY_ENEMY and entity.type != ENTITY_TYPES.ENTITY_BUZZER and entity.type != ENTITY_TYPES.ENTITY_BALLOON and entity.type != ENTITY_TYPES.ENTITY_PROJECTILE and entity.type != ENTITY_TYPES.ENTITY_BULLET_BUZZER and entity.type != ENTITY_TYPES.ENTITY_KOURA and entity.type != ENTITY_TYPES.ENTITY_STAR and entity.type != ENTITY_TYPES.ENTITY_KIKI and entity.type != ENTITY_TYPES.ENTITY_KIKI_PROJECTILE and entity.type != ENTITY_TYPES.ENTITY_KIKI_PIECE and entity.type != ENTITY_TYPES.ENTITY_BOSS and entity.type != ENTITY_TYPES.ENTITY_ITEM_BOX and entity.type != ENTITY_TYPES.ENTITY_SPECIAL_RING and entity.type != ENTITY_TYPES.ENTITY_SCATTER_RING and entity.type != ENTITY_TYPES.ENTITY_TRAPPED_ANIMAL and entity.type != ENTITY_TYPES.ENTITY_RING_EFFECT and entity.type != ENTITY_TYPES.ENTITY_HEART_EFFECT and entity.type != ENTITY_TYPES.ENTITY_DUST_EFFECT and entity.type != ENTITY_TYPES.ENTITY_GRIND_EFFECT and entity.type != ENTITY_TYPES.ENTITY_CHEESE and entity.type != ENTITY_TYPES.ENTITY_TAIL_SWIPE and entity.type != ENTITY_TYPES.ENTITY_KNUCKLES_FIRE and entity.type != ENTITY_TYPES.ENTITY_SONIC_SKID and entity.type != ENTITY_TYPES.ENTITY_FAN) or not entity.active:
			continue
		if entity.type == ENTITY_TYPES.ENTITY_TRAPPED_ANIMAL:
			_call(bridge, "_update_trapped_animal_motion", [entity, delta])
			continue
		if entity.type == ENTITY_TYPES.ENTITY_RING_EFFECT:
			_call(bridge, "_update_ring_effect_motion", [entity, delta])
			continue
		if entity.type == ENTITY_TYPES.ENTITY_HEART_EFFECT:
			_call(bridge, "_update_heart_effect_motion", [entity, delta])
			continue
		if entity.type == ENTITY_TYPES.ENTITY_DUST_EFFECT:
			_call(bridge, "_update_dust_effect_motion", [entity, delta])
			continue
		if entity.type == ENTITY_TYPES.ENTITY_GRIND_EFFECT:
			_call(bridge, "_update_grind_effect_motion", [entity, delta])
			continue
		if entity.type == ENTITY_TYPES.ENTITY_CHEESE:
			_call(bridge, "_update_cheese_motion", [entity, delta])
			continue
		if entity.type == ENTITY_TYPES.ENTITY_TAIL_SWIPE or entity.type == ENTITY_TYPES.ENTITY_KNUCKLES_FIRE or entity.type == ENTITY_TYPES.ENTITY_SONIC_SKID:
			_call(bridge, "_update_character_attack_effect", [entity, delta])
			continue
		if entity.type == ENTITY_TYPES.ENTITY_ITEM_BOX:
			_call(bridge, "_update_item_box_effect", [entity, delta])
			continue
		if entity.type == ENTITY_TYPES.ENTITY_SPECIAL_RING:
			_call(bridge, "_update_special_ring_motion", [entity, delta])
			continue
		if entity.type == ENTITY_TYPES.ENTITY_FAN and entity.variant == 1:
			entity.state_timer = fmod(entity.state_timer + delta * 60.0, 420.0)
			var periodic_frame: float = entity.state_timer
			if periodic_frame < 60.0:
				entity.fan_speed = 0.0
			elif periodic_frame < 120.0:
				entity.fan_speed = (periodic_frame - 60.0) / 60.0
			elif periodic_frame < 360.0:
				entity.fan_speed = 1.0
			else:
				entity.fan_speed = (420.0 - periodic_frame) / 60.0
			continue
		if entity.type == ENTITY_TYPES.ENTITY_SCATTER_RING:
			_call(bridge, "_update_scattered_ring", [entity, delta])
			continue
		if entity.type == ENTITY_TYPES.ENTITY_BUZZER:
			_call(bridge, "_update_buzzer_motion", [entity, delta])
			continue
		if entity.type == ENTITY_TYPES.ENTITY_BALLOON:
			_call(bridge, "_update_balloon_motion", [entity, delta])
			continue
		if entity.type == ENTITY_TYPES.ENTITY_PROJECTILE:
			if entity.enemy_profile == 4 or entity.enemy_profile == 5 or entity.enemy_profile == 8:
				entity.velocity_y += 280.0 * delta
			if entity.enemy_profile == 11 or entity.enemy_profile == 14 or entity.enemy_profile == 17:
				entity.state_timer -= delta
				if entity.state_timer <= 0.0:
					entity.active = false
					continue
			entity.world_x += entity.velocity_x * delta
			entity.world_y += entity.velocity_y * delta
			if entity.world_y < level.min_y - 80.0 or entity.world_y > level.max_y + 80.0 or entity.world_x < level.min_x - 80.0 or entity.world_x > level.max_x + 80.0:
				entity.active = false
			continue
		if entity.type == ENTITY_TYPES.ENTITY_BULLET_BUZZER:
			_call(bridge, "_update_bullet_buzzer_motion", [entity, delta])
			continue
		if entity.type == ENTITY_TYPES.ENTITY_KOURA:
			_call(bridge, "_update_koura_motion", [entity, delta])
			continue
		if entity.type == ENTITY_TYPES.ENTITY_STAR:
			_call(bridge, "_update_star_motion", [entity, delta])
			continue
		if entity.type == ENTITY_TYPES.ENTITY_KIKI:
			_call(bridge, "_update_kiki_motion", [entity, delta])
			continue
		if entity.enemy_profile == 1:
			_call(bridge, "_update_pen_motion", [entity, delta])
			continue
		if entity.enemy_profile == 2:
			_call(bridge, "_update_bell_motion", [entity, delta])
			continue
		if entity.enemy_profile == 3:
			_call(bridge, "_update_mouse_motion", [entity, delta])
			continue
		if entity.enemy_profile == 4:
			_call(bridge, "_update_circus_motion", [entity, delta])
			continue
		if entity.enemy_profile == 5:
			_call(bridge, "_update_yado_motion", [entity, delta])
			continue
		if entity.enemy_profile == 6:
			_call(bridge, "_update_gohla_motion", [entity, delta])
			continue
		if entity.enemy_profile == 7:
			_call(bridge, "_update_hammerhead_motion", [entity, delta])
			continue
		if entity.enemy_profile == 8:
			_call(bridge, "_update_kura_kura_motion", [entity, delta])
			continue
		if entity.enemy_profile == 10:
			_call(bridge, "_update_gejigeji_motion", [entity, delta])
			continue
		if entity.enemy_profile == 11:
			_call(bridge, "_update_kubinaga_motion", [entity, delta])
			continue
		if entity.enemy_profile == 12:
			_call(bridge, "_update_madillo_motion", [entity, delta])
			continue
		if entity.enemy_profile == 13:
			entity.state_timer = fmod(entity.state_timer + delta * 4.0, TAU)
			continue
		if entity.enemy_profile == 14:
			_call(bridge, "_update_kyura_motion", [entity, delta])
			continue
		if entity.enemy_profile == 15:
			_call(bridge, "_update_flickey_motion", [entity, delta])
			continue
		if entity.enemy_profile == 16:
			_call(bridge, "_update_mon_motion", [entity, delta])
			continue
		if entity.enemy_profile == 18:
			_call(bridge, "_update_pikopiko_motion", [entity, delta])
			continue
		if entity.enemy_profile == 9:
			_call(bridge, "_update_straw_motion", [entity, delta])
			continue
		if entity.type == ENTITY_TYPES.ENTITY_KIKI_PROJECTILE:
			_call(bridge, "_update_kiki_projectile", [entity, delta])
			continue
		if entity.type == ENTITY_TYPES.ENTITY_KIKI_PIECE:
			_call(bridge, "_update_kiki_piece", [entity, delta])
			continue
		if entity.type == ENTITY_TYPES.ENTITY_BOSS:
			var player := bridge.call("get_player_state") as PlayerState
			var elapsed := float(bridge.get("_elapsed_time"))
			BOSS_MOTION_SYSTEM.update(bridge, level, player, elapsed, entity, delta)
			continue
		entity.world_x += entity.velocity_x * delta
		if entity.world_x <= entity.patrol_min_x:
			entity.world_x = entity.patrol_min_x
			entity.velocity_x = abs(entity.velocity_x)
		if entity.world_x >= entity.patrol_max_x:
			entity.world_x = entity.patrol_max_x
			entity.velocity_x = -abs(entity.velocity_x)

static func _call(bridge: Object, method_name: String, arguments: Array) -> void:
	bridge.callv(method_name, arguments)
