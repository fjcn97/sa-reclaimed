# WorldRenderer.gd
# Syncs the Godot scene tree with the lightweight gameplay bridge.
extends Node

const ENTITY_SCENE := preload("res://scenes/EntitySprite.tscn")

@export var tile_map_fg: TileMapLayer = null
@export var tile_map_bg: TileMapLayer = null
@export var parallax: ParallaxBackground = null
@export var player_path: NodePath = NodePath("../Player")
@export var camera_path: NodePath = NodePath("../Camera2D")

var _player: Node2D = null
var _camera: Camera2D = null
var _entity_nodes: Array = []

func _ready() -> void:
	set_physics_process(true)
	_player = get_node_or_null(player_path)
	_camera = get_node_or_null(camera_path)
	if _camera == null:
		_camera = get_viewport().get_camera_2d()
	_rebuild_entities()

func _physics_process(_delta: float) -> void:
	sync_from_engine()

func sync_from_engine() -> void:
	var cam_state = CoreBridge.get_camera_state()
	if _camera == null:
		_camera = get_viewport().get_camera_2d()
	if _camera:
		_camera.global_position = Vector2(cam_state.x, cam_state.y)

	var state = CoreBridge.get_player_state()
	if _player:
		_player.global_position = Vector2(state.world_x, state.world_y)

	_sync_entities()

func load_level(_level_id: int) -> void:
	CoreBridge.init_level(_level_id)
	_rebuild_entities()
	sync_from_engine()

func _rebuild_entities() -> void:
	for node in _entity_nodes:
		if is_instance_valid(node):
			node.queue_free()
	_entity_nodes.clear()

	for entity_state in CoreBridge.get_entities():
		var view := ENTITY_SCENE.instantiate()
		add_child(view)
		view.bind_state(entity_state)
		_entity_nodes.append(view)

func _sync_entities() -> void:
	var entities = CoreBridge.get_entities()
	if entities.size() != _entity_nodes.size():
		_rebuild_entities()
		entities = CoreBridge.get_entities()

	for i in range(entities.size()):
		var entity_state = entities[i]
		var view: Node = _entity_nodes[i]
		view.bind_state(entity_state)
