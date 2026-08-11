class_name EntityInteractionDispatcher
extends RefCounted

const ENTITY_TYPES := preload("res://scripts/core/EntityTypes.gd")

static func dispatch(bridge: Object, level: LevelState, held_input: int, frame_input: int, delta: float) -> void:
	for entity in level.entities:
		if not entity.active:
			continue

		match entity.type:
			ENTITY_TYPES.ENTITY_RING, ENTITY_TYPES.ENTITY_SCATTER_RING:
				bridge.try_collect_ring(entity)
			ENTITY_TYPES.ENTITY_SPECIAL_RING:
				bridge.try_collect_special_ring(entity)
			ENTITY_TYPES.ENTITY_WHIRLWIND:
				bridge.try_whirlwind(entity, delta)
			ENTITY_TYPES.ENTITY_FAN:
				bridge.try_fan(entity, held_input, delta)
			ENTITY_TYPES.ENTITY_PROPELLER:
				bridge.try_propeller(entity, held_input, delta)
			ENTITY_TYPES.ENTITY_BOOSTER:
				bridge.try_booster(entity, delta)
			ENTITY_TYPES.ENTITY_DASH_RING:
				bridge.try_dash_ring(entity, delta)
			ENTITY_TYPES.ENTITY_GRIND_RAIL:
				bridge.try_grind_rail(entity)
			ENTITY_TYPES.ENTITY_GRAVITY_TOGGLE:
				bridge.try_gravity_toggle(entity)
			ENTITY_TYPES.ENTITY_NOTE_BLOCK:
				bridge.try_note_block(entity)
			ENTITY_TYPES.ENTITY_NOTE_SPHERE:
				bridge.try_note_sphere(entity)
			ENTITY_TYPES.ENTITY_BOUNCY_SPRING:
				bridge.try_bouncy_spring(entity, delta)
			ENTITY_TYPES.ENTITY_CONVEYOR:
				bridge.try_conveyor(entity, delta)
			ENTITY_TYPES.ENTITY_LAYER_TOGGLE:
				bridge.try_layer_toggle(entity)
			ENTITY_TYPES.ENTITY_RAMP:
				bridge.try_ramp(entity, frame_input)
			ENTITY_TYPES.ENTITY_ROTATING_HANDLE:
				bridge.try_rotating_handle(entity, held_input, frame_input, delta)
			ENTITY_TYPES.ENTITY_FLYING_HANDLE:
				bridge.try_flying_handle(entity, frame_input)
			ENTITY_TYPES.ENTITY_CORK_SCREW:
				bridge.try_corkscrew(entity, frame_input, delta)
			ENTITY_TYPES.ENTITY_CANNON:
				bridge.try_cannon(entity, held_input, delta)
			ENTITY_TYPES.ENTITY_LAUNCHER:
				bridge.try_launcher(entity, frame_input, delta)
			ENTITY_TYPES.ENTITY_PIPE_START:
				bridge.try_pipe_start(entity, delta)
			ENTITY_TYPES.ENTITY_HOOK_RAIL:
				bridge.try_hook_rail(entity, frame_input, delta)
			ENTITY_TYPES.ENTITY_SPIKES:
				bridge.try_spikes(entity)
			ENTITY_TYPES.ENTITY_SPIKE_PLATFORM:
				bridge.try_spike_platform(entity)
			ENTITY_TYPES.ENTITY_TURNAROUND_BAR:
				bridge.try_turnaround_bar(entity)
			ENTITY_TYPES.ENTITY_KEYBOARD:
				bridge.try_keyboard(entity)
			ENTITY_TYPES.ENTITY_POLE:
				bridge.try_pole(entity, held_input, frame_input)
			ENTITY_TYPES.ENTITY_LIGHT_GLOBE:
				bridge.try_light_globe(entity)
			ENTITY_TYPES.ENTITY_WINDUP_STICK:
				bridge.try_windup_stick(entity, held_input)
			ENTITY_TYPES.ENTITY_GERMAN_FLUTE:
				bridge.try_german_flute(entity)
			ENTITY_TYPES.ENTITY_SMALL_WINDMILL:
				bridge.try_small_windmill(entity)
			ENTITY_TYPES.ENTITY_CHORD:
				bridge.try_chord(entity)
			ENTITY_TYPES.ENTITY_HALF_PIPE:
				bridge.try_half_pipe(entity)
			ENTITY_TYPES.ENTITY_IRON_BALL:
				bridge.try_iron_ball(entity)
			ENTITY_TYPES.ENTITY_CRANE:
				bridge.try_crane(entity)
			ENTITY_TYPES.ENTITY_CEILING_SLOPE:
				bridge.try_ceiling_slope(entity)
			ENTITY_TYPES.ENTITY_GAPPED_LOOP:
				bridge.try_gapped_loop(entity)
			ENTITY_TYPES.ENTITY_FUNNEL_SPHERE:
				bridge.try_funnel_sphere(entity)
			ENTITY_TYPES.ENTITY_MUSIC_ENTRY:
				bridge.try_music_entry(entity)
			ENTITY_TYPES.ENTITY_DAMAGE_REGION:
				bridge.try_damage_region(entity)
			ENTITY_TYPES.ENTITY_ITEM_BOX:
				bridge.try_item_box(entity)
			ENTITY_TYPES.ENTITY_SPRING:
				bridge.try_bounce_from_spring(entity, delta)
			ENTITY_TYPES.ENTITY_ENEMY, ENTITY_TYPES.ENTITY_BUZZER:
				bridge.try_hit_enemy(entity)
			ENTITY_TYPES.ENTITY_BALLOON:
				bridge.try_hit_enemy(entity)
			ENTITY_TYPES.ENTITY_BULLET_BUZZER:
				bridge.try_hit_enemy(entity)
			ENTITY_TYPES.ENTITY_KOURA:
				bridge.try_koura(entity)
			ENTITY_TYPES.ENTITY_STAR:
				bridge.try_star(entity)
			ENTITY_TYPES.ENTITY_KIKI:
				bridge.try_hit_enemy(entity)
			ENTITY_TYPES.ENTITY_KIKI_PROJECTILE, ENTITY_TYPES.ENTITY_KIKI_PIECE:
				bridge.try_projectile(entity)
			ENTITY_TYPES.ENTITY_BOSS:
				bridge.try_boss(entity)
			ENTITY_TYPES.ENTITY_PROJECTILE:
				bridge.try_projectile(entity)
			ENTITY_TYPES.ENTITY_CHECKPOINT:
				bridge.try_activate_checkpoint(entity)
			ENTITY_TYPES.ENTITY_GOAL:
				bridge.try_reach_goal(entity)
			ENTITY_TYPES.ENTITY_LAP_TRIGGER:
				bridge.try_lap_trigger(entity)
			ENTITY_TYPES.ENTITY_GOAL_LEVER:
				bridge.try_goal_lever(entity)
