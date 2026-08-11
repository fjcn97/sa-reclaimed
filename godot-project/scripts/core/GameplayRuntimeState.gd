class_name GameplayRuntimeState
extends RefCounted

## Mutable run-scoped physics and traversal data. Player, level, checkpoint,
## ability and visual-effect state are owned by their dedicated models.
var frame_input: int = 0
var spindash_charging: bool = false
var spindash_charge: float = 0.0
var spindash_release_timer: float = 0.0
var spindash_velocity_x: float = 0.0
var facing_direction: float = 1.0
var braking_dust_cooldown: float = 0.0
var velocity_y: float = 0.0
var elapsed_time: float = 0.0
var move_speed: float = 230.0
var jump_speed: float = 435.0
var gravity: float = 1060.0
var spring_jump_speed: float = 560.0
var enemy_speed: float = 90.0
var ring_effect_limit: int = 8
var grind_timer: float = 0.0
var grind_velocity_x: float = 0.0
var grind_end_x: float = 0.0
var grind_y: float = 0.0
var grind_end_mode: int = 0
var grind_effect_entity: EntityState = null
var cheese_entity: EntityState = null
var gravity_inverted: bool = false
var player_layer: int = 0
var corkscrew_timer: float = 0.0
var corkscrew_origin: Vector2 = Vector2.ZERO
var corkscrew_direction: float = 1.0
var corkscrew_active_entity: EntityState = null
var pipe_active: bool = false
var pipe_origin: Vector2 = Vector2.ZERO
var pipe_target: Vector2 = Vector2.ZERO
var pipe_timer: float = 0.0
var pipe_target_entity: EntityState = null
var hook_active: bool = false
var hook_origin: Vector2 = Vector2.ZERO
var hook_target: Vector2 = Vector2.ZERO
var hook_timer: float = 0.0
var speed_up_timer: float = 0.0
var magnetic_shielded: bool = false
var defeat_score_index: int = 0
var player_half_width: float = 14.0
var player_half_height: float = 20.0
var level_complete: bool = false
