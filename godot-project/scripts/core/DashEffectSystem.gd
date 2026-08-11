class_name DashEffectSystem
extends RefCounted

## Applies active dash kinematics before the normal movement branches.

static func advance(bridge: Object, delta: float) -> bool:
	var dash = bridge.get_dash_effect_state()
	var player: PlayerState = bridge.get_player_state()
	if dash.dash_timer <= 0.0:
		return false
	dash.dash_timer = maxf(0.0, dash.dash_timer - delta)
	player.is_grounded = false
	player.world_x += dash.dash_velocity_x * delta
	player.speed_x = dash.dash_velocity_x
	bridge.get_gameplay_runtime_state().velocity_y = dash.dash_velocity_y
	return true
