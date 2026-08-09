# PlatformState.gd
# Runtime collision/motion state for one stage platform.
class_name PlatformState
extends RefCounted

var x1: float = 0.0
var x2: float = 0.0
var top_y: float = 0.0
var bottom_y: float = 0.0
var thickness: float = 0.0
var active: bool = true
var crumble_delay: float = -1.0
var crumble_timer: float = -1.0
var crumble_phase: int = 0
var crumble_break_timer: float = -1.0
var moving: bool = false
var motion_axis: int = 0
var motion_amplitude: float = 0.0
var motion_speed: float = 0.0
var motion_phase: float = 0.0
var sloped: bool = false
var slope_start_y: float = 0.0
var slope_end_y: float = 0.0
var collision_layer: int = -1
var arrow_mode: bool = false
var arrow_active: bool = false
var arrow_target_x: float = 0.0
var arrow_target_y: float = 0.0
var arrow_speed: float = 0.0
var speeding_mode: bool = false
var speeding_active: bool = false
var speeding_phase: int = 0
var speeding_target_x: float = 0.0
var speeding_target_y: float = 0.0
var speeding_first_x: float = 0.0
var speeding_first_y: float = 0.0
var speeding_base_x: float = 0.0
var speeding_base_y: float = 0.0
var speeding_final_x: float = 0.0
var speeding_final_y: float = 0.0
var speeding_player_attached: bool = false
var speeding_wait_timer: float = 0.0
var speeding_returning: bool = false
