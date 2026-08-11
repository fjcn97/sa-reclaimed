class_name EntityCollectibleRenderer
extends RefCounted

static func draw_ring(canvas: CanvasItem) -> void:
	canvas.draw_circle(Vector2.ZERO, 11.0, Color(1.0, 0.82, 0.18))
	canvas.draw_circle(Vector2.ZERO, 5.0, Color(0.96, 0.92, 0.48))

static func draw_special_ring(canvas: CanvasItem) -> void:
	canvas.draw_circle(Vector2.ZERO, 14.0, Color(0.24, 0.80, 0.94))
	canvas.draw_circle(Vector2.ZERO, 7.0, Color(0.72, 0.98, 1.0))
