class_name TitleNavigationState
extends RefCounted

## Owns the active title/frontend phase, menu cursor, and transient notice.

var phase: int = 0
var menu_index: int = 0
var notice_text: String = ""

func reset(press_start_phase: int) -> void:
	phase = press_start_phase
	menu_index = 0
	notice_text = ""
