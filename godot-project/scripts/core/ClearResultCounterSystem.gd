class_name ClearResultCounterSystem
extends RefCounted

## Owns the source-style clear-results bonus counter.

static func advance(time_bonus: int, ring_bonus: int, special_ring_bonus: int, total_score: int, fast_tail_seconds: float, tail_seconds: float, fast_forward: bool = false) -> Dictionary:
	var next_time := time_bonus
	var next_ring := ring_bonus
	var next_special := special_ring_bonus
	var next_total := total_score
	var counted_any := false
	if next_ring > 0:
		next_ring = maxi(0, next_ring - 100)
		next_total += 100
		counted_any = true
	if next_special > 0:
		next_special = maxi(0, next_special - 100)
		next_total += 100
		counted_any = true
	if next_time > 0:
		next_time = maxi(0, next_time - 100)
		next_total += 100
		counted_any = true
	if counted_any:
		return {"time_bonus": next_time, "ring_bonus": next_ring, "special_ring_bonus": next_special, "total_score": next_total, "counting_done": false, "input_lock": 0.0}
	return finish(next_time, next_ring, next_special, next_total, fast_tail_seconds, tail_seconds, fast_forward)

static func finish(time_bonus: int, ring_bonus: int, special_ring_bonus: int, total_score: int, fast_tail_seconds: float, tail_seconds: float, fast_forward: bool = false) -> Dictionary:
	return {"time_bonus": 0, "ring_bonus": 0, "special_ring_bonus": 0, "total_score": total_score + time_bonus + ring_bonus + special_ring_bonus, "counting_done": true, "input_lock": fast_tail_seconds if fast_forward else tail_seconds}
