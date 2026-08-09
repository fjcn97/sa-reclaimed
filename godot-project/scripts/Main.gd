# Main.gd
# Composition root for the remake's gameplay and state-driven presentation.
# Screen scripts still own their rendering/state behavior; this node provides
# one stable registry for scene composition, diagnostics, and future extraction
# into individually packed screen scenes.
extends Node

@onready var _screen_registry: Node = get_node_or_null("ScreenRegistry")

func _ready() -> void:
	if _screen_registry and _screen_registry.has_method("register_screens"):
		_screen_registry.register_screens()

func get_screen(screen_name: String) -> CanvasLayer:
	if _screen_registry == null:
		return null
	return _screen_registry.get_screen(screen_name)

func has_screen(screen_name: String) -> bool:
	return _screen_registry != null and _screen_registry.has_screen(screen_name)

func get_registered_screen_names() -> PackedStringArray:
	if _screen_registry == null:
		return PackedStringArray()
	return _screen_registry.get_registered_screen_names()

func get_screen_count() -> int:
	return _screen_registry.get_screen_count() if _screen_registry else 0
