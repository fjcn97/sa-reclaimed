# CreditsCatalog.gd
# Immutable credits slide metadata and timing data.
class_name CreditsCatalog
extends RefCounted

static func slide_groups() -> Array:
	return [6, 6, 8, 5]

static func source_tiles() -> Array:
	return [
		"credits_0", "credits_1", "credits_2", "credits_3", "credits_4",
		"credits_5", "credits_6", "credits_7", "credits_8", "credits_9",
		"credits_10", "credits_11", "credits_12", "credits_13", "credits_14",
		"credits_15", "credits_16", "credits_17", "credits_18", "credits_19",
		"credits_20", "credits_21", "credits_22", "credits_23", "credits_24",
	]

static func intro_duration() -> float:
	return 180.0 / 60.0

static func slide_duration() -> float:
	return 150.0 / 60.0

static func end_story_delays() -> Array:
	return [3, 3, 3, 3, 3, 3, 3, 12, 4, 4]
