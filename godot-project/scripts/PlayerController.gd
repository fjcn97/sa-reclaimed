# PlayerController.gd
# Reads keyboard/gamepad input and forwards it into the prototype bridge.
extends Node

signal player_state_updated(state)

const ACTION_LEFT   = InputBindings.ACTION_LEFT
const ACTION_RIGHT  = InputBindings.ACTION_RIGHT
const ACTION_UP     = InputBindings.ACTION_UP
const ACTION_DOWN   = InputBindings.ACTION_DOWN
const ACTION_JUMP   = InputBindings.ACTION_JUMP
const ACTION_ATTACK = InputBindings.ACTION_ATTACK
const ACTION_BOOST  = InputBindings.ACTION_BOOST
const ACTION_START  = InputBindings.ACTION_START
const INPUT_DEVICE_SAMPLER := preload("res://scripts/core/InputDeviceSampler.gd")
const IMMEDIATE_MENU_KEY_ROUTER := preload("res://scripts/core/ImmediateMenuKeyRouter.gd")
const MENU_INPUT_REPEATER := preload("res://scripts/core/MenuInputRepeater.gd")
const MENU_INPUT_ROUTER := preload("res://scripts/core/MenuInputRouter.gd")

@export var player_path: NodePath = NodePath("../Player")

var _held_input: int = 0
var _frame_input: int = 0
var _prev_input: int = 0
var _fallback_held_input: int = 0
var _fallback_frame_input: int = 0
var _joypad_axis_input: int = 0
var _touch_held_input: int = 0
var _touch_frame_input: int = 0
var _player: Node2D = null
var _menu_repeater := MENU_INPUT_REPEATER.new()
var _menu_router := MENU_INPUT_ROUTER.new()

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
	var device_held := _fallback_held_input | _touch_held_input | _joypad_axis_input
	# Menus receive keyboard transitions through _input. Do not merge the
	# polled InputMap/physical-key state into that path: a quick key tap can be
	# observed once as an event and again as a polled transition, which causes
	# cursor flashes or an extra menu step. Gameplay retains the full sampler.
	var new_held: int = device_held if not CoreBridge.is_gameplay_active() else InputBindings.sample_action_input(device_held)

	_frame_input = (new_held & ~_prev_input) | _fallback_frame_input | _touch_frame_input
	_held_input = new_held
	_prev_input = new_held

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		_handle_key_event(event)
		# Menu navigation is implemented by MenuInputRouter. Consume mapped
		# desktop keys here so Godot's built-in Control focus navigation cannot
		# also move/focus hidden or visible menu buttons on the same event.
		if INPUT_DEVICE_SAMPLER.key_event_bit(event) != 0:
			get_viewport().set_input_as_handled()
	elif event is InputEventJoypadButton:
		_handle_joypad_event(event)
	elif event is InputEventJoypadMotion:
		_handle_joypad_motion(event)

func _handle_key_event(event: InputEventKey) -> void:
	# The Options overview uses Escape for back. Do not turn X into a menu
	# action there; Name Entry still handles X as a printable character below.
	if (CoreBridge.is_options_main_screen() or CoreBridge.is_player_data_screen() or CoreBridge.is_language_screen() or CoreBridge.is_delete_confirm_screen() or CoreBridge.is_delete_final_confirm_screen()) and event.keycode == KEY_X:
		return
	if IMMEDIATE_MENU_KEY_ROUTER.handle(CoreBridge, event):
			return
	var bit := INPUT_DEVICE_SAMPLER.key_event_bit(event)
	if bit == 0:
		return
	# Always process release events. Some desktop backends can mark a key-up
	# event as an echo; ignoring it leaves the D-pad bit stuck and makes menu
	# repeat continue after the user has released the key.
	if not event.pressed:
		_fallback_held_input &= ~bit
		return
	if event.echo:
		return
	if event.pressed:
		_fallback_held_input |= bit
		_fallback_frame_input |= bit

func _handle_joypad_event(event: InputEventJoypadButton) -> void:
	var bit := INPUT_DEVICE_SAMPLER.joypad_button_bit(event.button_index)
	if bit == 0:
		return
	if event.pressed:
		_fallback_held_input |= bit
		_fallback_frame_input |= bit
	else:
		_fallback_held_input &= ~bit

func _handle_joypad_motion(event: InputEventJoypadMotion) -> void:
	_joypad_axis_input = INPUT_DEVICE_SAMPLER.joypad_axis_bits(
		event,
		_joypad_axis_input,
		CoreBridge.DPAD_LEFT,
		CoreBridge.DPAD_RIGHT,
		CoreBridge.DPAD_UP,
		CoreBridge.DPAD_DOWN
	)

# Compatibility entry points retained for existing smoke tests and tooling.
# Input translation itself lives in InputBindings so gameplay code has one
# canonical mapping.
func _keycode_to_bit(keycode: int) -> int:
	return InputBindings.keycode_to_bit(keycode)

func _joypad_button_to_bit(button_index: int) -> int:
	return InputBindings.joypad_button_to_bit(button_index)

func _poll_physical_keys() -> int:
	return InputBindings.sample_physical_keys()

func _handle_menu_input(frame_input: int) -> void:
	_menu_router.handle(frame_input)

func _get_menu_frame_input(delta: float) -> int:
	return _menu_repeater.sample(delta, _held_input, _frame_input, CoreBridge.is_name_entry_screen())

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
	_menu_repeater.reset()

func reset_input() -> void:
	_held_input = 0
	_frame_input = 0
	_prev_input = 0
	_fallback_held_input = 0
	_fallback_frame_input = 0
	_joypad_axis_input = 0
	_touch_held_input = 0
	_touch_frame_input = 0
