extends SceneTree

const ITEM_BOX_KINDS := preload("res://scripts/core/ItemBoxKinds.gd")
const TEXTURES := preload("res://scripts/ui/EntitySpriteTextureFactory.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	_check(ITEM_BOX_KINDS.RINGS == 0, "rings payload remains stable")
	_check(ITEM_BOX_KINDS.SHIELD == 1, "shield payload remains stable")
	_check(ITEM_BOX_KINDS.INVINCIBILITY == 2, "invincibility payload remains stable")
	_check(ITEM_BOX_KINDS.ONE_UP == 3, "one-up payload remains stable")
	_check(ITEM_BOX_KINDS.SPEED_UP == 4, "speed-up payload remains stable")
	_check(ITEM_BOX_KINDS.MAGNETIC_SHIELD == 5, "magnetic-shield payload remains stable")
	_check(ITEM_BOX_KINDS.RINGS_RANDOM == 6, "random-ring payload remains stable")
	_check(ITEM_BOX_KINDS.RINGS_5 == 7 and ITEM_BOX_KINDS.RINGS_10 == 8, "fixed ring payloads remain stable")
	var textures := TEXTURES.new()
	_check(textures.item_box_icon_texture(ITEM_BOX_KINDS.SHIELD) != null, "domain shield identifier renders an icon")
	_check(textures.item_box_icon_color(ITEM_BOX_KINDS.MAGNETIC_SHIELD) == Color(0.72, 0.48, 1.0, 1.0), "domain magnetic-shield identifier renders its tint")
	print("ITEM_BOX_KINDS_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("ITEM_BOX_KINDS_FAIL: " + label)
