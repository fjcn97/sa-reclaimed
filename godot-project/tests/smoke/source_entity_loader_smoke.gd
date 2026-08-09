extends SceneTree

const LOADER := preload("res://scripts/core/SourceEntityLoader.gd")
const LEVEL_STATE := preload("res://scripts/core/LevelState.gd")
const PLAYER_STATE := preload("res://scripts/core/PlayerState.gd")
const TYPES := preload("res://scripts/core/EntityTypes.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var level = LEVEL_STATE.new()
	level.spawn_y = 448.0
	level.max_x = 1280.0
	level.max_y = 720.0
	var manifest := {
		"valid": true,
		"region_width": 2,
		"region_height": 2,
		"terrain": {"valid": false},
		"entities": {
			"rings": [{"world_x": 96, "world_y": 655}],
			"itemboxes": [{"world_x": 160, "world_y": 640, "kind": "SHIELD"}],
			"enemies": [{"world_x": 240, "world_y": 640, "kind": "BUZZER", "fields": []}],
			"interactables": [
				{"world_x": 320, "world_y": 640, "kind": "SPECIAL_RING"},
				{"world_x": 400, "world_y": 640, "kind": "FAN_PERIODIC_LEFT"},
				{"world_x": 480, "world_y": 640, "kind": "GOAL"}
			]
		}
	}
	LOADER.new().apply(level, manifest, PLAYER_STATE.new(), 12.5)

	_check(level.entities.size() == 6, "Source loader creates all mapped records")
	_check(level.entities[0].type == TYPES.ENTITY_RING and level.entities[0].world_x == 180.0, "Source loader applies source runtime position")
	_check(level.entities[1].type == TYPES.ENTITY_ITEM_BOX and level.entities[1].item_kind == 1, "Source loader maps item kinds")
	_check(level.entities[2].type == TYPES.ENTITY_BUZZER and level.entities[2].velocity_x == 45.0, "Source loader delegates enemy configuration")
	_check(level.entities[3].type == TYPES.ENTITY_SPECIAL_RING, "Source loader maps interactable catalog entries")
	_check(level.entities[4].fan_speed == 1.0 and level.entities[4].velocity_x == -1.0, "Source loader configures fan direction")
	_check(level.entities[5].type == TYPES.ENTITY_GOAL, "Source loader maps goals")

	print("SOURCE_ENTITY_LOADER_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("SOURCE_ENTITY_LOADER_FAIL: " + label)
