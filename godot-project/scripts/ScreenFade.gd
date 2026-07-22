# Recreates the original stage/menu blend as a screen-wide transition layer.
extends CanvasLayer

var _overlay: ColorRect = null

func _ready() -> void:
	layer = 200
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
	_overlay.color = Color(0.01, 0.01, 0.02, CoreBridge.get_screen_fade_alpha())
