extends SceneTree

const SourceTilemapTextureImpl = preload("res://scripts/SourceTilemapTexture.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var credits := SourceTilemapTextureImpl.compose("credits_0")
	_check(credits != null, "credits source tilemap composes")
	if credits:
		_check(credits.get_width() == 240 and credits.get_height() == 160, "credits tilemap is 30x20")
	var notification := SourceTilemapTextureImpl.compose("collect_all_chaos_emeralds_en")
	_check(notification != null, "missing emerald source card composes")
	if notification:
		_check(notification.get_width() == 240 and notification.get_height() == 48, "notification tilemap is 30x6")
	var unlock := SourceTilemapTextureImpl.compose("unlocked_tiny_chao_garden_en")
	_check(unlock != null, "unlock source card composes")
	if unlock:
		_check(unlock.get_width() == 240 and unlock.get_height() == 56, "unlock tilemap is 30x7")
	print("SOURCE_TILEMAP_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("SOURCE_TILEMAP_FAIL: " + label)
