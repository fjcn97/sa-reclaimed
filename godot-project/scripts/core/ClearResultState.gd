class_name ClearResultState
extends RefCounted

## Owns one completed-stage result, including the source-style bonus counter.

var time_snapshot: float = 0.0
var score_snapshot: int = 0
var final_score_snapshot: int = 0
var rank_text: String = "D"
var ring_snapshot: int = 0
var special_ring_snapshot: int = 0
var previous_best_time: float = -1.0
var new_best_time: bool = false
var time_attack_record_rank: int = 0
var time_bonus_remaining: int = 0
var ring_bonus_remaining: int = 0
var special_ring_bonus_remaining: int = 0
var total_display_score: int = 0
var count_step_accumulator: float = 0.0
var count_delay_timer: float = 0.0
var input_lock_timer: float = 0.0
var counting_done: bool = false
var from_goal: bool = false

func reset() -> void:
	time_snapshot = 0.0
	score_snapshot = 0
	final_score_snapshot = 0
	rank_text = "D"
	ring_snapshot = 0
	special_ring_snapshot = 0
	previous_best_time = -1.0
	new_best_time = false
	time_attack_record_rank = 0
	time_bonus_remaining = 0
	ring_bonus_remaining = 0
	special_ring_bonus_remaining = 0
	total_display_score = 0
	count_step_accumulator = 0.0
	count_delay_timer = 0.0
	input_lock_timer = 0.0
	counting_done = false
	from_goal = false

func begin(time: float, score: int, rings: int, special_rings: int, rank: String, time_bonus: int, ring_bonus: int, special_ring_bonus: int, count_delay: float, input_lock: float, time_attack: bool) -> void:
	time_snapshot = time
	score_snapshot = score
	ring_snapshot = rings
	special_ring_snapshot = special_rings
	rank_text = rank
	time_bonus_remaining = time_bonus
	ring_bonus_remaining = ring_bonus
	special_ring_bonus_remaining = special_ring_bonus
	total_display_score = score
	final_score_snapshot = score + time_bonus + ring_bonus + special_ring_bonus
	count_step_accumulator = 0.0
	count_delay_timer = count_delay
	input_lock_timer = input_lock
	counting_done = time_attack

func apply_counter(counter: Dictionary, update_input_lock: bool) -> void:
	time_bonus_remaining = int(counter.get("time_bonus", time_bonus_remaining))
	ring_bonus_remaining = int(counter.get("ring_bonus", ring_bonus_remaining))
	special_ring_bonus_remaining = int(counter.get("special_ring_bonus", special_ring_bonus_remaining))
	total_display_score = int(counter.get("total_score", total_display_score))
	count_step_accumulator = 0.0
	counting_done = bool(counter.get("counting_done", counting_done))
	if update_input_lock:
		input_lock_timer = float(counter.get("input_lock", input_lock_timer))

func set_time_attack_record(previous_best: float, rank: int, is_new_best: bool) -> void:
	previous_best_time = previous_best
	time_attack_record_rank = rank
	new_best_time = is_new_best
