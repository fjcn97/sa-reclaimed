extends SceneTree

const ENTITY_STATE := preload("res://scripts/core/EntityState.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var entity = ENTITY_STATE.new()
	_check(entity.type == 0, "Entity state starts with the neutral type")
	_check(entity.active, "Entity state starts active")
	_check(not entity.collected, "Entity state starts uncollected")
	_check(entity.item_kind == 0, "Entity state keeps the ring item default")
	_check(entity.gravity_kind == 2, "Entity state keeps the toggle gravity default")
	entity.world_x = 128.0
	entity.world_y = 64.0
	entity.health = 3
	_check(entity.world_position() == Vector2(128.0, 64.0), "Entity state exposes its world position")
	_check(entity.health == 3, "Entity state remains mutable by the simulation")
	print("ENTITY_STATE_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("ENTITY_STATE_FAIL: " + label)
