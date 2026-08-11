# Recreates the original stage/menu blend as a screen-wide transition layer.
extends CanvasLayer

@export var state_bridge_path: NodePath = NodePath("/root/CoreBridge")

var _overlay: ColorRect = null
var _bridge: Node = null

func _ready() -> void:
	layer = 200
	_bridge = get_node_or_null(state_bridge_path)
	_overlay = ColorRect.new()
	_overlay.name = "Overlay"
	_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_overlay.color = Color.BLACK
	add_child(_overlay)
	set_process(true)

func _process(_delta: float) -> void:
	if _overlay == null:
		return
	if _bridge == null:
		_bridge = get_node_or_null(state_bridge_path)
		if _bridge == null:
			return
	_overlay.color = Color(0.01, 0.01, 0.02, _bridge.get_screen_fade_alpha())
