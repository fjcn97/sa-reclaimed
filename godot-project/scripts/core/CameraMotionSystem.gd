class_name CameraMotionSystem
extends RefCounted

var camera_state: CameraState = CameraState.new()
var _shake_amplitude: float = 0.0
var _shake_decay: float = 0.0
var _shake_phase: float = 0.0
var _shake_phase_speed: float = 0.0
var _shake_timer: float = 0.0
var _shake_horizontal: bool = true
var _shake_vertical: bool = true
var _shake_random: bool = false
var _shake_offset: Vector2 = Vector2.ZERO

func update_camera(level: LevelState, player: PlayerState, viewport: Vector2) -> void:
	camera_state.min_x = level.min_x
	camera_state.max_x = level.max_x
	camera_state.min_y = level.min_y
	camera_state.max_y = level.max_y
	var camera_target_x := player.world_x
	if player.super_sonic:
		camera_target_x += clampf(player.speed_x * 0.18, -144.0, 144.0)
	camera_state.x = clamp(camera_target_x, viewport.x * 0.5, level.max_x - viewport.x * 0.5) + _shake_offset.x
	camera_state.y = clamp(player.world_y - 120.0, viewport.y * 0.5, level.max_y - viewport.y * 0.5) + _shake_offset.y

func request_shake(amplitude: float, duration: float, phase_speed: float, horizontal: bool, vertical: bool, random_value: bool) -> void:
	_shake_amplitude = maxf(_shake_amplitude, amplitude)
	_shake_decay = amplitude / maxf(duration, 0.01)
	_shake_phase = 0.0
	_shake_phase_speed = phase_speed * TAU
	_shake_timer = maxf(_shake_timer, duration)
	_shake_horizontal = horizontal
	_shake_vertical = vertical
	_shake_random = random_value

func update_shake(delta: float) -> void:
	if _shake_timer <= 0.0:
		_shake_offset = Vector2.ZERO
		return
	_shake_timer = maxf(0.0, _shake_timer - delta)
	_shake_amplitude = maxf(0.0, _shake_amplitude - _shake_decay * delta)
	_shake_phase += _shake_phase_speed * delta
	var factor := randf_range(-1.0, 1.0) if _shake_random else sin(_shake_phase)
	var offset := factor * _shake_amplitude
	_shake_offset = Vector2(offset if _shake_horizontal else 0.0, offset if _shake_vertical else 0.0)
	if _shake_timer <= 0.0:
		clear_shake()

func clear_shake() -> void:
	_shake_amplitude = 0.0
	_shake_decay = 0.0
	_shake_phase = 0.0
	_shake_phase_speed = 0.0
	_shake_timer = 0.0
	_shake_offset = Vector2.ZERO

func get_shake_offset() -> Vector2:
	return _shake_offset
