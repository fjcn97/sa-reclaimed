class_name PlayerAbilityState
extends RefCounted

## Owns transient player combat, movement-ability, and protection timers.

var attack_timer: float = 0.0
var flight_timer: float = 0.0
var glide_timer: float = 0.0
var damage_cooldown: float = 0.0
var invincibility_timer: float = 0.0

func reset() -> void:
	attack_timer = 0.0
	flight_timer = 0.0
	glide_timer = 0.0
	damage_cooldown = 0.0
	invincibility_timer = 0.0

func advance(delta: float) -> void:
	attack_timer = maxf(0.0, attack_timer - delta)
	flight_timer = maxf(0.0, flight_timer - delta)
	glide_timer = maxf(0.0, glide_timer - delta)
	damage_cooldown = maxf(0.0, damage_cooldown - delta)
	invincibility_timer = maxf(0.0, invincibility_timer - delta)
