# WorldRenderer.gd
# Syncs the Godot scene tree with the lightweight gameplay bridge.
extends Node

const ENTITY_SCENE := preload("res://scenes/EntitySprite.tscn")

@export var tile_map_fg: TileMapLayer = null
@export var tile_map_bg: TileMapLayer = null
@export var parallax: ParallaxBackground = null
@export var player_path: NodePath = NodePath("../Player")
@export var camera_path: NodePath = NodePath("../Camera2D")
@export var state_bridge_path: NodePath = NodePath("/root/CoreBridge")

var _player: Node2D = null
var _camera: Camera2D = null
var _entity_nodes: Array = []
var _bridge: Node = null

func _ready() -> void:
	set_physics_process(true)
	_bridge = get_node_or_null(state_bridge_path)
	_player = get_node_or_null(player_path)
	_camera = get_node_or_null(camera_path)
	if _camera == null:
		_camera = get_viewport().get_camera_2d()
	_rebuild_entities()

func _physics_process(_delta: float) -> void:
	sync_from_engine()

func sync_from_engine() -> void:
	if _bridge == null:
		_bridge = get_node_or_null(state_bridge_path)
		if _bridge == null:
			return
	var cam_state = _bridge.get_camera_state()
	if _camera == null:
		_camera = get_viewport().get_camera_2d()
	if _camera:
		_camera.global_position = Vector2(cam_state.x, cam_state.y)

	var state = _bridge.get_player_state()
	if _player:
		_player.global_position = Vector2(state.world_x, state.world_y)

	_sync_entities()

func load_level(_level_id: int) -> void:
	if _bridge == null:
		_bridge = get_node_or_null(state_bridge_path)
	if _bridge == null:
		return
	_bridge.init_level(_level_id)
	_rebuild_entities()
	sync_from_engine()

func _rebuild_entities() -> void:
	for node in _entity_nodes:
		if is_instance_valid(node):
			node.queue_free()
	_entity_nodes.clear()

	if _bridge == null:
		return
	for entity_state in _bridge.get_entities():
		var view := ENTITY_SCENE.instantiate()
		add_child(view)
		view.bind_state(entity_state)
		_entity_nodes.append(view)

func _sync_entities() -> void:
	if _bridge == null:
		return
	var entities = _bridge.get_entities()
	if entities.size() != _entity_nodes.size():
		_rebuild_entities()
		entities = _bridge.get_entities()

	for i in range(entities.size()):
		var entity_state = entities[i]
		var view: Node = _entity_nodes[i]
		view.bind_state(entity_state)
