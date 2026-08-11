class_name TouchControlsPresenter
extends RefCounted

const RUNTIME_SETTINGS := preload("res://scripts/core/RuntimeSettings.gd")

static func is_touch_device(bridge: Object) -> bool:
	return RUNTIME_SETTINGS.is_enabled(RUNTIME_SETTINGS.TOUCH_CONTROLS_OVERRIDE_SETTING) or bridge.is_mobile_platform()

static func show_controls(bridge: Object) -> bool:
	return is_touch_device(bridge)

static func show_gameplay(bridge: Object) -> bool:
	return show_controls(bridge) and bridge.is_gameplay_active() and not bridge.is_clear_screen() and not bridge.is_intro_screen()

static func show_menu(bridge: Object) -> bool:
	return show_controls(bridge) and bridge.is_touch_menu_interactive_screen() and not show_gameplay(bridge)

static func show_menu_horizontal(bridge: Object) -> bool:
	if not show_menu(bridge):
		return false
	if bridge.is_title_screen():
		return bridge.is_touch_title_adjust_state()
	if bridge.is_save_options():
		return bridge.is_touch_save_adjust_state()
	return false

static func navigation_label(bridge: Object) -> String:
	return "SWIPE UP/DOWN" if is_touch_device(bridge) else "UP/DOWN"

static func confirm_label(bridge: Object) -> String:
	return "TAP" if is_touch_device(bridge) else "ENTER"

static func secondary_label(bridge: Object) -> String:
	return "TAP" if is_touch_device(bridge) else "ESC"

static func back_label(bridge: Object) -> String:
	return "BACK" if is_touch_device(bridge) else "ESC"
