extends SceneTree

const BUILDER := preload("res://scripts/core/LevelBuilder.gd")
const TYPES := preload("res://scripts/core/EntityTypes.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var first = BUILDER.build(0, "ZONE 1", false, 0, 90.0)
	_check(first.name == "ZONE 1" and first.max_x == 2400.0, "Level builder initializes stage bounds")
	_check(first.platforms.size() >= 6 and first.entities.size() > 20, "Level builder composes the first stage")
	_check(_has_entity(first, TYPES.ENTITY_GOAL) and not _has_entity(first, TYPES.ENTITY_BOSS), "Normal stages receive a goal")

	var boss = BUILDER.build(0, "ZONE 1", true, 15, 90.0)
	_check(_has_entity(boss, TYPES.ENTITY_BOSS) and not _has_entity(boss, TYPES.ENTITY_GOAL), "Boss mode swaps the goal for a boss")
	_check(_find_entity(boss, TYPES.ENTITY_BOSS).boss_profile == 8, "Level builder passes selected level to boss spawns")

	var second = BUILDER.build(1, "ZONE 2", false, 1, 72.0)
	_check(second.name == "ZONE 2" and _has_entity(second, TYPES.ENTITY_KOURA), "Level builder composes alternate stage content")
	_check(_find_entity(second, TYPES.ENTITY_ENEMY).velocity_x == 72.0, "Level builder passes enemy speed explicitly")

	print("LEVEL_BUILDER_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _has_entity(level, entity_type: int) -> bool:
	return _find_entity(level, entity_type) != null

func _find_entity(level, entity_type: int):
	for entity in level.entities:
		if entity.type == entity_type:
			return entity
	return null

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("LEVEL_BUILDER_FAIL: " + label)
