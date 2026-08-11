class_name TinyChaoGardenState
extends RefCounted

## Owns the Tiny Chao profile plus the transient garden interaction state.

var session_id: String = "TCG-0000"
var unlocked: bool = false
var play_x: float = 0.0
var play_y: float = 0.0
var hunger: int = 50
var mood: int = 50
var fruit: int = 3
var care_count: int = 0
var action_timer: float = 0.0
var action_text: String = "WELCOME TO THE GARDEN"
var selected_index: int = 0
var roster: Array = []

func reset_runtime() -> void:
	session_id = "TCG-0000"
	play_x = 0.0
	play_y = 0.0
	hunger = 50
	mood = 50
	fruit = 3
	care_count = 0
	action_timer = 0.0
	action_text = "WELCOME TO THE GARDEN"
	selected_index = 0

func reset_profile(default_roster: Array) -> void:
	reset_runtime()
	unlocked = false
	roster = default_roster.duplicate(true)

func begin_play() -> void:
	play_x = 0.0
	play_y = 0.0
	action_text = "WELCOME TO THE GARDEN"
	selected_index = clampi(selected_index, 0, max(roster.size() - 1, 0))

func apply_update(next_state: Dictionary) -> bool:
	selected_index = int(next_state.get("selected_index", selected_index))
	play_x = float(next_state.get("play_x", play_x))
	play_y = float(next_state.get("play_y", play_y))
	hunger = int(next_state.get("hunger", hunger))
	mood = int(next_state.get("mood", mood))
	fruit = int(next_state.get("fruit", fruit))
	care_count = int(next_state.get("care", care_count))
	action_timer = float(next_state.get("action_timer", action_timer))
	action_text = str(next_state.get("action_text", action_text))
	return bool(next_state.get("should_return", false))

func apply_selection(selection: Dictionary) -> void:
	hunger = int(selection.get("hunger", hunger))
	mood = int(selection.get("mood", mood))
	care_count = int(selection.get("care", care_count))
