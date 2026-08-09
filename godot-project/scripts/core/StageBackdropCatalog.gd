# StageBackdropCatalog.gd
# Presentation profiles for the runtime's source-inspired stage backdrops.
class_name StageBackdropCatalog
extends RefCounted

static func profile(level_id: int) -> Dictionary:
	if level_id == 1:
		return {
			"sky": Color(0.08, 0.10, 0.16),
			"sky_mid": Color(0.14, 0.18, 0.28),
			"sky_high": Color(0.22, 0.30, 0.44),
			"sun": Color(0.88, 0.94, 1.0, 0.18),
			"ground": Color(0.12, 0.10, 0.12),
			"grass": Color(0.24, 0.52, 0.22),
			"hills": [
				{"origin": Vector2(340.0, 460.0), "size": Vector2(220.0, 104.0), "color": Color(0.14, 0.20, 0.14)},
				{"origin": Vector2(920.0, 460.0), "size": Vector2(300.0, 142.0), "color": Color(0.16, 0.24, 0.16)},
				{"origin": Vector2(1560.0, 460.0), "size": Vector2(260.0, 118.0), "color": Color(0.12, 0.18, 0.12)},
				{"origin": Vector2(2140.0, 460.0), "size": Vector2(240.0, 108.0), "color": Color(0.10, 0.16, 0.10)},
			],
		}
	return {
		"sky": Color(0.06, 0.11, 0.22),
		"sky_mid": Color(0.10, 0.21, 0.39),
		"sky_high": Color(0.16, 0.36, 0.62),
		"sun": Color(0.98, 0.86, 0.45, 0.35),
		"ground": Color(0.16, 0.12, 0.08),
		"grass": Color(0.18, 0.48, 0.18),
		"hills": [
			{"origin": Vector2(360.0, 460.0), "size": Vector2(260.0, 120.0), "color": Color(0.12, 0.22, 0.12)},
			{"origin": Vector2(980.0, 460.0), "size": Vector2(380.0, 160.0), "color": Color(0.14, 0.28, 0.14)},
			{"origin": Vector2(1720.0, 460.0), "size": Vector2(320.0, 130.0), "color": Color(0.11, 0.20, 0.11)},
			{"origin": Vector2(2320.0, 460.0), "size": Vector2(280.0, 115.0), "color": Color(0.10, 0.18, 0.10)},
			{"origin": Vector2(520.0, 460.0), "size": Vector2(180.0, 92.0), "color": Color(0.18, 0.34, 0.18)},
		],
	}
