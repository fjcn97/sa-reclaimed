# CharacterCatalog.gd
# Immutable character metadata and default Tiny Chao roster data.
class_name CharacterCatalog
extends RefCounted

static func names() -> Array:
	return ["SONIC", "CREAM", "TAILS", "KNUCKLES", "AMY"]

static func descriptions() -> Array:
	return [
		"BALANCED SPEED TYPE",
		"FLIGHT AND CHEESE SUPPORT",
		"FLIGHT AND TECHNICAL ROUTES",
		"POWER AND CLIMB ROUTES",
		"HAMMER TECHNIQUE",
	]

static func default_tiny_chao_roster() -> Array:
	return [
		{"name": "CHAO 1", "hunger": 50, "mood": 50, "care": 0},
		{"name": "CHAO 2", "hunger": 42, "mood": 58, "care": 0},
		{"name": "CHAO 3", "hunger": 64, "mood": 44, "care": 0},
	]
