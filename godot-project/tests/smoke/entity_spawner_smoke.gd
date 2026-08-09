extends SceneTree

const SPAWNER := preload("res://scripts/core/EntitySpawner.gd")
const LEVEL_STATE := preload("res://scripts/core/LevelState.gd")
const TYPES := preload("res://scripts/core/EntityTypes.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var level = LEVEL_STATE.new()
	SPAWNER.add_ring_line(level, 100.0, 200.0, 3, 24.0)
	_check(level.entities.size() == 3, "Ring line creates the requested count")
	_check(level.entities[2].world_position() == Vector2(148.0, 200.0), "Ring line applies spacing")

	SPAWNER.add_spring(level, 220.0, 300.0, 99)
	_check(level.entities[3].type == TYPES.ENTITY_SPRING and level.entities[3].variant == 7, "Spring direction is clamped")

	SPAWNER.add_enemy(level, 320.0, 300.0, 280.0, 380.0, 90.0)
	_check(level.entities[4].velocity_x == 90.0 and level.entities[4].patrol_max_x == 380.0, "Enemy spawn applies patrol data")

	SPAWNER.add_boss_for_level(level, 500.0, 300.0, 15)
	_check(level.entities[5].boss_profile == 8 and level.entities[5].max_health == 12, "Boss spawn derives the selected-level profile")

	SPAWNER.add_item_box(level, 600.0, 300.0, 0)
	_check(level.entities[6].item_kind == 0 and level.entities[6].variant == 1, "Item box spawn supplies a safe ring count")

	SPAWNER.add_conveyor(level, 700.0, 300.0, 8.0, 4.0, -1.0)
	_check(level.entities[7].width == 32.0 and level.entities[7].surface_speed == -37.5, "Conveyor spawn clamps geometry and direction")

	print("ENTITY_SPAWNER_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("ENTITY_SPAWNER_FAIL: " + label)
