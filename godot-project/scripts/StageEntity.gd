# StageEntity.gd
# Simple debug-friendly entity view for the Godot remake prototype.
extends Node2D
class_name StageEntity

var entity_state = null

func bind_state(state) -> void:
	entity_state = state
	queue_redraw()

func _process(_delta: float) -> void:
	if entity_state == null:
		visible = false
		return

	visible = entity_state.active
	if visible:
		global_position = Vector2(entity_state.world_x, entity_state.world_y)
		queue_redraw()

func _draw() -> void:
	if entity_state == null or not entity_state.active:
		return

	match entity_state.type:
		CoreBridge.ENTITY_RING, CoreBridge.ENTITY_SCATTER_RING:
			draw_circle(Vector2.ZERO, 11.0, Color(1.0, 0.82, 0.18))
			draw_circle(Vector2.ZERO, 5.0, Color(0.96, 0.92, 0.48))
		CoreBridge.ENTITY_SPECIAL_RING:
			draw_circle(Vector2.ZERO, 14.0, Color(0.24, 0.80, 0.94))
			draw_circle(Vector2.ZERO, 7.0, Color(0.72, 0.98, 1.0))
		CoreBridge.ENTITY_WHIRLWIND:
			for i in range(4):
				var radius := 18.0 + i * 10.0
				draw_arc(Vector2(0.0, 22.0 - i * 18.0), radius, 0.2, 2.9, 18, Color(0.35, 0.82, 1.0, 0.72), 4.0)
				draw_arc(Vector2(0.0, 22.0 - i * 18.0), radius, 3.35, 6.0, 18, Color(0.72, 0.94, 1.0, 0.48), 3.0)
		CoreBridge.ENTITY_FAN:
			var direction := 1.0 if entity_state.velocity_x >= 0.0 else -1.0
			for i in range(3):
				var y := -24.0 + i * 24.0
				var x := -18.0 if direction > 0.0 else 18.0
				draw_line(Vector2(x, y), Vector2(x + direction * 36.0, y), Color(0.42, 0.84, 1.0, 0.68), 4.0)
				draw_colored_polygon(PackedVector2Array([Vector2(x + direction * 36.0, y), Vector2(x + direction * 24.0, y - 7.0), Vector2(x + direction * 24.0, y + 7.0)]), Color(0.75, 0.96, 1.0, 0.75))
		CoreBridge.ENTITY_SPIKES:
			for i in range(4):
				var x := -18.0 + i * 12.0
				draw_colored_polygon(PackedVector2Array([Vector2(x - 6.0, 8.0), Vector2(x, -10.0), Vector2(x + 6.0, 8.0)]), Color(0.86, 0.90, 0.96, 1.0))
			draw_rect(Rect2(-26.0, 8.0, 52.0, 6.0), Color(0.26, 0.30, 0.40, 1.0))
		CoreBridge.ENTITY_ITEM_BOX:
			var box_broken: bool = bool(entity_state.activated)
			draw_rect(Rect2(-16.0, -16.0, 32.0, 32.0), Color(0.30, 0.34, 0.44, 1.0) if box_broken else Color(0.96, 0.72, 0.16, 1.0))
			draw_rect(Rect2(-11.0, -11.0, 22.0, 22.0), Color(0.10, 0.14, 0.22, 1.0), false, 3.0)
			var box_text := "SH" if entity_state.item_kind == CoreBridge.ITEM_BOX_KIND_SHIELD else ("INV" if entity_state.item_kind == CoreBridge.ITEM_BOX_KIND_INVINCIBILITY else "+%d" % entity_state.variant)
			if not box_broken:
				draw_string(ThemeDB.fallback_font, Vector2(-8.0, 7.0), box_text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 11, Color.WHITE)
			else:
				var icon_y: float = -float(entity_state.effect_offset) - 18.0
				var icon_color := Color(0.34, 0.82, 1.0) if entity_state.item_kind == CoreBridge.ITEM_BOX_KIND_SHIELD else (Color(1.0, 0.84, 0.24) if entity_state.item_kind == CoreBridge.ITEM_BOX_KIND_INVINCIBILITY else Color(1.0, 0.92, 0.48))
				draw_circle(Vector2(0.0, icon_y), 12.0, icon_color)
				draw_string(ThemeDB.fallback_font, Vector2(-10.0, icon_y + 5.0), box_text, HORIZONTAL_ALIGNMENT_CENTER, 20.0, 9, Color(0.08, 0.12, 0.20, 1.0))
		CoreBridge.ENTITY_PROPELLER:
			var active_color := Color(1.0, 0.86, 0.30, 0.92) if entity_state.variant == 1 else Color(0.48, 0.78, 1.0, 0.86)
			for i in range(4):
				var angle := float(i) * PI * 0.5 + (Time.get_ticks_msec() * 0.004)
				var tip := Vector2(cos(angle), sin(angle)) * 54.0
				draw_line(Vector2.ZERO, tip, active_color, 7.0)
				draw_circle(Vector2.ZERO, 10.0, Color(0.16, 0.28, 0.48, 1.0))
			draw_arc(Vector2.ZERO, 64.0, 0.0, TAU, 32, Color(0.50, 0.86, 1.0, 0.30), 2.0)
		CoreBridge.ENTITY_BOOSTER:
			var booster_color := Color(1.0, 0.84, 0.26, 0.92) if not entity_state.activated else Color(1.0, 0.98, 0.70, 1.0)
			draw_rect(Rect2(-18.0, -10.0, 36.0, 20.0), Color(0.12, 0.18, 0.30, 1.0))
			draw_colored_polygon(PackedVector2Array([Vector2(-10.0, -6.0), Vector2(10.0, 0.0), Vector2(-10.0, 6.0)]), booster_color)
		CoreBridge.ENTITY_DASH_RING:
			var ring_color := Color(0.42, 0.92, 1.0, 0.92) if not entity_state.activated else Color(0.76, 0.98, 1.0, 0.52)
			var ring_angle := -PI * 0.5 + float(entity_state.variant) * PI * 0.25
			var arrow_tip := Vector2(cos(ring_angle), sin(ring_angle)) * 22.0
			draw_circle(Vector2.ZERO, 15.0, Color(0.08, 0.18, 0.30, 1.0))
			draw_arc(Vector2.ZERO, 12.0, 0.0, TAU, 24, ring_color, 4.0)
			draw_line(Vector2.ZERO, arrow_tip, ring_color, 4.0)
		CoreBridge.ENTITY_CANNON:
			var barrel_direction := Vector2(cos(entity_state.cannon_angle), sin(entity_state.cannon_angle))
			draw_circle(Vector2.ZERO, 22.0, Color(0.10, 0.14, 0.24, 1.0))
			draw_arc(Vector2.ZERO, 22.0, 0.0, TAU, 24, Color(0.42, 0.54, 0.72, 1.0), 4.0)
			draw_line(Vector2.ZERO, barrel_direction * 34.0, Color(0.82, 0.88, 0.98, 1.0), 10.0)
		CoreBridge.ENTITY_LAUNCHER:
			var launcher_color := Color(0.98, 0.70, 0.24, 1.0) if not entity_state.launcher_active else Color(1.0, 0.92, 0.52, 1.0)
			var launcher_direction: float = float(entity_state.launcher_direction)
			draw_rect(Rect2(-18.0, -12.0, 36.0, 24.0), Color(0.10, 0.16, 0.28, 1.0))
			draw_colored_polygon(PackedVector2Array([Vector2(-12.0, -8.0), Vector2(launcher_direction * 16.0, 0.0), Vector2(-12.0, 8.0)]), launcher_color)
		CoreBridge.ENTITY_PIPE_START, CoreBridge.ENTITY_PIPE_END:
			var pipe_color := Color(0.30, 0.72, 0.90, 0.90) if entity_state.type == CoreBridge.ENTITY_PIPE_START else Color(0.48, 0.88, 0.68, 0.90)
			draw_circle(Vector2.ZERO, 14.0, Color(0.08, 0.16, 0.26, 1.0))
			draw_arc(Vector2.ZERO, 11.0, 0.0, TAU, 20, pipe_color, 4.0)
		CoreBridge.ENTITY_HOOK_RAIL:
			draw_circle(Vector2.ZERO, 10.0, Color(0.14, 0.20, 0.30, 1.0))
			draw_arc(Vector2.ZERO, 9.0, 0.0, TAU, 18, Color(0.82, 0.88, 0.94, 1.0), 3.0)
		CoreBridge.ENTITY_SLIDY_ICE:
			draw_rect(Rect2(-entity_state.width * 0.5, -entity_state.height * 0.5, entity_state.width, entity_state.height), Color(0.52, 0.84, 1.0, 0.20))
			draw_line(Vector2(-entity_state.width * 0.5, 0.0), Vector2(entity_state.width * 0.5, 0.0), Color(0.70, 0.94, 1.0, 0.55), 2.0)
		CoreBridge.ENTITY_LIGHT_BRIDGE:
			var bridge_color := Color(0.42, 0.92, 1.0, 0.82) if entity_state.light_bridge_active else Color(0.20, 0.30, 0.40, 0.34)
			if entity_state.light_bridge_type == 0:
				draw_line(Vector2(-120.0, 0.0), Vector2(120.0, 0.0), bridge_color, 6.0)
			else:
				draw_arc(Vector2.ZERO, 96.0, -PI * 0.5, 0.0, 16, bridge_color, 6.0)
		CoreBridge.ENTITY_SLOWING_SNOW:
			draw_rect(Rect2(-entity_state.width * 0.5, -entity_state.height * 0.5, entity_state.width, entity_state.height), Color(0.86, 0.94, 1.0, 0.28))
			for i in range(3):
				var snow_x: float = -float(entity_state.width) * 0.35 + i * float(entity_state.width) * 0.35
				draw_circle(Vector2(snow_x, 0.0), 4.0, Color(0.92, 0.98, 1.0, 0.74))
		CoreBridge.ENTITY_SPIKE_PLATFORM:
			draw_rect(Rect2(-24.0, 4.0, 48.0, 8.0), Color(0.18, 0.24, 0.34, 1.0))
			if entity_state.activated:
				for i in range(4):
					var spike_x: float = -18.0 + i * 12.0
					draw_colored_polygon(PackedVector2Array([Vector2(spike_x - 6.0, 4.0), Vector2(spike_x, -14.0), Vector2(spike_x + 6.0, 4.0)]), Color(0.92, 0.96, 1.0, 1.0))
		CoreBridge.ENTITY_TURNAROUND_BAR:
			var bar_color := Color(1.0, 0.78, 0.30, 1.0) if not entity_state.activated else Color(1.0, 0.96, 0.62, 1.0)
			draw_line(Vector2(0.0, -22.0), Vector2(0.0, 22.0), Color(0.14, 0.18, 0.28, 1.0), 8.0)
			draw_circle(Vector2.ZERO, 12.0, bar_color)
			draw_line(Vector2(-10.0, -8.0), Vector2(10.0, 8.0), Color(0.16, 0.22, 0.34, 1.0), 3.0)
		CoreBridge.ENTITY_KEYBOARD:
			var keyboard_color := Color(0.96, 0.42, 0.74, 1.0) if not entity_state.activated else Color(1.0, 0.82, 0.94, 1.0)
			draw_rect(Rect2(-entity_state.width * 0.5, -entity_state.height * 0.5, entity_state.width, entity_state.height), Color(0.12, 0.16, 0.28, 1.0))
			if entity_state.keyboard_type == 0:
				draw_line(Vector2(0.0, entity_state.height * 0.35), Vector2(0.0, -entity_state.height * 0.35), keyboard_color, 5.0)
			else:
				draw_line(Vector2(-entity_state.width * 0.35, 0.0), Vector2(entity_state.width * 0.35, 0.0), keyboard_color, 5.0)
		CoreBridge.ENTITY_POLE:
			var pole_color := Color(0.42, 0.76, 0.92, 1.0) if not entity_state.pole_sliding else Color(0.88, 0.96, 1.0, 1.0)
			draw_line(Vector2(0.0, -entity_state.height * 0.5), Vector2(0.0, entity_state.height * 0.5), Color(0.16, 0.24, 0.36, 1.0), 8.0)
			draw_line(Vector2(0.0, -entity_state.height * 0.5), Vector2(0.0, entity_state.height * 0.5), pole_color, 3.0)
		CoreBridge.ENTITY_LIGHT_GLOBE:
			var globe_y := sin(entity_state.light_globe_phase) * 4.0
			draw_circle(Vector2(0.0, globe_y), 13.0, Color(0.18, 0.42, 0.68, 1.0))
			draw_circle(Vector2(0.0, globe_y), 8.0, Color(0.66, 0.92, 1.0, 1.0))
			draw_arc(Vector2(0.0, globe_y), 18.0, 0.0, TAU, 24, Color(0.38, 0.82, 1.0, 0.60), 3.0)
		CoreBridge.ENTITY_WINDUP_STICK:
			var stick_color := Color(0.92, 0.46, 0.32, 1.0) if not entity_state.activated else Color(1.0, 0.82, 0.46, 1.0)
			draw_rect(Rect2(-entity_state.width * 0.5, -entity_state.height * 0.5, entity_state.width, entity_state.height), Color(0.14, 0.18, 0.28, 1.0))
			draw_line(Vector2(-entity_state.width * 0.42, 0.0), Vector2(entity_state.width * 0.42, 0.0), stick_color, 6.0)
			draw_circle(Vector2(-entity_state.width * 0.35, 0.0), 5.0, stick_color)
			draw_circle(Vector2(entity_state.width * 0.35, 0.0), 5.0, stick_color)
		CoreBridge.ENTITY_GERMAN_FLUTE:
			var flute_color := Color(0.42, 0.84, 0.72, 1.0) if not entity_state.activated else Color(0.84, 1.0, 0.78, 1.0)
			draw_rect(Rect2(-16.0, -5.0, 32.0, 10.0), Color(0.12, 0.24, 0.28, 1.0))
			draw_line(Vector2(-14.0, 0.0), Vector2(14.0, 0.0), flute_color, 4.0)
			for i in range(4):
				draw_circle(Vector2(-8.0 + i * 5.0, -1.0), 2.0, flute_color)
			if entity_state.activated:
				draw_arc(Vector2(0.0, -22.0), 9.0 + entity_state.german_flute_kind * 3.0, PI, TAU, 12, Color(0.70, 0.96, 1.0, 0.72), 3.0)
		CoreBridge.ENTITY_SMALL_WINDMILL:
			var mill_color := Color(0.96, 0.70, 0.30, 1.0) if not entity_state.activated else Color(1.0, 0.94, 0.60, 1.0)
			draw_circle(Vector2.ZERO, 7.0, Color(0.14, 0.20, 0.30, 1.0))
			for i in range(4):
				var angle: float = float(i) * PI * 0.5 + float(entity_state.small_windmill_angle)
				var tip := Vector2(cos(angle), sin(angle)) * 29.0
				draw_line(Vector2.ZERO, tip, mill_color, 6.0)
			draw_arc(Vector2.ZERO, 34.0, 0.0, TAU, 24, Color(0.48, 0.80, 1.0, 0.38), 2.0)
		CoreBridge.ENTITY_CHORD:
			var chord_color := Color(0.64, 0.42, 0.92, 1.0) if not entity_state.activated else Color(0.94, 0.74, 1.0, 1.0)
			for i in range(6):
				var note_x: float = -20.0 + float(i) * 8.0
				var note_y: float = -absf(sin(float(i) * 0.7 + entity_state.chord_timer * 18.0)) * 10.0
				draw_line(Vector2(note_x, 8.0), Vector2(note_x, note_y), chord_color, 3.0)
				draw_circle(Vector2(note_x, note_y), 4.0, chord_color)
		CoreBridge.ENTITY_HALF_PIPE:
			var pipe_color := Color(0.54, 0.82, 0.96, 0.72) if not entity_state.activated else Color(0.86, 0.96, 1.0, 0.94)
			var points := PackedVector2Array()
			for i in range(17):
				var t: float = float(i) / 16.0
				points.append(Vector2(-entity_state.width * 0.5 + t * entity_state.width, entity_state.height * 0.20 - sin(t * PI) * entity_state.height * 0.42))
				draw_polyline(points, pipe_color, 5.0)
		CoreBridge.ENTITY_IRON_BALL:
			draw_circle(Vector2.ZERO, 14.0, Color(0.18, 0.22, 0.30, 1.0))
			draw_circle(Vector2(-4.0, -4.0), 5.0, Color(0.72, 0.78, 0.86, 0.9))
			draw_arc(Vector2.ZERO, 14.0, 0.0, TAU, 24, Color(0.46, 0.54, 0.66, 1.0), 3.0)
		CoreBridge.ENTITY_CRANE:
			var hook_offset := Vector2(entity_state.crane_hook_x - entity_state.origin_x, entity_state.crane_hook_y - entity_state.origin_y)
			draw_line(Vector2.ZERO, hook_offset, Color(0.50, 0.58, 0.70, 0.9), 3.0)
			draw_circle(hook_offset, 10.0, Color(0.96, 0.72, 0.28, 1.0) if not entity_state.activated else Color(1.0, 0.94, 0.58, 1.0))
			draw_rect(Rect2(-16.0, -10.0, 32.0, 20.0), Color(0.16, 0.24, 0.36, 1.0))
		CoreBridge.ENTITY_CEILING_SLOPE:
			var slope_color := Color(0.42, 0.72, 0.92, 0.25) if not entity_state.activated else Color(0.82, 0.94, 1.0, 0.65)
			draw_rect(Rect2(-entity_state.width * 0.5, -entity_state.height * 0.5, entity_state.width, entity_state.height), slope_color, false, 2.0)
			var slope_start := Vector2(-entity_state.width * 0.5, entity_state.height * 0.35)
			var slope_end := Vector2(entity_state.width * 0.5, -entity_state.height * 0.35) if entity_state.ceiling_slope_variant == 0 else Vector2(entity_state.width * 0.5, entity_state.height * 0.35)
			draw_line(slope_start, slope_end, slope_color, 4.0)
		CoreBridge.ENTITY_GAPPED_LOOP:
			var loop_color := Color(0.72, 0.48, 0.92, 0.70) if not entity_state.activated else Color(0.94, 0.80, 1.0, 0.96)
			draw_arc(Vector2(-96.0 * float(entity_state.gapped_loop_direction), 96.0), 135.0, PI * 0.10, PI * 0.90, 20, loop_color, 5.0)
			draw_line(Vector2(-32.0 * float(entity_state.gapped_loop_direction), 0.0), Vector2(32.0 * float(entity_state.gapped_loop_direction), 0.0), loop_color, 3.0)
		CoreBridge.ENTITY_FUNNEL_SPHERE:
			var funnel_color := Color(0.54, 0.84, 0.96, 0.68) if not entity_state.activated else Color(0.86, 0.98, 1.0, 0.96)
			draw_circle(Vector2.ZERO, 14.0, Color(0.16, 0.30, 0.44, 1.0))
			draw_circle(Vector2(-4.0, -4.0), 5.0, funnel_color)
			draw_arc(Vector2.ZERO, 22.0, 0.0, PI, 16, funnel_color, 3.0)
			draw_arc(Vector2(0.0, 12.0), 30.0, PI, TAU, 16, Color(0.44, 0.72, 0.88, 0.48), 3.0)
		CoreBridge.ENTITY_MUSIC_ENTRY:
			var entry_color := Color(0.92, 0.50, 0.72, 0.70) if not entity_state.activated else Color(1.0, 0.86, 0.96, 0.96)
			draw_circle(Vector2.ZERO, 16.0, Color(0.14, 0.20, 0.32, 1.0))
			draw_arc(Vector2.ZERO, 14.0, 0.0, TAU, 20, entry_color, 4.0)
			if entity_state.music_entry_pipe:
				draw_line(Vector2(-9.0, 0.0), Vector2(9.0, 0.0), entry_color, 4.0)
			else:
				draw_colored_polygon(PackedVector2Array([Vector2(-10.0, -8.0), Vector2(10.0, 0.0), Vector2(-10.0, 8.0)]), entry_color)
		CoreBridge.ENTITY_DAMAGE_REGION:
			draw_rect(Rect2(-entity_state.width * 0.5, -entity_state.height * 0.5, entity_state.width, entity_state.height), Color(0.96, 0.24, 0.28, 0.16))
			draw_line(Vector2(-entity_state.width * 0.5, -entity_state.height * 0.5), Vector2(entity_state.width * 0.5, entity_state.height * 0.5), Color(1.0, 0.40, 0.36, 0.45), 2.0)
		CoreBridge.ENTITY_DECORATION:
			var deco_color := Color(0.34, 0.84, 0.46, 0.9) if entity_state.decoration_id % 3 == 0 else (Color(0.34, 0.58, 0.92, 0.9) if entity_state.decoration_id % 3 == 1 else Color(0.72, 0.64, 0.44, 0.9))
			if entity_state.decoration_id >= 4:
				draw_circle(Vector2.ZERO, 12.0, deco_color)
			else:
				for i in range(5):
					var petal_angle: float = float(i) * TAU / 5.0
					draw_circle(Vector2(cos(petal_angle), sin(petal_angle)) * 8.0, 5.0, deco_color)
				draw_circle(Vector2.ZERO, 4.0, Color(1.0, 0.82, 0.30, 1.0))
		CoreBridge.ENTITY_GRIND_RAIL:
			var rail_half_width: float = float(entity_state.width) * 0.5
			draw_line(Vector2(-rail_half_width, 0.0), Vector2(rail_half_width, 0.0), Color(0.18, 0.24, 0.34, 1.0), 8.0)
			draw_line(Vector2(-rail_half_width, -2.0), Vector2(rail_half_width, -2.0), Color(0.70, 0.78, 0.88, 1.0), 3.0)
			draw_circle(Vector2(-rail_half_width, 0.0), 6.0, Color(0.44, 0.54, 0.68, 1.0))
			draw_circle(Vector2(rail_half_width, 0.0), 6.0, Color(0.44, 0.54, 0.68, 1.0))
		CoreBridge.ENTITY_GRAVITY_TOGGLE:
			var gravity_color := Color(0.78, 0.42, 1.0, 0.88) if not entity_state.activated else Color(0.92, 0.72, 1.0, 1.0)
			draw_circle(Vector2.ZERO, 26.0, Color(0.14, 0.08, 0.24, 1.0))
			draw_arc(Vector2.ZERO, 22.0, 0.0, TAU, 28, gravity_color, 4.0)
			draw_line(Vector2(-12.0, 0.0), Vector2(12.0, 0.0), gravity_color, 4.0)
			draw_line(Vector2(0.0, -12.0), Vector2(0.0, 12.0), gravity_color, 4.0)
		CoreBridge.ENTITY_BOUNCY_SPRING:
			var bouncy_color := Color(0.92, 0.42, 0.68, 0.92) if not entity_state.activated else Color(1.0, 0.74, 0.86, 1.0)
			draw_rect(Rect2(-22.0, -6.0, 44.0, 12.0), Color(0.18, 0.12, 0.24, 1.0))
			for i in range(3):
				var x := -15.0 + i * 15.0
				draw_line(Vector2(x, 7.0), Vector2(x + 5.0, -7.0), bouncy_color, 4.0)
		CoreBridge.ENTITY_CONVEYOR:
			var conveyor_color := Color(0.28, 0.84, 0.72, 0.92)
			var conveyor_half_width: float = float(entity_state.width) * 0.5
			draw_rect(Rect2(-conveyor_half_width, -8.0, entity_state.width, 16.0), Color(0.08, 0.20, 0.24, 1.0))
			for i in range(4):
				var x: float = -conveyor_half_width + 20.0 + i * 38.0
				var arrow_direction := 1.0 if entity_state.surface_speed >= 0.0 else -1.0
				draw_line(Vector2(x - arrow_direction * 8.0, 0.0), Vector2(x + arrow_direction * 8.0, 0.0), conveyor_color, 3.0)
				draw_colored_polygon(PackedVector2Array([Vector2(x + arrow_direction * 8.0, 0.0), Vector2(x + arrow_direction * 2.0, -5.0), Vector2(x + arrow_direction * 2.0, 5.0)]), conveyor_color)
		CoreBridge.ENTITY_SPRING:
			draw_rect(Rect2(-12.0, -6.0, 24.0, 12.0), Color(0.12, 0.64, 1.0))
			draw_rect(Rect2(-7.0, -14.0, 14.0, 8.0), Color(0.93, 0.2, 0.3))
			draw_rect(Rect2(-9.0, -2.0, 18.0, 4.0), Color(0.95, 0.96, 1.0))
		CoreBridge.ENTITY_ENEMY:
			if entity_state.enemy_profile == 6:
				draw_circle(Vector2.ZERO, 13.0, Color(0.20, 0.36, 0.52, 1.0))
				draw_circle(Vector2.ZERO, 9.0, Color(0.96, 0.56, 0.24, 1.0))
				for i in range(4):
					var angle: float = entity_state.state_timer + float(i) * TAU / 4.0
					var orbit := Vector2(cos(angle), sin(angle)) * 22.0
					draw_circle(orbit, 4.0, Color(0.66, 0.88, 1.0, 0.92))
					draw_line(Vector2.ZERO, orbit, Color(0.46, 0.70, 0.86, 0.46), 2.0)
			else:
				draw_circle(Vector2.ZERO, 12.0, Color(0.95, 0.24, 0.26))
				draw_rect(Rect2(-14.0, 2.0, 28.0, 8.0), Color(0.18, 0.18, 0.2))
				draw_circle(Vector2(-5.0, -3.0), 2.0, Color.WHITE)
				draw_circle(Vector2(5.0, -3.0), 2.0, Color.WHITE)
		CoreBridge.ENTITY_BUZZER:
			var buzzer_color := Color(1.0, 0.40, 0.22) if entity_state.variant == 0 else Color(1.0, 0.78, 0.28)
			draw_circle(Vector2.ZERO, 13.0, Color(0.16, 0.20, 0.30, 1.0))
			draw_circle(Vector2.ZERO, 10.0, buzzer_color)
			draw_line(Vector2(-20.0, 0.0), Vector2(-7.0, 0.0), Color(0.60, 0.86, 1.0, 0.82), 4.0)
			draw_line(Vector2(7.0, 0.0), Vector2(20.0, 0.0), Color(0.60, 0.86, 1.0, 0.82), 4.0)
			draw_circle(Vector2(-4.0, -3.0), 2.0, Color.WHITE)
			draw_circle(Vector2(4.0, -3.0), 2.0, Color.WHITE)
		CoreBridge.ENTITY_BALLOON:
			var balloon_color := Color(0.94, 0.28, 0.42) if entity_state.variant == 0 else Color(1.0, 0.70, 0.26)
			draw_circle(Vector2.ZERO, 17.0, Color(0.16, 0.22, 0.34, 1.0))
			draw_circle(Vector2.ZERO, 13.0, balloon_color)
			draw_line(Vector2(-8.0, 13.0), Vector2(0.0, 23.0), Color(0.72, 0.84, 0.94, 0.85), 3.0)
			draw_line(Vector2(8.0, 13.0), Vector2(0.0, 23.0), Color(0.72, 0.84, 0.94, 0.85), 3.0)
			draw_circle(Vector2(-5.0, -3.0), 2.0, Color.WHITE)
			draw_circle(Vector2(5.0, -3.0), 2.0, Color.WHITE)
		CoreBridge.ENTITY_PROJECTILE:
			draw_circle(Vector2.ZERO, 6.0, Color(0.96, 0.46, 0.24, 0.95))
			draw_circle(Vector2.ZERO, 3.0, Color(1.0, 0.92, 0.48, 1.0))
		CoreBridge.ENTITY_BULLET_BUZZER:
			var bullet_color := Color(0.42, 0.72, 1.0) if entity_state.variant == 0 else Color(1.0, 0.48, 0.30)
			draw_circle(Vector2.ZERO, 14.0, Color(0.12, 0.18, 0.30, 1.0))
			draw_circle(Vector2.ZERO, 10.0, bullet_color)
			draw_arc(Vector2.ZERO, 19.0, 0.0, TAU, 20, Color(0.64, 0.86, 1.0, 0.70), 3.0)
			draw_circle(Vector2(-4.0, -3.0), 2.0, Color.WHITE)
			draw_circle(Vector2(4.0, -3.0), 2.0, Color.WHITE)
		CoreBridge.ENTITY_KOURA:
			var shell_color := Color(0.34, 0.72, 0.48) if not entity_state.activated else Color(0.72, 0.94, 0.54)
			draw_circle(Vector2.ZERO, 16.0, Color(0.12, 0.18, 0.22, 1.0))
			draw_circle(Vector2(0.0, -2.0), 12.0, shell_color)
			draw_line(Vector2(-10.0, 8.0), Vector2(10.0, 8.0), Color(0.82, 0.92, 0.96, 0.90), 3.0)
		CoreBridge.ENTITY_STAR:
			var star_color := Color(1.0, 0.34, 0.40) if entity_state.variant == 0 else Color(0.42, 0.72, 0.96)
			var points := PackedVector2Array()
			for i in range(10):
				var angle := -PI * 0.5 + float(i) * PI / 5.0
				var radius := 18.0 if i % 2 == 0 else 8.0
				points.append(Vector2(cos(angle), sin(angle)) * radius)
			draw_colored_polygon(points, star_color)
			draw_circle(Vector2.ZERO, 4.0, Color(1.0, 0.92, 0.62, 0.95))
		CoreBridge.ENTITY_KIKI:
			var kiki_color := Color(0.66, 0.38, 0.92) if entity_state.variant == 0 else Color(0.98, 0.56, 0.30)
			draw_circle(Vector2.ZERO, 14.0, Color(0.14, 0.16, 0.28, 1.0))
			draw_circle(Vector2.ZERO, 10.0, kiki_color)
			draw_line(Vector2(-9.0, 12.0), Vector2(-14.0, 22.0), kiki_color, 4.0)
			draw_line(Vector2(9.0, 12.0), Vector2(14.0, 22.0), kiki_color, 4.0)
		CoreBridge.ENTITY_KIKI_PROJECTILE:
			draw_circle(Vector2.ZERO, 7.0, Color(0.88, 0.42, 0.98, 0.94))
			draw_circle(Vector2.ZERO, 3.0, Color(1.0, 0.88, 0.68, 1.0))
		CoreBridge.ENTITY_KIKI_PIECE:
			draw_colored_polygon(PackedVector2Array([Vector2(0.0, -9.0), Vector2(8.0, 7.0), Vector2(-8.0, 7.0)]), Color(0.98, 0.54, 0.34, 0.96))
		CoreBridge.ENTITY_BOSS:
			var boss_color := Color(0.92, 0.30, 0.22) if entity_state.hit_timer <= 0.0 else Color(1.0, 0.88, 0.62)
			draw_rect(Rect2(-46.0, -28.0, 92.0, 56.0), Color(0.12, 0.16, 0.24, 1.0))
			draw_rect(Rect2(-38.0, -22.0, 76.0, 44.0), boss_color)
			draw_circle(Vector2(-20.0, -6.0), 6.0, Color(1.0, 0.92, 0.58, 1.0))
			draw_circle(Vector2(20.0, -6.0), 6.0, Color(1.0, 0.92, 0.58, 1.0))
			draw_rect(Rect2(-34.0, 30.0, 22.0, 8.0), Color(0.20, 0.24, 0.34, 1.0))
			draw_rect(Rect2(12.0, 30.0, 22.0, 8.0), Color(0.20, 0.24, 0.34, 1.0))
			var health_ratio := float(entity_state.health) / float(maxi(1, entity_state.max_health))
			draw_rect(Rect2(-42.0, -42.0, 84.0, 5.0), Color(0.16, 0.08, 0.10, 1.0))
			draw_rect(Rect2(-42.0, -42.0, 84.0 * health_ratio, 5.0), Color(0.96, 0.24, 0.20, 1.0))
		CoreBridge.ENTITY_CHECKPOINT:
			var pole_color := Color(0.75, 0.75, 0.8) if not entity_state.activated else Color(0.96, 0.82, 0.2)
			draw_rect(Rect2(-2.0, -36.0, 4.0, 72.0), pole_color)
			draw_rect(Rect2(2.0, -30.0, 18.0, 12.0), Color(0.16, 0.76, 0.34) if not entity_state.activated else Color(0.95, 0.38, 0.16))
			draw_rect(Rect2(-8.0, 30.0, 16.0, 4.0), Color(0.4, 0.28, 0.16))
		CoreBridge.ENTITY_GOAL:
			draw_rect(Rect2(-2.0, -48.0, 4.0, 96.0), Color(0.95, 0.95, 0.96))
			draw_rect(Rect2(-2.0, -48.0, 28.0, 14.0), Color(0.95, 0.84, 0.18))
			draw_rect(Rect2(-2.0, -28.0, 24.0, 10.0), Color(0.16, 0.76, 0.34))
			draw_rect(Rect2(-2.0, -8.0, 18.0, 8.0), Color(0.95, 0.38, 0.16))
			draw_rect(Rect2(-10.0, 44.0, 20.0, 6.0), Color(0.4, 0.28, 0.16))
		CoreBridge.ENTITY_TRAPPED_ANIMAL:
			var animal_color: Color = [Color(0.84, 0.62, 0.38), Color(0.56, 0.78, 0.96), Color(0.92, 0.48, 0.58)][clampi(entity_state.variant, 0, 2)]
			draw_circle(Vector2(0.0, -5.0), 12.0, animal_color)
			draw_circle(Vector2(-5.0, -8.0), 2.5, Color(0.06, 0.10, 0.16))
			draw_circle(Vector2(5.0, -8.0), 2.5, Color(0.06, 0.10, 0.16))
			draw_arc(Vector2(0.0, 0.0), 9.0, 0.2, 2.9, 12, Color(0.98, 0.90, 0.72), 2.0)
			draw_line(Vector2(-7.0, 8.0), Vector2(-10.0, 17.0), animal_color, 4.0)
			draw_line(Vector2(7.0, 8.0), Vector2(10.0, 17.0), animal_color, 4.0)
		_:
			draw_rect(Rect2(-8.0, -8.0, 16.0, 16.0), Color(1.0, 1.0, 1.0))
