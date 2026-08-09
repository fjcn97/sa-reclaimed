# PlayerState.gd
# Public player snapshot consumed by gameplay presentation and HUD layers.
class_name PlayerState
extends RefCounted

var world_x: float = 0.0
var world_y: float = 0.0
var speed_x: float = 0.0
var speed_y: float = 0.0
var ground_speed: float = 0.0
var anim_id: int = 0
var anim_frame: int = 0
var variant: int = 0
var rotation: int = 0
var move_state: int = 0
var char_state: int = 0
var is_alive: bool = true
var is_grounded: bool = true
var rings: int = 0
var special_rings: int = 0
var shielded: bool = false
var score: int = 0
var lives: int = 3
var has_cleared_level: bool = false
var super_sonic: bool = false
var super_sonic_ring_timer: float = 0.0
