# ScreenBase.gd
# Shared foundation for the remake's state-driven CanvasLayer screens.
#
# Screen scripts intentionally remain responsible for their presentation and
# CoreBridge state mapping. This class owns only the safe, reusable scene-node
# construction primitives so screen implementations can converge on one UI
# contract without changing their runtime state machine.
class_name ScreenBase
extends CanvasLayer

const VIEWPORT_RECT := Rect2(0.0, 0.0, 1280.0, 720.0)
const UI_NODE_FACTORY := preload("res://scripts/ui/UiNodeFactory.gd")

var screen_time: float = 0.0
@export var state_bridge_path: NodePath = NodePath("/root/CoreBridge")

## Screens resolve their state owner through this boundary so tests and future
## scene composition can provide a bridge without changing the screen script.
func resolve_state_bridge() -> Node:
	return get_node_or_null(state_bridge_path)

func _process(delta: float) -> void:
	screen_time += delta

func ensure_rect(node_name: String, rect: Rect2, color: Color) -> ColorRect:
	return UI_NODE_FACTORY.ensure_rect(self, node_name, rect, color)

func ensure_label(node_name: String, pos: Vector2, size: Vector2, font_size: int) -> Label:
	return UI_NODE_FACTORY.ensure_label(self, node_name, pos, size, font_size)

func resolve_label(current: Label, node_name: String) -> Label:
	if current != null:
		return current
	return get_node_or_null(node_name) as Label

func set_standard_labels(title_label: Label, prompt_label: Label, detail_label: Label) -> Array[Label]:
	return [
		resolve_label(title_label, "TitleLabel"),
		resolve_label(prompt_label, "PromptLabel"),
		resolve_label(detail_label, "DetailLabel"),
	]
