extends SceneTree

var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var scene := preload("res://scenes/SaveScreen.tscn").instantiate()
	get_root().add_child(scene)
	_check(scene.get_node_or_null("TitleLabel") != null, "Legacy save scene still loads its menu shell")
	_check(scene.get_node_or_null("PromptLabel") != null, "Legacy save scene keeps its prompt label")
	_check(scene.get_node_or_null("DetailLabel") != null, "Legacy save scene keeps its detail label")
	print("LEGACY_SAVE_SCREEN_CHECKS=3")
	scene.queue_free()
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	if not condition:
		failed = true
		push_error("LEGACY_SAVE_SCREEN_FAIL: " + label)
