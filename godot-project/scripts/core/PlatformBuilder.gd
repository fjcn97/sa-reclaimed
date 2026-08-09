class_name PlatformBuilder

extends RefCounted

static func add_platform(level: LevelState, x: float, y: float, width: float, thickness: float) -> void:
	var platform := PlatformState.new()
	platform.x1 = x
	platform.x2 = x + width
	platform.bottom_y = y
	platform.top_y = y - thickness
	platform.thickness = thickness
	platform.slope_start_y = platform.top_y
	platform.slope_end_y = platform.top_y
	level.platforms.append(platform)

static func add_sloped_platform(level: LevelState, x1: float, y1: float, x2: float, y2: float, thickness: float, collision_layer: int = -1) -> void:
	var platform := PlatformState.new()
	platform.x1 = minf(x1, x2)
	platform.x2 = maxf(x1, x2)
	platform.top_y = y1 if x1 <= x2 else y2
	platform.bottom_y = platform.top_y + thickness
	platform.thickness = thickness
	platform.sloped = not is_equal_approx(y1, y2)
	platform.slope_start_y = y1 if x1 <= x2 else y2
	platform.slope_end_y = y2 if x1 <= x2 else y1
	platform.collision_layer = collision_layer
	level.platforms.append(platform)

static func add_crumbling_platform(level: LevelState, x: float, y: float, width: float, thickness: float, delay: float = 0.5) -> void:
	add_platform(level, x, y, width, thickness)
	var platform: PlatformState = level.platforms.back()
	platform.crumble_delay = maxf(0.1, delay)

static func add_moving_platform(level: LevelState, x: float, y: float, width: float, thickness: float, axis: int, amplitude: float, speed: float, phase: float = 0.0) -> void:
	add_platform(level, x, y, width, thickness)
	var platform: PlatformState = level.platforms.back()
	platform.moving = true
	platform.motion_axis = 1 if axis != 0 else 0
	platform.motion_amplitude = maxf(0.0, amplitude)
	platform.motion_speed = speed
	platform.motion_phase = phase
