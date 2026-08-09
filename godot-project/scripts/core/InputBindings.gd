# InputBindings.gd
# Canonical desktop/controller bindings for the GBA-style input bitfield.
class_name InputBindings
extends RefCounted

const ACTION_LEFT := "move_left"
const ACTION_RIGHT := "move_right"
const ACTION_UP := "move_up"
const ACTION_DOWN := "move_down"
const ACTION_JUMP := "jump"
const ACTION_ATTACK := "attack"
const ACTION_BOOST := "boost"
const ACTION_START := "pause"

const A_BUTTON := 0x0001
const B_BUTTON := 0x0002
const SELECT_BUTTON := 0x0004
const START_BUTTON := 0x0008
const DPAD_RIGHT := 0x0010
const DPAD_LEFT := 0x0020
const DPAD_UP := 0x0040
const DPAD_DOWN := 0x0080
const R_BUTTON := 0x0100
const L_BUTTON := 0x0200

static func sample_action_input(initial: int = 0) -> int:
	var held := initial
	if Input.is_action_pressed(ACTION_LEFT):
		held |= DPAD_LEFT
	if Input.is_action_pressed(ACTION_RIGHT):
		held |= DPAD_RIGHT
	if Input.is_action_pressed(ACTION_UP):
		held |= DPAD_UP
	if Input.is_action_pressed(ACTION_DOWN):
		held |= DPAD_DOWN
	if Input.is_action_pressed(ACTION_JUMP):
		held |= A_BUTTON
	if Input.is_action_pressed(ACTION_ATTACK):
		held |= B_BUTTON
	if Input.is_action_pressed(ACTION_BOOST):
		held |= L_BUTTON | R_BUTTON
	if Input.is_action_pressed(ACTION_START):
		held |= START_BUTTON
	return held | sample_physical_keys()

static func sample_physical_keys() -> int:
	var held := 0
	if Input.is_key_pressed(KEY_Q):
		held |= L_BUTTON
	if Input.is_key_pressed(KEY_E):
		held |= R_BUTTON
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		held |= DPAD_LEFT
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		held |= DPAD_RIGHT
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		held |= DPAD_UP
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		held |= DPAD_DOWN
	if Input.is_key_pressed(KEY_Z):
		held |= A_BUTTON
	if Input.is_key_pressed(KEY_X) or Input.is_key_pressed(KEY_SPACE):
		held |= B_BUTTON
	if Input.is_key_pressed(KEY_ENTER):
		held |= START_BUTTON
	return held

static func keycode_to_bit(keycode: int) -> int:
	match keycode:
		KEY_Q:
			return L_BUTTON
		KEY_E:
			return R_BUTTON
		KEY_A, KEY_LEFT:
			return DPAD_LEFT
		KEY_D, KEY_RIGHT:
			return DPAD_RIGHT
		KEY_W, KEY_UP:
			return DPAD_UP
		KEY_S, KEY_DOWN:
			return DPAD_DOWN
		KEY_Z, KEY_ENTER, KEY_KP_ENTER:
			return A_BUTTON
		KEY_SPACE, KEY_ESCAPE:
			return B_BUTTON
		KEY_PAUSE:
			return START_BUTTON
		KEY_INSERT:
			return SELECT_BUTTON
		_:
			return 0

static func joypad_button_to_bit(button_index: int) -> int:
	match button_index:
		JOY_BUTTON_DPAD_LEFT:
			return DPAD_LEFT
		JOY_BUTTON_DPAD_RIGHT:
			return DPAD_RIGHT
		JOY_BUTTON_DPAD_UP:
			return DPAD_UP
		JOY_BUTTON_DPAD_DOWN:
			return DPAD_DOWN
		JOY_BUTTON_A:
			return A_BUTTON
		JOY_BUTTON_B:
			return B_BUTTON
		JOY_BUTTON_START:
			return START_BUTTON
		JOY_BUTTON_BACK:
			return SELECT_BUTTON
		JOY_BUTTON_LEFT_SHOULDER:
			return L_BUTTON
		JOY_BUTTON_RIGHT_SHOULDER:
			return R_BUTTON
		_:
			return 0
