class_name ChaosEmeraldProgressionSystem
extends RefCounted

## Owns per-character Chaos Emerald mask storage and zone indexing.

static func selected_mask(masks: Array, character_index: int) -> int:
	if masks.is_empty():
		return 0
	var index := clampi(character_index, 0, masks.size() - 1)
	return clampi(int(masks[index]), 0, 127)

static func set_selected_mask(masks: Array, character_index: int, mask: int) -> int:
	if masks.is_empty():
		masks.append_array([0, 0, 0, 0, 0])
	var index := clampi(character_index, 0, masks.size() - 1)
	var sanitized := clampi(mask, 0, 127)
	masks[index] = sanitized
	return sanitized

static func count(mask: int) -> int:
	var total := 0
	for i in range(7):
		if (mask & (1 << i)) != 0:
			total += 1
	return total

static func selected_zone(level_index: int) -> int:
	return clampi(int(level_index / 2), 0, 6)
