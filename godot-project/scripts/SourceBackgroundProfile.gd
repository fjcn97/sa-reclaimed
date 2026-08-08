extends RefCounted
class_name SourceBackgroundProfile

static func for_level(level_id: int) -> Dictionary:
	# Profiles correspond to the non-matching SA2 background update families.
	match level_id:
		2, 3:
			return {"strips": 16, "phase_speed": 1.4, "amplitude_x": 7.0, "amplitude_y": 1.5, "opacity": 0.30}
		6, 7:
			return {"strips": 20, "phase_speed": 1.8, "amplitude_x": 11.0, "amplitude_y": 2.0, "opacity": 0.32, "spotlights": true}
		10, 11:
			return {"strips": 18, "phase_speed": 1.2, "amplitude_x": 5.0, "amplitude_y": 1.0, "opacity": 0.30}
		12, 13:
			return {"strips": 24, "phase_speed": 2.1, "amplitude_x": 14.0, "amplitude_y": 2.5, "opacity": 0.34}
		_:
			return {"strips": 15, "phase_speed": 0.0, "amplitude_x": 0.0, "amplitude_y": 0.0, "opacity": 0.28}
