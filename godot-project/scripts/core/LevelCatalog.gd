# LevelCatalog.gd
# Immutable level names shared by gameplay and course-selection presentation.
class_name LevelCatalog
extends RefCounted

static func names() -> Array:
	return [
		"LEAF FOREST", "LEAF FOREST", "HOT CRATER", "HOT CRATER",
		"MUSIC PLANT", "MUSIC PLANT", "ICE PARADISE", "ICE PARADISE",
		"SKY CANYON", "SKY CANYON", "TECHNO BASE", "TECHNO BASE",
		"EGG UTOPIA", "EGG UTOPIA", "FINAL ZONE", "TRUE AREA 53",
	]
