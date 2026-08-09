class_name RuntimeSettings
extends RefCounted

const TOUCH_CONTROLS_OVERRIDE_SETTING := "sa_reclaimed/debug/show_touch_controls_on_desktop"

static func is_enabled(setting_name: String) -> bool:
	if not ProjectSettings.has_setting(setting_name):
		return false
	var value: Variant = ProjectSettings.get_setting(setting_name)
	if value is bool:
		return value
	if value is int:
		return value != 0
	if value is String:
		var normalized: String = value.strip_edges().to_lower()
		return normalized == "1" or normalized == "true" or normalized == "yes" or normalized == "on"
	return false
