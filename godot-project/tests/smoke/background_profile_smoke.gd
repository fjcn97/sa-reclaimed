extends SceneTree

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var profile = preload("res://scripts/SourceBackgroundProfile.gd")
	var neutral: Dictionary = profile.for_level(0)
	var zone_2: Dictionary = profile.for_level(2)
	var zone_6: Dictionary = profile.for_level(6)
	var zone_7: Dictionary = profile.for_level(12)
	_check(float(neutral.get("amplitude_x", -1.0)) == 0.0, "neutral stages retain a static source backdrop")
	_check(int(zone_2.get("strips", 0)) == 16, "Zone 2/3 source background uses scanline strips")
	_check(float(zone_2.get("amplitude_x", 0.0)) > 0.0, "Zone 2/3 source background has horizontal HBlank motion")
	_check(int(zone_6.get("strips", 0)) == 20, "Zone 6 source background uses its source strip profile")
	_check(bool(zone_6.get("spotlights", false)), "Zone 4 snow source background enables spotlight windows")
	_check(int(zone_7.get("strips", 0)) == 24, "Zone 7 source background uses its source strip profile")
	_check(float(zone_7.get("amplitude_x", 0.0)) > float(zone_6.get("amplitude_x", 0.0)), "Zone 7 source background keeps the stronger distortion")
	print("BACKGROUND_PROFILE_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("BACKGROUND_PROFILE_FAIL: " + label)
