extends SceneTree

const ENTITY_STATE := preload("res://scripts/core/EntityState.gd")
const RENDERER := preload("res://scripts/ui/EntityVisualRenderer.gd")
const STAGE_ENTITY := preload("res://scripts/StageEntity.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var state = ENTITY_STATE.new()
	state.world_x = 123.0
	state.world_y = 234.0
	state.active = true

	var renderer = RENDERER.new()
	get_root().add_child(renderer)
	renderer.bind_state(state)
	await process_frame
	await process_frame
	_check(renderer.entity_state == state, "Renderer binds the shared entity state")
	_check(renderer.visible, "Renderer remains visible for an active entity")
	_check(renderer.global_position == Vector2(123.0, 234.0), "Renderer follows entity world coordinates")

	var compatibility_renderer = STAGE_ENTITY.new()
	get_root().add_child(compatibility_renderer)
	compatibility_renderer.bind_state(state)
	await process_frame
	await process_frame
	_check(compatibility_renderer is RENDERER, "StageEntity remains a renderer compatibility alias")
	_check(compatibility_renderer.entity_state == state, "Legacy StageEntity path keeps renderer binding")

	print("ENTITY_VISUAL_RENDERER_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("ENTITY_VISUAL_RENDERER_FAIL: " + label)
