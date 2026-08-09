extends SceneTree

const ENTITY_STATE := preload("res://scripts/core/EntityState.gd")
const ENTITY_TYPES := preload("res://scripts/core/EntityTypes.gd")
const TEXTURE_FACTORY := preload("res://scripts/ui/EntitySpriteTextureFactory.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var entity_scene = load("res://scenes/EntitySprite.tscn")
	var factory = TEXTURE_FACTORY.new()
	_check(factory.make_ring_texture() != null, "Texture factory creates ring textures")
	_check(factory.make_item_box_texture() != null, "Texture factory creates item-box textures")
	_check(factory.item_box_icon_texture(CoreBridge.ITEM_BOX_KIND_SHIELD) != null, "Texture factory creates item icons")

	var sprite = entity_scene.instantiate()
	get_root().add_child(sprite)
	var state = ENTITY_STATE.new()
	state.type = ENTITY_TYPES.ENTITY_RING
	state.world_x = 96.0
	state.world_y = 48.0
	sprite.bind_state(state)
	await process_frame
	await process_frame
	_check(sprite.get_node("Body").texture != null, "EntitySprite applies the extracted ring texture")
	_check(sprite.global_position == Vector2(96.0, 48.0), "EntitySprite preserves world positioning")

	state.type = ENTITY_TYPES.ENTITY_ITEM_BOX
	state.item_kind = CoreBridge.ITEM_BOX_KIND_SPEED_UP
	sprite.bind_state(state)
	await process_frame
	await process_frame
	_check(sprite.get_node("Body").texture != null, "EntitySprite updates visuals through the texture factory")
	_check(sprite.get_node("Overlay").texture != null, "EntitySprite applies the item icon overlay")

	print("ENTITY_SPRITE_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("ENTITY_SPRITE_FAIL: " + label)
