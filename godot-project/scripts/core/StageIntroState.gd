class_name StageIntroState
extends RefCounted

## Owns stage-entry countdown, final-intro, and start-boost transient state.

var intro_timer: float = 0.0
var final_intro_timer: float = 0.0
var final_intro_pending: bool = false
var intro_primed: bool = false
var intro_speed_boost: bool = false
var intro_boost_disabled: bool = false
var race_start_message_timer: float = 0.0
var start_boost_timer: float = 0.0

func reset() -> void:
	intro_timer = 0.0
	final_intro_timer = 0.0
	final_intro_pending = false
	intro_primed = false
	intro_speed_boost = false
	intro_boost_disabled = false
	race_start_message_timer = 0.0
	start_boost_timer = 0.0

func begin(intro_duration: float) -> void:
	reset()
	intro_timer = intro_duration
