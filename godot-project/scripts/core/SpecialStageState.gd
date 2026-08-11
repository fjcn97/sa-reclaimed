class_name SpecialStageState
extends RefCounted

## Owns the special-stage run, results, pause, and guard-robo simulation data.

var timer: float = 0.0
var entry_duration: float = 2.6
var run_duration: float = 120.0
var phase: int = 0
var pending: bool = false
var ring_count: int = 0
var score: int = 0
var points_remaining: int = 0
var bonus_remaining: int = 0
var result_hold_started: bool = false
var emerald_index: int = 0
var lane: int = 1
var progress: float = 0.0
var last_segment: int = -1
var target_reached: bool = false
var paused: bool = false
var pause_cursor: int = 0
var multiplier: int = 1
var multiplier_streak: int = 0
var multiplier_timer: float = 0.0
var robo_progress: float = 0.15
var robo_lane: int = 1
var robo_speed: float = 0.18
var robo_zone_speeds: Array = []
var robo_lane_timer: float = 0.0
var robo_cooldown: float = 0.0
var run_target: int = 300
var speed: float = 1.0
var jump_timer: float = 0.0
var ring_targets: Array = []
var ring_kinds: Array = []

func configure(zone_speeds: Array, targets: Array, kinds: Array) -> void:
	robo_zone_speeds = zone_speeds.duplicate()
	ring_targets = targets.duplicate()
	ring_kinds = kinds.duplicate()

func reset() -> void:
	timer = 0.0
	phase = 0
	pending = false
	ring_count = 0
	score = 0
	points_remaining = 0
	bonus_remaining = 0
	result_hold_started = false
	emerald_index = 0
	lane = 1
	progress = 0.0
	last_segment = -1
	target_reached = false
	paused = false
	pause_cursor = 0
	multiplier = 1
	multiplier_streak = 0
	multiplier_timer = 0.0
	robo_progress = 0.15
	robo_lane = 1
	robo_speed = 0.18
	robo_lane_timer = 0.0
	robo_cooldown = 0.0
	run_target = 300
	speed = 1.0
	jump_timer = 0.0
