class_name EntityItemBoxRenderer
extends RefCounted

const ITEM_BOX_KINDS := preload("res://scripts/core/ItemBoxKinds.gd")

static func draw(canvas: CanvasItem, state: EntityState) -> void:
	var broken: bool = bool(state.activated)
	canvas.draw_rect(Rect2(-16.0, -16.0, 32.0, 32.0), Color(0.30, 0.34, 0.44, 1.0) if broken else Color(0.96, 0.72, 0.16, 1.0))
	canvas.draw_rect(Rect2(-11.0, -11.0, 22.0, 22.0), Color(0.10, 0.14, 0.22, 1.0), false, 3.0)
	var label := item_label(state)
	if not broken:
		canvas.draw_string(ThemeDB.fallback_font, Vector2(-8.0, 7.0), label, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 11, Color.WHITE)
		return
	var icon_y: float = -float(state.effect_offset) - 18.0
	canvas.draw_circle(Vector2(0.0, icon_y), 12.0, item_color(state))
	canvas.draw_string(ThemeDB.fallback_font, Vector2(-10.0, icon_y + 5.0), label, HORIZONTAL_ALIGNMENT_CENTER, 20.0, 9, Color(0.08, 0.12, 0.20, 1.0))

static func item_label(state: EntityState) -> String:
	match state.item_kind:
		ITEM_BOX_KINDS.SHIELD: return "SH"
		ITEM_BOX_KINDS.MAGNETIC_SHIELD: return "MG"
		ITEM_BOX_KINDS.INVINCIBILITY: return "INV"
		ITEM_BOX_KINDS.ONE_UP: return "1UP"
		ITEM_BOX_KINDS.SPEED_UP: return "SPD"
		ITEM_BOX_KINDS.RINGS_5: return "+5"
		ITEM_BOX_KINDS.RINGS_10: return "+10"
		_: return "+%d" % state.variant

static func item_color(state: EntityState) -> Color:
	match state.item_kind:
		ITEM_BOX_KINDS.SHIELD: return Color(0.34, 0.82, 1.0)
		ITEM_BOX_KINDS.MAGNETIC_SHIELD: return Color(0.72, 0.48, 1.0)
		ITEM_BOX_KINDS.INVINCIBILITY: return Color(1.0, 0.84, 0.24)
		ITEM_BOX_KINDS.SPEED_UP: return Color(1.0, 0.52, 0.20)
		ITEM_BOX_KINDS.ONE_UP: return Color(0.38, 1.0, 0.54)
		_: return Color(1.0, 0.92, 0.48)
