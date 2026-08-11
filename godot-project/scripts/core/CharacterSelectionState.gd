class_name CharacterSelectionState
extends RefCounted

## Owns the selected roster entry and the context in which it is being picked.

var selected_index: int = 0
var context: int = 0

func reset() -> void:
	selected_index = 0
	context = 0

func open(selection: int, selection_context: int, character_count: int) -> void:
	selected_index = clampi(selection, 0, maxi(character_count - 1, 0))
	context = selection_context

func move(direction: int, available_indices: Array) -> void:
	if available_indices.is_empty():
		return
	var current_slot := available_indices.find(selected_index)
	if current_slot < 0:
		current_slot = 0
	selected_index = int(available_indices[wrapi(current_slot + direction, 0, available_indices.size())])

func is_context(expected_context: int) -> bool:
	return context == expected_context
