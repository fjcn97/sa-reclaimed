# LevelState.gd
# Runtime container for stage bounds, terrain, and entities.
class_name LevelState
extends RefCounted

var level_id: int = 0
var name: String = ""
var spawn_x: float = 0.0
var spawn_y: float = 0.0
var ground_y: float = 0.0
var min_x: float = 0.0
var max_x: float = 0.0
var min_y: float = 0.0
var max_y: float = 0.0
var platforms: Array = []
var entities: Array = []
