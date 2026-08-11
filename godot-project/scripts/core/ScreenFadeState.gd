class_name ScreenFadeState
extends RefCounted

## Owns screen-wide fade interpolation independently of scene presentation.
var alpha: float = 0.0
var last_state: int = -1
var last_phase: int = -1
var speed: float = 3.6

func reset() -> void:
	alpha = 0.0
	last_state = -1
	last_phase = -1

func advance(delta: float, game_state: int, title_phase: int, suppress_fade: bool, is_title: bool, is_paused: bool) -> void:
	if suppress_fade:
		alpha = 0.0
		last_state = game_state
		last_phase = title_phase
		return
	var state_changed := last_state != game_state
	var phase_changed := is_title and last_phase != title_phase
	if last_state >= 0 and (state_changed or phase_changed) and not is_paused:
		alpha = 1.0
	last_state = game_state
	last_phase = title_phase
	alpha = maxf(0.0, alpha - delta * speed)

func opacity() -> float:
	return clampf(alpha, 0.0, 1.0)
