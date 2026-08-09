# SpecialStageCatalog.gd
# Immutable route checkpoints used by the special-stage simulation.
class_name SpecialStageCatalog
extends RefCounted

static func robo_zone_speeds() -> Array:
	return [0.18, 0.21, 0.24, 0.27, 0.30, 0.33, 0.36]

static func ring_targets() -> Array:
	return [0, 2, 1, 0, 2, 1, 1, 0, 2, 1, 0, 2, 1, 0, 2, 1, 1, 0, 2, 1]

static func ring_kinds() -> Array:
	return [0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0]
