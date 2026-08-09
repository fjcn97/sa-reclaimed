extends RefCounted
class_name StageMechanismStateSystem

static func update_spike_platforms(level: LevelState, elapsed_time: float) -> void:
	var phase := fmod(elapsed_time * 60.0, 286.0)
	for entity in level.entities:
		if entity.active and entity.spike_platform:
			entity.spike_platform_phase = phase
			entity.activated = phase >= 185.0 and phase <= 244.0

static func update_keyboards(level: LevelState, delta: float) -> void:
	for entity in level.entities:
		if not entity.active or not entity.keyboard:
			continue
		entity.keyboard_timer = maxf(0.0, entity.keyboard_timer - delta)
		if entity.keyboard_timer <= 0.0:
			entity.activated = false

static func update_light_globes(level: LevelState, delta: float) -> void:
	for entity in level.entities:
		if entity.active and entity.light_globe:
			entity.light_globe_phase = fmod(entity.light_globe_phase + delta * 3.0, TAU)

static func update_windup_sticks(level: LevelState, delta: float) -> void:
	for entity in level.entities:
		if not entity.active or not entity.windup_stick:
			continue
		entity.windup_stick_timer = maxf(0.0, entity.windup_stick_timer - delta)
		if entity.windup_stick_timer <= 0.0:
			entity.activated = false
