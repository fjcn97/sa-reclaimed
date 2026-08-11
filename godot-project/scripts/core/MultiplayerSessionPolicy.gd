class_name MultiplayerSessionPolicy
extends RefCounted

## Pure multiplayer-session rules. State ownership remains with the caller;
## this class only derives valid remote character assignments and rank order.
static func refresh_remote_characters(characters: Array, selected_character: int, character_count: int, is_unlocked: Callable) -> Array:
	var resolved: Array = characters.duplicate()
	while resolved.size() < 4:
		resolved.append(resolved.size())
	resolved[0] = selected_character
	var used: Dictionary = {selected_character: true}
	for i in range(1, resolved.size()):
		var candidate := int(resolved[i])
		if used.has(candidate) or not is_unlocked.call(candidate):
			candidate = next_available_character(used, character_count, is_unlocked)
		resolved[i] = candidate
		used[candidate] = true
	return resolved

static func next_available_character(used: Dictionary, character_count: int, is_unlocked: Callable) -> int:
	for i in range(character_count):
		if is_unlocked.call(i) and not used.has(i):
			return i
	return 0

static func rankings(connected: Array, characters: Array, level_index: int, pak_mode: int) -> Array:
	var ranks: Array = [-1, -1, -1, -1]
	var connected_indices: Array = []
	for i in range(connected.size()):
		if bool(connected[i]):
			connected_indices.append(i)
	connected_indices.sort_custom(func(left: Variant, right: Variant) -> bool:
		return _rank_value(int(right), characters, level_index, pak_mode) > _rank_value(int(left), characters, level_index, pak_mode)
	)
	for rank in range(connected_indices.size()):
		ranks[int(connected_indices[rank])] = rank
	return ranks

static func connected_indices(connected: Array) -> Array:
	var indices: Array = []
	for i in range(connected.size()):
		if bool(connected[i]):
			indices.append(i)
	return indices

static func course_result_keys(ranks: Array, connected: Array) -> Dictionary:
	var host_rank := int(ranks[0]) if not ranks.is_empty() else -1
	if host_rank < 0:
		return {"host": "DRAW", "remote": {}}
	var best_remote_rank := 999
	var remote_results: Dictionary = {}
	for i in range(1, connected.size()):
		if not bool(connected[i]):
			continue
		var remote_rank := int(ranks[i]) if i < ranks.size() else -1
		if remote_rank >= 0:
			best_remote_rank = mini(best_remote_rank, remote_rank)
		var result := "DRAW"
		if remote_rank > host_rank:
			result = "WIN"
		elif remote_rank < host_rank:
			result = "LOSS"
		remote_results[i] = result
	var host_result := "DRAW"
	if host_rank < best_remote_rank:
		host_result = "WIN"
	elif host_rank > best_remote_rank and best_remote_rank != 999:
		host_result = "LOSS"
	return {"host": host_result, "remote": remote_results}

static func _rank_value(player_index: int, characters: Array, level_index: int, pak_mode: int) -> int:
	var character_index := clampi(int(characters[player_index]) if player_index < characters.size() else 0, 0, 99)
	return (level_index + 1) * 19 + character_index * 7 + player_index * 5 + pak_mode * 11
