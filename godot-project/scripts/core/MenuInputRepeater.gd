# Menu navigation is edge-triggered for desktop input. A direction press must
# produce one menu step; holding a key must not cycle the cursor indefinitely.
extends RefCounted
class_name MenuInputRepeater

func sample(_delta: float, _held_input: int, frame_input: int, _name_entry_active: bool) -> int:
	# Menus are edge-triggered. Returning only the sampled frame prevents a
	# held Enter/A key from immediately acting again after opening Name Entry.
	return frame_input

func reset() -> void:
	pass
