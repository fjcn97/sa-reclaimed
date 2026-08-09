class_name PlayerVisualPresenter
extends RefCounted

static func should_show(bridge: Object) -> bool:
	return not bridge.is_title_screen() and not bridge.is_save_options() and not bridge.is_clear_screen() and not bridge.is_intro_screen() and not bridge.is_final_intro_screen() and not bridge.is_chaos_emeralds_screen() and not bridge.is_missing_emeralds_screen() and not bridge.is_to_be_continued_screen() and not bridge.is_sega_logo_screen() and not bridge.is_sonic_team_logo_screen() and not bridge.is_credits_screen() and not bridge.is_copyright_screen() and not bridge.is_credits_end_screen() and not bridge.is_character_unlock_screen() and not bridge.is_special_stage_screen()

static func palette() -> Array:
	return [
		Color(0.20, 0.72, 1.0, 1.0),
		Color(0.99, 0.78, 0.32, 1.0),
		Color(0.98, 0.70, 0.18, 1.0),
		Color(0.88, 0.18, 0.18, 1.0),
		Color(0.96, 0.48, 0.64, 1.0),
	]

static func color(bridge: Object, variant: int, cleared: bool = false) -> Color:
	if cleared:
		return Color(0.96, 0.86, 0.24, 1.0)
	if bridge._player_state.super_sonic:
		return Color(1.0, 0.86, 0.18, 1.0)
	var colors := palette()
	return colors[clampi(variant, 0, colors.size() - 1)]
