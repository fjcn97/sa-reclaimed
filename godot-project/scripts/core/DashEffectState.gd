class_name DashEffectState
extends RefCounted

## Owns active dash kinematics and the visual boost trail cache.

var dash_timer: float = 0.0
var dash_velocity_x: float = 0.0
var dash_velocity_y: float = 0.0
var boost_effect_timer: float = 0.0
var boost_position_history: Array[Vector2] = []

func reset() -> void:
	dash_timer = 0.0
	dash_velocity_x = 0.0
	dash_velocity_y = 0.0
	boost_effect_timer = 0.0
	boost_position_history.clear()

func seed_trail(position: Vector2, size: int = 16) -> void:
	boost_position_history.clear()
	for _index in range(size):
		boost_position_history.append(position)

func record_trail(position: Vector2, size: int = 16) -> void:
	boost_position_history.push_front(position)
	while boost_position_history.size() > size:
		boost_position_history.pop_back()
