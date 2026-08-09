class_name MenuCommand
extends RefCounted

const NONE := ""
const MOVE_UP := "move_up"
const MOVE_DOWN := "move_down"
const MOVE_LEFT := "move_left"
const MOVE_RIGHT := "move_right"
const CONFIRM := "confirm"
const BACK := "back"
const START := "start"
const SPECIAL := "special"
const SLOT_PREVIOUS := "slot_previous"
const SLOT_NEXT := "slot_next"

static func from_input_bit(bit: int, bridge: Object) -> String:
	if bit & bridge.DPAD_UP:
		return MOVE_UP
	if bit & bridge.DPAD_DOWN:
		return MOVE_DOWN
	if bit & bridge.DPAD_LEFT:
		return MOVE_LEFT
	if bit & bridge.DPAD_RIGHT:
		return MOVE_RIGHT
	if bit & bridge.A_BUTTON:
		return CONFIRM
	if bit & bridge.B_BUTTON:
		return BACK
	if bit & bridge.START_BUTTON:
		return START
	if bit & bridge.SELECT_BUTTON:
		return SPECIAL
	if bit & bridge.L_BUTTON:
		return SLOT_PREVIOUS
	if bit & bridge.R_BUTTON:
		return SLOT_NEXT
	return NONE
