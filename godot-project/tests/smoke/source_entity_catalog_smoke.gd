extends SceneTree

const CATALOG := preload("res://scripts/core/SourceEntityCatalog.gd")
const TYPES := preload("res://scripts/core/EntityTypes.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	_check(CATALOG._source_interactable_type("SPECIAL_RING") == TYPES.ENTITY_SPECIAL_RING, "Catalog maps special rings")
	_check(CATALOG._source_interactable_type("PIPE__START") == TYPES.ENTITY_PIPE_START, "Catalog maps pipe starts")
	_check(CATALOG._source_interactable_type("TOGGLE_GRAVITY_DOWN") == TYPES.ENTITY_GRAVITY_TOGGLE, "Catalog maps gravity toggles")
	_check(CATALOG._source_interactable_type("UNKNOWN_SOURCE_KIND") == -1, "Catalog rejects unknown interactables")
	_check(CATALOG._source_gravity_kind("GRAVITY_DOWN") == 0, "Catalog maps downward gravity")
	_check(CATALOG._source_gravity_kind("GRAVITY_UP") == 1, "Catalog maps upward gravity")
	_check(CATALOG._source_spring_variant("SPRING_DOWNRIGHT") == 7, "Catalog maps diagonal springs")
	_check(CATALOG._source_enemy_type("KIKI") == TYPES.ENTITY_KIKI, "Catalog maps Kiki")
	_check(CATALOG._source_enemy_type("NOT_AN_ENEMY") == -1, "Catalog rejects unknown enemies")
	_check(CATALOG._source_item_kind("SHIELD_MAGNETIC") == 5, "Catalog maps magnetic shields")
	_check(CATALOG._source_item_kind("UNKNOWN_ITEM") == 0, "Catalog defaults unknown items to rings")
	print("SOURCE_ENTITY_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("SOURCE_ENTITY_FAIL: " + label)
