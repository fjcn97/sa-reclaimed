extends SceneTree

const FACTORY := preload("res://scripts/core/EntityFactory.gd")
const LEVEL_STATE := preload("res://scripts/core/LevelState.gd")
const TYPES := preload("res://scripts/core/EntityTypes.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var level = LEVEL_STATE.new()
	var ring = FACTORY.add_entity(level, TYPES.ENTITY_RING, 120.0, 240.0)
	_check(level.entities.size() == 1, "Entity factory appends the new entity")
	_check(ring.type == TYPES.ENTITY_RING and ring.world_position() == Vector2(120.0, 240.0), "Entity factory preserves type and position")
	_check(ring.radius == 14.0 and ring.width == 28.0 and ring.anim_id == 0, "Entity factory configures ring geometry")

	var note = FACTORY.add_entity(level, TYPES.ENTITY_NOTE_BLOCK, 300.0, 180.0)
	_check(note.note_block and note.width == 32.0 and note.height == 24.0, "Entity factory configures note blocks")
	_check(note.anim_id == 584, "Entity factory preserves specialized animation IDs")

	var unknown = FACTORY.add_entity(level, 999, 0.0, 0.0)
	_check(unknown.width == 16.0 and unknown.height == 16.0, "Entity factory supplies safe fallback geometry")
	_check(level.entities.size() == 3, "Entity factory keeps all created entities in level order")

	print("ENTITY_FACTORY_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("ENTITY_FACTORY_FAIL: " + label)
