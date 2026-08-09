extends RefCounted
class_name IntroSourceArtView

const SOURCE_TILEMAP_TEXTURE := preload("res://scripts/SourceTilemapTexture.gd")

var background: TextureRect = null
var clouds: TextureRect = null
var source_cache: Dictionary = {}

func setup(screen: Node) -> void:
	background = _create_texture(screen, "OriginalFinalEndingFallBackground", -5)
	clouds = _create_texture(screen, "OriginalFinalEndingFallClouds", -4)

func _create_texture(screen: Node, node_name: String, layer_index: int) -> TextureRect:
	var node := TextureRect.new()
	node.name = node_name
	node.position = Vector2(176.0, 188.0)
	node.size = Vector2(928.0, 464.0)
	node.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	node.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	node.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	node.z_index = layer_index
	screen.add_child(node)
	return node

func update() -> void:
	var final_mode := CoreBridge.is_final_intro_screen()
	if background:
		background.visible = final_mode
	if clouds:
		clouds.visible = final_mode
	if not final_mode:
		return
	var sources: Array = CoreBridge.get_final_intro_source_tilemaps()
	if sources.size() < 2:
		return
	for source in sources:
		if not source_cache.has(source):
			source_cache[source] = SOURCE_TILEMAP_TEXTURE.compose(str(source), 32)
	if background:
		background.texture = source_cache[sources[0]] as Texture2D
	if clouds:
		clouds.texture = source_cache[sources[1]] as Texture2D

func set_visible(screen_visible: bool) -> void:
	if background:
		background.visible = screen_visible and CoreBridge.is_final_intro_screen()
	if clouds:
		clouds.visible = screen_visible and CoreBridge.is_final_intro_screen()
