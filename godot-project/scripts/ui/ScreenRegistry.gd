# ScreenRegistry.gd
# Discovers presentation CanvasLayers owned by the Main composition root.
class_name ScreenRegistry
extends Node

const NON_SCREEN_LAYER_NAMES := {
	"ScreenFade": true,
	"HUD": true,
	"TouchControls": true,
}

var _screen_layers: Dictionary = {}

func register_screens() -> void:
	_screen_layers.clear()
	var composition_root := get_parent()
	if composition_root == null:
		return
	_collect_screens(composition_root)

func _collect_screens(parent: Node) -> void:
	for child in parent.get_children():
		if child is CanvasLayer and not NON_SCREEN_LAYER_NAMES.has(child.name):
			_screen_layers[child.name] = child as CanvasLayer
		_collect_screens(child)

func get_screen(screen_name: String) -> CanvasLayer:
	return _screen_layers.get(screen_name) as CanvasLayer

func has_screen(screen_name: String) -> bool:
	return _screen_layers.has(screen_name)

func get_registered_screen_names() -> PackedStringArray:
	var names := PackedStringArray()
	for screen_name in _screen_layers.keys():
		names.append(str(screen_name))
	names.sort()
	return names

func get_screen_count() -> int:
	return _screen_layers.size()
