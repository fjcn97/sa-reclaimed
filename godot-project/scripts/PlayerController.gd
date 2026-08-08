# PlayerController.gd
# Reads keyboard/gamepad input and forwards it into the prototype bridge.
extends Node

signal player_state_updated(state)

const ACTION_LEFT   = "move_left"
const ACTION_RIGHT  = "move_right"
const ACTION_UP     = "move_up"
const ACTION_DOWN   = "move_down"
const ACTION_JUMP   = "jump"
const ACTION_ATTACK = "attack"
const ACTION_BOOST  = "boost"
const ACTION_START  = "pause"

@export var player_path: NodePath = NodePath("../Player")

var _held_input: int = 0
var _frame_input: int = 0
var _prev_input: int = 0
var _fallback_held_input: int = 0
var _fallback_frame_input: int = 0
var _joypad_axis_input: int = 0
var _touch_held_input: int = 0
var _touch_frame_input: int = 0
var _menu_repeat_timer: float = 0.0
var _menu_action_repeat_timer: float = 0.0
var _player: Node2D = null

# SA2 initializes gKeysFirstRepeatIntervals/gKeysContinuedRepeatIntervals
# to 20 and 8 frames for its menu tasks.
const MENU_REPEAT_START_DELAY := 20.0 / 60.0
const MENU_REPEAT_INTERVAL := 8.0 / 60.0
const MENU_REPEAT_DIRECTIONS := CoreBridge.DPAD_UP | CoreBridge.DPAD_DOWN | CoreBridge.DPAD_LEFT | CoreBridge.DPAD_RIGHT
const MENU_ACTION_REPEAT_START_DELAY := 20.0 / 60.0
const MENU_ACTION_REPEAT_INTERVAL := 8.0 / 60.0
const MENU_REPEAT_ACTIONS := CoreBridge.A_BUTTON | CoreBridge.B_BUTTON | CoreBridge.L_BUTTON | CoreBridge.R_BUTTON

func _ready() -> void:
	set_physics_process(true)
	set_process_input(true)
	_player = get_node_or_null(player_path)
	if _player:
		_player.global_position = Vector2(CoreBridge.get_player_state().world_x, CoreBridge.get_player_state().world_y)

func _physics_process(delta: float) -> void:
	_sample_input()
	CoreBridge.advance_ui_timers(delta, get_held_input(), get_frame_input())
	if not CoreBridge.is_gameplay_active():
		_handle_menu_input(_get_menu_frame_input(delta))
		_frame_input = 0
		_fallback_frame_input = 0
		_touch_frame_input = 0
		return
	var gameplay_held := CoreBridge.translate_gameplay_input(get_held_input())
	var gameplay_frame := CoreBridge.translate_gameplay_input(get_frame_input())
	if CoreBridge.is_demo_mode():
		gameplay_held = CoreBridge.get_demo_held_input()
		gameplay_frame = CoreBridge.get_demo_frame_input()
	CoreBridge.physics_tick(gameplay_held, gameplay_frame, delta)
	_frame_input = 0
	_fallback_frame_input = 0
	_touch_frame_input = 0

	var state = CoreBridge.get_player_state()
	if _player:
		_player.global_position = Vector2(state.world_x, state.world_y)
	emit_signal("player_state_updated", state)

func _sample_input() -> void:
	var new_held: int = _fallback_held_input | _touch_held_input
	if Input.is_action_pressed(ACTION_LEFT):
		new_held |= CoreBridge.DPAD_LEFT
	if Input.is_action_pressed(ACTION_RIGHT):
		new_held |= CoreBridge.DPAD_RIGHT
	if Input.is_action_pressed(ACTION_UP):
		new_held |= CoreBridge.DPAD_UP
	if Input.is_action_pressed(ACTION_DOWN):
		new_held |= CoreBridge.DPAD_DOWN
	if Input.is_action_pressed(ACTION_JUMP):
		new_held |= CoreBridge.A_BUTTON
	if Input.is_action_pressed(ACTION_ATTACK):
		new_held |= CoreBridge.B_BUTTON
	if Input.is_action_pressed(ACTION_BOOST):
		new_held |= CoreBridge.L_BUTTON | CoreBridge.R_BUTTON
	if Input.is_action_pressed(ACTION_START):
		new_held |= CoreBridge.START_BUTTON
	new_held |= _poll_physical_keys()

	_frame_input = (new_held & ~_prev_input) | _fallback_frame_input | _touch_frame_input
	_held_input = new_held
	_prev_input = new_held

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		_handle_key_event(event)
	elif event is InputEventJoypadButton:
		_handle_joypad_event(event)
	elif event is InputEventJoypadMotion:
		_handle_joypad_motion(event)

func _handle_key_event(event: InputEventKey) -> void:
	if event.echo:
		return
	var bit := _keycode_to_bit(event.keycode)
	if bit == 0 and event.physical_keycode != event.keycode:
		bit = _keycode_to_bit(event.physical_keycode)
	if bit == 0:
		return
	if event.pressed:
		_fallback_held_input |= bit
		_fallback_frame_input |= bit
	else:
		_fallback_held_input &= ~bit

func _handle_joypad_event(event: InputEventJoypadButton) -> void:
	var bit := _joypad_button_to_bit(event.button_index)
	if bit == 0:
		return
	if event.pressed:
		_fallback_held_input |= bit
		_fallback_frame_input |= bit
	else:
		_fallback_held_input &= ~bit

func _handle_joypad_motion(event: InputEventJoypadMotion) -> void:
	const AXIS_DEADZONE := 0.35
	if event.axis == JOY_AXIS_LEFT_X:
		_joypad_axis_input &= ~(CoreBridge.DPAD_LEFT | CoreBridge.DPAD_RIGHT)
		if event.axis_value <= -AXIS_DEADZONE:
			_joypad_axis_input |= CoreBridge.DPAD_LEFT
		elif event.axis_value >= AXIS_DEADZONE:
			_joypad_axis_input |= CoreBridge.DPAD_RIGHT
	elif event.axis == JOY_AXIS_LEFT_Y:
		_joypad_axis_input &= ~(CoreBridge.DPAD_UP | CoreBridge.DPAD_DOWN)
		if event.axis_value <= -AXIS_DEADZONE:
			_joypad_axis_input |= CoreBridge.DPAD_UP
		elif event.axis_value >= AXIS_DEADZONE:
			_joypad_axis_input |= CoreBridge.DPAD_DOWN

func _keycode_to_bit(keycode: int) -> int:
	match keycode:
		KEY_Q:
			return CoreBridge.L_BUTTON
		KEY_E:
			return CoreBridge.R_BUTTON
		KEY_A, KEY_LEFT:
			return CoreBridge.DPAD_LEFT
		KEY_D, KEY_RIGHT:
			return CoreBridge.DPAD_RIGHT
		KEY_W, KEY_UP:
			return CoreBridge.DPAD_UP
		KEY_S, KEY_DOWN:
			return CoreBridge.DPAD_DOWN
		KEY_Z, KEY_ENTER, KEY_KP_ENTER:
			# The modern menu labels Enter as confirm; keep Z as the
			# original face-button binding as well.
			return CoreBridge.A_BUTTON
		KEY_X, KEY_SPACE, KEY_ESCAPE:
			# Escape is a desktop-friendly alias for the source B/back action.
			return CoreBridge.B_BUTTON
		KEY_PAUSE:
			return CoreBridge.START_BUTTON
		KEY_INSERT:
			return CoreBridge.SELECT_BUTTON
		_:
			return 0

func _joypad_button_to_bit(button_index: int) -> int:
	match button_index:
		JOY_BUTTON_DPAD_LEFT:
			return CoreBridge.DPAD_LEFT
		JOY_BUTTON_DPAD_RIGHT:
			return CoreBridge.DPAD_RIGHT
		JOY_BUTTON_DPAD_UP:
			return CoreBridge.DPAD_UP
		JOY_BUTTON_DPAD_DOWN:
			return CoreBridge.DPAD_DOWN
		JOY_BUTTON_A:
			return CoreBridge.A_BUTTON
		JOY_BUTTON_B:
			return CoreBridge.B_BUTTON
		JOY_BUTTON_START:
			return CoreBridge.START_BUTTON
		JOY_BUTTON_BACK:
			return CoreBridge.SELECT_BUTTON
		JOY_BUTTON_LEFT_SHOULDER:
			return CoreBridge.L_BUTTON
		JOY_BUTTON_RIGHT_SHOULDER:
			return CoreBridge.R_BUTTON
		_:
			return 0

func _poll_physical_keys() -> int:
	var held: int = 0
	if Input.is_key_pressed(KEY_Q):
		held |= CoreBridge.L_BUTTON
	if Input.is_key_pressed(KEY_E):
		held |= CoreBridge.R_BUTTON
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		held |= CoreBridge.DPAD_LEFT
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		held |= CoreBridge.DPAD_RIGHT
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		held |= CoreBridge.DPAD_UP
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		held |= CoreBridge.DPAD_DOWN
	if Input.is_key_pressed(KEY_Z):
		held |= CoreBridge.A_BUTTON
	if Input.is_key_pressed(KEY_X) or Input.is_key_pressed(KEY_SPACE):
		held |= CoreBridge.B_BUTTON
	if Input.is_key_pressed(KEY_ENTER):
		held |= CoreBridge.START_BUTTON
	return held

func _handle_menu_input(frame_input: int) -> void:
	if CoreBridge.is_tiny_chao_garden_play_screen():
		# Garden input is consumed by advance_ui_timers before generic menu input.
		return

	if CoreBridge.is_title_screen():
		if CoreBridge.is_play_mode_screen() and not CoreBridge.is_play_mode_input_ready():
			return
		if CoreBridge.is_single_player_menu_screen() and not CoreBridge.is_single_player_input_ready():
			if frame_input & CoreBridge.B_BUTTON:
				CoreBridge.open_save_options_from_title()
			return
		# title_screen.c checks the Single Player cursor, then B, then A.
		# Keep B ahead of A when both arrive in the same frame.
		if CoreBridge.is_single_player_menu_screen():
			if frame_input & CoreBridge.DPAD_UP:
				CoreBridge.move_title_selection(-1)
			elif frame_input & CoreBridge.DPAD_DOWN:
				CoreBridge.move_title_selection(1)
			if frame_input & CoreBridge.B_BUTTON:
				CoreBridge.open_save_options_from_title()
			elif frame_input & CoreBridge.A_BUTTON:
				CoreBridge.start_title_selection()
			return
		# title_screen.c's press-start task uses START; the modern Godot prompt
		# also exposes Z/touch confirm, so A follows the same start path.
		if CoreBridge.is_press_start_screen():
			if frame_input & (CoreBridge.START_BUTTON | CoreBridge.A_BUTTON):
				CoreBridge.start_title_selection()
			return
		# Link communication is not a cursor menu in the original. Only START
		# advances the host handshake; B returns to Pak Mode Select.
		if CoreBridge.is_multiplayer_connection_screen():
			if frame_input & CoreBridge.START_BUTTON:
				CoreBridge.start_title_selection()
			elif frame_input & CoreBridge.B_BUTTON:
				CoreBridge.open_save_options_from_title()
			return
		# The original VS lobby commits YES/NO before reading Left/Right.
		if CoreBridge.is_multiplayer_lobby_screen() and (frame_input & CoreBridge.START_BUTTON or frame_input & CoreBridge.A_BUTTON):
			CoreBridge.start_title_selection()
			return
		if CoreBridge.is_multiplayer_lobby_screen():
			# multiplayer_lobby.c only reads host Left/Right after confirm;
			# B and Select must not fall through to the title save-options path.
			if frame_input & CoreBridge.DPAD_LEFT:
				CoreBridge.adjust_title_selection(-1)
			elif frame_input & CoreBridge.DPAD_RIGHT:
				CoreBridge.adjust_title_selection(1)
			return
		if CoreBridge.is_singlepak_results_screen():
			# Multiplayer results advance on their source-defined presentation timer.
			return
		if CoreBridge.is_time_attack_lobby_screen():
			# time_attack_lobby.c falls through from a blocked Up to Down,
			# allowing Up+Down at the top edge to move downward.
			var time_attack_cursor := CoreBridge.get_time_attack_lobby_cursor()
			if frame_input & CoreBridge.DPAD_UP and time_attack_cursor != 0:
				CoreBridge.move_title_selection(-1)
			elif frame_input & CoreBridge.DPAD_DOWN and time_attack_cursor != 3:
				CoreBridge.move_title_selection(1)
			if frame_input & CoreBridge.A_BUTTON:
				CoreBridge.start_title_selection()
			return
		# The original mode-select screens handle confirm/back before their
		# directional toggle. This matters when a held direction overlaps A/B.
		if CoreBridge.is_time_attack_mode_screen() or CoreBridge.is_multiplayer_mode_screen():
			if CoreBridge.is_time_attack_mode_screen() and not CoreBridge.is_time_attack_mode_input_ready():
				if frame_input & CoreBridge.A_BUTTON:
					CoreBridge.skip_time_attack_mode_intro()
				return
			if CoreBridge.is_multiplayer_mode_screen() and not CoreBridge.is_multiplayer_mode_input_ready():
				if frame_input & CoreBridge.A_BUTTON:
					CoreBridge.skip_multiplayer_mode_intro()
				return
			# time_attack_mode_select.c and the multiplayer mode task still
			# process its vertical toggle after A/B. Apply it before the Godot
			# transition so A+Up/Down preserves the source-selected mode.
			if frame_input & (CoreBridge.DPAD_UP | CoreBridge.DPAD_DOWN) and frame_input & (CoreBridge.A_BUTTON | CoreBridge.B_BUTTON):
				CoreBridge.move_title_selection(1)
			if frame_input & CoreBridge.A_BUTTON:
				CoreBridge.start_title_selection()
				return
			if frame_input & CoreBridge.B_BUTTON:
				CoreBridge.open_save_options_from_title()
				return
		# Course Select is a horizontal map, not a generic cursor menu. Its
		# movement animation also consumes Back and defers single-player A.
		if CoreBridge.is_course_select_screen():
			if CoreBridge.is_course_select_unlocking():
				# course_select.c consumes all input while the new path is revealed.
				return
			if frame_input & CoreBridge.DPAD_LEFT:
				CoreBridge.move_title_selection(-1)
				return
			if frame_input & CoreBridge.DPAD_RIGHT:
				CoreBridge.move_title_selection(1)
				return
			if CoreBridge.is_course_select_busy() or CoreBridge.is_course_select_starting():
				if frame_input & CoreBridge.A_BUTTON and not CoreBridge.is_multiplayer_course_select_screen():
					CoreBridge.start_title_selection()
				return
			if frame_input & CoreBridge.A_BUTTON:
				CoreBridge.start_title_selection()
				return
			if frame_input & CoreBridge.B_BUTTON:
				CoreBridge.open_save_options_from_title()
			return
		if CoreBridge.is_play_mode_screen():
			# title_screen.c toggles once when either vertical direction is
			# present; Up+Down must not toggle twice.
			if frame_input & (CoreBridge.DPAD_UP | CoreBridge.DPAD_DOWN):
				CoreBridge.move_title_selection(1)
		else:
			if frame_input & CoreBridge.DPAD_UP:
				CoreBridge.move_title_selection(-1)
			elif frame_input & CoreBridge.DPAD_DOWN:
				CoreBridge.move_title_selection(1)
		if frame_input & CoreBridge.DPAD_LEFT:
			CoreBridge.adjust_title_selection(-1)
		elif frame_input & CoreBridge.DPAD_RIGHT:
			CoreBridge.adjust_title_selection(1)
		# title_screen.c checks B before A in the Single Player menu. Keep
		# simultaneous input on the return path instead of opening the item.
		if CoreBridge.is_single_player_menu_screen():
			if frame_input & CoreBridge.B_BUTTON:
				CoreBridge.open_save_options_from_title()
				return
			if frame_input & CoreBridge.A_BUTTON:
				CoreBridge.start_title_selection()
				return
		# Course Select reserves a Left/Right frame for map travel; the original
		# ignores confirmation when directional travel is pressed simultaneously.
		var title_direction_busy := CoreBridge.is_course_select_screen() and bool(frame_input & (CoreBridge.DPAD_LEFT | CoreBridge.DPAD_RIGHT))
		var title_confirmed := bool(frame_input & CoreBridge.A_BUTTON)
		if title_confirmed and not title_direction_busy:
			CoreBridge.start_title_selection()
			return
		if frame_input & CoreBridge.B_BUTTON:
			CoreBridge.open_save_options_from_title()
		return

	if CoreBridge.is_save_options():
		if CoreBridge.handle_save_shoulder_input(frame_input):
			return
		# Options' top-level screen checks confirm/back before directional input.
		if CoreBridge.is_save_main_menu_screen():
			if frame_input & CoreBridge.A_BUTTON:
				CoreBridge.accept_save_selection()
				return
			if frame_input & CoreBridge.B_BUTTON:
				if not CoreBridge.trigger_save_secondary_action():
					CoreBridge.cancel_save_selection()
				return
		# These source tasks consume the first matching D-pad direction even
		# when the cursor wraps or stays on the same active name slot.
		if CoreBridge.is_name_entry_screen():
			if frame_input & CoreBridge.DPAD_UP:
				CoreBridge.move_save_selection(-1)
				return
			elif frame_input & CoreBridge.DPAD_DOWN:
				CoreBridge.move_save_selection(1)
				return
			elif frame_input & CoreBridge.DPAD_LEFT:
				CoreBridge.adjust_save_selection(-1)
				return
			elif frame_input & CoreBridge.DPAD_RIGHT:
				CoreBridge.adjust_save_selection(1)
				return
		if CoreBridge.is_player_data_screen():
			if frame_input & CoreBridge.DPAD_UP:
				CoreBridge.move_save_selection(-1)
				return
			elif frame_input & CoreBridge.DPAD_DOWN:
				CoreBridge.move_save_selection(1)
				return
		if CoreBridge.is_language_screen():
			if frame_input & CoreBridge.DPAD_DOWN:
				CoreBridge.move_save_selection(1)
				return
			elif frame_input & CoreBridge.DPAD_UP:
				CoreBridge.move_save_selection(-1)
				return
		# Task_OptionsScreenMain checks A/B before its D-pad branches. Keep
		# simultaneous confirm-and-direction input on the current item.
		if CoreBridge.is_options_main_screen():
			if frame_input & CoreBridge.A_BUTTON:
				CoreBridge.accept_save_selection()
				return
			if frame_input & CoreBridge.B_BUTTON:
				CoreBridge.cancel_save_selection()
				return
		# sound_test.c evaluates all four directions independently, then A and
		# B independently. Preserve that order for simultaneous input frames.
		if CoreBridge.is_sound_test_screen():
			if frame_input & CoreBridge.DPAD_LEFT:
				CoreBridge.adjust_save_selection(-1)
			if frame_input & CoreBridge.DPAD_RIGHT:
				CoreBridge.adjust_save_selection(1)
			if frame_input & CoreBridge.DPAD_UP:
				CoreBridge.move_save_selection(-1)
			if frame_input & CoreBridge.DPAD_DOWN:
				CoreBridge.move_save_selection(1)
			if frame_input & CoreBridge.A_BUTTON:
				CoreBridge.accept_save_selection()
			if frame_input & CoreBridge.B_BUTTON:
				CoreBridge.cancel_save_selection()
			return
		# options_screen.c uses Down-first on its main menu and language
		# screen, but Up-first on Player Data and profile name entry.
		var save_vertical_up_first := CoreBridge.is_player_data_screen() or CoreBridge.is_name_entry_screen() or CoreBridge.is_multiplayer_records_screen() or CoreBridge.is_time_records_courses_view()
		if save_vertical_up_first and frame_input & CoreBridge.DPAD_UP:
			CoreBridge.move_save_selection(-1)
			return
		if not save_vertical_up_first and frame_input & CoreBridge.DPAD_DOWN:
			CoreBridge.move_save_selection(1)
			return
		if save_vertical_up_first and frame_input & CoreBridge.DPAD_DOWN:
			CoreBridge.move_save_selection(1)
			return
		if not save_vertical_up_first and frame_input & CoreBridge.DPAD_UP:
			CoreBridge.move_save_selection(-1)
			return
		if frame_input & CoreBridge.DPAD_LEFT:
			CoreBridge.adjust_save_selection(-1)
		elif frame_input & CoreBridge.DPAD_RIGHT:
			CoreBridge.adjust_save_selection(1)
		if CoreBridge.save_direction_consumes_action(frame_input):
			return
		# Converted options tasks handle A before all later actions and return,
		# so simultaneous A+START/B/Select cannot commit twice.
		if frame_input & CoreBridge.A_BUTTON:
			CoreBridge.accept_save_selection()
			return
		if frame_input & CoreBridge.START_BUTTON:
			var start_handled := CoreBridge.trigger_save_start_action()
			# options_screen.c accepts A or START on the language screen,
			# including edits to an existing profile.
			var start_can_confirm := CoreBridge.is_name_entry_screen() or CoreBridge.is_language_screen()
			if not start_handled and start_can_confirm:
				CoreBridge.accept_save_selection()
		if frame_input & CoreBridge.SELECT_BUTTON:
			# options_screen.c handles Select only in Button Config; all
			# other submenu tasks ignore it.
			if CoreBridge.is_button_config_screen():
				CoreBridge.trigger_save_special_action()
		if frame_input & CoreBridge.B_BUTTON:
			if not CoreBridge.trigger_save_secondary_action():
				CoreBridge.cancel_save_selection()
		return

	if CoreBridge.is_character_select():
		if not CoreBridge.is_character_select_input_ready():
			if frame_input & CoreBridge.A_BUTTON and not CoreBridge.is_multiplayer_character_select_screen():
				CoreBridge.skip_character_select_intro()
			return
		var character_direction := 0
		if frame_input & CoreBridge.DPAD_LEFT or frame_input & CoreBridge.DPAD_UP:
			character_direction = -1
		elif frame_input & CoreBridge.DPAD_RIGHT or frame_input & CoreBridge.DPAD_DOWN:
			character_direction = 1
		if character_direction != 0:
			CoreBridge.move_character_selection(character_direction)
			return
		if frame_input & CoreBridge.A_BUTTON:
			CoreBridge.confirm_character_selection()
		# character_select.c only handles B for single-player cancel;
		# Select is ignored on this screen.
		if frame_input & CoreBridge.B_BUTTON and not CoreBridge.is_multiplayer_character_select_screen():
			CoreBridge.cancel_character_selection()
		return

	if CoreBridge.is_intro_screen():
		if frame_input & CoreBridge.A_BUTTON:
			CoreBridge.skip_intro()
		if frame_input & CoreBridge.B_BUTTON:
			CoreBridge.skip_intro()
		return

	if CoreBridge.is_final_intro_screen():
		if frame_input & CoreBridge.START_BUTTON:
			CoreBridge.skip_final_intro()
		return

	if CoreBridge.is_clear_screen():
		if CoreBridge.is_time_attack_clear_screen() and (frame_input & CoreBridge.START_BUTTON or frame_input & CoreBridge.A_BUTTON):
			CoreBridge.clear_replay()
		return

	if CoreBridge.is_chaos_emeralds_screen():
		# missing_emeralds.c handles this message automatically without input.
		return

	if CoreBridge.is_missing_emeralds_screen():
		# missing_emeralds.c advances automatically and has no input handler.
		return

	if CoreBridge.is_to_be_continued_screen():
		# The ending sequence advances automatically in the original.
		return

	if CoreBridge.is_sega_logo_screen():
		if CoreBridge.can_skip_sega_logo() and (frame_input & CoreBridge.START_BUTTON or frame_input & CoreBridge.A_BUTTON):
			CoreBridge.skip_sega_logo()
		return

	if CoreBridge.is_sonic_team_logo_screen():
		if CoreBridge.can_skip_sonic_team_logo() and (frame_input & CoreBridge.START_BUTTON or frame_input & CoreBridge.A_BUTTON):
			CoreBridge.skip_sonic_team_logo()
		return

	if CoreBridge.is_credits_screen():
		# credits.c only accepts START for the replay skip path; slides advance automatically.
		if CoreBridge.can_skip_credits() and frame_input & CoreBridge.START_BUTTON:
			CoreBridge.skip_credits()
		return

	if CoreBridge.is_copyright_screen():
		# Credits End and Copyright are automatic in credits_end.c.
		return

	if CoreBridge.is_credits_end_screen():
		# The original sequence has no input handler; it advances on its timer.
		return

	if CoreBridge.is_character_unlock_screen():
		if frame_input & CoreBridge.START_BUTTON:
			CoreBridge.fast_forward_character_unlock()
		return

	if CoreBridge.is_special_stage_screen():
		# special_stage/main.c handles the paused menu before the global
		# START toggle, so A/Up/Down take precedence while paused.
		if CoreBridge.is_special_stage_paused():
			# The source checks Up and Down independently (Down wins if both
			# are pressed), then consumes cursor movement before A and ignores B.
			if frame_input & CoreBridge.DPAD_UP:
				CoreBridge.move_special_stage_pause_selection(-1)
			if frame_input & CoreBridge.DPAD_DOWN:
				CoreBridge.move_special_stage_pause_selection(1)
				return
			if frame_input & CoreBridge.DPAD_UP:
				return
			if frame_input & CoreBridge.A_BUTTON:
				CoreBridge.confirm_special_stage_pause_selection()
			return
		if frame_input & CoreBridge.START_BUTTON:
			CoreBridge.toggle_special_stage_pause()
		elif frame_input & CoreBridge.A_BUTTON:
			# The original only consumes A during result scoring; the entry
			# sequence advances automatically and ignores A.
			if CoreBridge.is_special_stage_results_screen():
				CoreBridge.advance_special_stage_screen()
		return

	if CoreBridge.is_game_over_screen():
		if frame_input & CoreBridge.START_BUTTON or frame_input & CoreBridge.A_BUTTON:
			CoreBridge.accept_game_over()
		if frame_input & CoreBridge.B_BUTTON or frame_input & CoreBridge.SELECT_BUTTON:
			CoreBridge.cancel_game_over()
		return

	if CoreBridge.is_paused():
		# The source checks confirmation before cursor movement. This also
		# prevents A+Down from quitting when Continue was focused.
		if frame_input & CoreBridge.START_BUTTON:
			CoreBridge.resume_game()
			return
		if frame_input & CoreBridge.A_BUTTON:
			# pause_menu.c confirms A on release; advance_ui_timers handles it.
			return
		if frame_input & CoreBridge.B_BUTTON and (CoreBridge.is_time_attack_run() or CoreBridge.is_multiplayer_run()):
			# pause_menu.c handles multiplayer/Time Attack B before cursor movement.
			CoreBridge.cancel_pause_selection()
			return
		if frame_input & CoreBridge.DPAD_UP:
			CoreBridge.move_pause_selection(-1)
		elif frame_input & CoreBridge.DPAD_DOWN:
			CoreBridge.move_pause_selection(1)
		if frame_input & CoreBridge.B_BUTTON:
			CoreBridge.cancel_pause_selection()
		return

func _get_menu_frame_input(delta: float) -> int:
	var menu_frame_input := _frame_input
	var direction_held := _held_input & MENU_REPEAT_DIRECTIONS
	var direction_pressed := _frame_input & MENU_REPEAT_DIRECTIONS
	if direction_held == 0:
		_menu_repeat_timer = 0.0
	elif direction_pressed != 0:
		_menu_repeat_timer = MENU_REPEAT_START_DELAY
	else:
		_menu_repeat_timer -= delta
		if _menu_repeat_timer <= 0.0:
			_menu_repeat_timer += MENU_REPEAT_INTERVAL
			menu_frame_input |= direction_held

	if not CoreBridge.is_name_entry_screen():
		_menu_action_repeat_timer = 0.0
		return menu_frame_input
	var action_held := _held_input & MENU_REPEAT_ACTIONS
	var action_pressed := _frame_input & MENU_REPEAT_ACTIONS
	if action_held == 0:
		_menu_action_repeat_timer = 0.0
	elif action_pressed != 0:
		_menu_action_repeat_timer = MENU_ACTION_REPEAT_START_DELAY
	else:
		_menu_action_repeat_timer -= delta
		if _menu_action_repeat_timer <= 0.0:
			_menu_action_repeat_timer += MENU_ACTION_REPEAT_INTERVAL
			menu_frame_input |= action_held
	return menu_frame_input

func get_held_input() -> int:
	return _held_input

func get_frame_input() -> int:
	return _frame_input

func set_touch_button_pressed(bit: int, pressed: bool) -> void:
	if pressed:
		_touch_held_input |= bit
		_touch_frame_input |= bit
	else:
		_touch_held_input &= ~bit

func tap_touch_button(bit: int) -> void:
	_touch_frame_input |= bit

func clear_touch_input() -> void:
	_touch_held_input = 0
	_touch_frame_input = 0

func reset_input() -> void:
	_held_input = 0
	_frame_input = 0
	_prev_input = 0
	_fallback_held_input = 0
	_fallback_frame_input = 0
	_touch_held_input = 0
	_touch_frame_input = 0
