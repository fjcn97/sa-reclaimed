class_name TinyChaoGardenSystem
extends RefCounted

## Runs the small garden's deterministic input and care simulation.

static func sync_selection(roster: Array, selected_index: int) -> Dictionary:
	if roster.is_empty():
		return {"hunger": 50, "mood": 50, "care": 0}
	var chao: Dictionary = roster[clampi(selected_index, 0, roster.size() - 1)]
	return {
		"hunger": int(chao.get("hunger", 50)),
		"mood": int(chao.get("mood", 50)),
		"care": int(chao.get("care", 0)),
	}

static func update(roster: Array, selected_index: int, play_x: float, play_y: float, hunger: int, mood: int, fruit: int, care: int, action_timer: float, action_text: String, held_input: int, frame_input: int, delta: float, dpad_up: int, dpad_down: int, dpad_left: int, dpad_right: int, a_button: int, b_button: int, select_button: int, start_button: int) -> Dictionary:
	var next_index := selected_index
	var next_x := play_x
	var next_y := play_y
	var next_hunger := hunger
	var next_mood := mood
	var next_fruit := fruit
	var next_care := care
	var next_timer := maxf(0.0, action_timer - delta)
	var next_text := action_text
	var should_return := false
	if frame_input & dpad_up:
		next_index = wrapi(next_index - 1, 0, roster.size())
		var selection := sync_selection(roster, next_index)
		next_hunger = selection.hunger
		next_mood = selection.mood
		next_care = selection.care
		next_text = "SELECTED %s" % roster[next_index].get("name", "CHAO")
	if frame_input & dpad_down:
		next_index = wrapi(next_index + 1, 0, roster.size())
		var selection := sync_selection(roster, next_index)
		next_hunger = selection.hunger
		next_mood = selection.mood
		next_care = selection.care
		next_text = "SELECTED %s" % roster[next_index].get("name", "CHAO")
	if held_input & dpad_left:
		next_x = maxf(-1.0, next_x - delta * 1.7)
	if held_input & dpad_right:
		next_x = minf(1.0, next_x + delta * 1.7)
	if held_input & dpad_up:
		next_y = maxf(-0.55, next_y - delta * 1.2)
	if held_input & dpad_down:
		next_y = minf(0.55, next_y + delta * 1.2)
	next_hunger = maxi(0, next_hunger - (1 if delta > 0.0 and fmod(Time.get_ticks_msec(), 3500.0) < delta * 1000.0 else 0))
	if frame_input & a_button and next_timer <= 0.0 and not roster.is_empty():
		var chao: Dictionary = roster[next_index]
		if next_fruit > 0:
			next_fruit -= 1
			chao["hunger"] = mini(100, int(chao.get("hunger", 0)) + 18)
			chao["mood"] = mini(100, int(chao.get("mood", 0)) + 8)
			next_text = "%s ATE FRUIT" % chao.get("name", "CHAO")
		else:
			chao["mood"] = mini(100, int(chao.get("mood", 0)) + 4)
			next_text = "%s WANTS MORE FRUIT" % chao.get("name", "CHAO")
		chao["care"] = int(chao.get("care", 0)) + 1
		next_hunger = int(chao.get("hunger", next_hunger))
		next_mood = int(chao.get("mood", next_mood))
		next_care = int(chao.get("care", next_care))
		next_timer = 0.7
	should_return = bool(frame_input & b_button or frame_input & select_button or frame_input & start_button)
	return {"selected_index": next_index, "play_x": next_x, "play_y": next_y, "hunger": next_hunger, "mood": next_mood, "fruit": next_fruit, "care": next_care, "action_timer": next_timer, "action_text": next_text, "should_return": should_return}
