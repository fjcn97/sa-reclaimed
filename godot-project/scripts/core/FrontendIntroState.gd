class_name FrontendIntroState
extends RefCounted

## Owns entry-sweep timers for frontend screens.
var timers: Dictionary = {}

func reset() -> void:
	timers.clear()

func start(kind: String, duration: float) -> void:
	timers[kind] = maxf(0.0, duration)

func stop(kind: String) -> void:
	timers[kind] = 0.0

func cap(kind: String, duration: float) -> void:
	timers[kind] = minf(timer(kind), maxf(0.0, duration))

func advance(kind: String, delta: float) -> void:
	if timer(kind) > 0.0:
		timers[kind] = maxf(0.0, timer(kind) - delta)

func timer(kind: String) -> float:
	return float(timers.get(kind, 0.0))

func is_ready(kind: String) -> bool:
	return timer(kind) <= 0.0

func progress(kind: String, duration: float) -> float:
	var remaining := timer(kind)
	if duration <= 0.0 or remaining <= 0.0:
		return 1.0
	return clampf(1.0 - (remaining / duration), 0.0, 1.0)
