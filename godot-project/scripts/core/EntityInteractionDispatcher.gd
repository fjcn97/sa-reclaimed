class_name EntityInteractionDispatcher
extends RefCounted

const ENTITY_TYPES := preload("res://scripts/core/EntityTypes.gd")

static func dispatch(bridge: Object, level: LevelState, held_input: int, frame_input: int, delta: float) -> void:
	for entity in level.entities:
		if not entity.active:
			continue

		match entity.type:
			ENTITY_TYPES.ENTITY_RING, ENTITY_TYPES.ENTITY_SCATTER_RING:
				_call(bridge, "_try_collect_ring", [entity])
			ENTITY_TYPES.ENTITY_SPECIAL_RING:
				_call(bridge, "_try_collect_special_ring", [entity])
			ENTITY_TYPES.ENTITY_WHIRLWIND:
				_call(bridge, "_try_whirlwind", [entity, delta])
			ENTITY_TYPES.ENTITY_FAN:
				_call(bridge, "_try_fan", [entity, held_input, delta])
			ENTITY_TYPES.ENTITY_PROPELLER:
				_call(bridge, "_try_propeller", [entity, held_input, delta])
			ENTITY_TYPES.ENTITY_BOOSTER:
				_call(bridge, "_try_booster", [entity, delta])
			ENTITY_TYPES.ENTITY_DASH_RING:
				_call(bridge, "_try_dash_ring", [entity, delta])
			ENTITY_TYPES.ENTITY_GRIND_RAIL:
				_call(bridge, "_try_grind_rail", [entity])
			ENTITY_TYPES.ENTITY_GRAVITY_TOGGLE:
				_call(bridge, "_try_gravity_toggle", [entity])
			ENTITY_TYPES.ENTITY_NOTE_BLOCK:
				_call(bridge, "_try_note_block", [entity])
			ENTITY_TYPES.ENTITY_NOTE_SPHERE:
				_call(bridge, "_try_note_sphere", [entity])
			ENTITY_TYPES.ENTITY_BOUNCY_SPRING:
				_call(bridge, "_try_bouncy_spring", [entity, delta])
			ENTITY_TYPES.ENTITY_CONVEYOR:
				_call(bridge, "_try_conveyor", [entity, delta])
			ENTITY_TYPES.ENTITY_LAYER_TOGGLE:
				_call(bridge, "_try_layer_toggle", [entity])
			ENTITY_TYPES.ENTITY_RAMP:
				_call(bridge, "_try_ramp", [entity, frame_input])
			ENTITY_TYPES.ENTITY_ROTATING_HANDLE:
				_call(bridge, "_try_rotating_handle", [entity, held_input, frame_input, delta])
			ENTITY_TYPES.ENTITY_FLYING_HANDLE:
				_call(bridge, "_try_flying_handle", [entity, frame_input])
			ENTITY_TYPES.ENTITY_CORK_SCREW:
				_call(bridge, "_try_corkscrew", [entity, frame_input, delta])
			ENTITY_TYPES.ENTITY_CANNON:
				_call(bridge, "_try_cannon", [entity, held_input, delta])
			ENTITY_TYPES.ENTITY_LAUNCHER:
				_call(bridge, "_try_launcher", [entity, frame_input, delta])
			ENTITY_TYPES.ENTITY_PIPE_START:
				_call(bridge, "_try_pipe_start", [entity, delta])
			ENTITY_TYPES.ENTITY_HOOK_RAIL:
				_call(bridge, "_try_hook_rail", [entity, frame_input, delta])
			ENTITY_TYPES.ENTITY_SPIKES:
				_call(bridge, "_try_spikes", [entity])
			ENTITY_TYPES.ENTITY_SPIKE_PLATFORM:
				_call(bridge, "_try_spike_platform", [entity])
			ENTITY_TYPES.ENTITY_TURNAROUND_BAR:
				_call(bridge, "_try_turnaround_bar", [entity])
			ENTITY_TYPES.ENTITY_KEYBOARD:
				_call(bridge, "_try_keyboard", [entity])
			ENTITY_TYPES.ENTITY_POLE:
				_call(bridge, "_try_pole", [entity, held_input, frame_input])
			ENTITY_TYPES.ENTITY_LIGHT_GLOBE:
				_call(bridge, "_try_light_globe", [entity])
			ENTITY_TYPES.ENTITY_WINDUP_STICK:
				_call(bridge, "_try_windup_stick", [entity, held_input])
			ENTITY_TYPES.ENTITY_GERMAN_FLUTE:
				_call(bridge, "_try_german_flute", [entity])
			ENTITY_TYPES.ENTITY_SMALL_WINDMILL:
				_call(bridge, "_try_small_windmill", [entity])
			ENTITY_TYPES.ENTITY_CHORD:
				_call(bridge, "_try_chord", [entity])
			ENTITY_TYPES.ENTITY_HALF_PIPE:
				_call(bridge, "_try_half_pipe", [entity])
			ENTITY_TYPES.ENTITY_IRON_BALL:
				_call(bridge, "_try_iron_ball", [entity])
			ENTITY_TYPES.ENTITY_CRANE:
				_call(bridge, "_try_crane", [entity])
			ENTITY_TYPES.ENTITY_CEILING_SLOPE:
				_call(bridge, "_try_ceiling_slope", [entity])
			ENTITY_TYPES.ENTITY_GAPPED_LOOP:
				_call(bridge, "_try_gapped_loop", [entity])
			ENTITY_TYPES.ENTITY_FUNNEL_SPHERE:
				_call(bridge, "_try_funnel_sphere", [entity])
			ENTITY_TYPES.ENTITY_MUSIC_ENTRY:
				_call(bridge, "_try_music_entry", [entity])
			ENTITY_TYPES.ENTITY_DAMAGE_REGION:
				_call(bridge, "_try_damage_region", [entity])
			ENTITY_TYPES.ENTITY_ITEM_BOX:
				_call(bridge, "_try_item_box", [entity])
			ENTITY_TYPES.ENTITY_SPRING:
				_call(bridge, "_try_bounce_from_spring", [entity, delta])
			ENTITY_TYPES.ENTITY_ENEMY, ENTITY_TYPES.ENTITY_BUZZER:
				_call(bridge, "_try_hit_enemy", [entity])
			ENTITY_TYPES.ENTITY_BALLOON:
				_call(bridge, "_try_hit_enemy", [entity])
			ENTITY_TYPES.ENTITY_BULLET_BUZZER:
				_call(bridge, "_try_hit_enemy", [entity])
			ENTITY_TYPES.ENTITY_KOURA:
				_call(bridge, "_try_koura", [entity])
			ENTITY_TYPES.ENTITY_STAR:
				_call(bridge, "_try_star", [entity])
			ENTITY_TYPES.ENTITY_KIKI:
				_call(bridge, "_try_hit_enemy", [entity])
			ENTITY_TYPES.ENTITY_KIKI_PROJECTILE, ENTITY_TYPES.ENTITY_KIKI_PIECE:
				_call(bridge, "_try_projectile", [entity])
			ENTITY_TYPES.ENTITY_BOSS:
				_call(bridge, "_try_boss", [entity])
			ENTITY_TYPES.ENTITY_PROJECTILE:
				_call(bridge, "_try_projectile", [entity])
			ENTITY_TYPES.ENTITY_CHECKPOINT:
				_call(bridge, "_try_activate_checkpoint", [entity])
			ENTITY_TYPES.ENTITY_GOAL:
				_call(bridge, "_try_reach_goal", [entity])
			ENTITY_TYPES.ENTITY_LAP_TRIGGER:
				_call(bridge, "_try_lap_trigger", [entity])
			ENTITY_TYPES.ENTITY_GOAL_LEVER:
				_call(bridge, "_try_goal_lever", [entity])

static func _call(bridge: Object, method_name: String, arguments: Array) -> void:
	bridge.callv(method_name, arguments)

