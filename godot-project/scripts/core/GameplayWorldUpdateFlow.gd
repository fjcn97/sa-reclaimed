class_name GameplayWorldUpdateFlow
extends RefCounted

## Advances the level's non-player entities and surface interactions before
## player movement is resolved for the frame.
static func advance(bridge: Object, held_input: int, frame_input: int, delta: float) -> void:
	bridge.update_enemy_motion(delta)
	bridge.update_flying_spring_motion(delta)
	bridge.update_flying_handle_state(delta)
	bridge.update_slidy_ice_state()
	bridge.update_slowing_snow_state()
	bridge.update_light_bridge_state(delta)
	bridge.update_spike_platform_state()
	bridge.update_turnaround_bar_state(delta)
	bridge.update_keyboard_state(delta)
	bridge.update_pole_state()
	bridge.update_light_globe_state(delta)
	bridge.update_windup_stick_state(delta)
	bridge.update_german_flute_state(delta, held_input)
	bridge.update_small_windmill_state(delta)
	bridge.update_chord_state(delta)
	bridge.update_note_state(delta)
	bridge.update_note_particle_state(delta)
	bridge.update_half_pipe_state(frame_input)
	bridge.update_iron_ball_state(delta)
	bridge.update_crane_state(delta)
	bridge.update_ceiling_slope_state(delta)
	bridge.update_gapped_loop_state(delta)
	bridge.update_funnel_sphere_state(delta)
	bridge.update_music_entry_state(delta)
