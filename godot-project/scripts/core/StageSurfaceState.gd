class_name StageSurfaceState
extends RefCounted

## Owns per-frame terrain surface modifiers affecting player movement.

var on_slidy_ice: bool = false
var on_slowing_snow: bool = false

func reset() -> void:
	on_slidy_ice = false
	on_slowing_snow = false
