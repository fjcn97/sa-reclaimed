# CoreBridge.gd
# Lightweight gameplay bridge for the Godot remake prototype.
extends Node

const A_BUTTON = 0x0001
const B_BUTTON = 0x0002
const SELECT_BUTTON = 0x0004
const START_BUTTON = 0x0008
const DPAD_RIGHT = 0x0010
const DPAD_LEFT = 0x0020
const DPAD_UP = 0x0040
const DPAD_DOWN = 0x0080
const R_BUTTON = 0x0100
const L_BUTTON = 0x0200

const ENTITY_RING = 0
const ENTITY_SPRING = 1
const ENTITY_ENEMY = 2
const ENTITY_CHECKPOINT = 3
const ENTITY_GOAL = 4
const ENTITY_SPECIAL_RING = 5
const ENTITY_WHIRLWIND = 6
const ENTITY_FAN = 7
const ENTITY_SPIKES = 8
const ENTITY_ITEM_BOX = 9
const ENTITY_PROPELLER = 10
const ENTITY_BOOSTER = 11
const ENTITY_DASH_RING = 12
const ENTITY_GRIND_RAIL = 13
const ENTITY_GRAVITY_TOGGLE = 14
const ENTITY_BOUNCY_SPRING = 15
const ENTITY_CONVEYOR = 16
const ENTITY_BUZZER = 17
const ENTITY_BALLOON = 18
const ENTITY_PROJECTILE = 19
const ENTITY_BULLET_BUZZER = 20
const ENTITY_KOURA = 21
const ENTITY_STAR = 22
const ENTITY_KIKI = 23
const ENTITY_KIKI_PROJECTILE = 24
const ENTITY_KIKI_PIECE = 25
const ENTITY_BOSS = 26
const ENTITY_SCATTER_RING = 27
const ENTITY_TRAPPED_ANIMAL = 28
const ENTITY_RING_EFFECT = 29
const ENTITY_HEART_EFFECT = 30
const ENTITY_DUST_EFFECT = 31
const ENTITY_GRIND_EFFECT = 32
const ENTITY_CHEESE = 33
const ENTITY_TAIL_SWIPE = 34
const ENTITY_KNUCKLES_FIRE = 35
const ENTITY_SONIC_SKID = 36
const ENTITY_LAYER_TOGGLE = 37
const ENTITY_RAMP = 38
const ENTITY_ROTATING_HANDLE = 39
const ENTITY_CORK_SCREW = 40
const ENTITY_CANNON = 41
const ENTITY_LAUNCHER = 42
const ENTITY_PIPE_START = 43
const ENTITY_PIPE_END = 44
const ENTITY_HOOK_RAIL = 45
const ENTITY_SLIDY_ICE = 46
const ENTITY_LIGHT_BRIDGE = 47
const ENTITY_SLOWING_SNOW = 48
const ENTITY_SPIKE_PLATFORM = 49
const ENTITY_TURNAROUND_BAR = 50
const ENTITY_KEYBOARD = 51
const ENTITY_POLE = 52
const ENTITY_LIGHT_GLOBE = 53
const ENTITY_WINDUP_STICK = 54
const ENTITY_GERMAN_FLUTE = 55
const ENTITY_SMALL_WINDMILL = 56
const ENTITY_CHORD = 57
const ENTITY_HALF_PIPE = 58
const ENTITY_IRON_BALL = 59
const ENTITY_CRANE = 60
const ENTITY_CEILING_SLOPE = 61
const ENTITY_GAPPED_LOOP = 62
const ENTITY_FUNNEL_SPHERE = 63
const ENTITY_MUSIC_ENTRY = 64
const ENTITY_DAMAGE_REGION = 65
const ENTITY_DECORATION = 66
const ENTITY_NOTE_BLOCK = 67
const ENTITY_NOTE_SPHERE = 68
const ENTITY_FLYING_HANDLE = 69
const ENTITY_NOTE_PARTICLE = 70
const ENTITY_LAP_TRIGGER = 71
const ENTITY_GOAL_LEVER = 72
const SOURCE_MAP_LOADER := preload("res://scripts/SourceMapLoader.gd")
const GRAVITY_KIND_DOWN = 0
const GRAVITY_KIND_UP = 1
const GRAVITY_KIND_TOGGLE = 2
const SPRING_UP = 0
const SPRING_DOWN = 1
const SPRING_LEFT = 2
const SPRING_RIGHT = 3
const SPRING_UP_LEFT = 4
const SPRING_UP_RIGHT = 5
const SPRING_DOWN_LEFT = 6
const SPRING_DOWN_RIGHT = 7
const DASH_RING_UP = 0
const DASH_RING_UP_RIGHT = 1
const DASH_RING_RIGHT = 2
const DASH_RING_DOWN_RIGHT = 3
const DASH_RING_DOWN = 4
const DASH_RING_DOWN_LEFT = 5
const DASH_RING_LEFT = 6
const DASH_RING_UP_LEFT = 7
const ITEM_BOX_KIND_RINGS = 0
const ITEM_BOX_KIND_SHIELD = 1
const ITEM_BOX_KIND_INVINCIBILITY = 2
const ITEM_BOX_KIND_ONE_UP = 3
const ITEM_BOX_KIND_SPEED_UP = 4
const ITEM_BOX_KIND_MAGNETIC_SHIELD = 5
const ITEM_BOX_KIND_RINGS_RANDOM = 6
const ITEM_BOX_KIND_RINGS_5 = 7
const ITEM_BOX_KIND_RINGS_10 = 8
const GAME_STATE_TITLE = 0
const GAME_STATE_PLAYING = 1
const GAME_STATE_CLEAR = 2
const GAME_STATE_PAUSED = 3
const GAME_STATE_SAVE_OPTIONS = 4
const GAME_STATE_INTRO = 5
const GAME_STATE_CHARACTER_SELECT = 6
const GAME_STATE_GAME_OVER = 7
const GAME_STATE_CHAOS_EMERALDS = 8
const GAME_STATE_TO_BE_CONTINUED = 9
const GAME_STATE_SEGA_LOGO = 10
const GAME_STATE_SONIC_TEAM = 11
const GAME_STATE_CREDITS = 12
const GAME_STATE_MISSING_EMERALDS = 13
const GAME_STATE_COPYRIGHT = 14
const GAME_STATE_SPECIAL_STAGE = 15
const ENDING_VARIANT_NORMAL = 0
const ENDING_VARIANT_FINAL = 1
const ENDING_VARIANT_EXTRA = 2
const GAME_STATE_CREDITS_END = 16
const GAME_STATE_CHARACTER_UNLOCK = 17
const GAME_STATE_FINAL_INTRO = 18
# stage_intro.c holds the course card for 200 GBA frames before handing off to
# countdown.c. The normal countdown then runs for five seconds plus ten frames.
const STAGE_INTRO_DURATION = 200.0 / 60.0
const COURSE_COUNTDOWN_DURATION = 310.0 / 60.0
const INTRO_TOTAL_TIME = STAGE_INTRO_DURATION + COURSE_COUNTDOWN_DURATION
const INTRO_COUNTDOWN_START = 3.0
const INTRO_GO_TIME = 0.35
const INTRO_BOOST_WINDOW = 5.0 / 60.0
const INTRO_BOOST_SPEED = 540.0
const INTRO_BOOST_DURATION = 0.60
const INPUT_BUFFER_FRAMES = 4
const JUMP_BUFFER_DURATION = 0.12
const CREAM_FLIGHT_DURATION = 4.0
const TAILS_FLIGHT_DURATION = 8.0
const MAX_COURSE_TIME_SECONDS = 600.0
# game_over.c starts the normal card at G_START_X (140 frames), then runs a
# 120-frame background fade and a 140-frame music wait before returning to the
# title. TIME OVER uses the shorter 140-frame stage restart path.
const GAME_OVER_DURATION_SECONDS = 400.0 / 60.0
const TIME_OVER_DURATION_SECONDS = 140.0 / 60.0
# stage_results.c holds the completed score card for 310 frames after the
# bonus counters finish; fast-forwarding with A starts the shorter 160-frame
# tail used by the source counter state.
const CLEAR_RESULT_TAIL_SECONDS = 310.0 / 60.0
const CLEAR_RESULT_FAST_TAIL_SECONDS = 160.0 / 60.0
# multiplayer_lobby.c waves Cheese for 120 frames before closing the room.
const MULTIPLAYER_LOBBY_EXIT_DURATION = 120.0 / 60.0
# time_attack_results.c fades for 16 frames before opening the lobby after
# A/START confirms the result.
const TIME_ATTACK_RESULTS_EXIT_FADE_SECONDS = 16.0 / 60.0
const TITLE_PHASE_PRESS_START = 0
const TITLE_PHASE_PLAY_MODE = 1
const TITLE_PHASE_SINGLE_PLAYER = 2
const TITLE_PHASE_MULTI_PLAYER = 3
const TITLE_PHASE_TIME_ATTACK = 4
const TITLE_PHASE_TINY_CHAO_GARDEN = 5
const TITLE_PHASE_MULTI_CONNECT = 6
const TITLE_PHASE_TINY_CHAO_SETUP = 7
const TITLE_PHASE_SINGLEPAK_SYNC = 8
const TITLE_PHASE_SINGLEPAK_RESULTS = 9
const TITLE_PHASE_MULTIPLAYER_LOBBY = 10
const TITLE_PHASE_TIME_ATTACK_LOBBY = 11
const TITLE_PHASE_COURSE_SELECT = 12
const TITLE_PHASE_MULTIPLAYER_OUTCOME = 13
const TITLE_PHASE_TINY_CHAO_GARDEN_PLAY = 14
const OPTIONS_MODE_MAIN = 0
const OPTIONS_MODE_PLAYER_DATA = 1
const OPTIONS_MODE_LANGUAGE = 2
const OPTIONS_MODE_BUTTON_CONFIG = 3
const OPTIONS_MODE_SOUND_TEST = 4
const OPTIONS_MODE_TIME_RECORDS = 5
const OPTIONS_MODE_MULTI_RECORDS = 6
const OPTIONS_MODE_NAME_ENTRY = 7
const OPTIONS_MODE_DIFFICULTY = 8
const OPTIONS_MODE_TIME_LIMIT = 9
const OPTIONS_MODE_DELETE_CONFIRM = 10
const OPTIONS_MODE_DELETE_CONFIRM_FINAL = 11
const TIME_RECORDS_VIEW_MODE_CHOICE = 0
const TIME_RECORDS_VIEW_COURSES = 1
const TIME_RECORDS_CONTEXT_OPTIONS = 0
const TIME_RECORDS_CONTEXT_TIME_ATTACK = 1
const SOUND_TEST_STATE_STOPPED = 0
const SOUND_TEST_STATE_PLAYING = 1
const MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION = 0
const MULTIPLAYER_RESULTS_MODE_COURSE_COMPLETE = 1
const CHARACTER_SELECT_CONTEXT_GAME_START = 0
const CHARACTER_SELECT_CONTEXT_TIME_ATTACK_ZONE = 1
const CHARACTER_SELECT_CONTEXT_TIME_ATTACK_BOSS = 2
const CHARACTER_SELECT_CONTEXT_MULTIPLAYER = 3
const NAME_ENTRY_MATRIX_COLS = 11
const NAME_ENTRY_MATRIX_ROWS = 22
const NAME_ENTRY_MATRIX_VISIBLE_ROWS = 7
const NAME_ENTRY_CONTROL_ROW_BACK = 4
const NAME_ENTRY_CONTROL_ROW_FORWARD = 5
const NAME_ENTRY_CONTROL_ROW_END = 6
const NAME_ENTRY_CONTROLS_COL = NAME_ENTRY_MATRIX_COLS

class PlayerState:
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
	# player_super_sonic.c owns a separate player presentation for the extra
	# boss route. Keep it on the shared state so the renderer and HUD can use it.
	var super_sonic: bool = false
	var super_sonic_ring_timer: float = 0.0

class CameraState:
	var x: float = 0.0
	var y: float = 0.0
	var min_x: float = 0.0
	var max_x: float = 0.0
	var min_y: float = 0.0
	var max_y: float = 0.0

class EntityState:
	var type: int = 0
	var world_x: float = 0.0
	var world_y: float = 0.0
	var anim_id: int = 0
	var variant: int = 0
	var active: bool = true
	var collected: bool = false
	var activated: bool = false
	var width: float = 0.0
	var height: float = 0.0
	var radius: float = 0.0
	var velocity_x: float = 0.0
	var velocity_y: float = 0.0
	var patrol_min_x: float = 0.0
	var patrol_max_x: float = 0.0
	var origin_x: float = 0.0
	var origin_y: float = 0.0
	var previous_world_y: float = 0.0
	var trail_positions: Array = []
	var target_x: float = 0.0
	var target_y: float = 0.0
	var effect_offset: float = 0.0
	var state_timer: float = 0.0
	var enemy_profile: int = 0
	var boss_profile: int = 0
	var health: int = 0
	var max_health: int = 0
	var hit_timer: float = 0.0
	var flag_active: bool = false
	var item_kind: int = ITEM_BOX_KIND_RINGS
	var special_ring_collected: bool = false
	var special_ring_collect_timer: float = 0.0
	var fan_speed: float = 1.0
	var whirlwind_active: bool = false
	var whirlwind_timer: float = 0.0
	var whirlwind_release_latch: bool = false
	var propeller_horizontal_step: float = 0.0
	var propeller_vertical_step: float = 0.0
	var propeller_phase_units: float = 0.0
	var rail_end_mode: int = 0
	var rail_direction: float = 1.0
	var rail_is_start: bool = true
	var rail_air_start: bool = false
	var gravity_kind: int = GRAVITY_KIND_TOGGLE
	var bounce_strength: float = 1.125
	var surface_speed: float = 0.0
	var flying_spring: bool = false
	var flying_spring_phase: float = 0.0
	var flying_spring_trigger_timer: float = 0.0
	var flying_spring_step: int = 0
	var flying_spring_motion_state: int = 0
	var floating_spring: bool = false
	var floating_spring_amplitude_x: float = 0.0
	var floating_spring_amplitude_y: float = 0.0
	var floating_spring_phase: float = 0.0
	var note_block: bool = false
	var note_sphere: bool = false
	var note_kind: int = 0
	var note_health: int = 3
	var note_timer: float = 0.0
	var note_angle: float = 0.0
	var note_offset_x: float = 0.0
	var note_offset_y: float = 0.0
	var note_particle: bool = false
	var note_particle_delay: float = 0.0
	var lap_previous_player_x: float = 0.0
	var lap_previous_checkpoint_time: float = 0.0
	var lap_count: int = 0
	var lap_highest: int = 0
	var lap_passed: bool = false
	var lap_touching: bool = false
	var lap_last_bonus: int = 0
	var goal_lever: bool = false
	var goal_toggle: bool = false
	var gohla_turn_timer: float = 0.0
	var koura_motion_variant: int = 0
	var koura_patrol_min_y: float = 0.0
	var koura_patrol_max_y: float = 0.0
	var gejigeji_vertical: bool = false
	var gejigeji_pause_timer: float = 0.0
	var gejigeji_history: Array = []
	var kubinaga_phase: int = 0
	var kubinaga_phase_timer: float = 2.0
	var kubinaga_extension: float = 0.0
	var kubinaga_angle: float = 0.0
	var kubinaga_shot_fired: bool = false
	var madillo_return_timer: float = 0.0
	var kyura_phase_units: float = 0.0
	var kyura_switch_timer: float = 8.0 / 60.0
	var kyura_recovering: bool = false
	var kyura_projectile_counter: int = 12
	var kyura_projectile_variant: int = 0
	var flickey_vertical_speed: float = -240.0
	var flickey_turn_timer: float = 0.0
	var flickey_history: Array = []
	var mon_phase_timer: float = 0.0
	var straw_phase: int = 0
	var straw_phase_timer: float = 30.0 / 60.0
	var straw_cycles: int = 5
	var yado_phase: int = 0
	var yado_phase_timer: float = 120.0 / 60.0
	var yado_projectile_fired: bool = false
	var yado_facing: int = 1
	var bell_phase: int = 0
	var bell_phase_timer: float = 120.0 / 60.0
	var pen_boosting: bool = false
	var pen_turn_timer: float = 0.0
	var pen_direction: float = -1.0
	var mouse_boosting: bool = false
	var mouse_turn_timer: float = 0.0
	var mouse_direction: float = -1.0
	var mouse_position_offset: float = 0.0
	var circus_phase: int = 0
	var circus_phase_timer: float = 1.0 / 60.0
	var circus_projectile_spawned: bool = false
	var balloon_angle: float = 0.0
	var balloon_amplitude_x: float = 12.0
	var balloon_amplitude_y: float = 12.0
	var balloon_projectile_spawned: bool = false
	var bullet_buzzer_angle: float = 0.0
	var bullet_buzzer_attack_timer: float = 0.0
	var bullet_buzzer_projectile_spawned: bool = false
	var kiki_vertical_direction: float = 1.0
	var kiki_vertical_min: float = 0.0
	var kiki_vertical_max: float = 0.0
	var kiki_border_hits: int = 0
	var kiki_attack_frames: int = 0
	var kiki_projectile_spawned: bool = false
	var buzzer_turn_timer: float = 0.0
	var buzzer_cooldown: float = 0.0
	var buzzer_attack_origin_x: float = 0.0
	var buzzer_attack_origin_y: float = 0.0
	var buzzer_attack_timer: float = 0.0
	var pikopiko_clamp_ground: bool = false
	var bouncy_landing_speed: int = 0
	var bouncy_launch_frame: int = 0
	var bouncy_spring_stiffness: float = 9.0
	var bouncy_landing_position: float = 0.0
	var light_bridge: bool = false
	var light_bridge_type: int = 0
	var light_bridge_phase: float = 0.0
	var light_bridge_active: bool = false
	var spike_platform: bool = false
	var spike_platform_phase: float = 0.0
	var turnaround_bar: bool = false
	var turnaround_direction: float = 1.0
	var turnaround_timer: float = 0.0
	var turnaround_entry_speed: float = 0.0
	var ramp_incline: bool = false
	var pipe_exit_back_layer: bool = false
	var pipe_exit_uncurl: bool = false
	var keyboard: bool = false
	var keyboard_type: int = 0
	var keyboard_timer: float = 0.0
	var pole: bool = false
	var pole_sliding: bool = false
	var light_globe: bool = false
	var light_globe_phase: float = 0.0
	var windup_stick: bool = false
	var windup_stick_timer: float = 0.0
	var windup_stick_mode: int = 0
	var german_flute: bool = false
	var german_flute_kind: int = 0
	var german_flute_timer: float = 0.0
	var german_flute_phase: int = 0
	var small_windmill: bool = false
	var small_windmill_type: int = 0
	var small_windmill_timer: float = 0.0
	var small_windmill_angle: float = 0.0
	var small_windmill_touch_angle: int = 0
	var chord: bool = false
	var chord_timer: float = 0.0
	var chord_phase: int = 0
	var chord_bounce_speed: float = 240.0
	var half_pipe: bool = false
	var half_pipe_direction: float = 1.0
	var half_pipe_active: bool = false
	var half_pipe_base_y: float = 0.0
	var iron_ball: bool = false
	var iron_ball_horizontal: bool = true
	var iron_ball_amplitude: float = 0.0
	var iron_ball_phase: float = 0.0
	var crane: bool = false
	var crane_timer: float = 0.0
	var crane_phase: float = 0.0
	var crane_hook_x: float = 0.0
	var crane_hook_y: float = 0.0
	var crane_launch_speed: float = 450.0
	var ceiling_slope: bool = false
	var ceiling_slope_variant: int = 0
	var ceiling_slope_timer: float = 0.0
	var ceiling_slope_latched: bool = false
	var gapped_loop: bool = false
	var gapped_loop_direction: float = 1.0
	var gapped_loop_active: bool = false
	var gapped_loop_angle: float = 0.0
	var gapped_loop_center_x: float = 0.0
	var gapped_loop_center_y: float = 0.0
	var funnel_sphere: bool = false
	var funnel_sphere_timer: float = 0.0
	var funnel_sphere_direction: float = 1.0
	var music_entry: bool = false
	var music_entry_pipe: bool = false
	var music_entry_kind: int = 0
	var music_entry_timer: float = 0.0
	var music_entry_duration: float = 1.1
	var damage_region: bool = false
	var decoration: bool = false
	var decoration_id: int = 0
	var cannon_facing_right: bool = true
	var cannon_angle: float = 0.0
	var cannon_active: bool = false
	var cannon_timer: float = 0.0
	var cannon_loading: bool = false
	var cannon_aim_phase: int = 0
	var rotating_handle_angle: float = 0.0
	var rotating_handle_speed: float = 0.0
	var rotating_handle_quartile: int = 0
	var flying_handle: bool = false
	var flying_handle_top_y: float = 0.0
	var flying_handle_bottom_y: float = 0.0
	var flying_handle_speed_y: float = 0.0
	var flying_handle_phase: float = 0.0
	var flying_handle_cooldown: float = 0.0
	var launcher_direction: float = 1.0
	var launcher_gravity_up: bool = false
	var launcher_active: bool = false
	var launcher_cart_x: float = 0.0
	var launcher_cart_y: float = 0.0
	var launcher_target_x: float = 0.0
	var launcher_base_x: float = 0.0
	var launcher_scale: float = 1.0
	var launcher_returning: bool = false
	var launcher_wait_timer: float = 0.0

class PlatformState:
	var x1: float = 0.0
	var x2: float = 0.0
	var top_y: float = 0.0
	var bottom_y: float = 0.0
	var thickness: float = 0.0
	var active: bool = true
	var crumble_delay: float = -1.0
	var crumble_timer: float = -1.0
	var crumble_phase: int = 0 # 0 stable, 1 warning, 2 breaking, 3 gone
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

class LevelState:
	var level_id: int = 0
	var name: String = ""
	var spawn_x: float = 0.0
	var spawn_y: float = 0.0
	var ground_y: float = 0.0
	var min_x: float = 0.0
	var max_x: float = 0.0
	var min_y: float = 0.0
	var max_y: float = 0.0
	var platforms: Array = []
	var entities: Array = []

var _player_state: PlayerState = PlayerState.new()
var _camera_state: CameraState = CameraState.new()
var _level_state: LevelState = LevelState.new()
var _source_map_manifest: Dictionary = {}
var _screen_shake_amplitude: float = 0.0
var _screen_shake_decay: float = 0.0
var _screen_shake_phase: float = 0.0
var _screen_shake_phase_speed: float = 0.0
var _screen_shake_timer: float = 0.0
var _screen_shake_horizontal: bool = true
var _screen_shake_vertical: bool = true
var _screen_shake_random: bool = false
var _screen_shake_offset: Vector2 = Vector2.ZERO
var _input_frame_history: Array = []
var _frame_input: int = 0
var _jump_buffer_timer: float = 0.0
var _spindash_charging: bool = false
var _spindash_charge: float = 0.0
var _spindash_release_timer: float = 0.0
var _spindash_velocity_x: float = 0.0
var _facing_direction: float = 1.0
var _braking_dust_cooldown: float = 0.0
var _velocity_y: float = 0.0
var _elapsed_time: float = 0.0
var _move_speed: float = 230.0
var _jump_speed: float = 435.0
var _gravity: float = 1060.0
var _spring_jump_speed: float = 560.0
var _enemy_speed: float = 90.0
var _dash_timer: float = 0.0
var _dash_velocity_x: float = 0.0
var _dash_velocity_y: float = 0.0
var _boost_effect_timer: float = 0.0
var _boost_position_history: Array = []
var _ring_effect_limit: int = 8
var _grind_timer: float = 0.0
var _grind_velocity_x: float = 0.0
var _grind_end_x: float = 0.0
var _grind_y: float = 0.0
var _grind_end_mode: int = 0
var _grind_effect_entity: EntityState = null
var _cheese_entity: EntityState = null
var _gravity_inverted: bool = false
var _player_layer: int = 0
var _corkscrew_timer: float = 0.0
var _corkscrew_origin: Vector2 = Vector2.ZERO
var _corkscrew_direction: float = 1.0
var _corkscrew_active_entity: EntityState = null
var _pipe_active: bool = false
var _pipe_origin: Vector2 = Vector2.ZERO
var _pipe_target: Vector2 = Vector2.ZERO
var _pipe_timer: float = 0.0
var _pipe_target_entity: EntityState = null
var _hook_active: bool = false
var _hook_origin: Vector2 = Vector2.ZERO
var _hook_target: Vector2 = Vector2.ZERO
var _hook_timer: float = 0.0
var _on_slidy_ice: bool = false
var _on_slowing_snow: bool = false
var _attack_timer: float = 0.0
var _flight_timer: float = 0.0
var _glide_timer: float = 0.0
var _damage_cooldown: float = 0.0
var _invincibility_timer: float = 0.0
var _speed_up_timer: float = 0.0
var _magnetic_shielded: bool = false
var _defeat_score_index: int = 0
var _spawn_x: float = 0.0
var _spawn_y: float = 0.0
var _respawn_x: float = 0.0
var _respawn_y: float = 0.0
var _checkpoint_time: float = 0.0
var _player_half_width: float = 14.0
var _player_half_height: float = 20.0
var _level_complete: bool = false
var _intro_timer: float = 0.0
var _final_intro_timer: float = 0.0
var _final_intro_pending: bool = false
var _intro_primed: bool = false
var _intro_speed_boost: bool = false
var _intro_boost_disabled: bool = false
var _race_start_message_timer: float = 0.0
var _start_boost_timer: float = 0.0
var _clear_time_snapshot: float = 0.0
var _clear_score_snapshot: int = 0
var _clear_final_score_snapshot: int = 0
var _clear_rank_text: String = "D"
var _clear_ring_snapshot: int = 0
var _clear_special_ring_snapshot: int = 0
var _clear_previous_best_time: float = -1.0
var _clear_new_best_time: bool = false
var _clear_time_attack_record_rank: int = 0
var _time_attack_result_timer: float = 0.0
var _time_attack_exit_timer: float = 0.0
var _clear_time_bonus_remaining: int = 0
var _clear_ring_bonus_remaining: int = 0
var _clear_special_ring_bonus_remaining: int = 0
var _clear_total_display_score: int = 0
var _clear_count_step_accumulator: float = 0.0
var _clear_count_delay_timer: float = 0.0
var _clear_input_lock_timer: float = 0.0
var _clear_counting_done: bool = false
var _clear_from_goal: bool = false
var _game_over_timer: float = 0.0
var _game_over_input_lock_timer: float = 0.0
var _game_over_time_over: bool = false
var _chaos_emeralds_timer: float = 0.0
## missing_emeralds.c holds the card for 0xF0 frames, fades, then waits 0xB4.
var _chaos_emeralds_duration: float = 7.0
var _chaos_emeralds_message_seen: bool = false
var _missing_emeralds_timer: float = 0.0
var _missing_emeralds_duration: float = 7.0
var _to_be_continued_timer: float = 0.0
# endings.c holds the transition for 0xB4 frames before the ending cutscene.
var _to_be_continued_duration: float = 3.0
var _sega_logo_timer: float = 0.0
# title_screen.c holds each boot logo for FRAME_TIME_SECONDS(2).
var _sega_logo_duration: float = 2.0
var _sonic_team_timer: float = 0.0
var _sonic_team_duration: float = 2.0
var _chaos_emerald_mask: int = 0 # Legacy single-character save field.
var _chaos_emerald_masks: Array = [0, 0, 0, 0, 0]
var _credits_timer: float = 0.0
var _credits_page: int = 0
var _credits_page_duration: float = 2.5
var _credits_page_count: int = 25
var _ending_variant: int = ENDING_VARIANT_NORMAL
var _extra_ending_credits_played: bool = false
var _copyright_timer: float = 0.0
# credits_end.c assigns delayFrames = 270 before the copyright card advances.
var _copyright_duration: float = 4.5
var _credits_end_timer: float = 0.0
var _credits_end_duration: float = 4.5
var _credits_end_story_frame: int = 0
var _credits_end_story_timer: float = 0.0
var _credits_end_show_missing_emeralds: bool = false
const CREDITS_SLIDE_GROUPS := [6, 6, 8, 5]
const CREDITS_SOURCE_TILES := [
	"credits_0", "credits_1", "credits_2", "credits_3", "credits_4",
	"credits_5", "credits_6", "credits_7", "credits_8", "credits_9",
	"credits_10", "credits_11", "credits_12", "credits_13", "credits_14",
	"credits_15", "credits_16", "credits_17", "credits_18", "credits_19",
	"credits_20", "credits_21", "credits_22", "credits_23", "credits_24",
]
const CREDITS_INTRO_DURATION: float = 180.0 / 60.0
const CREDITS_SLIDE_DURATION: float = 150.0 / 60.0
const CREDITS_END_STORY_DELAYS := [3, 3, 3, 3, 3, 3, 3, 12, 4, 4]
const CHARACTER_UNLOCK_SEGMENT_COUNT = 4
const CHARACTER_UNLOCK_SEGMENT_FRAMES = 340
const CHARACTER_UNLOCK_FINAL_FRAMES = 300
var _character_unlock_timer: float = 0.0
var _character_unlock_segment: int = 0
var _character_unlock_scene_frame: float = 0.0
var _character_unlock_pending: int = -1
var _character_select_intro_timer: float = 0.0
var _play_mode_intro_timer: float = 0.0
var _time_attack_mode_intro_timer: float = 0.0
var _multiplayer_mode_intro_timer: float = 0.0
var _special_stage_timer: float = 0.0
var _special_stage_entry_duration: float = 2.6
var _special_stage_run_duration: float = 120.0
var _special_stage_phase: int = 0
var _special_stage_pending: bool = false
var _special_stage_ring_count: int = 0
var _special_stage_score: int = 0
var _special_stage_points_remaining: int = 0
var _special_stage_bonus_remaining: int = 0
var _special_stage_result_hold_started: bool = false
var _special_stage_emerald_index: int = 0
var _special_stage_lane: int = 1
var _special_stage_progress: float = 0.0
var _special_stage_last_segment: int = -1
var _special_stage_target_reached: bool = false
var _special_stage_paused: bool = false
var _special_stage_pause_cursor: int = 0
var _special_stage_multiplier: int = 1
var _special_stage_multiplier_streak: int = 0
var _special_stage_multiplier_timer: float = 0.0
var _special_stage_robo_progress: float = 0.15
var _special_stage_robo_lane: int = 1
var _special_stage_robo_speed: float = 0.18
var _special_stage_robo_zone_speeds: Array = [0.18, 0.21, 0.24, 0.27, 0.30, 0.33, 0.36]
var _special_stage_robo_lane_timer: float = 0.0
var _special_stage_robo_cooldown: float = 0.0
var _special_stage_run_target: int = 300
var _special_stage_speed: float = 1.0
var _special_stage_jump_timer: float = 0.0
# The source marks special-ring objects with unk7. These compact checkpoints
# preserve that distinction while the full spatial object field is migrated.
var _special_stage_ring_targets: Array = [0, 2, 1, 0, 2, 1, 1, 0, 2, 1, 0, 2, 1, 0, 2, 1, 1, 0, 2, 1]
var _special_stage_ring_kinds: Array = [0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0]
var _status_text: String = ""
var _title_text: String = "SONIC ADVANCE RECLAIMED"
var _pause_text: String = "PRESS ENTER TO RESUME"
var _screen_fade_alpha: float = 0.0
var _screen_fade_last_state: int = -1
var _screen_fade_last_phase: int = -1
var _screen_fade_speed: float = 3.6
var _pause_menu_index: int = 0
var _pause_a_hold_lock: bool = false
var _pause_a_previous_held: bool = false
var _save_menu_text: String = "SAVE OPTIONS"
var _game_state: int = GAME_STATE_TITLE
var _boot_intro_pending: bool = false
var _selected_level_index: int = 0
var _level_names: Array = [
	"LEAF FOREST", "LEAF FOREST", "HOT CRATER", "HOT CRATER",
	"MUSIC PLANT", "MUSIC PLANT", "ICE PARADISE", "ICE PARADISE",
	"SKY CANYON", "SKY CANYON", "TECHNO BASE", "TECHNO BASE",
	"EGG UTOPIA", "EGG UTOPIA", "FINAL ZONE", "TRUE AREA 53",
]
var _save_menu_index: int = 0
var _save_reset_pending: bool = false
var _unlocked_level_index: int = 0
var _character_unlocked_level_indices: Array = [0, 0, 0, 0, 0]
var _best_scores: Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var _profile_score: int = 0
var _level_cleared_flags: Array = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
var _time_attack_best_times: Dictionary = {}
var _time_attack_record_tables: Dictionary = {}
var _save_path: String = "user://save_data.json"
var _save_id: int = 0
const TOUCH_CONTROLS_OVERRIDE_SETTING := "sa_reclaimed/debug/show_touch_controls_on_desktop"
var _title_phase: int = TITLE_PHASE_PRESS_START
var _title_menu_index: int = 0
var _title_idle_timer: float = 0.0
var _demo_mode: bool = false
var _demo_elapsed: float = 0.0
var _single_player_intro_timer: float = 0.0
var _options_mode: int = OPTIONS_MODE_MAIN
var _options_menu_index: int = 0
var _player_data_menu_index: int = 0
var _difficulty_index: int = 0
var _difficulty_before_edit: int = 0
var _time_limit_enabled: bool = true
var _time_limit_before_edit: bool = true
var _language_index: int = 1
var _language_index_before_edit: int = 1
var _button_config_index: int = 0
var _button_bindings_before_edit: Array = ["JUMP", "ATTACK", "TRICK"]
var _sound_test_menu_index: int = 0
var _sound_test_track_index: int = 0
var _sound_test_state: int = SOUND_TEST_STATE_STOPPED
var _sound_test_unlocked: bool = false
var _time_records_menu_index: int = 0
var _time_records_view: int = TIME_RECORDS_VIEW_MODE_CHOICE
var _time_records_context: int = TIME_RECORDS_CONTEXT_OPTIONS
var _time_records_boss_mode: bool = false
var _time_records_character_index: int = 0
var _time_records_course_index: int = 0
var _time_records_act_index: int = 0
var _multi_records_menu_index: int = 0
var _name_entry_menu_index: int = 0
var _name_entry_cursor_col: int = 0
var _name_entry_cursor_row: int = 0
var _name_entry_matrix_page_index: int = 0
var _name_entry_snapshot: Array = ["S", "O", "N", "I", "C", " "]
var _delete_confirm_index: int = 1
var _player_profile_name: Array = ["S", "O", "N", "I", "C", " "]
var _button_bindings: Array = ["JUMP", "ATTACK", "TRICK"]
var _sound_test_tracks: Array = [
	{"number": 1, "name": "OPENING"},
	{"number": 2, "name": "TITLE"},
	{"number": 3, "name": "CHARACTER SELECT"},
	{"number": 4, "name": "ZONE SELECT"},
	{"number": 9, "name": "ZONE 1-1"},
	{"number": 10, "name": "ZONE 1-2"},
	{"number": 11, "name": "ZONE 2-1"},
	{"number": 12, "name": "ZONE 2-2"},
	{"number": 13, "name": "ZONE 3-1"},
	{"number": 14, "name": "ZONE 3-2"},
	{"number": 15, "name": "ZONE 4-1"},
	{"number": 16, "name": "ZONE 4-2"},
	{"number": 17, "name": "ZONE 5-1"},
	{"number": 18, "name": "ZONE 5-2"},
	{"number": 19, "name": "ZONE 6-1"},
	{"number": 20, "name": "ZONE 6-2"},
	{"number": 21, "name": "ZONE 7-1"},
	{"number": 22, "name": "ZONE 7-2"},
	{"number": 23, "name": "FINAL ZONE"},
	{"number": 27, "name": "BOSS"},
	{"number": 28, "name": "BOSS-PINCH"},
	{"number": 29, "name": "KNUCKLES BOSS"},
	{"number": 30, "name": "7-BOSS"},
	{"number": 31, "name": "7-BOSS-PINCH"},
	{"number": 32, "name": "FINAL BOSS"},
	{"number": 33, "name": "FINAL BOSS-PINCH"},
	{"number": 55, "name": "ACT CLEAR"},
	{"number": 56, "name": "BOSS CLEAR"},
	{"number": 57, "name": "FINAL CLEAR"},
	{"number": 34, "name": "GAME OVER"},
	{"number": 25, "name": "UNRIVAL"},
	{"number": 26, "name": "DROWN"},
	{"number": 61, "name": "1_UP"},
	{"number": 38, "name": "DEMO 1"},
	{"number": 39, "name": "DEMO 2"},
	{"number": 5, "name": "ZONE SELECT 2"},
	{"number": 42, "name": "IN SP STAGE"},
	{"number": 43, "name": "SP STAGE"},
	{"number": 44, "name": "SP STAGE-PINCH"},
	{"number": 45, "name": "ACHIEVEMENT"},
	{"number": 46, "name": "SP CLEAR"},
	{"number": 47, "name": "SP RESULT 1"},
	{"number": 48, "name": "SP RESULT 2"},
	{"number": 49, "name": "SP RESULT 3"},
	{"number": 35, "name": "FINAL ENDING"},
	{"number": 37, "name": "STAFF ROLL"},
	{"number": 67, "name": "MESSAGE"},
	{"number": 7, "name": "TIMEATTACK 1"},
	{"number": 59, "name": "TIMEATTACK 2"},
	{"number": 60, "name": "TIMEATTACK 3"},
	{"number": 8, "name": "OPTIONS"},
	{"number": 54, "name": "VS WAIT"},
	{"number": 50, "name": "VS 1"},
	{"number": 51, "name": "VS 2"},
	{"number": 53, "name": "VS 3"},
	{"number": 52, "name": "VS 4"},
	{"number": 63, "name": "VS END"},
]
var _sound_test_bonus_tracks: Array = [
	{"number": 6, "name": "ZONE SELECT 3"},
	{"number": 40, "name": "EXTRA DEMO 1"},
	{"number": 41, "name": "EXTRA DEMO 2"},
	{"number": 24, "name": "EXTRA ZONE"},
	{"number": 58, "name": "EXTRA CLEAR"},
	{"number": 36, "name": "EXTRA ENDING"},
]
const SOUND_TEST_TEMPOS: Array[float] = [
	17.5, 17.5, 16.0, 16.0625, 16.6875, 16.25, 15.25, 15.0,
	20.75, 20.75, 21.0234375, 20.4375, 16.842285, 16.842285, 19.0, 27.0,
	17.8125, 20.0, 20.5, 21.5, 20.125, 21.5, 20.75, 21.5,
	16.8203125, 19.25, 21.25, 20.0, 20.5, 22.5, 23.6875, 18.0,
	19.125, 16.0, 17.0, 22.5, 19.0, 16.0, 14.75, 18.875,
	19.0625, 16.0, 21.0, 22.0, 21.0, 20.0, 26.3125, 18.0,
	23.75, 20.8125, 20.0, 21.0, 16.875, 20.0, 18.0, 19.0,
	21.0, 18.0, 18.0, 21.0, 16.0, 16.0, 16.0, 16.0,
	18.0, 16.0, 20.0,
]
var _sound_test_completed_order: Array = [
	1, 2, 3, 4, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23,
	27, 28, 29, 30, 31, 32, 33, 55, 56, 57, 34, 25, 26, 61, 38, 39, 5,
	42, 43, 44, 45, 46, 47, 48, 49, 35, 37, 67, 7, 59, 60, 8, 54, 50,
	51, 53, 52, 63, 6, 40, 41, 24, 58, 36,
]
var _time_record_rows: Array = [
	["SONIC", "00'58\"24"],
	["CREAM", "01'04\"81"],
	["TAILS", "01'02\"36"],
	["KNUCKLES", "01'08\"47"],
]
var _multi_record_rows: Array = []
var _multiplayer_record_totals: Dictionary = {"wins": 0, "losses": 0, "draws": 0}
var _selected_character_index: int = 0
var _title_notice_text: String = ""
var _character_select_context: int = CHARACTER_SELECT_CONTEXT_GAME_START
var _boss_time_attack_unlocked: bool = false
var _return_to_multiplayer_after_name_entry: bool = false
var _return_to_title_after_new_profile: bool = false
var _creating_new_profile: bool = false
var _return_to_multiplayer_menu_index: int = 0
var _multiplayer_name_entry_snapshot: Array = []
var _multiplayer_pak_mode: int = 0
var _multiplayer_link_players: Array = ["YOU", "P2", "P3", "P4"]
var _multiplayer_link_connected: Array = [true, false, false, false]
var _multiplayer_player_characters: Array = [0, 1, 2, 3]
var _multiplayer_player_ranks: Array = [0, 1, 2, 3]
var _multiplayer_link_ready: bool = false
var _multiplayer_disconnect_timer: float = 0.0
var _singlepak_download_progress: int = 0
var _singlepak_download_timer: float = 0.0
var _singlepak_sync_step: int = 0
var _multiplayer_result_mode: int = MULTIPLAYER_RESULTS_MODE_COURSE_COMPLETE
var _multiplayer_result_snapshot: Array = []
var _singlepak_results_cursor: int = 0
var _singlepak_results_timer: float = 0.0
var _singlepak_results_character_duration: float = 1.0
var _singlepak_results_course_duration: float = 5.0
var _multiplayer_lobby_cursor: int = 0
var _multiplayer_lobby_waiting: bool = false
var _multiplayer_lobby_wait_timer: float = 0.0
var _multiplayer_lobby_wait_duration: float = 0.8
var _multiplayer_lobby_exit_timer: float = 0.0
var _multiplayer_outcome_type: int = 0
var _multiplayer_outcome_timer: float = 0.0
# communication_outcome.c holds the result for 0x78 frames, then raises the
# blend for 16 more frames before entering character select/title.
var _multiplayer_outcome_duration: float = (120.0 + 16.0) / 60.0
var _multiplayer_outcome_return_phase: int = TITLE_PHASE_MULTI_CONNECT
var _multiplayer_course_results_committed: bool = false
var _time_attack_lobby_cursor: int = 0
var _time_attack_boss_mode: bool = false
var _course_select_return_phase: int = TITLE_PHASE_TIME_ATTACK_LOBBY
var _course_select_travel_timer: float = 0.0
var _course_select_travel_duration: float = 0.18
var _course_select_settle_timer: float = 0.0
var _course_select_settle_duration: float = 0.10
var _course_select_confirm_pending: bool = false
const COURSE_UNLOCK_PHASE_PATH := 0
const COURSE_UNLOCK_PHASE_SCROLL_BACK := 1
const COURSE_UNLOCK_PHASE_SCROLL_NEXT := 2
const COURSE_UNLOCK_PHASE_PAUSE := 3
const COURSE_UNLOCK_PATH_FRAMES := 18
const COURSE_UNLOCK_PAUSE_FRAMES := 61
var _course_select_unlock_timer: float = 0.0
var _course_select_unlock_phase: int = COURSE_UNLOCK_PHASE_PATH
var _course_select_unlock_phase_timer: float = 0.0
var _course_select_unlock_phase_duration: float = 0.0
var _course_select_start_timer: float = 0.0
var _course_select_start_duration: float = 0.24
var _course_select_intro_timer: float = 0.0
var _course_select_intro_duration: float = 0.34
var _course_select_from_index: int = 0
var _course_select_to_index: int = 0
var _run_from_time_attack: bool = false
var _run_from_multiplayer: bool = false
var _tiny_chao_session_id: String = "TCG-0000"
var _tiny_chao_unlocked: bool = false
var _tiny_chao_play_x: float = 0.0
var _tiny_chao_play_y: float = 0.0
var _tiny_chao_hunger: int = 50
var _tiny_chao_mood: int = 50
var _tiny_chao_fruit: int = 3
var _tiny_chao_care_count: int = 0
var _tiny_chao_action_timer: float = 0.0
var _tiny_chao_action_text: String = "WELCOME TO THE GARDEN"
var _tiny_chao_selected_index: int = 0
var _tiny_chao_roster: Array = _get_default_tiny_chao_roster()
var _true_area_unlocked: bool = false
var _extra_zone_status: int = 0
var _character_names: Array = ["SONIC", "CREAM", "TAILS", "KNUCKLES", "AMY"]
var _character_descriptions: Array = [
	"BALANCED SPEED TYPE",
	"FLIGHT AND CHEESE SUPPORT",
	"FLIGHT AND TECHNICAL ROUTES",
	"POWER AND CLIMB ROUTES",
	"HAMMER TECHNIQUE",
]
var _character_unlocked: Array = [true, false, false, false, false]
var _completed_character_routes: Array = [false, false, false, false, false]
const PROFILE_NAME_CHARS := [
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
	"N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
	"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "-", "!", "?",
]

func _ready() -> void:
	_load_save_data()
	if _save_id == 0 or not has_profile_name():
		open_profile_name_from_game_start()
	else:
		_open_boot_intro()

func reset_to_title() -> void:
	_boot_intro_pending = false
	_game_state = GAME_STATE_TITLE
	_screen_fade_alpha = 0.0
	_screen_fade_last_state = -1
	_screen_fade_last_phase = -1
	_elapsed_time = 0.0
	_velocity_y = 0.0
	_level_complete = false
	_intro_timer = 0.0
	_final_intro_timer = 0.0
	_final_intro_pending = false
	_intro_primed = false
	_intro_speed_boost = false
	_intro_boost_disabled = false
	_race_start_message_timer = 0.0
	_start_boost_timer = 0.0
	_clear_time_snapshot = 0.0
	_clear_score_snapshot = 0
	_clear_final_score_snapshot = 0
	_clear_rank_text = "D"
	_clear_ring_snapshot = 0
	_clear_special_ring_snapshot = 0
	_clear_previous_best_time = -1.0
	_clear_new_best_time = false
	_clear_time_attack_record_rank = 0
	_time_attack_result_timer = 0.0
	_time_attack_exit_timer = 0.0
	_clear_time_bonus_remaining = 0
	_clear_ring_bonus_remaining = 0
	_clear_special_ring_bonus_remaining = 0
	_clear_total_display_score = 0
	_clear_count_step_accumulator = 0.0
	_clear_count_delay_timer = 0.0
	_clear_input_lock_timer = 0.0
	_clear_counting_done = false
	_clear_from_goal = false
	_pause_a_hold_lock = false
	_pause_a_previous_held = false
	_game_over_timer = 0.0
	_game_over_input_lock_timer = 0.0
	_game_over_time_over = false
	_chaos_emeralds_timer = 0.0
	_to_be_continued_timer = 0.0
	_sega_logo_timer = 0.0
	_sonic_team_timer = 0.0
	_copyright_timer = 0.0
	_credits_end_timer = 0.0
	_credits_end_show_missing_emeralds = false
	_character_unlock_timer = 0.0
	_character_unlock_segment = 0
	_character_unlock_scene_frame = 0.0
	_character_unlock_pending = -1
	_character_select_intro_timer = 0.0
	_play_mode_intro_timer = 0.0
	_time_attack_mode_intro_timer = 0.0
	_multiplayer_mode_intro_timer = 0.0
	_special_stage_timer = 0.0
	_special_stage_pending = false
	_special_stage_phase = 0
	_special_stage_lane = 1
	_special_stage_progress = 0.0
	_special_stage_last_segment = -1
	_special_stage_target_reached = false
	_special_stage_paused = false
	_special_stage_pause_cursor = 0
	_special_stage_multiplier = 1
	_special_stage_multiplier_streak = 0
	_special_stage_multiplier_timer = 0.0
	_special_stage_robo_progress = 0.15
	_special_stage_robo_lane = 1
	_special_stage_robo_speed = 0.18
	_special_stage_robo_lane_timer = 0.35
	_special_stage_robo_cooldown = 0.0
	_special_stage_speed = 1.0
	_special_stage_jump_timer = 0.0
	_special_stage_points_remaining = 0
	_special_stage_bonus_remaining = 0
	_special_stage_result_hold_started = false
	_save_reset_pending = false
	_status_text = get_title_prompt_text()
	_title_text = "SONIC ADVANCE RECLAIMED"
	_pause_text = get_pause_text()
	_save_menu_text = "SAVE OPTIONS"
	_selected_level_index = clamp(_selected_level_index, 0, _unlocked_level_index)
	_save_menu_index = 0
	_title_phase = TITLE_PHASE_PRESS_START
	_title_menu_index = 0
	_title_idle_timer = 0.0
	_demo_mode = false
	_demo_elapsed = 0.0
	_single_player_intro_timer = 0.0
	_options_mode = OPTIONS_MODE_MAIN
	_options_menu_index = 0
	_player_data_menu_index = 0
	_button_config_index = 0
	_sound_test_menu_index = 0
	_sound_test_track_index = 0
	_sound_test_state = SOUND_TEST_STATE_STOPPED
	_time_records_menu_index = 0
	_time_records_view = TIME_RECORDS_VIEW_MODE_CHOICE
	_time_records_context = TIME_RECORDS_CONTEXT_OPTIONS
	_time_records_boss_mode = false
	_time_records_character_index = 0
	_time_records_course_index = 0
	_time_records_act_index = 0
	_multi_records_menu_index = 0
	_name_entry_menu_index = 0
	_delete_confirm_index = 1
	_save_reset_pending = false
	_selected_character_index = 0
	_title_notice_text = ""
	_character_select_context = CHARACTER_SELECT_CONTEXT_GAME_START
	_return_to_multiplayer_after_name_entry = false
	_return_to_title_after_new_profile = false
	_creating_new_profile = false
	_multiplayer_pak_mode = 0
	_multiplayer_link_connected = [true, false, false, false]
	_multiplayer_player_characters = [0, 1, 2, 3]
	_multiplayer_player_ranks = [0, 1, 2, 3]
	_multiplayer_link_ready = false
	_multiplayer_disconnect_timer = 0.0
	_singlepak_download_progress = 0
	_singlepak_download_timer = 0.0
	_singlepak_sync_step = 0
	_multiplayer_result_mode = MULTIPLAYER_RESULTS_MODE_COURSE_COMPLETE
	_multiplayer_result_snapshot = []
	_singlepak_results_cursor = 0
	_singlepak_results_timer = 0.0
	_multiplayer_lobby_cursor = 0
	_multiplayer_lobby_waiting = false
	_multiplayer_lobby_wait_timer = 0.0
	_multiplayer_lobby_exit_timer = 0.0
	_multiplayer_outcome_type = 0
	_multiplayer_outcome_timer = 0.0
	_multiplayer_outcome_return_phase = TITLE_PHASE_MULTI_CONNECT
	_multiplayer_course_results_committed = false
	_time_attack_lobby_cursor = 0
	_time_attack_boss_mode = false
	_course_select_return_phase = TITLE_PHASE_TIME_ATTACK_LOBBY
	_course_select_travel_timer = 0.0
	_course_select_settle_timer = 0.0
	_course_select_confirm_pending = false
	_course_select_unlock_timer = 0.0
	_course_select_start_timer = 0.0
	_course_select_from_index = _selected_level_index
	_course_select_to_index = _selected_level_index
	_run_from_time_attack = false
	_run_from_multiplayer = false
	_tiny_chao_session_id = "TCG-0000"
	_tiny_chao_play_x = 0.0
	_tiny_chao_play_y = 0.0
	_tiny_chao_hunger = 50
	_tiny_chao_mood = 50
	_tiny_chao_fruit = 3
	_tiny_chao_care_count = 0
	_tiny_chao_action_timer = 0.0
	_tiny_chao_action_text = "WELCOME TO THE GARDEN"
	_tiny_chao_selected_index = 0
	_level_state = LevelState.new()
	_level_state.level_id = 0
	_level_state.name = "Title Screen"
	_level_state.spawn_x = 180.0
	_level_state.spawn_y = 460.0
	_level_state.ground_y = 460.0
	_level_state.min_x = 0.0
	_level_state.max_x = 2400.0
	_level_state.min_y = 0.0
	_level_state.max_y = 720.0
	_level_state.platforms = []
	_level_state.entities = []
	_reset_player()
	_player_state.is_alive = false
	_player_state.has_cleared_level = false

func open_title_screen_and_skip_intro() -> void:
	reset_to_title()

func open_press_start_screen(notice_text: String = "") -> void:
	reset_to_title()
	_title_notice_text = notice_text
	_status_text = get_title_prompt_text()

func open_title_screen_at_play_mode_menu(selected_index: int = 0, notice_text: String = "", animate_intro: bool = false) -> void:
	reset_to_title()
	_title_phase = TITLE_PHASE_PLAY_MODE
	_title_menu_index = clampi(selected_index, 0, max(get_title_menu_items().size() - 1, 0))
	_play_mode_intro_timer = 16.0 / 60.0 if animate_intro else 0.0
	_title_notice_text = notice_text
	_status_text = get_title_prompt_text()

func is_play_mode_input_ready() -> bool:
	return _game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_PLAY_MODE and _play_mode_intro_timer <= 0.0

func open_title_screen_at_single_player_menu(selected_index: int = 0, notice_text: String = "", animate_intro: bool = false) -> void:
	reset_to_title()
	_title_phase = TITLE_PHASE_SINGLE_PLAYER
	_title_menu_index = clampi(selected_index, 0, max(get_title_menu_items().size() - 1, 0))
	_single_player_intro_timer = 13.0 / 60.0 if animate_intro else 0.0
	_title_notice_text = notice_text
	_status_text = get_title_prompt_text()

func is_single_player_input_ready() -> bool:
	return _game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_SINGLE_PLAYER and _single_player_intro_timer <= 0.0

func open_title_screen_at_multiplayer_menu(selected_index: int = 0, notice_text: String = "") -> void:
	reset_to_title()
	_title_phase = TITLE_PHASE_MULTI_PLAYER
	_title_menu_index = clampi(selected_index, 0, max(get_title_menu_items().size() - 1, 0))
	_multiplayer_mode_intro_timer = 47.0 / 60.0
	_title_notice_text = notice_text
	_status_text = get_title_prompt_text()

func is_multiplayer_mode_input_ready() -> bool:
	return _game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_MULTI_PLAYER and _multiplayer_mode_intro_timer <= 0.0

func skip_multiplayer_mode_intro() -> void:
	if not (_game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_MULTI_PLAYER):
		return
	_multiplayer_mode_intro_timer = minf(_multiplayer_mode_intro_timer, 32.0 / 60.0)

func get_multiplayer_mode_intro_progress() -> float:
	if not is_multiplayer_mode_screen():
		return 1.0
	return clampf(1.0 - (_multiplayer_mode_intro_timer / (47.0 / 60.0)), 0.0, 1.0)

func open_title_screen_at_time_attack_menu(selected_index: int = 0, notice_text: String = "") -> void:
	reset_to_title()
	_title_phase = TITLE_PHASE_TIME_ATTACK
	_title_menu_index = clampi(selected_index, 0, max(get_title_menu_items().size() - 1, 0))
	_time_attack_mode_intro_timer = 47.0 / 60.0
	_title_notice_text = notice_text
	_status_text = get_title_prompt_text()

func is_time_attack_mode_input_ready() -> bool:
	return _game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_TIME_ATTACK and _time_attack_mode_intro_timer <= 0.0

func get_time_attack_mode_intro_progress() -> float:
	if not is_time_attack_mode_screen():
		return 1.0
	return clampf(1.0 - (_time_attack_mode_intro_timer / (47.0 / 60.0)), 0.0, 1.0)

func skip_time_attack_mode_intro() -> void:
	if not (_game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_TIME_ATTACK):
		return
	_time_attack_mode_intro_timer = minf(_time_attack_mode_intro_timer, 32.0 / 60.0)

func open_tiny_chao_garden_menu(selected_index: int = 0, notice_text: String = "") -> void:
	_game_state = GAME_STATE_TITLE
	_title_phase = TITLE_PHASE_TINY_CHAO_GARDEN
	_title_menu_index = clampi(selected_index, 0, max(get_title_menu_items().size() - 1, 0))
	_title_notice_text = notice_text
	_status_text = get_title_prompt_text()

func open_tiny_chao_setup_menu(selected_index: int = 0, notice_text: String = "") -> void:
	_game_state = GAME_STATE_TITLE
	_title_phase = TITLE_PHASE_TINY_CHAO_SETUP
	_title_menu_index = clampi(selected_index, 0, max(get_title_menu_items().size() - 1, 0))
	_title_notice_text = notice_text
	_status_text = get_title_prompt_text()

func open_tiny_chao_garden_play() -> void:
	_game_state = GAME_STATE_TITLE
	_title_phase = TITLE_PHASE_TINY_CHAO_GARDEN_PLAY
	_title_menu_index = 0
	_title_notice_text = ""
	_tiny_chao_play_x = 0.0
	_tiny_chao_play_y = 0.0
	_tiny_chao_action_text = "WELCOME TO THE GARDEN"
	_tiny_chao_selected_index = clampi(_tiny_chao_selected_index, 0, _tiny_chao_roster.size() - 1)
	_sync_tiny_chao_selection()
	_status_text = "LEFT/RIGHT MOVE   A CARE   B EXIT"

func open_singlepak_results_screen(result_mode: int = MULTIPLAYER_RESULTS_MODE_COURSE_COMPLETE, cursor: int = 0, notice_text: String = "") -> void:
	_game_state = GAME_STATE_TITLE
	_multiplayer_result_mode = clampi(result_mode, MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION, MULTIPLAYER_RESULTS_MODE_COURSE_COMPLETE)
	_title_phase = TITLE_PHASE_SINGLEPAK_RESULTS
	_singlepak_results_cursor = clampi(cursor, 0, max(get_singlepak_results_items().size() - 1, 0))
	_singlepak_results_timer = _singlepak_results_character_duration if _multiplayer_result_mode == MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION else _singlepak_results_course_duration
	_title_notice_text = notice_text
	_status_text = get_title_prompt_text()

func open_multiplayer_lobby_screen(cursor: int = 0, notice_text: String = "") -> void:
	_game_state = GAME_STATE_TITLE
	_title_phase = TITLE_PHASE_MULTIPLAYER_LOBBY
	_multiplayer_lobby_cursor = clampi(cursor, 0, max(get_multiplayer_lobby_items().size() - 1, 0))
	_multiplayer_lobby_waiting = false
	_multiplayer_lobby_wait_timer = 0.0
	_multiplayer_lobby_exit_timer = 0.0
	_title_notice_text = notice_text
	_status_text = get_title_prompt_text()

func open_multiplayer_comm_screen(pak_mode: int, cursor: int = 0, notice_text: String = "") -> void:
	_game_state = GAME_STATE_TITLE
	_multiplayer_pak_mode = clampi(pak_mode, 0, 1)
	_multiplayer_disconnect_timer = 0.0
	_title_phase = TITLE_PHASE_MULTI_CONNECT
	_title_menu_index = clampi(cursor, 0, max(get_title_menu_items().size() - 1, 0))
	_title_notice_text = notice_text
	_status_text = get_title_prompt_text()

func open_singlepak_sync_screen(cursor: int = 0, notice_text: String = "") -> void:
	_game_state = GAME_STATE_TITLE
	_title_phase = TITLE_PHASE_SINGLEPAK_SYNC
	_title_menu_index = clampi(cursor, 0, max(get_title_menu_items().size() - 1, 0))
	_title_notice_text = notice_text
	_status_text = get_title_prompt_text()

func open_multiplayer_outcome_screen(outcome: int, return_phase: int, notice_text: String = "") -> void:
	_game_state = GAME_STATE_TITLE
	_multiplayer_outcome_type = clampi(outcome, 0, 1)
	_multiplayer_outcome_return_phase = return_phase
	_multiplayer_outcome_timer = _multiplayer_outcome_duration
	_title_phase = TITLE_PHASE_MULTIPLAYER_OUTCOME
	_title_menu_index = 0
	_title_notice_text = notice_text
	_status_text = get_title_prompt_text()

func open_time_attack_level_select_screen(is_boss_mode: bool = _time_attack_boss_mode) -> void:
	_game_state = GAME_STATE_SAVE_OPTIONS
	_options_mode = OPTIONS_MODE_TIME_RECORDS
	_time_records_context = TIME_RECORDS_CONTEXT_TIME_ATTACK
	_time_records_view = TIME_RECORDS_VIEW_COURSES
	_time_records_boss_mode = is_boss_mode
	_time_records_menu_index = 0
	_time_records_character_index = _selected_character_index
	_time_records_course_index = 0
	_time_records_act_index = 0
	update_save_menu_status()

func open_course_select_screen(return_phase: int = TITLE_PHASE_TIME_ATTACK_LOBBY, notice_text: String = "", unlock_cutscene: bool = false) -> void:
	_game_state = GAME_STATE_TITLE
	_course_select_return_phase = return_phase
	_title_phase = TITLE_PHASE_COURSE_SELECT
	_course_select_travel_timer = 0.0
	_course_select_settle_timer = 0.0
	_course_select_confirm_pending = false
	_course_select_unlock_phase = COURSE_UNLOCK_PHASE_PATH
	_course_select_unlock_phase_timer = 0.0
	_course_select_unlock_phase_duration = 0.0
	_course_select_unlock_timer = 0.0
	_course_select_intro_timer = _course_select_intro_duration
	if unlock_cutscene:
		_start_course_select_unlock_cutscene()
	_course_select_start_timer = 0.0
	_course_select_from_index = _selected_level_index
	_course_select_to_index = _selected_level_index
	_title_notice_text = notice_text if not notice_text.is_empty() else "COURSE READY: %s" % get_selected_level_text()
	_status_text = get_title_prompt_text()

func open_multiplayer_outcome_return_phase(return_phase: int, notice_text: String = "") -> void:
	match return_phase:
		TITLE_PHASE_PRESS_START:
			open_press_start_screen(notice_text)
		TITLE_PHASE_PLAY_MODE:
			open_title_screen_at_play_mode_menu(1, notice_text)
		TITLE_PHASE_SINGLE_PLAYER:
			open_title_screen_at_single_player_menu(0, notice_text)
		TITLE_PHASE_TIME_ATTACK:
			open_title_screen_at_time_attack_menu(1 if _time_attack_boss_mode else 0, notice_text)
		TITLE_PHASE_SINGLEPAK_RESULTS:
			open_singlepak_results_screen(_multiplayer_result_mode, 0, notice_text)
		TITLE_PHASE_MULTIPLAYER_LOBBY:
			open_multiplayer_lobby_screen(0, notice_text)
		TITLE_PHASE_MULTI_PLAYER:
			open_title_screen_at_multiplayer_menu(_multiplayer_pak_mode, notice_text)
		TITLE_PHASE_TINY_CHAO_GARDEN:
			open_tiny_chao_garden_menu(0, notice_text)
		TITLE_PHASE_TINY_CHAO_SETUP:
			open_tiny_chao_setup_menu(0, notice_text)
		TITLE_PHASE_TIME_ATTACK_LOBBY:
			open_time_attack_lobby(_time_attack_boss_mode)
			_title_notice_text = notice_text
			_status_text = get_title_prompt_text()
		_:
			open_press_start_screen(notice_text)

func return_from_course_select(notice_text: String = "") -> void:
	_title_notice_text = notice_text
	match _course_select_return_phase:
		TITLE_PHASE_PRESS_START:
			open_press_start_screen(notice_text)
		TITLE_PHASE_PLAY_MODE:
			open_title_screen_at_play_mode_menu(0, notice_text)
		TITLE_PHASE_SINGLE_PLAYER:
			open_title_screen_at_single_player_menu(0, notice_text)
		TITLE_PHASE_MULTI_PLAYER:
			open_title_screen_at_multiplayer_menu(_multiplayer_pak_mode, notice_text)
		TITLE_PHASE_TIME_ATTACK:
			open_title_screen_at_time_attack_menu(1 if _time_attack_boss_mode else 0, notice_text)
		TITLE_PHASE_SINGLEPAK_RESULTS:
			open_singlepak_results_screen(_multiplayer_result_mode, 0, notice_text)
		TITLE_PHASE_TIME_ATTACK_LOBBY:
			open_time_attack_lobby(_time_attack_boss_mode)
			_title_notice_text = notice_text
			_status_text = get_title_prompt_text()
		TITLE_PHASE_MULTI_CONNECT:
			open_multiplayer_comm_screen(_multiplayer_pak_mode, _title_menu_index, notice_text)
		TITLE_PHASE_SINGLEPAK_SYNC:
			open_singlepak_sync_screen(_title_menu_index, notice_text)
		TITLE_PHASE_TINY_CHAO_GARDEN:
			open_tiny_chao_garden_menu(0, notice_text)
		TITLE_PHASE_TINY_CHAO_SETUP:
			open_tiny_chao_setup_menu(0, notice_text)
		_:
			open_press_start_screen(notice_text)

func init_level(level_id: int, from_time_attack: bool = false, from_multiplayer: bool = false) -> void:
	level_id = clamp(level_id, 0, _unlocked_level_index)
	_run_from_time_attack = from_time_attack
	_run_from_multiplayer = from_multiplayer
	if from_multiplayer:
		_multiplayer_course_results_committed = false
	_elapsed_time = 0.0
	_velocity_y = 0.0
	_level_complete = false
	# Keep the stage-intro presentation and the course countdown as separate
	# phases while retaining one timer for the compact Godot screen.
	_intro_timer = STAGE_INTRO_DURATION if _is_boss_intro() else INTRO_TOTAL_TIME
	_final_intro_timer = 0.0
	_final_intro_pending = false
	_intro_primed = false
	_intro_speed_boost = false
	_intro_boost_disabled = false
	_race_start_message_timer = 0.0
	_start_boost_timer = 0.0
	_clear_time_snapshot = 0.0
	_clear_score_snapshot = 0
	_clear_final_score_snapshot = 0
	_clear_rank_text = "D"
	_clear_ring_snapshot = 0
	_clear_special_ring_snapshot = 0
	_clear_previous_best_time = -1.0
	_clear_new_best_time = false
	_clear_time_attack_record_rank = 0
	_clear_time_bonus_remaining = 0
	_clear_ring_bonus_remaining = 0
	_clear_special_ring_bonus_remaining = 0
	_clear_total_display_score = 0
	_clear_count_step_accumulator = 0.0
	_clear_count_delay_timer = 0.0
	_clear_input_lock_timer = 0.0
	_clear_counting_done = false
	_clear_from_goal = false
	_game_over_timer = 0.0
	_game_over_input_lock_timer = 0.0
	_game_over_time_over = false
	_save_reset_pending = false
	_status_text = "READY!"
	_title_text = _level_names[level_id]
	_source_map_manifest = SOURCE_MAP_LOADER.load_level(level_id, from_time_attack and _time_attack_boss_mode)
	_pause_text = get_pause_text()
	_level_state = _build_level(level_id)
	_spawn_x = _level_state.spawn_x
	_spawn_y = _level_state.spawn_y
	_respawn_x = _spawn_x
	_respawn_y = _spawn_y
	_checkpoint_time = 0.0
	_damage_cooldown = 0.0
	_invincibility_timer = 0.0
	_clear_screen_shake()
	_reset_input_buffer()
	_speed_up_timer = 0.0
	_magnetic_shielded = false
	_defeat_score_index = 0
	_reset_player()
	_player_state.is_alive = true
	if _player_state.variant == 1 and not _run_from_multiplayer and level_id < 15:
		_spawn_cheese_companion()
	if level_id == _level_names.size() - 1 and not from_time_attack and not from_multiplayer:
		_game_state = GAME_STATE_FINAL_INTRO
		_final_intro_timer = 10.0
		_final_intro_pending = true
		_status_text = "TRUE AREA 53 INTRO"
	else:
		_game_state = GAME_STATE_INTRO

func _begin_level_run(level_id: int, from_time_attack: bool, from_multiplayer: bool = false) -> void:
	init_level(level_id, from_time_attack, from_multiplayer)

func physics_tick(held_input: int, frame_input: int, delta: float) -> void:
	_frame_input = frame_input
	_update_screen_shake(delta)
	_record_input_frame(frame_input)
	_jump_buffer_timer = maxf(0.0, _jump_buffer_timer - delta)
	if frame_input & A_BUTTON and not _player_state.is_grounded:
		_jump_buffer_timer = JUMP_BUFFER_DURATION
	_damage_cooldown = maxf(0.0, _damage_cooldown - delta)
	_invincibility_timer = maxf(0.0, _invincibility_timer - delta)
	_speed_up_timer = maxf(0.0, _speed_up_timer - delta)
	_boost_effect_timer = maxf(0.0, _boost_effect_timer - delta)
	_spindash_release_timer = maxf(0.0, _spindash_release_timer - delta)
	_braking_dust_cooldown = maxf(0.0, _braking_dust_cooldown - delta)
	if _game_state == GAME_STATE_TITLE:
		if frame_input & DPAD_UP:
			_selected_level_index = max(0, _selected_level_index - 1)
			_save_save_data()
			_status_text = get_title_prompt_text()
		if frame_input & DPAD_DOWN:
			_selected_level_index = min(_unlocked_level_index, _selected_level_index + 1)
			_save_save_data()
			_status_text = get_title_prompt_text()
		if frame_input & B_BUTTON:
			_game_state = GAME_STATE_SAVE_OPTIONS
			_save_menu_index = 0
			_status_text = _save_menu_text
		if frame_input & START_BUTTON or frame_input & A_BUTTON:
			init_level(_selected_level_index)
		_update_camera()
		return

	if _game_state == GAME_STATE_SAVE_OPTIONS:
		if _save_reset_pending:
			if frame_input & START_BUTTON or frame_input & A_BUTTON:
				_reset_progress()
				_save_reset_pending = false
				open_press_start_screen()
			if frame_input & B_BUTTON or frame_input & SELECT_BUTTON:
				_save_reset_pending = false
			_update_camera()
			return
		if frame_input & DPAD_UP or frame_input & DPAD_DOWN:
			_save_menu_index = 1 - _save_menu_index
		if frame_input & START_BUTTON or frame_input & A_BUTTON:
			if _save_menu_index == 0:
				_save_reset_pending = true
				_status_text = "CONFIRM RESET? %s YES, %s NO" % [get_confirm_label(), get_secondary_label()]
			else:
				open_press_start_screen()
		if frame_input & B_BUTTON or frame_input & SELECT_BUTTON:
			open_press_start_screen()
		_update_camera()
		return

	if _game_state == GAME_STATE_INTRO:
		# countdown.c checks gPressedKeys, not the held directional state:
		# pressing Right during the boost window enables the start boost, but
		# holding it from earlier does not.
		if frame_input & DPAD_RIGHT:
			# countdown.c enables the boost only below the five-frame boundary.
			if _intro_timer < INTRO_BOOST_WINDOW and not _intro_boost_disabled:
				_intro_speed_boost = true
			elif _intro_timer >= INTRO_BOOST_WINDOW:
				_intro_boost_disabled = true
		# stage_intro.c only skips single-player non-boss intros with A or B.
		if (frame_input & A_BUTTON or frame_input & B_BUTTON) and _intro_timer > INTRO_COUNTDOWN_START and can_skip_intro():
			_intro_timer = INTRO_COUNTDOWN_START
		_intro_timer = max(0.0, _intro_timer - delta)
		if _intro_timer <= INTRO_GO_TIME:
			_intro_primed = true
			_status_text = "GO!"
		elif _intro_timer <= INTRO_COUNTDOWN_START:
			_intro_primed = true
			_status_text = "BOSS READY" if _is_boss_intro() else get_intro_countdown_text()
		else:
			_status_text = "READY!"
		if _intro_timer <= 0.0:
			_game_state = GAME_STATE_PLAYING
			# countdown.c displays the race-start message for normal courses;
			# boss intros hand control straight to the encounter.
			_race_start_message_timer = 0.0 if _is_boss_intro() else 1.0
			_start_boost_timer = INTRO_BOOST_DURATION if _intro_speed_boost and not _intro_boost_disabled else 0.0
			_player_state.speed_x = INTRO_BOOST_SPEED if _start_boost_timer > 0.0 else 0.0
			_player_state.ground_speed = _player_state.speed_x
			_status_text = "DEFEAT THE BOSS" if _is_boss_intro() else ("OUTRUN RIVALS" if _run_from_multiplayer else "REACH THE GOAL")
		_update_camera()
		return

	if _game_state == GAME_STATE_CLEAR:
		if not is_clear_input_ready():
			# SA2's result counter is fast-forwarded by A, not START.
			# The original ignores A during the opening results delay and only
			# accepts it once score counting has started.
			var is_final_or_extra_stage := _selected_level_index >= _level_names.size() - 2
			# stage_results.c begins accepting A on the frame the 150-frame
			# opening delay expires; the timer is decremented later this tick.
			if frame_input & A_BUTTON and _clear_count_delay_timer <= delta and not is_final_or_extra_stage:
				_finish_clear_counting(true)
		else:
			if frame_input & START_BUTTON or frame_input & A_BUTTON:
				clear_replay()
			if frame_input & B_BUTTON or frame_input & SELECT_BUTTON:
				clear_return_to_title()
		_update_camera()
		return

	if _game_state == GAME_STATE_PAUSED:
		_update_pause_menu_input(held_input, frame_input)
		return

	if _demo_mode:
		if held_input != 0 or frame_input != 0:
			open_press_start_screen("DEMO INTERRUPTED")
			return
		_demo_elapsed += delta
		if _demo_elapsed >= 20.0:
			open_press_start_screen()
			return

	# stage.c creates the pause task only for single-player runs.
	if _game_state == GAME_STATE_PLAYING and frame_input & START_BUTTON and not _run_from_multiplayer:
		toggle_pause(held_input)
		_update_camera()
		return

	if not _player_state.is_alive:
		return

	_elapsed_time += delta
	_update_super_sonic(delta)
	_start_boost_timer = maxf(0.0, _start_boost_timer - delta)
	_attack_timer = maxf(0.0, _attack_timer - delta)
	_flight_timer = maxf(0.0, _flight_timer - delta)
	_glide_timer = maxf(0.0, _glide_timer - delta)
	var time_limit_active := _run_from_time_attack or _time_limit_enabled
	if time_limit_active and _elapsed_time >= MAX_COURSE_TIME_SECONDS:
		# stage.c sends time-attack deaths straight back to its lobby; the
		# TIME OVER card is reserved for the regular stage life-loss path.
		if _run_from_time_attack:
			open_time_attack_lobby(_time_attack_boss_mode)
			_update_camera()
			return
		_open_game_over(true)
		_update_camera()
		return
	_update_enemy_motion(delta)
	_update_flying_spring_motion(delta)
	_update_flying_handle_state(delta)
	_update_slidy_ice_state()
	_update_slowing_snow_state()
	_update_light_bridge_state(delta)
	_update_spike_platform_state()
	_update_turnaround_bar_state(delta)
	_update_keyboard_state(delta)
	_update_pole_state()
	_update_light_globe_state(delta)
	_update_windup_stick_state(delta)
	_update_german_flute_state(delta, held_input)
	_update_small_windmill_state(delta)
	_update_chord_state(delta)
	_update_note_state(delta)
	_update_note_particle_state(delta)
	_update_half_pipe_state(frame_input)
	_update_iron_ball_state(delta)
	_update_crane_state(delta)
	_update_ceiling_slope_state(delta)
	_update_gapped_loop_state(delta)
	_update_funnel_sphere_state(delta)
	_update_music_entry_state(delta)
	var previous_world_x := _player_state.world_x
	var previous_world_y := _player_state.world_y
	_update_platform_motion(delta)

	var move_direction := 0
	if held_input & DPAD_LEFT:
		move_direction -= 1
	if held_input & DPAD_RIGHT:
		move_direction += 1
	var speed_multiplier := 1.35 if _speed_up_timer > 0.0 else 1.0
	var snow_multiplier := 0.95 if _on_slowing_snow else 1.0
	var current_move_speed := (INTRO_BOOST_SPEED if _start_boost_timer > 0.0 else _move_speed) * speed_multiplier * snow_multiplier
	if _player_state.super_sonic:
		# Super Sonic's directional task uses the extra-boss top speed rather
		# than the regular character acceleration profile.
		current_move_speed = 900.0 * speed_multiplier
	var current_move_direction := 1 if _start_boost_timer > 0.0 and move_direction == 0 else move_direction
	var gravity_direction := -1.0 if _gravity_inverted else 1.0
	if _player_state.is_grounded and current_move_direction != 0 and absf(_player_state.speed_x) > 160.0 and signf(_player_state.speed_x) != signf(current_move_direction) and _braking_dust_cooldown <= 0.0:
		_spawn_dust_cloud(_player_state.world_x, _player_state.world_y)
		_braking_dust_cooldown = 0.10
	if frame_input & B_BUTTON:
		if _player_state.is_grounded and held_input & DPAD_DOWN:
			_spindash_charging = true
			_spindash_charge = maxf(_spindash_charge, 0.08)
			_spindash_direction_from_player()
		elif _player_state.variant == 3 and not _player_state.is_grounded:
			_glide_timer = 1.0
			_player_state.char_state = 7
		else:
			_attack_timer = 0.22
			_player_state.char_state = 8
			if _player_state.variant == 4:
				_spawn_amy_attack_hearts()
			elif _player_state.variant == 2:
				_spawn_character_attack_effect(ENTITY_TAIL_SWIPE)
			elif _player_state.variant == 3:
				_spawn_character_attack_effect(ENTITY_KNUCKLES_FIRE)
			elif _player_state.variant == 0:
				_spawn_character_attack_effect(ENTITY_SONIC_SKID)

	if _dash_timer > 0.0:
		_dash_timer = maxf(0.0, _dash_timer - delta)
		_player_state.is_grounded = false
		_player_state.world_x += _dash_velocity_x * delta
		_player_state.speed_x = _dash_velocity_x
		_velocity_y = _dash_velocity_y
	elif _spindash_charging:
		_player_state.is_grounded = true
		_player_state.speed_x = 0.0
		_player_state.ground_speed = 0.0
		_player_state.char_state = 8
		_player_state.anim_id = 2
		if held_input & DPAD_DOWN:
			_spindash_charge = minf(1.0, _spindash_charge + delta * 1.8)
		else:
			_spindash_charging = false
			_spindash_release_timer = 0.55
			_spindash_velocity_x = _facing_direction * (260.0 + _spindash_charge * 360.0)
			_spindash_charge = 0.0
			_spawn_dust_cloud(_player_state.world_x, _player_state.world_y)
	elif _spindash_release_timer > 0.0:
		_player_state.is_grounded = true
		_player_state.world_x += _spindash_velocity_x * delta
		_player_state.speed_x = _spindash_velocity_x
		_player_state.ground_speed = _spindash_velocity_x
		_player_state.char_state = 5
		_player_state.anim_id = 2
		if fmod(_spindash_release_timer, 0.12) < delta:
			_spawn_dust_cloud(_player_state.world_x, _player_state.world_y)
	elif _grind_timer > 0.0:
		_grind_timer = maxf(0.0, _grind_timer - delta)
		var reached_end := (_grind_velocity_x > 0.0 and _player_state.world_x >= _grind_end_x) or (_grind_velocity_x < 0.0 and _player_state.world_x <= _grind_end_x)
		var jump_off := frame_input & A_BUTTON and _grind_end_mode != 0
		if reached_end or jump_off or _grind_timer <= 0.0:
			_grind_timer = 0.0
			_player_state.world_x = _grind_end_x if reached_end else _player_state.world_x
			if _grind_end_mode != 0 or jump_off:
				_velocity_y = -_jump_speed
				_player_state.is_grounded = false
				_player_state.char_state = 1
			else:
				_velocity_y = 0.0
				_player_state.world_y = _grind_y
				_player_state.is_grounded = true
		else:
			_player_state.world_x += _grind_velocity_x * delta
			_player_state.world_y = _grind_y
			_player_state.speed_x = _grind_velocity_x
			_player_state.speed_y = 0.0
			_player_state.is_grounded = false
			_player_state.char_state = 6
	else:
		if _on_slidy_ice and _player_state.is_grounded:
			var ice_target_speed := current_move_direction * current_move_speed
			if current_move_direction != 0:
				_player_state.speed_x = move_toward(_player_state.speed_x, ice_target_speed, 420.0 * delta)
			else:
				_player_state.speed_x = move_toward(_player_state.speed_x, 0.0, 24.0 * delta)
			_player_state.ground_speed = _player_state.speed_x
		else:
			_player_state.ground_speed = current_move_direction * current_move_speed
			_player_state.speed_x = current_move_direction * current_move_speed
		if current_move_direction != 0:
			_facing_direction = signf(current_move_direction)

		if _player_state.is_grounded:
			_player_state.world_x += _player_state.speed_x * delta
			if frame_input & A_BUTTON or _jump_buffer_timer > 0.0:
				_velocity_y = -_jump_speed * gravity_direction
				_player_state.is_grounded = false
				_player_state.char_state = 1
				_jump_buffer_timer = 0.0
		else:
			_velocity_y += _gravity * gravity_direction * delta

	if not _player_state.is_grounded and (_player_state.variant == 1 or _player_state.variant == 2) and held_input & A_BUTTON:
		if frame_input & A_BUTTON:
			_flight_timer = CREAM_FLIGHT_DURATION if _player_state.variant == 1 else TAILS_FLIGHT_DURATION
		if _flight_timer > 0.0:
			_velocity_y = -120.0 * gravity_direction
			_player_state.world_x += current_move_direction * current_move_speed * 0.65 * delta
			_player_state.char_state = 9
		else:
			_player_state.char_state = 10
	elif not _player_state.is_grounded and _player_state.variant == 3 and _glide_timer > 0.0:
		_velocity_y = 80.0 * gravity_direction
		_player_state.world_x += current_move_direction * current_move_speed * 0.8 * delta
		_player_state.char_state = 7

	_player_state.world_y += _velocity_y * delta
	_player_state.speed_y = _velocity_y

	_player_state.world_x = clamp(_player_state.world_x, _level_state.min_x, _level_state.max_x)
	_resolve_platforms(previous_world_x, previous_world_y)
	_handle_fall_and_restart()

	_player_state.anim_id = 1 if _player_state.is_grounded and move_direction != 0 else 0
	_player_state.rotation = int(clamp(_velocity_y / 8.0, -16.0, 16.0))

	_handle_entity_interactions(held_input, frame_input, delta)
	_sync_grind_effect()
	_store_boost_effect_position()
	_update_camera()

func advance_ui_timers(delta: float, held_input: int = 0, frame_input: int = 0) -> void:
	_update_screen_fade(delta)
	_race_start_message_timer = maxf(0.0, _race_start_message_timer - delta)
	# Paused gameplay does not enter physics_tick in PlayerController; its
	# release-sensitive pause task must advance on this UI path instead.
	if _game_state == GAME_STATE_PAUSED:
		_update_pause_menu_input(held_input, frame_input)
		return
	if _game_state == GAME_STATE_FINAL_INTRO:
		_final_intro_timer = maxf(0.0, _final_intro_timer - delta)
		if _final_intro_timer <= 0.0:
			skip_final_intro()
		return
	if _title_phase == TITLE_PHASE_COURSE_SELECT and _course_select_intro_timer > 0.0:
		_course_select_intro_timer = maxf(0.0, _course_select_intro_timer - delta)
	# Course Select is a menu state, so its map and launch timers must advance
	# here rather than in the gameplay-only physics tick.
	if _course_select_travel_timer > 0.0:
		_course_select_travel_timer = maxf(0.0, _course_select_travel_timer - delta)
		if _course_select_travel_timer <= 0.0:
			_course_select_settle_timer = _course_select_settle_duration
	if _course_select_settle_timer > 0.0:
		_course_select_settle_timer = maxf(0.0, _course_select_settle_timer - delta)
		if _course_select_settle_timer <= 0.0 and _course_select_confirm_pending:
			_course_select_confirm_pending = false
			_course_select_start_timer = _course_select_start_duration
			_title_notice_text = "STARTING %s" % get_selected_level_text()
			_status_text = get_title_prompt_text()
	if _course_select_unlock_timer > 0.0:
		_advance_course_select_unlock_cutscene(delta)
	if _course_select_start_timer > 0.0:
		_course_select_start_timer = maxf(0.0, _course_select_start_timer - delta)
		if _course_select_start_timer <= 0.0 and _title_phase == TITLE_PHASE_COURSE_SELECT:
			if _is_multiplayer_course_select():
				_continue_multiplayer_after_course_select()
			else:
				var time_attack_course := _course_select_return_phase == TITLE_PHASE_TIME_ATTACK_LOBBY
				_begin_level_run(_selected_level_index, time_attack_course)
			return
	if _multiplayer_outcome_timer > 0.0:
		_multiplayer_outcome_timer = maxf(0.0, _multiplayer_outcome_timer - delta)
		if _multiplayer_outcome_timer <= 0.0 and _title_phase == TITLE_PHASE_MULTIPLAYER_OUTCOME:
			_resolve_multiplayer_outcome()
			return
	if _game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_MULTIPLAYER_LOBBY and _multiplayer_lobby_exit_timer > 0.0:
		_multiplayer_lobby_exit_timer = maxf(0.0, _multiplayer_lobby_exit_timer - delta)
		if _multiplayer_lobby_exit_timer <= 0.0:
			open_title_screen_and_skip_intro()
		return
	if _game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_MULTI_CONNECT and _multiplayer_pak_mode == 1 and is_singlepak_transfer_started() and not is_singlepak_transfer_complete():
		_singlepak_download_timer += delta
		if _singlepak_download_timer >= 0.25:
			_singlepak_download_timer = 0.0
			_advance_singlepak_transfer_step()
			return
	if _multiplayer_lobby_wait_timer > 0.0:
		_multiplayer_lobby_wait_timer = maxf(0.0, _multiplayer_lobby_wait_timer - delta)
		if _multiplayer_lobby_wait_timer <= 0.0 and _title_phase == TITLE_PHASE_MULTIPLAYER_LOBBY and _multiplayer_lobby_waiting:
			_resolve_multiplayer_lobby_choice()
			return
	if _game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_MULTI_CONNECT and _multiplayer_disconnect_timer > 0.0:
		_multiplayer_disconnect_timer = maxf(0.0, _multiplayer_disconnect_timer - delta)
		if _multiplayer_disconnect_timer <= 0.0:
			_multiplayer_link_ready = false
			open_title_screen_at_multiplayer_menu(_multiplayer_pak_mode)
		return
	if _singlepak_results_timer > 0.0:
		_singlepak_results_timer = maxf(0.0, _singlepak_results_timer - delta)
		if _singlepak_results_timer <= 0.0 and _title_phase == TITLE_PHASE_SINGLEPAK_RESULTS:
			_advance_singlepak_results_flow()
			return
	if _game_state == GAME_STATE_CHARACTER_SELECT and _character_select_intro_timer > 0.0:
		_character_select_intro_timer = maxf(0.0, _character_select_intro_timer - delta)
	if _game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_TIME_ATTACK and _time_attack_mode_intro_timer > 0.0:
		_time_attack_mode_intro_timer = maxf(0.0, _time_attack_mode_intro_timer - delta)
	if _game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_PLAY_MODE and _play_mode_intro_timer > 0.0:
		_play_mode_intro_timer = maxf(0.0, _play_mode_intro_timer - delta)
	if _game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_SINGLE_PLAYER and _single_player_intro_timer > 0.0:
		_single_player_intro_timer = maxf(0.0, _single_player_intro_timer - delta)
	if _game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_MULTI_PLAYER and _multiplayer_mode_intro_timer > 0.0:
		_multiplayer_mode_intro_timer = maxf(0.0, _multiplayer_mode_intro_timer - delta)
	if _game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_TINY_CHAO_GARDEN_PLAY:
		_update_tiny_chao_garden(held_input, frame_input, delta)
		_update_camera()
		return
	if _demo_mode and (_game_state == GAME_STATE_CLEAR or _game_state == GAME_STATE_GAME_OVER):
		open_press_start_screen()
		return
	if _game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_PRESS_START:
		if held_input != 0:
			_title_idle_timer = 0.0
		else:
			_title_idle_timer += delta
		if _title_idle_timer >= 15.0:
			_start_title_demo()
			return
	if _game_state == GAME_STATE_CLEAR:
		_clear_input_lock_timer = maxf(0.0, _clear_input_lock_timer - delta)
		_clear_count_delay_timer = maxf(0.0, _clear_count_delay_timer - delta)
		if _run_from_multiplayer:
			# mp_finish.c transitions multiplayer clears to its dedicated results task;
			# they do not use the single-player bonus counter or course chain.
			_prepare_multiplayer_results_snapshot(MULTIPLAYER_RESULTS_MODE_COURSE_COMPLETE)
			open_singlepak_results_screen(MULTIPLAYER_RESULTS_MODE_COURSE_COMPLETE, 0)
			return
		if _run_from_time_attack:
			if _time_attack_exit_timer > 0.0:
				_time_attack_exit_timer = maxf(0.0, _time_attack_exit_timer - delta)
				if _time_attack_exit_timer <= 0.0:
					open_time_attack_lobby(_time_attack_boss_mode)
				return
			_time_attack_result_timer += delta
			if _time_attack_result_timer >= 10.0:
				open_time_attack_lobby(_time_attack_boss_mode)
				return
		if not _run_from_time_attack and not _clear_counting_done and _clear_count_delay_timer <= 0.0:
			# stage_results.c drains each bonus by 100 points on every game
			# frame after its 150-frame opening delay. The source's 4-frame
			# cadence only controls the counter sound effect.
			_advance_clear_count_step()
		elif not _run_from_time_attack and not _run_from_multiplayer and _clear_counting_done and _clear_input_lock_timer <= 0.0:
			if _character_unlock_pending >= 0:
				_open_character_unlock()
			elif _special_stage_pending:
				_open_special_stage()
			elif _should_show_to_be_continued():
				_open_to_be_continued()
			elif _should_show_chaos_emeralds_message():
				if get_chaos_emerald_count() >= 7:
					_open_chaos_emeralds_message()
				else:
					_open_missing_emeralds_message()
			else:
				_open_next_single_player_course()
	if _game_state == GAME_STATE_TO_BE_CONTINUED:
		_to_be_continued_timer = maxf(0.0, _to_be_continued_timer - delta)
		if _to_be_continued_timer <= 0.0:
			_resolve_to_be_continued()
	if _game_state == GAME_STATE_SEGA_LOGO:
		_sega_logo_timer = maxf(0.0, _sega_logo_timer - delta)
		if _sega_logo_timer <= 0.0:
			_resolve_sega_logo()
	if _game_state == GAME_STATE_SONIC_TEAM:
		_sonic_team_timer = maxf(0.0, _sonic_team_timer - delta)
		if _sonic_team_timer <= 0.0:
			_resolve_sonic_team_logo()
	if _game_state == GAME_STATE_CREDITS:
		_credits_timer = maxf(0.0, _credits_timer - delta)
		if _credits_timer <= 0.0:
			_advance_credits_page()
	if _game_state == GAME_STATE_COPYRIGHT:
		_copyright_timer = maxf(0.0, _copyright_timer - delta)
		if _copyright_timer <= 0.0:
			_resolve_copyright()
	if _game_state == GAME_STATE_CREDITS_END:
		_advance_credits_end_story(delta)
		_credits_end_timer = maxf(0.0, _credits_end_timer - delta)
		if _credits_end_timer <= 0.0:
			_resolve_credits_end()
	if _game_state == GAME_STATE_CHARACTER_UNLOCK:
		_character_unlock_timer = maxf(0.0, _character_unlock_timer - delta)
		_character_unlock_scene_frame += delta * 60.0
		# level_endings.c holds four dialogue/slide segments at 341 frames
		# each, then a 301-frame final message before the fade out.
		if _character_unlock_segment < CHARACTER_UNLOCK_SEGMENT_COUNT:
			if _character_unlock_scene_frame > CHARACTER_UNLOCK_SEGMENT_FRAMES:
				_character_unlock_segment += 1
				_character_unlock_scene_frame = 0.0
		elif _character_unlock_scene_frame > CHARACTER_UNLOCK_FINAL_FRAMES:
			_resolve_character_unlock()
	if _game_state == GAME_STATE_SPECIAL_STAGE:
		if _special_stage_paused:
			return
		if _special_stage_phase == 1:
			_update_special_stage_guard_robo(delta)
			_update_special_stage_run(delta, held_input, frame_input)
		elif _special_stage_phase == 2:
			_update_special_stage_results(delta)
		_special_stage_timer = maxf(0.0, _special_stage_timer - delta)
		if _special_stage_timer <= 0.0:
			# The source result task owns its counter loop; do not interpret a
			# zero timer as A/fast-forward while points are still being counted.
			if _special_stage_phase != 2 or (_special_stage_points_remaining == 0 and _special_stage_bonus_remaining == 0):
				_advance_special_stage()
	if _game_state == GAME_STATE_CHAOS_EMERALDS:
		_chaos_emeralds_timer = maxf(0.0, _chaos_emeralds_timer - delta)
		if _chaos_emeralds_timer <= 0.0:
			_resolve_chaos_emeralds_message()
	if _game_state == GAME_STATE_MISSING_EMERALDS:
		_missing_emeralds_timer = maxf(0.0, _missing_emeralds_timer - delta)
		if _missing_emeralds_timer <= 0.0:
			_resolve_missing_emeralds_message()
	if _game_state == GAME_STATE_GAME_OVER:
		_game_over_input_lock_timer = maxf(0.0, _game_over_input_lock_timer - delta)
		_game_over_timer = maxf(0.0, _game_over_timer - delta)
		if _game_over_timer <= 0.0:
			_resolve_game_over_timeout()

func _update_pause_menu_input(held_input: int, frame_input: int) -> void:
	var a_held := bool(held_input & A_BUTTON)
	# pause_menu.c checks START first, then the non-single-player B escape,
	# before interpreting an A release. This prevents A-release+B/START from
	# opening the wrong lobby route.
	if frame_input & START_BUTTON:
		resume_game()
		_update_camera()
		return
	if (frame_input & B_BUTTON) and (_run_from_time_attack or _run_from_multiplayer):
		cancel_pause_selection()
		_update_camera()
		return
	if _pause_a_previous_held and not a_held:
		if _pause_a_hold_lock:
			# The A release that created the pause is consumed by the source.
			_pause_a_hold_lock = false
		else:
			_pause_a_previous_held = false
			confirm_pause_selection()
			_update_camera()
			return
	_pause_a_previous_held = a_held
	# pause_menu.c records whether A was already held when the menu was
	# created; that initial release must not confirm Continue.
	if _pause_a_hold_lock and not (held_input & A_BUTTON):
		_pause_a_hold_lock = false
	_update_camera()

func _update_screen_fade(delta: float) -> void:
	# The original fade updates blend brightness independently of the screen task.
	# Recreate that boundary here so converted menus do not pop between states.
	var state_changed := _screen_fade_last_state != _game_state
	var phase_changed := _game_state == GAME_STATE_TITLE and _screen_fade_last_phase != _title_phase
	if _screen_fade_last_state >= 0 and (state_changed or phase_changed) and _game_state != GAME_STATE_PAUSED:
		_screen_fade_alpha = 1.0
	_screen_fade_last_state = _game_state
	_screen_fade_last_phase = _title_phase
	_screen_fade_alpha = maxf(0.0, _screen_fade_alpha - delta * _screen_fade_speed)

func get_screen_fade_alpha() -> float:
	return clampf(_screen_fade_alpha, 0.0, 1.0)

func _start_title_demo() -> void:
	_title_idle_timer = 0.0
	_selected_character_index = 0
	init_level(0)
	# title_screen.c starts the recorded stage directly through GameStageStart;
	# it does not show the normal stage-intro countdown for a demo.
	_intro_timer = 0.0
	_game_state = GAME_STATE_PLAYING
	_demo_mode = true
	_demo_elapsed = 0.0
	_status_text = "DEMO PLAYBACK"

func is_demo_mode() -> bool:
	return _demo_mode

func get_demo_held_input() -> int:
	return DPAD_RIGHT

func get_demo_frame_input() -> int:
	return A_BUTTON if fmod(_demo_elapsed, 2.4) < 0.08 else 0

func _update_tiny_chao_garden(held_input: int, frame_input: int, delta: float) -> void:
	_tiny_chao_action_timer = maxf(0.0, _tiny_chao_action_timer - delta)
	if frame_input & DPAD_UP:
		_tiny_chao_selected_index = wrapi(_tiny_chao_selected_index - 1, 0, _tiny_chao_roster.size())
		_sync_tiny_chao_selection()
		_tiny_chao_action_text = "SELECTED %s" % _tiny_chao_roster[_tiny_chao_selected_index].get("name", "CHAO")
	if frame_input & DPAD_DOWN:
		_tiny_chao_selected_index = wrapi(_tiny_chao_selected_index + 1, 0, _tiny_chao_roster.size())
		_sync_tiny_chao_selection()
		_tiny_chao_action_text = "SELECTED %s" % _tiny_chao_roster[_tiny_chao_selected_index].get("name", "CHAO")
	if held_input & DPAD_LEFT:
		_tiny_chao_play_x = maxf(-1.0, _tiny_chao_play_x - delta * 1.7)
	if held_input & DPAD_RIGHT:
		_tiny_chao_play_x = minf(1.0, _tiny_chao_play_x + delta * 1.7)
	if held_input & DPAD_UP:
		_tiny_chao_play_y = maxf(-0.55, _tiny_chao_play_y - delta * 1.2)
	if held_input & DPAD_DOWN:
		_tiny_chao_play_y = minf(0.55, _tiny_chao_play_y + delta * 1.2)
	_tiny_chao_hunger = maxi(0, _tiny_chao_hunger - (1 if delta > 0.0 and fmod(Time.get_ticks_msec(), 3500.0) < delta * 1000.0 else 0))
	if frame_input & A_BUTTON and _tiny_chao_action_timer <= 0.0:
		var chao: Dictionary = _tiny_chao_roster[_tiny_chao_selected_index]
		if _tiny_chao_fruit > 0:
			_tiny_chao_fruit -= 1
			chao["hunger"] = mini(100, int(chao.get("hunger", 0)) + 18)
			chao["mood"] = mini(100, int(chao.get("mood", 0)) + 8)
			_tiny_chao_action_text = "%s ATE FRUIT" % chao.get("name", "CHAO")
		else:
			chao["mood"] = mini(100, int(chao.get("mood", 0)) + 4)
			_tiny_chao_action_text = "%s WANTS MORE FRUIT" % chao.get("name", "CHAO")
		chao["care"] = int(chao.get("care", 0)) + 1
		_tiny_chao_hunger = int(chao.get("hunger", _tiny_chao_hunger))
		_tiny_chao_mood = int(chao.get("mood", _tiny_chao_mood))
		_tiny_chao_care_count = int(chao.get("care", _tiny_chao_care_count))
		_tiny_chao_action_timer = 0.7
		_save_save_data()
	if frame_input & B_BUTTON or frame_input & SELECT_BUTTON or frame_input & START_BUTTON:
		open_tiny_chao_garden_menu(0, "RETURNED FROM GARDEN")

func _sync_tiny_chao_selection() -> void:
	if _tiny_chao_roster.is_empty():
		return
	var chao: Dictionary = _tiny_chao_roster[_tiny_chao_selected_index]
	_tiny_chao_hunger = int(chao.get("hunger", 50))
	_tiny_chao_mood = int(chao.get("mood", 50))
	_tiny_chao_care_count = int(chao.get("care", 0))

func _advance_clear_count_step() -> void:
	var counted_any := false
	# stage_results.c drains ring, special-ring, then time bonuses each tick.
	if _clear_ring_bonus_remaining > 0:
		_clear_ring_bonus_remaining = maxi(0, _clear_ring_bonus_remaining - 100)
		_clear_total_display_score += 100
		counted_any = true
	if _clear_special_ring_bonus_remaining > 0:
		_clear_special_ring_bonus_remaining = maxi(0, _clear_special_ring_bonus_remaining - 100)
		_clear_total_display_score += 100
		counted_any = true
	if _clear_time_bonus_remaining > 0:
		_clear_time_bonus_remaining = maxi(0, _clear_time_bonus_remaining - 100)
		_clear_total_display_score += 100
		counted_any = true
	if not counted_any:
		_finish_clear_counting()

func _finish_clear_counting(fast_forward: bool = false) -> void:
	_clear_total_display_score += _clear_time_bonus_remaining + _clear_ring_bonus_remaining + _clear_special_ring_bonus_remaining
	_clear_time_bonus_remaining = 0
	_clear_ring_bonus_remaining = 0
	_clear_special_ring_bonus_remaining = 0
	_clear_count_step_accumulator = 0.0
	_clear_counting_done = true
	_clear_input_lock_timer = CLEAR_RESULT_FAST_TAIL_SECONDS if fast_forward else CLEAR_RESULT_TAIL_SECONDS

func _should_show_chaos_emeralds_message() -> bool:
	if _chaos_emeralds_message_seen:
		return false
	if _run_from_time_attack or _run_from_multiplayer:
		return false
	if _level_names.is_empty():
		return false
	return _unlocked_level_index >= _level_names.size() - 1

func _should_show_to_be_continued() -> bool:
	if _level_names.is_empty():
		return false
	# The original results screen enters the ending after Final Zone and
	# after True Area 53; it does not chain either stage into another run.
	return _selected_level_index >= _level_names.size() - 2

func _open_next_single_player_course() -> void:
	if _game_state != GAME_STATE_CLEAR or _run_from_time_attack or _run_from_multiplayer:
		return
	var next_level := _selected_level_index + 1
	if next_level >= _level_names.size():
		_open_to_be_continued()
		return
	if next_level > _unlocked_level_index:
		# Final Zone can be complete while True Area 53 is still gated.
		# Do not clamp back into the same stage; follow the original ending path.
		_open_to_be_continued()
		return
	_selected_level_index = next_level
	_save_save_data()
	# Normal acts chain directly into the next stage in stage_results.c.
	# Boss results and special-stage branches are handled before this point.
	_begin_level_run(_selected_level_index, false)

func _open_chaos_emeralds_message() -> void:
	_game_state = GAME_STATE_CHAOS_EMERALDS
	_chaos_emeralds_timer = _chaos_emeralds_duration
	_chaos_emeralds_message_seen = true
	_status_text = "ALL CHAOS EMERALDS COLLECTED"
	_save_save_data()

func _open_missing_emeralds_message() -> void:
	_game_state = GAME_STATE_MISSING_EMERALDS
	_missing_emeralds_timer = _missing_emeralds_duration
	_status_text = "COLLECT ALL CHAOS EMERALDS"

func _resolve_missing_emeralds_message() -> void:
	if _game_state != GAME_STATE_MISSING_EMERALDS:
		return
	# The original task calls CreateTitleScreen() after the notification.
	open_title_screen_and_skip_intro()

func _resolve_chaos_emeralds_message() -> void:
	if _game_state != GAME_STATE_CHAOS_EMERALDS:
		return
	# The completion variant uses the same direct return to the title screen.
	open_title_screen_and_skip_intro()

func _open_to_be_continued() -> void:
	_update_ending_variant()
	_game_state = GAME_STATE_TO_BE_CONTINUED
	_to_be_continued_timer = _to_be_continued_duration
	_status_text = "TO BE CONTINUED"

func _resolve_to_be_continued() -> void:
	if _game_state != GAME_STATE_TO_BE_CONTINUED:
		return
	# The original final and extra ending tasks hand off directly to credits;
	# the Sega and Sonic Team logos are reserved for the boot/return path.
	_open_credits()

func _open_sega_logo() -> void:
	_update_ending_variant()
	_game_state = GAME_STATE_SEGA_LOGO
	_sega_logo_timer = _sega_logo_duration
	_status_text = "PRESENTED BY SEGA"

func _open_boot_intro() -> void:
	_boot_intro_pending = true
	_open_sega_logo()

func _resolve_sega_logo() -> void:
	if _game_state != GAME_STATE_SEGA_LOGO:
		return
	_open_sonic_team_logo()

func can_skip_sega_logo() -> bool:
	return _game_state == GAME_STATE_SEGA_LOGO and _boot_intro_pending

func skip_sega_logo() -> void:
	if not can_skip_sega_logo():
		return
	_boot_intro_pending = false
	open_press_start_screen()

func _open_sonic_team_logo() -> void:
	_game_state = GAME_STATE_SONIC_TEAM
	_sonic_team_timer = _sonic_team_duration
	_status_text = "CREATED BY SONIC TEAM"

func _resolve_sonic_team_logo() -> void:
	if _game_state != GAME_STATE_SONIC_TEAM:
		return
	if _boot_intro_pending:
		_boot_intro_pending = false
		open_press_start_screen()
		return
	_open_credits()

func _open_credits() -> void:
	_game_state = GAME_STATE_CREDITS
	_credits_page = 0
	_credits_timer = CREDITS_INTRO_DURATION
	_status_text = get_ending_variant_label()

func _advance_credits_page() -> void:
	if _game_state != GAME_STATE_CREDITS:
		return
	_credits_page += 1
	if _credits_page >= _credits_page_count:
		_open_credits_end()
		return
	_credits_timer = CREDITS_SLIDE_DURATION

func _open_credits_end() -> void:
	_game_state = GAME_STATE_CREDITS_END
	_credits_end_timer = _credits_end_duration
	_credits_end_story_frame = 0
	_credits_end_story_timer = 0.0
	_status_text = get_ending_variant_label()
	var selected_is_amy := _selected_character_index == CHARACTER_NAMES_AMY_INDEX()
	var selected_route_complete := bool(_completed_character_routes[clampi(_selected_character_index, 0, _completed_character_routes.size() - 1)])
	# credits_end.c routes Final Zone completion through missing_emeralds.c
	# unless Amy is selected or the current runner has a complete route.
	if _ending_variant == ENDING_VARIANT_FINAL and not selected_is_amy:
		_credits_end_show_missing_emeralds = _credits_end_show_missing_emeralds or get_chaos_emerald_count() < 7 or not selected_route_complete
	if _ending_variant == ENDING_VARIANT_EXTRA:
		_extra_ending_credits_played = true
		_extra_zone_status = 2
	elif _ending_variant == ENDING_VARIANT_FINAL and _extra_zone_status == 0:
		# credits_end.c marks normal completion before True Area is opened.
		_extra_zone_status = 1
	_save_save_data()

func _update_ending_variant() -> void:
	if _selected_level_index >= _level_names.size() - 1:
		_ending_variant = ENDING_VARIANT_EXTRA
	elif _selected_level_index >= _level_names.size() - 2:
		_ending_variant = ENDING_VARIANT_FINAL
	else:
		_ending_variant = ENDING_VARIANT_NORMAL

func get_ending_variant() -> int:
	return _ending_variant

func get_ending_variant_label() -> String:
	match _ending_variant:
		ENDING_VARIANT_EXTRA:
			return _language_text("EXTRA ENDING", "EXTRA-ENDE", "FIN EXTRA", "FINAL EXTRA", "FINALE EXTRA")
		ENDING_VARIANT_FINAL:
			return _language_text("FINAL ENDING", "FINALES ENDE", "FINALE", "FINAL", "FINALE")
	return _language_text("ADVENTURE ENDING", "ABENTEUER-ENDE", "FIN DE L'AVENTURE", "FINAL DE AVENTURA", "FINE AVVENTURA")

func _resolve_credits_end() -> void:
	if _game_state != GAME_STATE_CREDITS_END:
		return
	_open_copyright()

func _open_character_unlock() -> void:
	if _character_unlock_pending < 0 or _character_unlock_pending >= _character_names.size():
		return
	_game_state = GAME_STATE_CHARACTER_UNLOCK
	_character_unlock_timer = (CHARACTER_UNLOCK_SEGMENT_COUNT * (CHARACTER_UNLOCK_SEGMENT_FRAMES + 2) + CHARACTER_UNLOCK_FINAL_FRAMES + 2) / 60.0
	_character_unlock_segment = 0
	_character_unlock_scene_frame = 0.0
	_status_text = "%s UNLOCKED" % _character_names[_character_unlock_pending]

func _resolve_character_unlock() -> void:
	if _game_state != GAME_STATE_CHARACTER_UNLOCK:
		return
	_character_unlock_pending = -1
	_save_save_data()
	_game_state = GAME_STATE_CLEAR
	_open_course_select_after_unlock()

func _open_course_select_after_unlock() -> void:
	var next_level := _selected_level_index + 1
	if next_level >= _level_names.size():
		_open_to_be_continued()
		return
	_selected_level_index = clampi(next_level, 0, _unlocked_level_index)
	_save_save_data()
	open_course_select_screen(TITLE_PHASE_SINGLE_PLAYER, "NEW COURSE UNLOCKED: %s" % get_selected_level_text(), true)

func _open_copyright() -> void:
	_game_state = GAME_STATE_COPYRIGHT
	_copyright_timer = _copyright_duration
	_status_text = "COPYRIGHT"

func _resolve_copyright() -> void:
	if _game_state != GAME_STATE_COPYRIGHT:
		return
	if _credits_end_show_missing_emeralds:
		_credits_end_show_missing_emeralds = false
		_open_missing_emeralds_message()
	else:
		open_title_screen_and_skip_intro()

func skip_credits_end() -> void:
	# credits_end.c advances the sequence automatically; it has no input path.
	return

func skip_character_unlock() -> void:
	# level_endings.c only uses START to accelerate this cutscene.
	fast_forward_character_unlock()

func fast_forward_character_unlock() -> void:
	if _game_state != GAME_STATE_CHARACTER_UNLOCK:
		return
	# sub_808E4C8 only jumps the current segment to frame 340; it does not
	# skip the remaining unlock slides. START is ignored during its first 8.
	if _character_unlock_scene_frame <= 8.0:
		return
	if _character_unlock_segment < CHARACTER_UNLOCK_SEGMENT_COUNT:
		_character_unlock_scene_frame = CHARACTER_UNLOCK_SEGMENT_FRAMES
	else:
		_character_unlock_scene_frame = CHARACTER_UNLOCK_FINAL_FRAMES

func _open_special_stage() -> void:
	_game_state = GAME_STATE_SPECIAL_STAGE
	_special_stage_pending = false
	_special_stage_phase = 0
	_special_stage_timer = _special_stage_entry_duration
	_special_stage_ring_count = 0
	_special_stage_score = 0
	_special_stage_emerald_index = _get_selected_zone_index()
	_special_stage_lane = 1
	_special_stage_progress = 0.0
	_special_stage_last_segment = -1
	_special_stage_target_reached = false
	_special_stage_paused = false
	_special_stage_pause_cursor = 0
	_special_stage_multiplier = 1
	_special_stage_multiplier_streak = 0
	_special_stage_multiplier_timer = 0.0
	_special_stage_robo_progress = 0.15
	_special_stage_robo_lane = 1
	_special_stage_robo_speed = float(_special_stage_robo_zone_speeds[_special_stage_emerald_index])
	_special_stage_robo_lane_timer = 0.35
	_special_stage_robo_cooldown = 0.0
	_special_stage_points_remaining = 0
	_special_stage_bonus_remaining = 0
	_special_stage_result_hold_started = false
	_status_text = "SPECIAL STAGE READY"

func _advance_special_stage() -> void:
	if _game_state != GAME_STATE_SPECIAL_STAGE:
		return
	if _special_stage_phase == 0:
		_special_stage_phase = 1
		_special_stage_timer = _special_stage_run_duration
		_status_text = "SPECIAL STAGE RUN"
		return
	if _special_stage_phase == 1:
		_special_stage_phase = 2
		# special_stage/main.c caps the ring points at MAX_POINTS (99,900)
		# before the results task starts counting them.
		_special_stage_timer = 0.0
		_special_stage_points_remaining = mini(99900, _special_stage_ring_count * 100)
		_special_stage_bonus_remaining = 10000 if _special_stage_target_reached else 0
		_special_stage_result_hold_started = false
		_special_stage_score = 0
		_status_text = "SPECIAL STAGE RESULTS"
		return
	if _special_stage_points_remaining > 0 or _special_stage_bonus_remaining > 0:
		# A skips both result counters in sub_806C25C/sub_806C338 and
		# leaves only the 60-frame result hold before the fade.
		_special_stage_score += _special_stage_points_remaining + _special_stage_bonus_remaining
		_special_stage_points_remaining = 0
		_special_stage_bonus_remaining = 0
		_special_stage_result_hold_started = true
		_special_stage_timer = 1.0
		return
	_finish_special_stage()

func _update_special_stage_run(delta: float, held_input: int, frame_input: int = 0) -> void:
	if _special_stage_phase != 1:
		return
	_special_stage_jump_timer = maxf(0.0, _special_stage_jump_timer - delta)
	# physics.c accelerates on Up, brakes on Down, and coasts toward rest.
	if held_input & DPAD_UP:
		_special_stage_speed = minf(1.6, _special_stage_speed + delta * 1.8)
	elif held_input & DPAD_DOWN:
		_special_stage_speed = maxf(0.35, _special_stage_speed - delta * 2.4)
	else:
		_special_stage_speed = move_toward(_special_stage_speed, 1.0, delta * 0.8)
	# HandleJumpControls uses the newly pressed jump button, not a held A.
	if frame_input & A_BUTTON:
		_special_stage_jump_timer = 0.72
		_status_text = "SPECIAL STAGE JUMP"
	_special_stage_multiplier_timer = maxf(0.0, _special_stage_multiplier_timer - delta)
	if _special_stage_multiplier_timer <= 0.0:
		_special_stage_multiplier = 1
		_special_stage_multiplier_streak = 0
	if held_input & DPAD_LEFT:
		_special_stage_lane = maxi(0, _special_stage_lane - 1)
	if held_input & DPAD_RIGHT:
		_special_stage_lane = mini(2, _special_stage_lane + 1)
	# The original Special Stage keeps its collectible field active for the
	# complete 120-second countdown. The lane checkpoints are a compact bridge
	# for the source object field, so advance them over that same duration.
	var jump_speed := 1.25 if _special_stage_jump_timer > 0.0 else 1.0
	_special_stage_progress = minf(1.0, _special_stage_progress + delta * _special_stage_speed * jump_speed / _special_stage_run_duration)
	var segment := mini(_special_stage_ring_targets.size() - 1, int(_special_stage_progress * float(_special_stage_ring_targets.size())))
	if segment <= _special_stage_last_segment:
		return
	for i in range(_special_stage_last_segment + 1, segment + 1):
		if int(_special_stage_ring_targets[i]) == _special_stage_lane:
			var pickup_kind := int(_special_stage_ring_kinds[i]) if i < _special_stage_ring_kinds.size() else 0
			var pickup_value := _special_stage_multiplier * (5 if pickup_kind != 0 else 1)
			_special_stage_ring_count = mini(999, _special_stage_ring_count + pickup_value)
			_special_stage_multiplier_streak += 1
			_special_stage_multiplier_timer = 1.0
			_special_stage_multiplier = mini(9, int(_special_stage_multiplier_streak / 6.0) + 1)
	_special_stage_last_segment = segment
	_special_stage_target_reached = _special_stage_ring_count >= _special_stage_run_target

func _update_special_stage_guard_robo(delta: float) -> void:
	_special_stage_robo_cooldown = maxf(0.0, _special_stage_robo_cooldown - delta)
	_special_stage_robo_lane_timer = maxf(0.0, _special_stage_robo_lane_timer - delta)
	_special_stage_robo_progress = minf(1.0, _special_stage_robo_progress + _special_stage_robo_speed * delta)
	# The original guard moves independently and turns toward the player; do
	# not mirror the player's lane every frame or avoidance becomes impossible.
	if _special_stage_robo_lane_timer <= 0.0:
		if _special_stage_robo_lane < _special_stage_lane:
			_special_stage_robo_lane += 1
		elif _special_stage_robo_lane > _special_stage_lane:
			_special_stage_robo_lane -= 1
		_special_stage_robo_lane_timer = 0.35
	var progress_gap := absf(_special_stage_robo_progress - _special_stage_progress)
	if _special_stage_jump_timer > 0.0 or progress_gap > 0.045 or _special_stage_robo_lane != _special_stage_lane or _special_stage_robo_cooldown > 0.0:
		return
	_special_stage_robo_cooldown = 1.5
	_special_stage_multiplier = 1
	_special_stage_multiplier_streak = 0
	_special_stage_multiplier_timer = 0.0
	if _special_stage_ring_count > 0:
		_special_stage_ring_count = maxi(0, _special_stage_ring_count - 10)
		_status_text = "GUARD ROBO HIT - 10 RINGS LOST"
	else:
		_status_text = "GUARD ROBO HIT - NO RINGS"

func _update_special_stage_results(_delta: float) -> void:
	# The original result tasks remove exactly 100 points per GBA frame;
	# the four-frame cadence is only used for the counter sound effect.
	var step := 100
	if _special_stage_points_remaining > 0:
		var points_step := mini(step, _special_stage_points_remaining)
		_special_stage_points_remaining -= points_step
		_special_stage_score += points_step
	elif _special_stage_bonus_remaining > 0:
		var bonus_step := mini(step, _special_stage_bonus_remaining)
		_special_stage_bonus_remaining -= bonus_step
		_special_stage_score += bonus_step
	else:
		# sub_806C49C waits 60 frames before beginning the result fade.
		if not _special_stage_result_hold_started:
			_special_stage_result_hold_started = true
			_special_stage_timer = 1.0

func _finish_special_stage() -> void:
	if _game_state != GAME_STATE_SPECIAL_STAGE:
		return
	# save.c adds Special Stage rings to the persistent profile score after
	# the result hold, regardless of whether the emerald target was reached.
	_profile_score = maxi(0, _profile_score + _special_stage_ring_count)
	_save_save_data()
	if _special_stage_target_reached:
		_collect_chaos_emerald_for_clear()
	if _should_show_to_be_continued():
		_open_to_be_continued()
	elif _should_show_chaos_emeralds_message():
		if get_chaos_emerald_count() >= 7:
			_open_chaos_emeralds_message()
		else:
			_open_missing_emeralds_message()
	else:
		_game_state = GAME_STATE_CLEAR
		_open_next_single_player_course()

func _resolve_game_over_timeout() -> void:
	if _game_state != GAME_STATE_GAME_OVER:
		return
	if _run_from_time_attack and _game_over_time_over:
		open_time_attack_lobby(_time_attack_boss_mode)
		return
	if _game_over_time_over:
		_init_restart()
		return
	reset_to_title()

func get_player_state() -> PlayerState:
	return _player_state

func _store_boost_effect_position() -> void:
	_boost_position_history.push_front(Vector2(_player_state.world_x, _player_state.world_y))
	while _boost_position_history.size() > 16:
		_boost_position_history.pop_back()

func get_boost_trail_positions() -> Array:
	var positions: Array = []
	for frame_offset in [2, 4, 6]:
		if frame_offset < _boost_position_history.size():
			positions.append(_boost_position_history[frame_offset])
		else:
			positions.append(Vector2(_player_state.world_x, _player_state.world_y))
	return positions

func is_player_boosting() -> bool:
	return not _run_from_multiplayer and (_player_state.super_sonic or _start_boost_timer > 0.0 or _dash_timer > 0.0 or _boost_effect_timer > 0.0)

func get_camera_state() -> CameraState:
	return _camera_state

func get_entities() -> Array:
	return _level_state.entities

func get_source_map_manifest() -> Dictionary:
	return _source_map_manifest

func get_source_map_summary() -> String:
	if _source_map_manifest.is_empty():
		return "SOURCE MAP DATA UNLOADED"
	var status := "SOURCE MAP" if _source_map_manifest.valid else "SOURCE MAP FALLBACK"
	return "%s %dx%d / %d OBJECTS" % [status, _source_map_manifest.region_width, _source_map_manifest.region_height, _source_map_manifest.entity_count]

func get_elapsed_time() -> float:
	return _elapsed_time

func get_hud_time_text() -> String:
	# stage_ui.c clamps the rendered digits even when the gameplay time limit
	# has been disabled; disabling the limit affects death handling, not HUD width.
	var display_time := minf(_elapsed_time, MAX_COURSE_TIME_SECONDS - 0.01)
	return get_formatted_time(display_time)

func is_hud_timer_warning() -> bool:
	return (_run_from_time_attack or _time_limit_enabled) and _elapsed_time >= 580.0

func get_hud_special_ring_count() -> int:
	return _player_state.special_rings

func get_hud_special_ring_text() -> String:
	return "%s  %d/7" % [_language_text("SP RINGS", "SPEZIALRINGE", "ANNEAUX SP", "ANILLOS SP", "ANELLI SP"), get_hud_special_ring_count()]

func get_hud_race_start_text() -> String:
	return _language_text("GO!", "LOS!", "GO!", "YA!", "VIA!")

func get_hud_boss_title_text(health: int, max_health: int) -> String:
	return "%s  %02d/%02d" % [_language_text("BOSS", "BOSS", "BOSS", "JEFE", "BOSS"), health, max_health]

func get_hud_boss_phase_text(phase: String) -> String:
	return "%s  %s" % [_language_text("PHASE", "PHASE", "PHASE", "FASE", "FASE"), phase]

func get_hud_multiplayer_start_flag_text() -> String:
	return _language_text("ST", "ST", "DEB", "INI", "AVV")

func get_hud_multiplayer_finish_flag_text() -> String:
	return _language_text("GOAL", "ZIEL", "BUT", "META", "TRAGUARDO")

func get_hud_powerup_text() -> String:
	if _invincibility_timer > 0.0:
		return "%s %02d" % [_language_text("INV", "UNV", "INV", "INV", "INV"), ceili(_invincibility_timer)]
	if _speed_up_timer > 0.0:
		return "%s %02d" % [_language_text("SPEED", "TEMPO", "VITESSE", "VELOCIDAD", "VELOCITA"), ceili(_speed_up_timer)]
	if _magnetic_shielded:
		return _language_text("MAGNETIC", "MAGNETISCH", "MAGNETIQUE", "MAGNETICO", "MAGNETICO")
	if _player_state.shielded:
		return _language_text("SHIELD", "SCHILD", "BOUCLIER", "ESCUDO", "SCUDO")
	return ""

func is_hud_shield_active() -> bool:
	return _player_state.shielded and not _magnetic_shielded and _invincibility_timer <= 0.0 and _speed_up_timer <= 0.0

func is_player_magnetic_shielded() -> bool:
	return _magnetic_shielded and _player_state.shielded

func is_player_invincible() -> bool:
	return _invincibility_timer > 0.0

func is_player_speed_up_active() -> bool:
	return _speed_up_timer > 0.0

func is_special_ring_hud_visible() -> bool:
	return not _run_from_multiplayer and not (_run_from_time_attack and _time_attack_boss_mode)

func get_level_name() -> String:
	return _level_state.name

func get_level_id() -> int:
	return _level_state.level_id

func get_stage_backdrop_profile() -> Dictionary:
	if _level_state.level_id == 1:
		return {
			"sky": Color(0.08, 0.10, 0.16),
			"sky_mid": Color(0.14, 0.18, 0.28),
			"sky_high": Color(0.22, 0.30, 0.44),
			"sun": Color(0.88, 0.94, 1.0, 0.18),
			"ground": Color(0.12, 0.10, 0.12),
			"grass": Color(0.24, 0.52, 0.22),
			"hills": [
				{"origin": Vector2(340.0, 460.0), "size": Vector2(220.0, 104.0), "color": Color(0.14, 0.20, 0.14)},
				{"origin": Vector2(920.0, 460.0), "size": Vector2(300.0, 142.0), "color": Color(0.16, 0.24, 0.16)},
				{"origin": Vector2(1560.0, 460.0), "size": Vector2(260.0, 118.0), "color": Color(0.12, 0.18, 0.12)},
				{"origin": Vector2(2140.0, 460.0), "size": Vector2(240.0, 108.0), "color": Color(0.10, 0.16, 0.10)},
			],
		}
	return {
		"sky": Color(0.06, 0.11, 0.22),
		"sky_mid": Color(0.10, 0.21, 0.39),
		"sky_high": Color(0.16, 0.36, 0.62),
		"sun": Color(0.98, 0.86, 0.45, 0.35),
		"ground": Color(0.16, 0.12, 0.08),
		"grass": Color(0.18, 0.48, 0.18),
		"hills": [
			{"origin": Vector2(360.0, 460.0), "size": Vector2(260.0, 120.0), "color": Color(0.12, 0.22, 0.12)},
			{"origin": Vector2(980.0, 460.0), "size": Vector2(380.0, 160.0), "color": Color(0.14, 0.28, 0.14)},
			{"origin": Vector2(1720.0, 460.0), "size": Vector2(320.0, 130.0), "color": Color(0.11, 0.20, 0.11)},
			{"origin": Vector2(2320.0, 460.0), "size": Vector2(280.0, 115.0), "color": Color(0.10, 0.18, 0.10)},
			{"origin": Vector2(520.0, 460.0), "size": Vector2(180.0, 92.0), "color": Color(0.18, 0.34, 0.18)},
		],
	}

func get_entity_visual_profile(entity_type: int, activated: bool = false) -> Dictionary:
	match entity_type:
		ENTITY_RING:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2(0.55, 0.55),
				"body_offset": Vector2.ZERO,
				"overlay_offset": Vector2.ZERO,
				"overlay_color": Color(1.0, 1.0, 1.0, 0.75),
			}
		ENTITY_SPRING:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2.ONE,
				"body_offset": Vector2(0.0, 4.0),
				"overlay_offset": Vector2(0.0, -6.0),
				"overlay_color": Color.WHITE,
			}
		ENTITY_ENEMY:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2.ONE,
				"body_offset": Vector2(0.0, 2.0),
				"overlay_offset": Vector2.ZERO,
				"overlay_color": Color.WHITE,
			}
		ENTITY_CHECKPOINT:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2.ONE,
				"body_offset": Vector2.ZERO,
				"overlay_offset": Vector2(16.0, -20.0),
				"overlay_color": Color(0.95, 0.38, 0.16, 1.0) if activated else Color(0.16, 0.76, 0.34, 1.0),
			}
		ENTITY_GOAL:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2.ONE,
				"body_offset": Vector2.ZERO,
				"overlay_offset": Vector2(18.0, -28.0),
				"overlay_color": Color.WHITE,
			}
		ENTITY_GOAL_LEVER:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2.ONE,
				"body_offset": Vector2.ZERO,
				"overlay_offset": Vector2(18.0, -28.0),
				"overlay_color": Color(1.0, 0.82, 0.28, 1.0) if activated else Color.WHITE,
			}
		ENTITY_SPECIAL_RING:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2.ONE,
				"body_offset": Vector2.ZERO,
				"overlay_offset": Vector2.ZERO,
				"overlay_color": Color(0.48, 0.92, 1.0, 1.0),
			}
		ENTITY_PROPELLER:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2(1.0, 1.0),
				"body_offset": Vector2.ZERO,
				"overlay_offset": Vector2.ZERO,
				"overlay_color": Color(1.0, 0.88, 0.38, 0.92) if activated else Color(0.54, 0.86, 1.0, 0.78),
			}
		ENTITY_BOOSTER:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2.ONE,
				"body_offset": Vector2.ZERO,
				"overlay_offset": Vector2.ZERO,
				"overlay_color": Color(1.0, 0.84, 0.26, 0.92),
			}
		ENTITY_DASH_RING:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2.ONE,
				"body_offset": Vector2.ZERO,
				"overlay_offset": Vector2.ZERO,
				"overlay_color": Color(0.42, 0.92, 1.0, 0.92),
			}
		ENTITY_GRIND_RAIL:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2.ONE,
				"body_offset": Vector2.ZERO,
				"overlay_offset": Vector2.ZERO,
				"overlay_color": Color(0.62, 0.72, 0.84, 0.92),
			}
		ENTITY_GRAVITY_TOGGLE:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2.ONE,
				"body_offset": Vector2.ZERO,
				"overlay_offset": Vector2.ZERO,
				"overlay_color": Color(0.78, 0.42, 1.0, 0.88),
			}
		ENTITY_BOUNCY_SPRING:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2.ONE,
				"body_offset": Vector2.ZERO,
				"overlay_offset": Vector2.ZERO,
				"overlay_color": Color(0.92, 0.42, 0.68, 0.92),
			}
		ENTITY_CONVEYOR:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2.ONE,
				"body_offset": Vector2.ZERO,
				"overlay_offset": Vector2.ZERO,
				"overlay_color": Color(0.28, 0.84, 0.72, 0.92),
			}
	return {
		"body_scale": Vector2.ONE,
		"overlay_scale": Vector2.ONE,
		"body_offset": Vector2.ZERO,
		"overlay_offset": Vector2.ZERO,
		"overlay_color": Color.WHITE,
	}

func _build_level(level_id: int) -> LevelState:
	var level := LevelState.new()
	level.level_id = level_id
	level.name = _level_names[clampi(level_id, 0, _level_names.size() - 1)]
	level.spawn_x = 180.0
	level.spawn_y = 460.0
	level.ground_y = 460.0
	level.min_x = 0.0
	level.max_x = 2400.0
	level.min_y = 0.0
	level.max_y = 720.0
	_add_platform(level, 200.0, 460.0, 380.0, 32.0)
	_add_platform(level, 620.0, 420.0, 220.0, 24.0)
	_add_platform(level, 930.0, 360.0, 220.0, 24.0)
	_add_platform(level, 1250.0, 320.0, 180.0, 24.0)
	_add_platform(level, 1490.0, 390.0, 260.0, 24.0)
	_add_platform(level, 1830.0, 340.0, 220.0, 24.0)

	if level_id == 0:
		_add_ring_line(level, 280.0, 384.0, 5, 54.0)
		_add_spring(level, 560.0, 448.0)
		_add_ring_line(level, 720.0, 350.0, 4, 52.0)
		_add_enemy(level, 980.0, 444.0, 900.0, 1040.0)
		_add_ring_line(level, 980.0, 306.0, 5, 42.0)
		_add_spring(level, 1300.0, 448.0)
		_add_item_box(level, 1450.0, 270.0, 10)
		_add_item_box(level, 1180.0, 300.0, 0, ITEM_BOX_KIND_SPEED_UP)
		_add_item_box(level, 1740.0, 280.0, 0, ITEM_BOX_KIND_ONE_UP)
		_add_item_box(level, 2050.0, 270.0, 0, ITEM_BOX_KIND_INVINCIBILITY)
		_add_ring_line(level, 1340.0, 286.0, 4, 40.0)
		_add_checkpoint(level, 1610.0, 448.0)
		_add_whirlwind(level, 1660.0, 250.0, 150.0, 260.0)
		_add_fan(level, 1100.0, 310.0, 220.0, 180.0, 1.0)
		_add_moving_platform(level, 1080.0, 280.0, 140.0, 18.0, 1, 44.0, 1.8)
		_add_propeller(level, 1910.0, 300.0)
		_add_enemy(level, 1760.0, 334.0, 1700.0, 1850.0)
		_add_buzzer(level, 1120.0, 260.0, 1060.0, 1190.0)
		_add_balloon(level, 1880.0, 230.0, 1800.0, 1960.0)
		_add_bullet_buzzer(level, 2100.0, 210.0)
		_add_star(level, 2180.0, 350.0)
		_add_kiki(level, 1520.0, 250.0)
		_add_ring_line(level, 1910.0, 300.0, 4, 42.0)
		_add_special_ring(level, 330.0, 340.0)
		_add_special_ring(level, 760.0, 300.0)
		_add_special_ring(level, 1010.0, 260.0)
		_add_special_ring(level, 1370.0, 240.0)
		_add_special_ring(level, 1570.0, 340.0)
		_add_special_ring(level, 1810.0, 280.0)
		_add_special_ring(level, 2010.0, 260.0)
		if _time_attack_boss_mode:
			_add_boss(level, 2180.0, 320.0)
		else:
			_add_goal(level, 2280.0, 360.0)
		_add_trapped_animal(level, 2210.0, 360.0, _selected_level_index % 3)
	else:
		_add_ring_line(level, 250.0, 402.0, 4, 52.0)
		_add_ring_line(level, 500.0, 370.0, 5, 38.0)
		_add_enemy(level, 640.0, 414.0, 580.0, 760.0)
		_add_spring(level, 680.0, 448.0)
		_add_platform(level, 820.0, 300.0, 160.0, 20.0)
		_add_moving_platform(level, 980.0, 300.0, 150.0, 18.0, 0, 72.0, 1.4, 0.8)
		_add_ring_line(level, 860.0, 252.0, 4, 36.0)
		_add_checkpoint(level, 880.0, 448.0)
		_add_spikes(level, 1020.0, 448.0, 48.0, 20.0)
		_add_spring(level, 1120.0, 448.0)
		_add_item_box(level, 1450.0, 250.0, 0, ITEM_BOX_KIND_SHIELD)
		_add_item_box(level, 1600.0, 250.0, 0, ITEM_BOX_KIND_MAGNETIC_SHIELD)
		_add_item_box(level, 1080.0, 270.0, 0, ITEM_BOX_KIND_RINGS_5)
		_add_enemy(level, 1260.0, 334.0, 1200.0, 1380.0)
		_add_koura(level, 1480.0, 320.0, 1400.0, 1570.0)
		_add_ring_line(level, 1340.0, 282.0, 6, 36.0)
		_add_special_ring(level, 300.0, 350.0)
		_add_special_ring(level, 540.0, 320.0)
		_add_special_ring(level, 880.0, 210.0)
		_add_special_ring(level, 1060.0, 340.0)
		_add_special_ring(level, 1280.0, 280.0)
		_add_special_ring(level, 1430.0, 240.0)
		_add_special_ring(level, 1510.0, 280.0)
		if _time_attack_boss_mode:
			_add_boss(level, 1520.0, 300.0)
		else:
			_add_goal(level, 1600.0, 340.0)
		_add_trapped_animal(level, 1540.0, 340.0, _selected_level_index % 3)

	_apply_source_entities(level)

	return level

func _apply_source_entities(level: LevelState) -> void:
	if _source_map_manifest.is_empty() or not bool(_source_map_manifest.get("valid", false)):
		return
	var source_width := maxf(1.0, float(_source_map_manifest.get("region_width", 1)) * 256.0)
	var source_height := maxf(1.0, float(_source_map_manifest.get("region_height", 1)) * 256.0)
	var source_entities: Dictionary = _source_map_manifest.get("entities", {})
	for row in source_entities.get("rings", []):
		_add_source_entity(level, ENTITY_RING, row, source_width, source_height)
	for row in source_entities.get("itemboxes", []):
		var item := _add_source_entity(level, ENTITY_ITEM_BOX, row, source_width, source_height)
		item.item_kind = _source_item_kind(str(row.get("kind", "")))
	for row in source_entities.get("enemies", []):
		var enemy_kind := str(row.get("kind", ""))
		var enemy_type := _source_enemy_type(enemy_kind)
		if enemy_type >= 0:
			var source_enemy := _add_source_entity(level, enemy_type, row, source_width, source_height)
			_configure_source_enemy(source_enemy, enemy_kind, row)
	var goal_added := false
	for row in source_entities.get("interactables", []):
		var kind := str(row.get("kind", ""))
		if kind == "PLATFORM_CRUMBLING":
			_add_source_crumbling_platform(level, row, source_width, source_height)
			continue
		if kind == "PLATFORM_SQUARE":
			_add_source_square_platform(level, row, source_width, source_height)
			continue
		if kind == "COMMON_THIN_PLATFORM":
			_add_source_thin_platform(level, row, source_width, source_height)
			continue
		if kind == "PLATFORM_A":
			_add_source_platform_a(level, row, source_width, source_height)
			continue
		if kind == "PLATFORM_B":
			_add_source_platform_b(level, row, source_width, source_height)
			continue
		if kind.begins_with("ARROW_PLATFORM"):
			_add_source_arrow_platform(level, row, kind, source_width, source_height)
			continue
		if kind == "SPEEDING_PLATFORM":
			_add_source_speeding_platform(level, row, source_width, source_height)
			continue
		var entity_type := _source_interactable_type(kind)
		if entity_type < 0:
			continue
		if entity_type == ENTITY_GOAL:
			if goal_added:
				continue
			goal_added = true
		var source_entity := _add_source_entity(level, entity_type, row, source_width, source_height)
		if entity_type == ENTITY_LAP_TRIGGER:
			_configure_source_lap_trigger(source_entity, row, source_width, source_height, level)
			continue
		if entity_type == ENTITY_LAUNCHER:
			_add_source_launcher(source_entity, row, kind, source_width, source_height, level)
		elif entity_type == ENTITY_CANNON:
			var cannon_fields: Array = row.get("fields", [])
			source_entity.cannon_facing_right = cannon_fields.size() > 5 and _to_int_field(cannon_fields[5]) != 0
			source_entity.cannon_angle = 0.0 if source_entity.cannon_facing_right else PI
		elif entity_type == ENTITY_HOOK_RAIL:
			var hook_fields: Array = row.get("fields", [])
			source_entity.variant = 1 if kind.ends_with("END") else 0
			if hook_fields.size() > 8:
				var hook_scale := _source_runtime_scale(source_width, source_height, level)
				var hook_base_x := float(row.get("world_x", 0))
				var hook_base_y := float(row.get("world_y", 0))
				var hook_left := float(_to_int_field(hook_fields[5])) * 8.0
				var hook_top := float(_to_int_field(hook_fields[6])) * 8.0
				var hook_right := hook_left + float(_to_int_field(hook_fields[7])) * 8.0
				var hook_start := _source_runtime_position(level, hook_base_x + hook_left, hook_base_y + hook_top + 20.0, source_width, source_height)
				var hook_end := _source_runtime_position(level, hook_base_x + hook_right, hook_base_y + hook_top + 20.0, source_width, source_height)
				source_entity.world_x = hook_start.x
				source_entity.world_y = hook_start.y
				source_entity.target_x = hook_end.x
				source_entity.target_y = hook_end.y
				source_entity.width = maxf(24.0, absf(hook_right - hook_left) * hook_scale)
		elif entity_type == ENTITY_SLIDY_ICE:
			var ice_fields: Array = row.get("fields", [])
			if ice_fields.size() > 8:
				var ice_scale := _source_runtime_scale(source_width, source_height, level)
				var ice_base_x := float(row.get("world_x", 0))
				var ice_base_y := float(row.get("world_y", 0))
				var ice_top_left := _source_runtime_position(level, ice_base_x + float(_to_int_field(ice_fields[5])) * 8.0, ice_base_y + float(_to_int_field(ice_fields[6])) * 8.0, source_width, source_height)
				source_entity.world_x = ice_top_left.x
				source_entity.world_y = ice_top_left.y
				source_entity.width = maxf(16.0, float(_to_int_field(ice_fields[7])) * 8.0 * ice_scale)
				source_entity.height = maxf(16.0, float(_to_int_field(ice_fields[8])) * 8.0 * ice_scale)
		elif entity_type == ENTITY_LIGHT_BRIDGE:
			var bridge_fields: Array = row.get("fields", [])
			source_entity.light_bridge = true
			if bridge_fields.size() > 6:
				source_entity.light_bridge_type = clampi(_to_int_field(bridge_fields[5]), 0, 1)
				source_entity.light_bridge_phase = float(_to_int_field(bridge_fields[6])) * TAU / 240.0
				source_entity.width = 240.0 if source_entity.light_bridge_type == 0 else 96.0
				source_entity.height = 32.0 if source_entity.light_bridge_type == 0 else 96.0
		elif entity_type == ENTITY_SLOWING_SNOW:
			var snow_fields: Array = row.get("fields", [])
			if snow_fields.size() > 8:
				var snow_scale := _source_runtime_scale(source_width, source_height, level)
				var snow_base_x := float(row.get("world_x", 0))
				var snow_base_y := float(row.get("world_y", 0))
				var snow_top_left := _source_runtime_position(level, snow_base_x + float(_to_int_field(snow_fields[5])) * 8.0, snow_base_y + float(_to_int_field(snow_fields[6])) * 8.0, source_width, source_height)
				source_entity.world_x = snow_top_left.x
				source_entity.world_y = snow_top_left.y
				source_entity.width = maxf(16.0, float(_to_int_field(snow_fields[7])) * 8.0 * snow_scale)
				source_entity.height = maxf(16.0, float(_to_int_field(snow_fields[8])) * 8.0 * snow_scale)
		elif entity_type == ENTITY_SPIKE_PLATFORM:
			var spike_position := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
			source_entity.world_x = spike_position.x
			source_entity.world_y = spike_position.y
			source_entity.spike_platform = true
			_add_platform(level, spike_position.x - 24.0, spike_position.y + 12.0, 48.0, 12.0)
		elif entity_type == ENTITY_TURNAROUND_BAR:
			var turnaround_position := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
			source_entity.world_x = turnaround_position.x
			source_entity.world_y = turnaround_position.y
			source_entity.turnaround_bar = true
		elif entity_type == ENTITY_KEYBOARD:
			var keyboard_fields: Array = row.get("fields", [])
			var keyboard_scale := _source_runtime_scale(source_width, source_height, level)
			var keyboard_base_x := float(row.get("world_x", 0))
			var keyboard_base_y := float(row.get("world_y", 0))
			var keyboard_left := float(_to_int_field(keyboard_fields[5])) * 8.0 if keyboard_fields.size() > 5 else -16.0
			var keyboard_top := float(_to_int_field(keyboard_fields[6])) * 8.0 if keyboard_fields.size() > 6 else -16.0
			var keyboard_width := float(_to_int_field(keyboard_fields[7])) * 8.0 if keyboard_fields.size() > 7 else 32.0
			var keyboard_height := float(_to_int_field(keyboard_fields[8])) * 8.0 if keyboard_fields.size() > 8 else 32.0
			var keyboard_position := _source_runtime_position(level, keyboard_base_x + keyboard_left + keyboard_width * 0.5, keyboard_base_y + keyboard_top + keyboard_height * 0.5, source_width, source_height)
			source_entity.world_x = keyboard_position.x
			source_entity.world_y = keyboard_position.y
			source_entity.width = maxf(16.0, keyboard_width * keyboard_scale)
			source_entity.height = maxf(16.0, keyboard_height * keyboard_scale)
			source_entity.keyboard = true
			source_entity.keyboard_type = 0 if kind == "KEYBOARD_VERTICAL" else (1 if kind == "KEYBOARD_HORIZONTAL_LEFT" else 2)
			source_entity.velocity_x = signf(keyboard_left) if source_entity.keyboard_type == 0 else float(source_entity.keyboard_type * 2 - 3)
			source_entity.velocity_y = signf(keyboard_top)
		elif entity_type == ENTITY_POLE:
			var pole_fields: Array = row.get("fields", [])
			var pole_scale := _source_runtime_scale(source_width, source_height, level)
			var pole_base_x := float(row.get("world_x", 0))
			var pole_base_y := float(row.get("world_y", 0))
			var pole_left := float(_to_int_field(pole_fields[5])) * 8.0 if pole_fields.size() > 5 else -8.0
			var pole_top := float(_to_int_field(pole_fields[6])) * 8.0 if pole_fields.size() > 6 else -32.0
			var pole_width := float(_to_int_field(pole_fields[7])) * 8.0 if pole_fields.size() > 7 else 16.0
			var pole_height := float(_to_int_field(pole_fields[8])) * 8.0 if pole_fields.size() > 8 else 64.0
			var pole_position := _source_runtime_position(level, pole_base_x + pole_left + pole_width * 0.5, pole_base_y + pole_top + pole_height * 0.5, source_width, source_height)
			source_entity.world_x = pole_position.x
			source_entity.world_y = pole_position.y
			source_entity.width = maxf(12.0, pole_width * pole_scale)
			source_entity.height = maxf(24.0, pole_height * pole_scale)
			source_entity.pole = true
		elif entity_type == ENTITY_LIGHT_GLOBE:
			var globe_position := _source_runtime_position(level, float(row.get("world_x", 0)) + 4.0, float(row.get("world_y", 0)), source_width, source_height)
			source_entity.world_x = globe_position.x
			source_entity.world_y = globe_position.y
			source_entity.light_globe = true
		elif entity_type == ENTITY_WINDUP_STICK:
			var stick_fields: Array = row.get("fields", [])
			var stick_scale := _source_runtime_scale(source_width, source_height, level)
			var stick_base_x := float(row.get("world_x", 0))
			var stick_base_y := float(row.get("world_y", 0))
			var stick_left := float(_to_int_field(stick_fields[5])) * 8.0 if stick_fields.size() > 5 else -24.0
			var stick_top := float(_to_int_field(stick_fields[6])) * 8.0 if stick_fields.size() > 6 else -8.0
			var stick_width := float(_to_int_field(stick_fields[7])) * 8.0 if stick_fields.size() > 7 else 48.0
			var stick_height := float(_to_int_field(stick_fields[8])) * 8.0 if stick_fields.size() > 8 else 24.0
			var stick_position := _source_runtime_position(level, stick_base_x + stick_left + stick_width * 0.5, stick_base_y + stick_top + stick_height * 0.5, source_width, source_height)
			source_entity.world_x = stick_position.x
			source_entity.world_y = stick_position.y
			source_entity.width = maxf(16.0, stick_width * stick_scale)
			source_entity.height = maxf(16.0, stick_height * stick_scale)
			source_entity.windup_stick = true
		elif entity_type == ENTITY_GERMAN_FLUTE:
			var flute_position := _source_runtime_position(level, float(row.get("world_x", 0)) + 4.0, float(row.get("world_y", 0)), source_width, source_height)
			source_entity.world_x = flute_position.x
			source_entity.world_y = flute_position.y
			source_entity.german_flute = true
			var flute_fields: Array = row.get("fields", [])
			source_entity.german_flute_kind = clampi(_to_int_field(flute_fields[5]) if flute_fields.size() > 5 else 0, 0, 3)
		elif entity_type == ENTITY_SMALL_WINDMILL:
			var windmill_position := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
			source_entity.world_x = windmill_position.x
			source_entity.world_y = windmill_position.y
			source_entity.small_windmill = true
			var windmill_fields: Array = row.get("fields", [])
			source_entity.small_windmill_type = _to_int_field(windmill_fields[5]) if windmill_fields.size() > 5 else 15
		elif entity_type == ENTITY_CHORD:
			var chord_position := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
			source_entity.world_x = chord_position.x
			source_entity.world_y = chord_position.y
			source_entity.chord = true
		elif entity_type == ENTITY_HALF_PIPE:
			var half_pipe_fields: Array = row.get("fields", [])
			var half_pipe_scale := _source_runtime_scale(source_width, source_height, level)
			var half_pipe_base_x := float(row.get("world_x", 0))
			var half_pipe_base_y := float(row.get("world_y", 0))
			var half_pipe_left := float(_to_int_field(half_pipe_fields[5])) * 8.0 if half_pipe_fields.size() > 5 else 0.0
			var half_pipe_top := float(_to_int_field(half_pipe_fields[6])) * 8.0 if half_pipe_fields.size() > 6 else -104.0
			var half_pipe_width := float(_to_int_field(half_pipe_fields[7])) * 8.0 if half_pipe_fields.size() > 7 else 96.0
			var half_pipe_height := float(_to_int_field(half_pipe_fields[8])) * 8.0 if half_pipe_fields.size() > 8 else 104.0
			var half_pipe_position := _source_runtime_position(level, half_pipe_base_x + half_pipe_left + half_pipe_width * 0.5, half_pipe_base_y + half_pipe_top + half_pipe_height * 0.5, source_width, source_height)
			source_entity.world_x = half_pipe_position.x
			source_entity.world_y = half_pipe_position.y
			source_entity.width = maxf(32.0, half_pipe_width * half_pipe_scale)
			source_entity.height = maxf(32.0, half_pipe_height * half_pipe_scale)
			source_entity.half_pipe = true
			source_entity.half_pipe_direction = 1.0 if kind == "HALFPIPE__START" else -1.0
		elif entity_type == ENTITY_IRON_BALL:
			var iron_fields: Array = row.get("fields", [])
			var iron_scale := _source_runtime_scale(source_width, source_height, level)
			var iron_position := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
			source_entity.world_x = iron_position.x
			source_entity.world_y = iron_position.y
			source_entity.origin_x = iron_position.x
			source_entity.origin_y = iron_position.y
			var iron_width := absf(float(_to_int_field(iron_fields[7])) * 8.0 * iron_scale) if iron_fields.size() > 7 else 32.0
			var iron_height := absf(float(_to_int_field(iron_fields[8])) * 8.0 * iron_scale) if iron_fields.size() > 8 else 32.0
			source_entity.iron_ball = true
			source_entity.iron_ball_horizontal = iron_width > iron_height
			source_entity.iron_ball_amplitude = maxf(16.0, iron_width if source_entity.iron_ball_horizontal else iron_height)
			source_entity.iron_ball_phase = PI if iron_fields.size() > 5 and _to_int_field(iron_fields[5]) < 0 else 0.0
		elif entity_type == ENTITY_CRANE:
			var crane_position := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
			source_entity.world_x = crane_position.x
			source_entity.world_y = crane_position.y
			source_entity.origin_x = crane_position.x
			source_entity.origin_y = crane_position.y
			source_entity.crane = true
			source_entity.crane_hook_x = crane_position.x
			source_entity.crane_hook_y = crane_position.y + 88.0
		elif entity_type == ENTITY_CEILING_SLOPE:
			var ceiling_fields: Array = row.get("fields", [])
			var ceiling_scale := _source_runtime_scale(source_width, source_height, level)
			var ceiling_base_x := float(row.get("world_x", 0))
			var ceiling_base_y := float(row.get("world_y", 0))
			var ceiling_left := float(_to_int_field(ceiling_fields[5])) * 8.0 if ceiling_fields.size() > 5 else 0.0
			var ceiling_top := float(_to_int_field(ceiling_fields[6])) * 8.0 if ceiling_fields.size() > 6 else 0.0
			var ceiling_width := float(_to_int_field(ceiling_fields[7])) * 8.0 if ceiling_fields.size() > 7 else 48.0
			var ceiling_height := float(_to_int_field(ceiling_fields[8])) * 8.0 if ceiling_fields.size() > 8 else 96.0
			var ceiling_position := _source_runtime_position(level, ceiling_base_x + ceiling_left + ceiling_width * 0.5, ceiling_base_y + ceiling_top + ceiling_height * 0.5, source_width, source_height)
			source_entity.world_x = ceiling_position.x
			source_entity.world_y = ceiling_position.y
			source_entity.width = maxf(16.0, ceiling_width * ceiling_scale)
			source_entity.height = maxf(16.0, ceiling_height * ceiling_scale)
			source_entity.ceiling_slope = true
			source_entity.ceiling_slope_variant = 1 if kind.ends_with("__B") else 0
		elif entity_type == ENTITY_GAPPED_LOOP:
			var loop_base_x := float(row.get("world_x", 0))
			var loop_base_y := float(row.get("world_y", 0))
			var loop_position := _source_runtime_position(level, loop_base_x, loop_base_y, source_width, source_height)
			source_entity.world_x = loop_position.x
			source_entity.world_y = loop_position.y
			source_entity.gapped_loop = true
			source_entity.gapped_loop_direction = 1.0 if kind.ends_with("START") else -1.0
			source_entity.gapped_loop_center_x = loop_position.x - 96.0 * source_entity.gapped_loop_direction
			source_entity.gapped_loop_center_y = loop_position.y + 96.0
		elif entity_type == ENTITY_FUNNEL_SPHERE:
			var funnel_position := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
			source_entity.world_x = funnel_position.x
			source_entity.world_y = funnel_position.y
			source_entity.funnel_sphere = true
		elif entity_type == ENTITY_MUSIC_ENTRY:
			var entry_position := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
			source_entity.world_x = entry_position.x
			source_entity.world_y = entry_position.y
			source_entity.music_entry = true
			source_entity.music_entry_pipe = kind == "PIPE_INSTRUMENT_ENTRY"
			var entry_fields: Array = row.get("fields", [])
			source_entity.music_entry_kind = clampi(_to_int_field(entry_fields[5]) if entry_fields.size() > 5 else 0, 0, 8)
			source_entity.music_entry_duration = _music_entry_duration(source_entity.music_entry_pipe, source_entity.music_entry_kind)
		elif entity_type == ENTITY_DAMAGE_REGION:
			var damage_fields: Array = row.get("fields", [])
			var damage_scale := _source_runtime_scale(source_width, source_height, level)
			var damage_base_x := float(row.get("world_x", 0))
			var damage_base_y := float(row.get("world_y", 0))
			var damage_left := float(_to_int_field(damage_fields[5])) * 8.0 if damage_fields.size() > 5 else 0.0
			var damage_top := float(_to_int_field(damage_fields[6])) * 8.0 if damage_fields.size() > 6 else 0.0
			var damage_width := float(_to_int_field(damage_fields[7])) * 8.0 if damage_fields.size() > 7 else 24.0
			var damage_height := float(_to_int_field(damage_fields[8])) * 8.0 if damage_fields.size() > 8 else 24.0
			var damage_position := _source_runtime_position(level, damage_base_x + damage_left + damage_width * 0.5, damage_base_y + damage_top + damage_height * 0.5, source_width, source_height)
			source_entity.world_x = damage_position.x
			source_entity.world_y = damage_position.y
			source_entity.width = maxf(16.0, damage_width * damage_scale)
			source_entity.height = maxf(16.0, damage_height * damage_scale)
			source_entity.damage_region = true
		elif entity_type == ENTITY_DECORATION:
			var decoration_position := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
			source_entity.world_x = decoration_position.x
			source_entity.world_y = decoration_position.y
			source_entity.decoration = true
			var decoration_fields: Array = row.get("fields", [])
			source_entity.decoration_id = maxi(0, _to_int_field(decoration_fields[5]) if decoration_fields.size() > 5 else 0)
		elif entity_type == ENTITY_GOAL:
			source_entity.goal_toggle = kind == "TOGGLE__GOAL"
		elif entity_type == ENTITY_LAYER_TOGGLE:
			source_entity.variant = 1 if kind.find("BACKGROUND") >= 0 else 0
			var fields: Array = row.get("fields", [])
			if fields.size() > 8:
				source_entity.width = maxf(32.0, float(_to_int_field(fields[7])) * 8.0 * _source_runtime_scale(source_width, source_height, level))
				source_entity.height = maxf(32.0, float(_to_int_field(fields[8])) * 8.0 * _source_runtime_scale(source_width, source_height, level))
		elif entity_type == ENTITY_RAMP:
			if kind == "INCLINE_RAMP":
				source_entity.ramp_incline = true
				var incline_fields: Array = row.get("fields", [])
				source_entity.variant = (_to_int_field(incline_fields[5]) & 1) if incline_fields.size() > 5 else 0
			else:
				var ramp_fields: Array = row.get("fields", [])
				source_entity.variant = (_to_int_field(ramp_fields[5]) & 1) if ramp_fields.size() > 5 else 0
		elif entity_type == ENTITY_PIPE_END:
			var pipe_end_fields: Array = row.get("fields", [])
			source_entity.pipe_exit_back_layer = pipe_end_fields.size() > 3 and _to_int_field(pipe_end_fields[3]) != 0
			source_entity.pipe_exit_uncurl = pipe_end_fields.size() > 4 and _to_int_field(pipe_end_fields[4]) != 0
		elif entity_type == ENTITY_CORK_SCREW:
			source_entity.variant = 1 if kind.find("STOP") >= 0 or kind.find("END") >= 0 else 0
		elif entity_type == ENTITY_FLYING_HANDLE:
			var flying_fields: Array = row.get("fields", [])
			var flying_scale := _source_runtime_scale(source_width, source_height, level)
			var flying_base := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
			var flying_top := float(_to_int_field(flying_fields[6])) * 8.0 * flying_scale if flying_fields.size() > 6 else -72.0 * flying_scale
			var flying_bottom := float(_to_int_field(flying_fields[8])) * 8.0 * flying_scale if flying_fields.size() > 8 else 72.0 * flying_scale
			source_entity.world_x = flying_base.x
			source_entity.world_y = flying_base.y + flying_bottom
			source_entity.origin_x = flying_base.x
			source_entity.origin_y = flying_base.y
			source_entity.flying_handle_top_y = flying_base.y + flying_top
			source_entity.flying_handle_bottom_y = flying_base.y + flying_bottom
			source_entity.flying_handle = true
		elif entity_type == ENTITY_BOUNCY_SPRING and kind == "BOUNCY_BAR":
			source_entity.variant = 2
		elif entity_type == ENTITY_NOTE_BLOCK or entity_type == ENTITY_NOTE_SPHERE:
			var note_fields: Array = row.get("fields", [])
			source_entity.note_kind = clampi(_to_int_field(note_fields[5]) if note_fields.size() > 5 else 0, 0, 7)
			source_entity.note_health = 3
		elif entity_type == ENTITY_SPRING:
			source_entity.variant = _source_spring_variant(kind)
			source_entity.flying_spring = kind == "FLYING_SPRING"
			source_entity.floating_spring = kind == "FLOATING_SPRING"
			source_entity.origin_y = source_entity.world_y
			source_entity.origin_x = source_entity.world_x
			if source_entity.floating_spring:
				var floating_fields: Array = row.get("fields", [])
				if floating_fields.size() > 8:
					var floating_scale := _source_runtime_scale(source_width, source_height, level)
					var floating_x_amplitude := absf(float(_to_int_field(floating_fields[7])) * 8.0 * floating_scale)
					var floating_y_amplitude := absf(float(_to_int_field(floating_fields[8])) * 8.0 * floating_scale)
					source_entity.floating_spring_amplitude_x = floating_x_amplitude
					source_entity.floating_spring_amplitude_y = floating_y_amplitude
					var floating_direction := _to_int_field(floating_fields[5]) if floating_x_amplitude > floating_y_amplitude else _to_int_field(floating_fields[6])
					source_entity.floating_spring_phase = PI if floating_direction < 0 else 0.0
		elif entity_type == ENTITY_FAN:
			source_entity.width = 96.0
			source_entity.height = 96.0
			source_entity.variant = 1 if kind.find("PERIODIC") >= 0 else 0
			source_entity.velocity_x = -1.0 if kind.find("LEFT") >= 0 else 1.0
			source_entity.fan_speed = 1.0
		elif entity_type == ENTITY_WHIRLWIND:
			source_entity.width = 128.0
			source_entity.height = 128.0
			source_entity.whirlwind_active = false
			source_entity.whirlwind_timer = 0.0
			var whirlwind_fields: Array = row.get("fields", [])
			if whirlwind_fields.size() > 8:
				source_entity.width = _source_entity_extent(whirlwind_fields[7], source_width, source_height, level)
				source_entity.height = _source_entity_extent(whirlwind_fields[8], source_width, source_height, level)
		elif entity_type == ENTITY_PROPELLER:
			source_entity.width = 148.0
			source_entity.height = 128.0
		elif entity_type == ENTITY_DASH_RING:
			source_entity.width = 28.0
			source_entity.height = 28.0
			var dash_fields: Array = row.get("fields", [])
			source_entity.variant = clampi(_to_int_field(dash_fields[5]), DASH_RING_UP, DASH_RING_UP_LEFT) if dash_fields.size() > 5 else DASH_RING_RIGHT
		elif entity_type == ENTITY_GRAVITY_TOGGLE:
			source_entity.width = 128.0
			source_entity.height = 128.0
			source_entity.gravity_kind = _source_gravity_kind(kind)
			var gravity_fields: Array = row.get("fields", [])
			if gravity_fields.size() > 8:
				source_entity.width = _source_entity_extent(gravity_fields[7], source_width, source_height, level)
				source_entity.height = _source_entity_extent(gravity_fields[8], source_width, source_height, level)
		elif entity_type == ENTITY_GRIND_RAIL:
			source_entity.rail_direction = -1.0 if kind.find("LEFT") >= 0 else 1.0
			source_entity.rail_end_mode = 1 if kind.find("END_AIR") >= 0 or kind.find("FORCED_JUMP") >= 0 or kind.find("ALTERNATE") >= 0 else 0
			source_entity.rail_is_start = kind.find("START") >= 0
			source_entity.rail_air_start = kind.find("START_AIR") >= 0
	_apply_source_terrain(level, source_width, source_height)

func _add_source_launcher(entity: EntityState, row: Dictionary, kind: String, source_width: float, source_height: float, level: LevelState) -> void:
	var fields: Array = row.get("fields", [])
	if fields.size() <= 8:
		return
	var scale := _source_runtime_scale(source_width, source_height, level)
	var base_x := float(row.get("world_x", 0))
	var base_y := float(row.get("world_y", 0))
	var left := float(_to_int_field(fields[5])) * 8.0
	var top := float(_to_int_field(fields[6])) * 8.0
	var right := left + float(_to_int_field(fields[7])) * 8.0
	var bottom := top + float(_to_int_field(fields[8])) * 8.0
	var goes_left := kind.ends_with("LEFT")
	var gravity_up := kind.find("__UP_") >= 0
	var start_x := right if goes_left else left
	var end_x := left if goes_left else right
	var vertical_offset := top if gravity_up else bottom
	var start := _source_runtime_position(level, base_x + start_x, base_y + vertical_offset, source_width, source_height)
	var end := _source_runtime_position(level, base_x + end_x, base_y + vertical_offset, source_width, source_height)
	entity.world_x = start.x
	entity.world_y = start.y
	entity.launcher_cart_x = start.x
	entity.launcher_cart_y = start.y
	entity.launcher_base_x = start.x
	entity.launcher_target_x = end.x
	entity.launcher_direction = -1.0 if goes_left else 1.0
	entity.launcher_gravity_up = gravity_up
	entity.launcher_scale = scale

func _add_source_platform_a(level: LevelState, row: Dictionary, source_width: float, source_height: float) -> void:
	var fields: Array = row.get("fields", [])
	if fields.size() <= 8:
		return
	var scale := _source_runtime_scale(source_width, source_height, level)
	var source_position := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
	var horizontal := _to_int_field(fields[7]) > _to_int_field(fields[8])
	var amplitude_source := _to_int_field(fields[7]) if horizontal else _to_int_field(fields[8])
	var direction_field := _to_int_field(fields[5]) if horizontal else _to_int_field(fields[6])
	var phase := PI if direction_field < 0 else 0.0
	var amplitude := absf(float(amplitude_source)) * 8.0 * scale
	_add_moving_platform(level, source_position.x - 24.0, source_position.y + 12.0, 48.0, 12.0, 0 if horizontal else 1, amplitude, 4.0 * TAU / 256.0 * 60.0, phase)

func _add_source_platform_b(level: LevelState, row: Dictionary, source_width: float, source_height: float) -> void:
	var source_position := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
	_add_platform(level, source_position.x - 24.0, source_position.y + 12.0, 48.0, 12.0)

func _add_source_speeding_platform(level: LevelState, row: Dictionary, source_width: float, source_height: float) -> void:
	var base_x := float(row.get("world_x", 0))
	var base_y := float(row.get("world_y", 0))
	var start := _source_runtime_position(level, base_x + 32.0, base_y + 18.0, source_width, source_height)
	var first_target := _source_runtime_position(level, base_x + 590.0, base_y + 576.0, source_width, source_height)
	var final_target := _source_runtime_position(level, base_x + 814.0, base_y + 576.0, source_width, source_height)
	_add_platform(level, start.x - 27.0, start.y, 54.0, 12.0)
	var platform: PlatformState = level.platforms.back()
	platform.speeding_mode = true
	platform.speeding_base_x = start.x - 27.0
	platform.speeding_base_y = start.y
	platform.speeding_target_x = first_target.x
	platform.speeding_target_y = first_target.y
	platform.speeding_first_x = first_target.x
	platform.speeding_first_y = first_target.y
	platform.speeding_final_x = final_target.x
	platform.speeding_final_y = final_target.y

func _add_source_entity(level: LevelState, entity_type: int, row: Dictionary, source_width: float, source_height: float) -> EntityState:
	var runtime_position := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
	var runtime_x: float = runtime_position.x
	var runtime_y: float = runtime_position.y
	return _add_entity(level, entity_type, runtime_x, runtime_y)

func _configure_source_lap_trigger(entity: EntityState, row: Dictionary, source_width: float, source_height: float, level: LevelState) -> void:
	var fields: Array = row.get("fields", [])
	var scale := _source_runtime_scale(source_width, source_height, level)
	var base_x := float(row.get("world_x", 0))
	var base_y := float(row.get("world_y", 0))
	var left := float(_to_int_field(fields[5])) * 8.0 if fields.size() > 5 else 0.0
	var top := float(_to_int_field(fields[6])) * 8.0 if fields.size() > 6 else 0.0
	var width := maxf(8.0, float(_to_int_field(fields[7])) * 8.0 if fields.size() > 7 else 8.0)
	var height := maxf(8.0, float(_to_int_field(fields[8])) * 8.0 if fields.size() > 8 else 8.0)
	var position := _source_runtime_position(level, base_x, base_y, source_width, source_height)
	entity.world_x = position.x
	entity.world_y = position.y
	entity.width = width * scale
	entity.height = height * scale
	entity.lap_previous_player_x = _player_state.world_x
	entity.lap_previous_checkpoint_time = _checkpoint_time


func _add_source_crumbling_platform(level: LevelState, row: Dictionary, source_width: float, source_height: float) -> void:
	var fields: Array = row.get("fields", [])
	if fields.size() <= 8:
		return
	var scale := _source_runtime_scale(source_width, source_height, level)
	var source_x := float(row.get("world_x", 0)) + float(_to_int_field(fields[5])) * 8.0
	var source_y := float(row.get("world_y", 0)) + float(_to_int_field(fields[6])) * 8.0
	var position := _source_runtime_position(level, source_x, source_y, source_width, source_height)
	var width := maxf(32.0, float(_to_int_field(fields[7])) * 8.0 * scale)
	var thickness := maxf(8.0, float(_to_int_field(fields[8])) * 8.0 * scale)
	# platform_crumbling.c transitions after its counter passes 30 frames.
	_add_crumbling_platform(level, position.x, position.y + thickness, width, thickness, 31.0 / 60.0)

func _add_source_square_platform(level: LevelState, row: Dictionary, source_width: float, source_height: float) -> void:
	var fields: Array = row.get("fields", [])
	if fields.size() <= 8:
		return
	var scale := _source_runtime_scale(source_width, source_height, level)
	var source_x := float(row.get("world_x", 0)) + float(_to_int_field(fields[5])) * 8.0
	var source_y := float(row.get("world_y", 0)) + float(_to_int_field(fields[6])) * 8.0
	var position := _source_runtime_position(level, source_x, source_y, source_width, source_height)
	var horizontal_extent := maxi(0, _to_int_field(fields[7]))
	var vertical_extent := maxi(0, _to_int_field(fields[8]))
	var axis := 0 if horizontal_extent > vertical_extent else 1
	var amplitude := maxf(16.0, float(maxi(horizontal_extent, vertical_extent)) * 8.0 * scale)
	var phase := PI if _to_int_field(fields[5]) < 0 or _to_int_field(fields[6]) < 0 else 0.0
	_add_moving_platform(level, position.x, position.y + 16.0, 32.0, 16.0, axis, amplitude, 3.75, phase)

func _add_source_thin_platform(level: LevelState, row: Dictionary, source_width: float, source_height: float) -> void:
	var position := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
	_add_platform(level, position.x, position.y + 8.0, 32.0, 8.0)

func _add_source_arrow_platform(level: LevelState, row: Dictionary, kind: String, source_width: float, source_height: float) -> void:
	var fields: Array = row.get("fields", [])
	if fields.size() <= 8:
		return
	var scale := _source_runtime_scale(source_width, source_height, level)
	var base_x := float(row.get("world_x", 0))
	var base_y := float(row.get("world_y", 0))
	var source_width_offset := float(_to_int_field(fields[5])) * 8.0 + 24.0
	var source_height_offset := float(_to_int_field(fields[6])) * 8.0 + 24.0
	var source_target_x := float(_to_int_field(fields[7])) * 8.0 + source_width_offset - 24.0
	var source_target_y := float(_to_int_field(fields[8])) * 8.0 + source_height_offset - 24.0
	var current_offset := Vector2(source_width_offset, source_height_offset)
	var target_offset := Vector2(source_target_x, source_target_y)
	if kind.ends_with("RIGHT"):
		current_offset.x = source_width_offset
		target_offset.x = source_target_x
	elif kind.ends_with("LEFT"):
		current_offset.x = source_target_x
		target_offset.x = source_width_offset
	else:
		current_offset.y = source_target_y
		target_offset.y = source_height_offset
	var position := _source_runtime_position(level, base_x + current_offset.x, base_y + current_offset.y, source_width, source_height)
	var target := _source_runtime_position(level, base_x + target_offset.x, base_y + target_offset.y, source_width, source_height)
	_add_platform(level, position.x, position.y + 12.0, 32.0, 12.0)
	var platform: PlatformState = level.platforms.back()
	platform.arrow_mode = true
	platform.arrow_target_x = target.x
	platform.arrow_target_y = target.y
	platform.arrow_speed = 7.5 * 60.0 * scale

func _source_runtime_position(level: LevelState, source_x: float, source_y: float, source_width: float, source_height: float) -> Vector2:
	var terrain: Dictionary = _source_map_manifest.get("terrain", {})
	var source_spawn_x := float(terrain.get("spawn_x", 96))
	var source_spawn_y := float(terrain.get("spawn_y", 655))
	var scale := _source_runtime_scale(source_width, source_height, level)
	return Vector2(
		clampf(180.0 + (source_x - source_spawn_x) * scale, 120.0, level.max_x - 120.0),
		clampf(level.spawn_y + (source_y - source_spawn_y) * scale, 48.0, level.max_y - 24.0)
	)

func _source_runtime_scale(source_width: float, source_height: float, level: LevelState) -> float:
	return clampf(minf((level.max_x - 360.0) / source_width, (level.max_y - 120.0) / source_height), 0.06, 0.14)

func _source_entity_extent(value: Variant, source_width: float, source_height: float, level: LevelState) -> float:
	return maxf(32.0, float(_to_int_field(value)) * 8.0 * _source_runtime_scale(source_width, source_height, level))

func _to_int_field(value: Variant) -> int:
	return int(str(value).strip_edges())

func _apply_source_terrain(level: LevelState, source_width: float, source_height: float) -> void:
	var terrain: Dictionary = _source_map_manifest.get("terrain", {})
	if not bool(terrain.get("valid", false)):
		return
	_apply_source_terrain_layer(level, terrain, source_width, source_height, 0)
	_apply_source_terrain_layer(level, terrain, source_width, source_height, 1)

func _apply_source_terrain_layer(level: LevelState, terrain: Dictionary, source_width: float, source_height: float, collision_layer: int) -> void:
	var sample_step := 16
	var segment_start := -1
	var segment_last_x := 0
	var segment_start_y := 0
	var segment_end_y := 0
	for source_x in range(0, int(source_width), sample_step):
		var surface := _source_surface_at(terrain, source_x, int(source_height), collision_layer)
		if surface < 0:
			if segment_start >= 0:
				_add_source_platform(level, segment_start, segment_last_x, segment_start_y, segment_end_y, source_width, source_height, collision_layer)
				segment_start = -1
			continue
		var runtime_position := _source_runtime_position(level, source_x, surface, source_width, source_height)
		if segment_start < 0 or absf(runtime_position.y - _source_runtime_position(level, segment_start, segment_start_y, source_width, source_height).y) > 22.0:
			if segment_start >= 0:
				_add_source_platform(level, segment_start, segment_last_x, segment_start_y, segment_end_y, source_width, source_height, collision_layer)
			segment_start = source_x
			segment_start_y = surface
			segment_last_x = source_x
		segment_end_y = surface
		segment_last_x = source_x
	if segment_start >= 0:
		_add_source_platform(level, segment_start, segment_last_x, segment_start_y, segment_end_y, source_width, source_height, collision_layer)

func _source_surface_at(terrain: Dictionary, source_x: int, source_height: int, collision_layer: int) -> int:
	# The source collision pass keeps the lowest solid surface at each column.
	# Scan upward from the bottom and stop once a future sample cannot exceed
	# the current surface. Negative source heights can extend a surface by up to
	# 16 pixels above its sampled row, so retain that bound for exact results.
	var best_surface := -1
	for source_y in range(source_height - 8, -1, -8):
		var sample: Dictionary = SOURCE_MAP_LOADER.sample_floor(terrain, source_x, source_y, collision_layer)
		if bool(sample.get("solid", false)):
			best_surface = maxi(best_surface, int(sample.get("surface_y", source_y)))
		if best_surface >= 0 and source_y + 16 <= best_surface:
			break
	return best_surface

func _add_source_platform(level: LevelState, source_start_x: int, source_end_x: int, source_start_y: float, source_end_y: float, source_width: float, source_height: float, collision_layer: int) -> void:
	var start_position := _source_runtime_position(level, source_start_x, source_start_y, source_width, source_height)
	var end_position := _source_runtime_position(level, source_end_x + 16, source_end_y, source_width, source_height)
	var start := start_position.x
	var end := end_position.x
	if end - start >= 18.0:
		_add_sloped_platform(level, start, start_position.y + 12.0, end, end_position.y + 12.0, 12.0, collision_layer)

func _source_interactable_type(kind: String) -> int:
	if kind == "COLLECT_RINGS_LAP_TRIGGER":
		return ENTITY_LAP_TRIGGER
	if kind == "GOAL_LEVER":
		return ENTITY_GOAL_LEVER
	if kind == "SPECIAL_RING":
		return ENTITY_SPECIAL_RING
	if kind.begins_with("LAUNCHER__"):
		return ENTITY_LAUNCHER
	if kind == "PIPE__START":
		return ENTITY_PIPE_START
	if kind == "PIPE__END":
		return ENTITY_PIPE_END
	if kind == "HOOK_RAIL__START" or kind == "HOOK_RAIL__END":
		return ENTITY_HOOK_RAIL
	if kind == "SLIDY_ICE":
		return ENTITY_SLIDY_ICE
	if kind == "LIGHT_BRIDGE":
		return ENTITY_LIGHT_BRIDGE
	if kind == "SLOWING_SNOW":
		return ENTITY_SLOWING_SNOW
	if kind == "SPIKE_PLATFORM":
		return ENTITY_SPIKE_PLATFORM
	if kind == "TURNAROUND_BAR":
		return ENTITY_TURNAROUND_BAR
	if kind == "KEYBOARD_VERTICAL" or kind == "KEYBOARD_HORIZONTAL_LEFT" or kind == "KEYBOARD_HORIZONTAL_RIGHT":
		return ENTITY_KEYBOARD
	if kind == "POLE":
		return ENTITY_POLE
	if kind == "LIGHT_GLOBE":
		return ENTITY_LIGHT_GLOBE
	if kind == "WINDUP_STICK":
		return ENTITY_WINDUP_STICK
	if kind == "GERMAN_FLUTE":
		return ENTITY_GERMAN_FLUTE
	if kind == "SMALL_WINDMILL":
		return ENTITY_SMALL_WINDMILL
	if kind == "CHORD":
		return ENTITY_CHORD
	if kind == "HALFPIPE__START" or kind == "HALFPIPE__END":
		return ENTITY_HALF_PIPE
	if kind == "IRON_BALL":
		return ENTITY_IRON_BALL
	if kind == "CRANE":
		return ENTITY_CRANE
	if kind.begins_with("CEILING_SLOPE__"):
		return ENTITY_CEILING_SLOPE
	if kind == "GAPPED_LOOP__START" or kind == "GAPPED_LOOP__END":
		return ENTITY_GAPPED_LOOP
	if kind == "FUNNEL_SPHERE":
		return ENTITY_FUNNEL_SPHERE
	if kind == "TRUMPET_ENTRY" or kind == "PIPE_INSTRUMENT_ENTRY":
		return ENTITY_MUSIC_ENTRY
	if kind == "IA105":
		return ENTITY_DAMAGE_REGION
	if kind == "DECORATION":
		return ENTITY_DECORATION
	if kind == "CANNON":
		return ENTITY_CANNON
	if kind.begins_with("WHIRLWIND"):
		return ENTITY_WHIRLWIND
	if kind.begins_with("FAN"):
		return ENTITY_FAN
	if kind == "PROPELLER":
		return ENTITY_PROPELLER
	if kind == "DASH_RING":
		return ENTITY_DASH_RING
	if kind.begins_with("TOGGLE_GRAVITY"):
		return ENTITY_GRAVITY_TOGGLE
	if kind.find("TOGGLE_PLAYER_LAYER") >= 0:
		return ENTITY_LAYER_TOGGLE
	if kind == "RAMP" or kind == "INCLINE_RAMP":
		return ENTITY_RAMP
	if kind == "FLYING_HANDLE":
		return ENTITY_FLYING_HANDLE
	if kind == "ROTATING_HANDLE":
		return ENTITY_ROTATING_HANDLE
	if kind.find("CORK_SCREW") >= 0 or kind.find("CORKSCREW") >= 0:
		return ENTITY_CORK_SCREW
	if kind.begins_with("NOTE_BLOCK") and kind.ends_with("__SPHERE"):
		return ENTITY_NOTE_SPHERE
	if kind.begins_with("NOTE_BLOCK"):
		return ENTITY_NOTE_BLOCK
	if kind == "BOUNCY_BAR":
		return ENTITY_BOUNCY_SPRING
	if kind.find("CHECKPOINT") >= 0:
		return ENTITY_CHECKPOINT
	if kind.find("GOAL") >= 0:
		return ENTITY_GOAL
	if kind.find("SPRING") >= 0:
		return ENTITY_BOUNCY_SPRING if kind == "BOUNCY_SPRING" else ENTITY_SPRING
	if kind.find("SPIKES") >= 0 or kind == "SPIKE_PLATFORM":
		return ENTITY_SPIKES
	if kind == "BOOSTER":
		return ENTITY_BOOSTER
	if kind.find("GRIND_RAIL") >= 0:
		return ENTITY_GRIND_RAIL
	return -1

func _source_gravity_kind(kind: String) -> int:
	if kind.ends_with("DOWN"):
		return GRAVITY_KIND_DOWN
	if kind.ends_with("UP"):
		return GRAVITY_KIND_UP
	return GRAVITY_KIND_TOGGLE

func _source_spring_variant(kind: String) -> int:
	if kind.ends_with("DOWNLEFT"):
		return SPRING_DOWN_LEFT
	if kind.ends_with("DOWNRIGHT"):
		return SPRING_DOWN_RIGHT
	if kind.ends_with("UPLEFT"):
		return SPRING_UP_LEFT
	if kind.ends_with("UPRIGHT"):
		return SPRING_UP_RIGHT
	if kind.ends_with("DOWN"):
		return SPRING_DOWN
	if kind.ends_with("LEFT"):
		return SPRING_LEFT
	if kind.ends_with("RIGHT"):
		return SPRING_RIGHT
	return SPRING_UP

func _source_enemy_type(kind: String) -> int:
	match kind:
		"BUZZER":
			return ENTITY_BUZZER
		"KIKI":
			return ENTITY_KIKI
		"MON":
			return ENTITY_ENEMY
		"BALLOON":
			return ENTITY_BALLOON
		"BULLETBUZZER":
			return ENTITY_BULLET_BUZZER
		"KOURA":
			return ENTITY_KOURA
		"STAR":
			return ENTITY_STAR
		# These source enemies share the generic contact/damage path until their
		# individual animation and attack state machines are migrated.
		"KUBINAGA", "GOHLA", "KURAKURA", "KOURA", "CIRCUS", "BELL", "YADO", "PIKOPIKO", "MADILLO", "STRAW", "HAMMERHEAD", "SPINNER", "MOUSE", "PEN", "GEJIGEJI", "BALLOON", "FLICKEY", "KYURA", "STAR", "BULLETBUZZER":
			return ENTITY_ENEMY
	return -1

func _configure_source_enemy(entity: EntityState, kind: String, row: Dictionary) -> void:
	# Keep source enemies anchored to their imported spawn until their original
	# species-specific state machine is available in the bridge.
	entity.origin_x = entity.world_x
	entity.origin_y = entity.world_y
	entity.previous_world_y = entity.world_y
	entity.patrol_min_x = entity.world_x - 96.0
	entity.patrol_max_x = entity.world_x + 96.0
	entity.velocity_x = 0.0
	var fields: Array = row.get("fields", [])
	if fields.size() > 7:
		var source_start := float(_to_int_field(fields[5])) * 8.0
		var source_width := float(_to_int_field(fields[7])) * 8.0
		if source_width > 0.0:
			entity.patrol_min_x = entity.world_x + source_start
			entity.patrol_max_x = entity.world_x + source_start + source_width
	match kind:
		"BUZZER":
			entity.velocity_x = 45.0
			entity.state_timer = 0.0
			entity.buzzer_turn_timer = 0.0
			entity.buzzer_cooldown = 0.0
			entity.buzzer_attack_origin_x = entity.world_x
			entity.buzzer_attack_origin_y = entity.world_y
			entity.buzzer_attack_timer = 0.0
		"BALLOON":
			entity.velocity_x = 42.0
			entity.velocity_x = 30.0
			entity.state_timer = 120.0 / 60.0
			entity.variant = 0
			entity.balloon_angle = 0.0
			entity.balloon_projectile_spawned = false
			if fields.size() > 8:
				entity.balloon_amplitude_x = clampf(absf(float(_to_int_field(fields[7]))) * 4.0, 4.0, 48.0)
				entity.balloon_amplitude_y = clampf(absf(float(_to_int_field(fields[8]))) * 4.0, 4.0, 48.0)
		"BULLETBUZZER":
			entity.state_timer = 0.0
			entity.bullet_buzzer_angle = 0.0
			entity.bullet_buzzer_attack_timer = 0.0
			entity.bullet_buzzer_projectile_spawned = false
		"KOURA":
			var horizontal := fields.size() > 8 and _to_int_field(fields[7]) > _to_int_field(fields[8])
			var direction := _to_int_field(fields[6]) if fields.size() > 6 else 0
			entity.koura_motion_variant = 0 if horizontal and direction == 0 else (1 if horizontal and direction == 1 else (2 if horizontal else 3))
			entity.velocity_x = -30.0 if entity.koura_motion_variant < 2 else 0.0
			if entity.koura_motion_variant == 3:
				entity.velocity_y = -30.0
				entity.koura_patrol_min_y = entity.world_y + float(_to_int_field(fields[6])) * 8.0 if fields.size() > 6 else entity.world_y - 96.0
				entity.koura_patrol_max_y = entity.koura_patrol_min_y + float(_to_int_field(fields[8])) * 8.0 if fields.size() > 8 else entity.world_y + 96.0
		"STAR":
			entity.state_timer = 2.0
		"KIKI":
			entity.state_timer = 0.0
			entity.kiki_vertical_direction = 1.0
			entity.kiki_vertical_min = entity.world_y - 48.0
			entity.kiki_vertical_max = entity.world_y + 48.0
			entity.kiki_border_hits = 0
			entity.kiki_attack_frames = 0
			entity.kiki_projectile_spawned = false
		"PEN":
			entity.enemy_profile = 1
			entity.velocity_x = -30.0
			entity.pen_boosting = false
			entity.pen_turn_timer = 0.0
			entity.pen_direction = -1.0
		"MOUSE":
			entity.enemy_profile = 3
			entity.velocity_x = -30.0
			entity.mouse_boosting = false
			entity.mouse_turn_timer = 0.0
			entity.mouse_direction = -1.0
			entity.mouse_position_offset = 8.0 if fields.size() > 8 and _to_int_field(fields[8]) != 0 else 0.0
		"BELL":
			entity.enemy_profile = 2
			entity.state_timer = 2.0
			entity.bell_phase = 0
			entity.bell_phase_timer = 120.0 / 60.0
		"CIRCUS":
			entity.enemy_profile = 4
			entity.circus_phase = 0
			entity.circus_phase_timer = 1.0 / 60.0
			entity.circus_projectile_spawned = false
		"PIKOPIKO":
			entity.enemy_profile = 18
			entity.velocity_x = -60.0
			entity.pikopiko_clamp_ground = fields.size() > 1 and _to_int_field(fields[1]) != 0
		"YADO":
			entity.enemy_profile = 5
			entity.state_timer = 2.0
			entity.yado_phase = 0
			entity.yado_phase_timer = 2.0
			entity.yado_projectile_fired = false
			entity.yado_facing = 1
		"GOHLA":
			entity.enemy_profile = 6
			entity.state_timer = 0.0
			entity.velocity_x = -30.0
		"KURAKURA":
			entity.enemy_profile = 8
			entity.state_timer = 0.0
		"GEJIGEJI":
			entity.enemy_profile = 10
			entity.gejigeji_vertical = fields.size() > 8 and _to_int_field(fields[7]) <= _to_int_field(fields[8])
			entity.velocity_x = -33.75 if not entity.gejigeji_vertical else 0.0
			entity.velocity_y = -33.75 if entity.gejigeji_vertical else 0.0
			if entity.gejigeji_vertical:
				entity.koura_patrol_min_y = entity.world_y + float(_to_int_field(fields[6])) * 8.0 if fields.size() > 6 else entity.world_y - 96.0
				entity.koura_patrol_max_y = entity.koura_patrol_min_y + float(_to_int_field(fields[8])) * 8.0 if fields.size() > 8 else entity.world_y + 96.0
			for _history in range(64):
				entity.gejigeji_history.append(Vector2(entity.world_x, entity.world_y))
			for _segment in range(4):
				entity.trail_positions.append(Vector2(entity.world_x, entity.world_y))
		"KUBINAGA":
			entity.enemy_profile = 11
			entity.target_x = entity.world_x
			entity.target_y = entity.world_y
			entity.kubinaga_phase = 0
			entity.kubinaga_phase_timer = 2.0
			entity.kubinaga_extension = 0.0
		"MADILLO":
			entity.enemy_profile = 12
			entity.state_timer = 0.0
			entity.velocity_x = 0.0
			entity.madillo_return_timer = 0.0
		"SPINNER":
			entity.enemy_profile = 13
			entity.state_timer = 0.0
		"KYURA":
			entity.enemy_profile = 14
			entity.state_timer = 0.0
			entity.kyura_phase_units = 0.0
			entity.kyura_switch_timer = 8.0 / 60.0
			entity.kyura_recovering = false
			entity.kyura_projectile_counter = 12
			entity.kyura_projectile_variant = 0
			entity.target_x = absf(float(_to_int_field(fields[7])) * 4.0) if fields.size() > 7 else 24.0
			entity.target_y = absf(float(_to_int_field(fields[8])) * 4.0) if fields.size() > 8 else 16.0
		"FLICKEY":
			entity.enemy_profile = 15
			entity.velocity_x = -90.0
			entity.flickey_vertical_speed = -240.0
			entity.flickey_turn_timer = 0.0
			for _history in range(64):
				entity.flickey_history.append(Vector2(entity.world_x, entity.world_y))
			for _segment in range(4):
				entity.trail_positions.append(Vector2(entity.world_x, entity.world_y))
		"MON":
			entity.enemy_profile = 16
			entity.state_timer = 0.0
			entity.mon_phase_timer = 0.0
		"HAMMERHEAD":
			entity.enemy_profile = 7
			# hammerhead.c multiplies the 256-step source phase by four and
			# offsets it by half a sine cycle before sampling SIN().
			entity.state_timer = TAU * 0.5 + (float(_to_int_field(fields[8])) * 4.0 * TAU / 1024.0 if fields.size() > 8 else 0.0)
		"STRAW":
			entity.enemy_profile = 9
			entity.state_timer = 1.0
			entity.straw_phase = 0
			entity.straw_phase_timer = 30.0 / 60.0
			entity.straw_cycles = 5
			var seed_angle := fmod(absf(entity.world_x * 0.017 + entity.world_y * 0.013), TAU)
			entity.velocity_x = cos(seed_angle) * 120.0
			entity.velocity_y = sin(seed_angle) * 120.0

func _source_item_kind(kind: String) -> int:
	match kind:
		"SHIELD":
			return ITEM_BOX_KIND_SHIELD
		"SHIELD_MAGNETIC":
			return ITEM_BOX_KIND_MAGNETIC_SHIELD
		"INVINCIBILITY":
			return ITEM_BOX_KIND_INVINCIBILITY
		"ONE_UP":
			return ITEM_BOX_KIND_ONE_UP
		"SPEED_UP":
			return ITEM_BOX_KIND_SPEED_UP
		"RINGS_5":
			return ITEM_BOX_KIND_RINGS_5
		"RINGS_10":
			return ITEM_BOX_KIND_RINGS_10
		"RINGS_RANDOM":
			return ITEM_BOX_KIND_RINGS_RANDOM
	return ITEM_BOX_KIND_RINGS

func _add_platform(level: LevelState, x: float, y: float, width: float, thickness: float) -> void:
	var platform := PlatformState.new()
	platform.x1 = x
	platform.x2 = x + width
	platform.bottom_y = y
	platform.top_y = y - thickness
	platform.thickness = thickness
	platform.slope_start_y = platform.top_y
	platform.slope_end_y = platform.top_y
	level.platforms.append(platform)

func _add_sloped_platform(level: LevelState, x1: float, y1: float, x2: float, y2: float, thickness: float, collision_layer: int = -1) -> void:
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

func _add_crumbling_platform(level: LevelState, x: float, y: float, width: float, thickness: float, delay: float = 0.5) -> void:
	_add_platform(level, x, y, width, thickness)
	var platform: PlatformState = level.platforms.back()
	platform.crumble_delay = maxf(0.1, delay)

func _add_moving_platform(level: LevelState, x: float, y: float, width: float, thickness: float, axis: int, amplitude: float, speed: float, phase: float = 0.0) -> void:
	_add_platform(level, x, y, width, thickness)
	var platform: PlatformState = level.platforms.back()
	platform.moving = true
	platform.motion_axis = 1 if axis != 0 else 0
	platform.motion_amplitude = maxf(0.0, amplitude)
	platform.motion_speed = speed
	platform.motion_phase = phase

func _add_ring_line(level: LevelState, start_x: float, y: float, count: int, spacing: float) -> void:
	for i in range(count):
		_add_entity(level, ENTITY_RING, start_x + (float(i) * spacing), y)

func _add_spring(level: LevelState, x: float, y: float, direction: int = SPRING_UP) -> void:
	var entity := _add_entity(level, ENTITY_SPRING, x, y)
	entity.variant = clampi(direction, SPRING_UP, SPRING_DOWN_RIGHT)

func _add_enemy(level: LevelState, x: float, y: float, patrol_min_x: float, patrol_max_x: float) -> void:
	var entity := _add_entity(level, ENTITY_ENEMY, x, y)
	entity.velocity_x = _enemy_speed
	entity.patrol_min_x = patrol_min_x
	entity.patrol_max_x = patrol_max_x

func _add_buzzer(level: LevelState, x: float, y: float, patrol_min_x: float, patrol_max_x: float) -> void:
	var entity := _add_entity(level, ENTITY_BUZZER, x, y)
	entity.velocity_x = 45.0
	entity.patrol_min_x = patrol_min_x
	entity.patrol_max_x = patrol_max_x
	entity.origin_x = x
	entity.origin_y = y
	entity.target_x = x
	entity.target_y = y
	entity.buzzer_turn_timer = 0.0
	entity.buzzer_cooldown = 0.0
	entity.buzzer_attack_origin_x = x
	entity.buzzer_attack_origin_y = y
	entity.buzzer_attack_timer = 0.0

func _add_balloon(level: LevelState, x: float, y: float, patrol_min_x: float, patrol_max_x: float) -> void:
	var entity := _add_entity(level, ENTITY_BALLOON, x, y)
	entity.velocity_x = 30.0
	entity.patrol_min_x = patrol_min_x
	entity.patrol_max_x = patrol_max_x
	entity.origin_x = x
	entity.origin_y = y
	entity.state_timer = 120.0 / 60.0
	entity.balloon_angle = 0.0
	entity.balloon_projectile_spawned = false

func _add_bullet_buzzer(level: LevelState, x: float, y: float) -> void:
	var entity := _add_entity(level, ENTITY_BULLET_BUZZER, x, y)
	entity.origin_x = x
	entity.origin_y = y
	entity.state_timer = 0.0
	entity.bullet_buzzer_angle = 0.0
	entity.bullet_buzzer_attack_timer = 0.0
	entity.bullet_buzzer_projectile_spawned = false

func _add_koura(level: LevelState, x: float, y: float, patrol_min_x: float, patrol_max_x: float) -> void:
	var entity := _add_entity(level, ENTITY_KOURA, x, y)
	entity.velocity_x = -30.0
	entity.koura_motion_variant = 0
	entity.patrol_min_x = patrol_min_x
	entity.patrol_max_x = patrol_max_x
	entity.origin_x = x
	entity.origin_y = y

func _add_star(level: LevelState, x: float, y: float) -> void:
	var entity := _add_entity(level, ENTITY_STAR, x, y)
	entity.width = 32.0
	entity.height = 32.0
	entity.state_timer = 2.0

func _add_kiki(level: LevelState, x: float, y: float) -> void:
	var entity := _add_entity(level, ENTITY_KIKI, x, y)
	entity.origin_x = x
	entity.origin_y = y
	entity.state_timer = 0.0
	entity.kiki_vertical_direction = 1.0
	entity.kiki_vertical_min = y - 48.0
	entity.kiki_vertical_max = y + 48.0
	entity.kiki_border_hits = 0
	entity.kiki_attack_frames = 0
	entity.kiki_projectile_spawned = false

func _add_trapped_animal(level: LevelState, x: float, y: float, animal_type: int) -> void:
	var entity := _add_entity(level, ENTITY_TRAPPED_ANIMAL, x, y)
	entity.variant = clampi(animal_type, 0, 2)
	entity.origin_x = x
	entity.origin_y = y
	entity.state_timer = 0.0
	entity.velocity_x = 16.0 if entity.variant == 2 else 0.0

func _add_boss(level: LevelState, x: float, y: float) -> EntityState:
	var entity := _add_entity(level, ENTITY_BOSS, x, y)
	entity.width = 92.0
	entity.height = 68.0
	entity.origin_x = x
	entity.origin_y = y
	entity.state_timer = 1.2
	entity.boss_profile = 8 if _selected_level_index >= 15 else (7 if _selected_level_index >= 14 else clampi(int(_selected_level_index / 2), 0, 6))
	entity.health = 8
	entity.max_health = 8
	if entity.boss_profile == 0:
		entity.target_x = 42.0
		entity.effect_offset = -PI * 0.5
		entity.state_timer = 1.2
	elif entity.boss_profile == 1:
		entity.health = 4
		entity.max_health = 4
		entity.velocity_x = 82.0
		entity.state_timer = 2.5
		entity.effect_offset = PI
	elif entity.boss_profile == 2:
		entity.velocity_x = 96.0
		entity.state_timer = 2.2
		entity.effect_offset = 0.0
	elif entity.boss_profile == 4:
		entity.velocity_x = 54.0
		entity.state_timer = 2.5
		entity.effect_offset = PI
	elif entity.boss_profile == 5:
		entity.velocity_x = 78.0
		entity.state_timer = 2.0
		entity.effect_offset = 0.0
	elif entity.boss_profile == 6:
		entity.velocity_x = 62.0
		entity.state_timer = 1.8
	elif entity.boss_profile == 7:
		entity.health = 6
		entity.max_health = 6
		entity.state_timer = 1.8
		entity.effect_offset = 0.0
	elif entity.boss_profile == 8:
		entity.health = 12
		entity.max_health = 12
		entity.state_timer = 1.5
		entity.effect_offset = 0.0
	elif entity.boss_profile == 3:
		# boss_4.c starts the Aero Egg on a long approach before its bomb loop.
		entity.velocity_x = 132.0
		entity.state_timer = 2.0
	return entity

func _add_checkpoint(level: LevelState, x: float, y: float) -> void:
	_add_entity(level, ENTITY_CHECKPOINT, x, y)

func _add_special_ring(level: LevelState, x: float, y: float) -> void:
	_add_entity(level, ENTITY_SPECIAL_RING, x, y)

func _add_whirlwind(level: LevelState, x: float, y: float, width: float, height: float) -> void:
	var entity := _add_entity(level, ENTITY_WHIRLWIND, x, y)
	entity.width = width
	entity.height = height
	entity.whirlwind_active = false
	entity.whirlwind_timer = 0.0
	entity.whirlwind_release_latch = false

func _add_fan(level: LevelState, x: float, y: float, width: float, height: float, direction: float) -> void:
	var entity := _add_entity(level, ENTITY_FAN, x, y)
	entity.width = width
	entity.height = height
	entity.velocity_x = signf(direction)
	entity.fan_speed = 1.0

func _add_spikes(level: LevelState, x: float, y: float, width: float, height: float) -> void:
	var entity := _add_entity(level, ENTITY_SPIKES, x, y)
	entity.width = width
	entity.height = height

func _add_item_box(level: LevelState, x: float, y: float, ring_amount: int, item_kind: int = ITEM_BOX_KIND_RINGS) -> void:
	var entity := _add_entity(level, ENTITY_ITEM_BOX, x, y)
	entity.width = 30.0
	entity.height = 30.0
	entity.item_kind = item_kind
	entity.variant = maxi(1, ring_amount) if item_kind == ITEM_BOX_KIND_RINGS else 1

func _add_propeller(level: LevelState, x: float, y: float) -> void:
	var entity := _add_entity(level, ENTITY_PROPELLER, x, y)
	entity.width = 148.0
	entity.height = 128.0

func _add_booster(level: LevelState, x: float, y: float, direction: float = 1.0) -> void:
	var entity := _add_entity(level, ENTITY_BOOSTER, x, y)
	entity.width = 34.0
	entity.height = 24.0
	entity.velocity_x = -1.0 if direction < 0.0 else 1.0

func _add_dash_ring(level: LevelState, x: float, y: float, orientation: int = DASH_RING_RIGHT) -> void:
	var entity := _add_entity(level, ENTITY_DASH_RING, x, y)
	entity.width = 28.0
	entity.height = 28.0
	entity.variant = clampi(orientation, DASH_RING_UP, DASH_RING_UP_LEFT)

func _add_grind_rail(level: LevelState, x: float, y: float, width: float, direction: float = 1.0, end_mode: int = 0) -> void:
	var entity := _add_entity(level, ENTITY_GRIND_RAIL, x, y)
	entity.width = maxf(48.0, width)
	entity.height = 18.0
	entity.rail_direction = -1.0 if direction < 0.0 else 1.0
	entity.rail_end_mode = 1 if end_mode != 0 else 0
	entity.rail_is_start = true
	entity.rail_air_start = false

func _add_gravity_toggle(level: LevelState, x: float, y: float, width: float, height: float, kind: int = GRAVITY_KIND_TOGGLE) -> void:
	var entity := _add_entity(level, ENTITY_GRAVITY_TOGGLE, x, y)
	entity.width = maxf(32.0, width)
	entity.height = maxf(32.0, height)
	entity.gravity_kind = clampi(kind, GRAVITY_KIND_DOWN, GRAVITY_KIND_TOGGLE)

func _add_bouncy_spring(level: LevelState, x: float, y: float, strength: float = 1.125) -> void:
	var entity := _add_entity(level, ENTITY_BOUNCY_SPRING, x, y)
	entity.width = 42.0
	entity.height = 22.0
	entity.bounce_strength = clampf(strength, 1.0, 1.5)

func _add_conveyor(level: LevelState, x: float, y: float, width: float, height: float, direction: float = 1.0) -> void:
	var entity := _add_entity(level, ENTITY_CONVEYOR, x, y)
	entity.width = maxf(32.0, width)
	entity.height = maxf(16.0, height)
	entity.surface_speed = 37.5 * (-1.0 if direction < 0.0 else 1.0)

func _add_goal(level: LevelState, x: float, y: float) -> void:
	_add_entity(level, ENTITY_GOAL, x, y)

func _add_entity(level: LevelState, entity_type: int, x: float, y: float) -> EntityState:
	var entity := EntityState.new()
	entity.type = entity_type
	entity.world_x = x
	entity.world_y = y
	entity.active = true
	match entity_type:
		ENTITY_RING:
			entity.radius = 14.0
			entity.width = 28.0
			entity.height = 28.0
			entity.anim_id = 0
		ENTITY_SCATTER_RING:
			entity.radius = 14.0
			entity.width = 28.0
			entity.height = 28.0
			entity.anim_id = 0
		ENTITY_SPECIAL_RING:
			entity.radius = 15.0
			entity.width = 30.0
			entity.height = 30.0
			entity.anim_id = 5
		ENTITY_WHIRLWIND:
			entity.anim_id = 6
		ENTITY_FAN:
			entity.anim_id = 7
		ENTITY_SPIKES:
			entity.anim_id = 8
		ENTITY_ITEM_BOX:
			entity.anim_id = 9
		ENTITY_PROPELLER:
			entity.anim_id = 10
		ENTITY_BOOSTER:
			entity.width = 34.0
			entity.height = 24.0
			entity.anim_id = 11
		ENTITY_DASH_RING:
			entity.width = 28.0
			entity.height = 28.0
			entity.anim_id = 12
		ENTITY_GRIND_RAIL:
			entity.width = 160.0
			entity.height = 18.0
			entity.anim_id = 13
		ENTITY_GRAVITY_TOGGLE:
			entity.width = 128.0
			entity.height = 128.0
			entity.anim_id = 14
		ENTITY_BOUNCY_SPRING:
			entity.width = 42.0
			entity.height = 22.0
			entity.anim_id = 15
		ENTITY_NOTE_BLOCK:
			entity.width = 32.0
			entity.height = 24.0
			entity.anim_id = 584
			entity.note_block = true
		ENTITY_NOTE_SPHERE:
			entity.width = 48.0
			entity.height = 48.0
			entity.anim_id = 585
			entity.note_sphere = true
		ENTITY_NOTE_PARTICLE:
			entity.width = 18.0
			entity.height = 18.0
			entity.anim_id = 587
			entity.note_particle = true
		ENTITY_CONVEYOR:
			entity.width = 160.0
			entity.height = 24.0
			entity.anim_id = 16
		ENTITY_LAYER_TOGGLE:
			entity.width = 32.0
			entity.height = 32.0
			entity.anim_id = 14
		ENTITY_RAMP:
			entity.width = 96.0
			entity.height = 64.0
			entity.anim_id = 543
		ENTITY_ROTATING_HANDLE:
			entity.width = 42.0
			entity.height = 42.0
			entity.anim_id = 546
		ENTITY_FLYING_HANDLE:
			entity.width = 32.0
			entity.height = 32.0
			entity.anim_id = 586
		ENTITY_CORK_SCREW:
			entity.width = 48.0
			entity.height = 48.0
			entity.anim_id = 539
		ENTITY_CANNON:
			entity.width = 48.0
			entity.height = 48.0
			entity.anim_id = 547
		ENTITY_LAUNCHER:
			entity.width = 34.0
			entity.height = 30.0
			entity.anim_id = 548
		ENTITY_PIPE_START, ENTITY_PIPE_END:
			entity.width = 24.0
			entity.height = 24.0
			entity.anim_id = 549
		ENTITY_HOOK_RAIL:
			entity.width = 64.0
			entity.height = 32.0
			entity.anim_id = 550
		ENTITY_SLIDY_ICE:
			entity.anim_id = 551
		ENTITY_LIGHT_BRIDGE:
			entity.width = 240.0
			entity.height = 32.0
			entity.anim_id = 552
		ENTITY_SLOWING_SNOW:
			entity.anim_id = 553
		ENTITY_SPIKE_PLATFORM:
			entity.width = 48.0
			entity.height = 24.0
			entity.anim_id = 554
		ENTITY_TURNAROUND_BAR:
			entity.width = 24.0
			entity.height = 48.0
			entity.anim_id = 567
		ENTITY_KEYBOARD:
			entity.width = 32.0
			entity.height = 32.0
			entity.anim_id = 568
		ENTITY_POLE:
			entity.width = 16.0
			entity.height = 64.0
			entity.anim_id = 569
		ENTITY_LIGHT_GLOBE:
			entity.width = 28.0
			entity.height = 28.0
			entity.anim_id = 570
		ENTITY_WINDUP_STICK:
			entity.width = 48.0
			entity.height = 24.0
			entity.anim_id = 571
		ENTITY_GERMAN_FLUTE:
			entity.width = 40.0
			entity.height = 32.0
			entity.anim_id = 572
		ENTITY_SMALL_WINDMILL:
			entity.width = 64.0
			entity.height = 64.0
			entity.anim_id = 573
		ENTITY_CHORD:
			entity.width = 48.0
			entity.height = 24.0
			entity.anim_id = 574
		ENTITY_HALF_PIPE:
			entity.width = 96.0
			entity.height = 104.0
			entity.anim_id = 575
		ENTITY_IRON_BALL:
			entity.width = 28.0
			entity.height = 28.0
			entity.anim_id = 576
		ENTITY_CRANE:
			entity.width = 32.0
			entity.height = 112.0
			entity.anim_id = 577
		ENTITY_CEILING_SLOPE:
			entity.width = 48.0
			entity.height = 96.0
			entity.anim_id = 578
		ENTITY_GAPPED_LOOP:
			entity.width = 64.0
			entity.height = 64.0
			entity.anim_id = 579
		ENTITY_FUNNEL_SPHERE:
			entity.width = 32.0
			entity.height = 32.0
			entity.anim_id = 580
		ENTITY_MUSIC_ENTRY:
			entity.width = 40.0
			entity.height = 40.0
			entity.anim_id = 581
		ENTITY_DAMAGE_REGION:
			entity.width = 24.0
			entity.height = 24.0
			entity.anim_id = 582
		ENTITY_DECORATION:
			entity.width = 32.0
			entity.height = 32.0
			entity.anim_id = 583
		ENTITY_LAP_TRIGGER:
			entity.width = 8.0
			entity.height = 8.0
		ENTITY_GOAL_LEVER:
			entity.width = 24.0
			entity.height = 64.0
			entity.anim_id = 4
		ENTITY_BUZZER:
			entity.width = 30.0
			entity.height = 30.0
			entity.anim_id = 17
		ENTITY_BALLOON:
			entity.width = 34.0
			entity.height = 34.0
			entity.anim_id = 18
		ENTITY_PROJECTILE:
			entity.width = 12.0
			entity.height = 12.0
			entity.anim_id = 19
		ENTITY_BULLET_BUZZER:
			entity.width = 32.0
			entity.height = 32.0
			entity.anim_id = 20
		ENTITY_KOURA:
			entity.width = 34.0
			entity.height = 26.0
			entity.anim_id = 21
		ENTITY_STAR:
			entity.width = 34.0
			entity.height = 34.0
			entity.anim_id = 22
		ENTITY_KIKI:
			entity.width = 30.0
			entity.height = 36.0
			entity.anim_id = 23
		ENTITY_KIKI_PROJECTILE:
			entity.width = 16.0
			entity.height = 16.0
			entity.anim_id = 24
		ENTITY_KIKI_PIECE:
			entity.width = 18.0
			entity.height = 18.0
			entity.anim_id = 25
		ENTITY_BOSS:
			entity.width = 92.0
			entity.height = 68.0
			entity.anim_id = 26
		ENTITY_TRAPPED_ANIMAL:
			entity.width = 30.0
			entity.height = 34.0
			entity.anim_id = 28
		ENTITY_RING_EFFECT:
			entity.width = 28.0
			entity.height = 28.0
			entity.anim_id = 29
		ENTITY_HEART_EFFECT:
			entity.width = 24.0
			entity.height = 24.0
			entity.anim_id = 30
		ENTITY_DUST_EFFECT:
			entity.width = 42.0
			entity.height = 28.0
			entity.anim_id = 31
		ENTITY_GRIND_EFFECT:
			entity.width = 26.0
			entity.height = 26.0
			entity.anim_id = 32
		ENTITY_CHEESE:
			entity.width = 28.0
			entity.height = 28.0
			entity.anim_id = 33
		ENTITY_TAIL_SWIPE:
			entity.width = 48.0
			entity.height = 42.0
			entity.anim_id = 34
		ENTITY_KNUCKLES_FIRE:
			entity.width = 34.0
			entity.height = 34.0
			entity.anim_id = 35
		ENTITY_SONIC_SKID:
			entity.width = 44.0
			entity.height = 38.0
			entity.anim_id = 36
		ENTITY_SPRING:
			entity.width = 24.0
			entity.height = 20.0
			entity.anim_id = 1
		ENTITY_ENEMY:
			entity.width = 30.0
			entity.height = 20.0
			entity.anim_id = 2
		ENTITY_CHECKPOINT:
			entity.width = 20.0
			entity.height = 72.0
			entity.anim_id = 3
		ENTITY_GOAL:
			entity.width = 24.0
			entity.height = 96.0
			entity.anim_id = 4
		_:
			entity.width = 16.0
			entity.height = 16.0
	level.entities.append(entity)
	return entity

func _update_spike_platform_state() -> void:
	var phase := fmod(_elapsed_time * 60.0, 286.0)
	for entity in _level_state.entities:
		if entity.active and entity.spike_platform:
			entity.spike_platform_phase = phase
			entity.activated = phase >= 185.0 and phase <= 244.0

func _update_turnaround_bar_state(delta: float) -> void:
	for entity in _level_state.entities:
		if not entity.active or not entity.turnaround_bar or entity.turnaround_timer <= 0.0:
			continue
		entity.turnaround_timer = maxf(0.0, entity.turnaround_timer - delta)
		_player_state.world_x = entity.world_x
		_player_state.world_y = entity.world_y
		_player_state.is_grounded = true
		_player_state.speed_x = 0.0
		_player_state.ground_speed = 0.0
		_velocity_y = 0.0
		_player_state.rotation = 0
		_player_state.char_state = 8
		if entity.turnaround_timer <= 0.0:
			_player_state.world_x = entity.world_x - entity.turnaround_direction * 6.0
			var speed_cap := 900.0 if is_player_boosting() else 540.0
			var outgoing_speed := minf(absf(entity.turnaround_entry_speed) + 75.0, speed_cap)
			_player_state.speed_x = -entity.turnaround_direction * outgoing_speed
			_player_state.ground_speed = _player_state.speed_x
			_player_state.char_state = 0
			entity.activated = false

func _update_keyboard_state(delta: float) -> void:
	for entity in _level_state.entities:
		if not entity.active or not entity.keyboard:
			continue
		entity.keyboard_timer = maxf(0.0, entity.keyboard_timer - delta)
		if entity.keyboard_timer <= 0.0:
			entity.activated = false

func _update_pole_state() -> void:
	for entity in _level_state.entities:
		if not entity.active or not entity.pole or not entity.pole_sliding:
			continue
		_player_state.world_x = entity.world_x
		_player_state.world_y = entity.world_y
		_player_state.is_grounded = false
		_player_state.speed_x = 0.0
		_player_state.ground_speed = 0.0
		_velocity_y = 0.0
		_player_state.char_state = 4
		if _frame_input & A_BUTTON:
			entity.pole_sliding = false
			_player_state.speed_x = -300.0 if _frame_input & DPAD_LEFT else 300.0
			_velocity_y = -330.0
			_player_state.speed_y = _velocity_y
	_player_state.char_state = 8

func _update_light_globe_state(delta: float) -> void:
	for entity in _level_state.entities:
		if entity.active and entity.light_globe:
			entity.light_globe_phase = fmod(entity.light_globe_phase + delta * 3.0, TAU)

func _update_windup_stick_state(delta: float) -> void:
	for entity in _level_state.entities:
		if not entity.active or not entity.windup_stick:
			continue
		entity.windup_stick_timer = maxf(0.0, entity.windup_stick_timer - delta)
		if entity.windup_stick_timer <= 0.0:
			entity.activated = false

func _update_german_flute_state(delta: float, held_input: int) -> void:
	for entity in _level_state.entities:
		if not entity.active or not entity.german_flute or entity.german_flute_timer <= 0.0:
			continue
		entity.german_flute_timer += delta
		_player_state.is_grounded = false
		_player_state.ground_speed = 0.0
		_player_state.rotation = 0
		if entity.german_flute_phase == 0:
			_player_state.world_x = move_toward(_player_state.world_x, entity.world_x, 30.0 * delta)
			_player_state.world_y = move_toward(_player_state.world_y, entity.world_y + 24.0, 30.0 * delta)
			_player_state.speed_x = 0.0
			_velocity_y = 0.0
			_player_state.char_state = 8
			if entity.german_flute_timer >= 31.0 / 60.0:
				entity.german_flute_phase = 1
				entity.german_flute_timer = 0.0001
				_velocity_y = -(420.0 + entity.german_flute_kind * 60.0)
				_player_state.speed_y = _velocity_y
		elif entity.german_flute_phase == 1:
			_player_state.world_y += _velocity_y * delta
			# qSpeedAirY gains Q(1/6) per frame, equivalent to 600 px/s^2.
			_velocity_y += 600.0 * delta
			_player_state.char_state = 9
			_player_state.speed_y = _velocity_y
			if _velocity_y >= 0.0:
				entity.german_flute_phase = 2
				entity.german_flute_timer = 0.0001
		else:
			if held_input & DPAD_RIGHT:
				_player_state.world_x += 30.0 * delta
			if held_input & DPAD_LEFT:
				_player_state.world_x -= 30.0 * delta
			var wave_phase: float = entity.german_flute_timer * 60.0 * 4.0 / 256.0 * TAU
			_player_state.world_y = entity.world_y + 24.0 + sin(wave_phase) * 8.0
			_player_state.char_state = 9
			_velocity_y = 0.0
			_player_state.speed_y = 0.0
			if absf(_player_state.world_x - entity.world_x) > 16.0 or entity.german_flute_timer > 180.0 / 60.0:
				entity.german_flute_timer = 0.0
				entity.german_flute_phase = 0
				entity.activated = false
				_player_state.char_state = 1

func _update_small_windmill_state(delta: float) -> void:
	for entity in _level_state.entities:
		if not entity.active or not entity.small_windmill or entity.small_windmill_timer <= 0.0:
			continue
		entity.small_windmill_timer += delta
		if entity.small_windmill_timer < 0.7:
			var rotation_sign := 1.0 if entity.small_windmill_touch_angle in [1, 3, 5, 7] else -1.0
			entity.small_windmill_angle += rotation_sign * delta * 60.0 * 8.0 / 256.0 * TAU
			_player_state.world_x = entity.world_x + cos(entity.small_windmill_angle) * 24.0
			_player_state.world_y = entity.world_y + sin(entity.small_windmill_angle) * 24.0
			_player_state.is_grounded = false
			_player_state.speed_x = 0.0
			_player_state.ground_speed = 0.0
			_velocity_y = 0.0
			_player_state.rotation = 0
			_player_state.char_state = 8
		else:
			var release_direction := Vector2.ZERO
			match entity.small_windmill_touch_angle:
				1, 4:
					release_direction = Vector2(0.0, -1.0)
				2, 5:
					release_direction = Vector2(-1.0, 0.0)
				3, 8:
					release_direction = Vector2(1.0, 0.0)
				6, 7:
					release_direction = Vector2(0.0, 1.0)
			entity.small_windmill_timer = 0.0
			entity.activated = false
			_player_state.is_grounded = false
			_player_state.speed_x = release_direction.x * 480.0
			_velocity_y = release_direction.y * 480.0
			_player_state.speed_y = _velocity_y
			_player_state.char_state = 5

func _update_chord_state(delta: float) -> void:
	for entity in _level_state.entities:
		if not entity.active or not entity.chord or entity.chord_phase == 0:
			continue
		entity.chord_timer += delta
		if entity.chord_phase == 1:
			var progress := clampf(entity.chord_timer / 0.35, 0.0, 1.0)
			_player_state.world_x = move_toward(_player_state.world_x, entity.world_x + 48.0, 30.0 * delta)
			_player_state.world_y = entity.world_y - 16.0 - sin(progress * PI) * 20.0
			_player_state.is_grounded = false
			_player_state.speed_x = 0.0
			_velocity_y = 0.0
			_player_state.char_state = 6
			if progress >= 1.0:
				entity.chord_phase = 2
				entity.chord_timer = 0.0
				_velocity_y = -entity.chord_bounce_speed
				_player_state.speed_y = _velocity_y
				_player_state.char_state = 5
		elif entity.chord_timer >= 0.35:
			entity.chord_phase = 0
			entity.chord_timer = 0.0
			entity.activated = false

func _update_note_state(delta: float) -> void:
	for entity in _level_state.entities:
		if not entity.active or (not entity.note_block and not entity.note_sphere):
			continue
		if entity.note_timer <= 0.0:
			entity.note_offset_x = 0.0
			entity.note_offset_y = 0.0
			continue
		entity.note_timer = maxf(0.0, entity.note_timer - delta)
		var phase: float = 1.0 - entity.note_timer / (4.0 / 60.0 if entity.note_block else 6.0 / 60.0)
		var amplitude := 4.0 if entity.note_block else 8.0
		entity.note_offset_x = cos(entity.note_angle) * amplitude * (1.0 - phase)
		entity.note_offset_y = sin(entity.note_angle) * amplitude * (1.0 - phase)
		if entity.note_timer <= 0.0:
			entity.note_offset_x = 0.0
			entity.note_offset_y = 0.0
			entity.activated = false
			if entity.note_block and entity.note_health <= 0:
				entity.active = false

func _try_note_block(entity: EntityState) -> void:
	if entity.note_timer > 0.0 or entity.note_health <= 0:
		return
	var dx := absf(_player_state.world_x - entity.world_x)
	var dy := absf((_player_state.world_y + 16.0) - entity.world_y)
	if dx > 24.0 or dy > 24.0:
		return
	var bounce_speeds := [270.0, 292.5, 315.0, 337.5, 360.0, 382.5, 405.0, 0.0]
	entity.note_health -= 1
	entity.note_timer = 4.0 / 60.0
	entity.note_angle = -PI * 0.5
	entity.activated = true
	_spawn_note_particle(entity.world_x, entity.world_y, bounce_speeds[entity.note_kind] * 0.125, -bounce_speeds[entity.note_kind] * 0.75, 0)
	_spawn_note_particle(entity.world_x, entity.world_y, -bounce_speeds[entity.note_kind] * 0.125, -bounce_speeds[entity.note_kind] * 0.75, 1)
	_velocity_y = -bounce_speeds[entity.note_kind]
	_player_state.speed_y = _velocity_y
	_player_state.is_grounded = false
	_player_state.char_state = 5
	_player_state.anim_id = 2

func _try_note_sphere(entity: EntityState) -> void:
	if entity.note_timer > 0.0:
		return
	var offset := Vector2(_player_state.world_x - entity.world_x, _player_state.world_y - entity.world_y)
	if offset.length_squared() > 24.0 * 24.0:
		return
	var away := offset.normalized() if offset.length_squared() > 0.01 else Vector2.UP
	var incoming := Vector2(-_player_state.speed_x, -_velocity_y)
	var direction := (away + (incoming.normalized() if incoming.length_squared() > 0.01 else away)).normalized()
	var note_speeds := [270.0, 300.0, 330.0, 360.0, 390.0, 420.0, 450.0, 480.0]
	var launch: Vector2 = direction * float(note_speeds[entity.note_kind])
	entity.note_timer = 6.0 / 60.0
	entity.note_angle = atan2(direction.y, direction.x)
	entity.activated = true
	var particle_speed := float(note_speeds[entity.note_kind])
	_spawn_note_particle(entity.world_x, entity.world_y, particle_speed * 0.125, -particle_speed * 0.75, 0)
	_spawn_note_particle(entity.world_x, entity.world_y, -particle_speed * 0.125, -particle_speed * 0.75, 1)
	_player_state.speed_x = launch.x
	_velocity_y = launch.y
	_player_state.speed_y = _velocity_y
	_player_state.is_grounded = false
	_player_state.char_state = 5
	_player_state.anim_id = 2

func _spawn_note_particle(x: float, y: float, velocity_x: float, velocity_y: float, kind: int) -> void:
	var particle := _add_entity(_level_state, ENTITY_NOTE_PARTICLE, x, y)
	particle.origin_x = x
	particle.origin_y = y
	particle.velocity_x = velocity_x
	particle.velocity_y = velocity_y
	particle.variant = clampi(kind, 0, 1)
	particle.state_timer = 0.5
	particle.note_particle_delay = 5.0 / 60.0

func _update_note_particle_state(delta: float) -> void:
	for entity in _level_state.entities:
		if not entity.active or not entity.note_particle:
			continue
		entity.note_particle_delay = maxf(0.0, entity.note_particle_delay - delta)
		if entity.note_particle_delay > 0.0:
			continue
		entity.state_timer -= delta
		entity.world_x += entity.velocity_x * delta
		entity.world_y += entity.velocity_y * delta
		entity.velocity_y += 48.0 * delta
		if entity.state_timer <= 0.0:
			entity.active = false

func _update_half_pipe_state(frame_input: int) -> void:
	for entity in _level_state.entities:
		if not entity.active or not entity.half_pipe or not entity.half_pipe_active:
			continue
		# half_pipe.c keeps the player on the curve only while the signed
		# horizontal speed is still above its entry threshold.
		var moving_forward: bool = entity.half_pipe_direction > 0.0 and _player_state.speed_x >= 135.0
		var moving_reverse: bool = entity.half_pipe_direction < 0.0 and _player_state.speed_x <= -135.0
		if not moving_forward and not moving_reverse:
			entity.half_pipe_active = false
			entity.activated = false
			_player_state.is_grounded = false
			_player_state.char_state = 0
			continue
		if frame_input & A_BUTTON:
			entity.half_pipe_active = false
			entity.activated = false
			_player_state.is_grounded = false
			_velocity_y = -_jump_speed
			_player_state.speed_y = _velocity_y
			_player_state.char_state = 5
			continue
		var distance: float = (_player_state.world_x - (entity.world_x - entity.width * 0.5)) if entity.half_pipe_direction > 0.0 else ((entity.world_x + entity.width * 0.5) - _player_state.world_x)
		var normalized := clampf(distance / maxf(1.0, entity.width), 0.0, 1.0)
		var speed_scale := clampf(absf(_player_state.speed_x) / 600.0, 0.0, 1.0)
		var curve_height := maxf(0.0, (entity.height - 16.0) * 0.5) * speed_scale
		_player_state.world_y = entity.half_pipe_base_y - sin(normalized * PI) * curve_height
		_player_state.is_grounded = true
		_player_state.speed_y = 0.0
		_velocity_y = 0.0
		_player_state.char_state = 0

func _update_iron_ball_state(delta: float) -> void:
	for entity in _level_state.entities:
		if not entity.active or not entity.iron_ball:
			continue
		# iron_ball.c advances SIN by four GBA angle units per frame.
		entity.iron_ball_phase = fmod(entity.iron_ball_phase + delta * 60.0 * 4.0 / 256.0 * TAU, TAU)
		var offset: float = sin(entity.iron_ball_phase) * entity.iron_ball_amplitude
		if entity.iron_ball_horizontal:
			entity.world_x = entity.origin_x + offset
		else:
			entity.world_y = entity.origin_y + offset

func _update_crane_state(delta: float) -> void:
	for entity in _level_state.entities:
		if not entity.active or not entity.crane:
			continue
		entity.crane_phase = fmod(entity.crane_phase + delta * 2.2, TAU)
		entity.crane_hook_x = entity.origin_x + sin(entity.crane_phase) * 42.0
		entity.crane_hook_y = entity.origin_y + 88.0 + cos(entity.crane_phase) * 18.0
		if entity.crane_timer <= 0.0:
			continue
		entity.crane_timer = maxf(0.0, entity.crane_timer - delta)
		if entity.crane_timer > 0.25:
			_player_state.world_x = entity.crane_hook_x
			_player_state.world_y = entity.crane_hook_y
			_player_state.is_grounded = false
			_player_state.speed_x = 0.0
			_velocity_y = 0.0
			_player_state.char_state = 8
		else:
			entity.activated = false
			_player_state.is_grounded = false
			_player_state.speed_x = signf(entity.crane_hook_x - entity.origin_x) * 360.0
			_velocity_y = -entity.crane_launch_speed
			_player_state.speed_y = _velocity_y
			_player_state.char_state = 5

func _update_ceiling_slope_state(delta: float) -> void:
	for entity in _level_state.entities:
		if not entity.active or not entity.ceiling_slope:
			continue
		entity.ceiling_slope_timer = maxf(0.0, entity.ceiling_slope_timer - delta)
		var dx := absf(_player_state.world_x - entity.world_x)
		var dy := absf((_player_state.world_y - 20.0) - entity.world_y)
		if dx > entity.width * 0.5 or dy > entity.height * 0.5:
			entity.ceiling_slope_latched = false
			entity.activated = false

func _update_gapped_loop_state(delta: float) -> void:
	for entity in _level_state.entities:
		if not entity.active or not entity.gapped_loop or not entity.gapped_loop_active:
			continue
		# gapped_loop.c advances the forward path by -8 and the reverse path by
		# +8 GBA angle units per frame.
		entity.gapped_loop_angle -= entity.gapped_loop_direction * delta * 60.0 * 8.0 / 256.0 * TAU
		_player_state.world_x = entity.gapped_loop_center_x + cos(entity.gapped_loop_angle) * 135.0
		_player_state.world_y = entity.gapped_loop_center_y + sin(entity.gapped_loop_angle) * 135.0
		_player_state.is_grounded = false
		_player_state.rotation = int(rad_to_deg(entity.gapped_loop_angle))
		_player_state.char_state = 5
		if absf(entity.gapped_loop_angle) >= PI * 0.85:
			entity.gapped_loop_active = false
			entity.activated = false
			_player_state.speed_x = entity.gapped_loop_direction * 360.0
			_velocity_y = 0.0
			_player_state.speed_y = _velocity_y

func _update_funnel_sphere_state(delta: float) -> void:
	for entity in _level_state.entities:
		if not entity.active or not entity.funnel_sphere or entity.funnel_sphere_timer <= 0.0:
			continue
		entity.funnel_sphere_timer += delta
		if entity.funnel_sphere_timer < 0.25:
			_player_state.world_x += 300.0 * delta
			_player_state.world_y = entity.world_y
		else:
			var progress: float = clampf((entity.funnel_sphere_timer - 0.25) / 1.0, 0.0, 1.0)
			var angle: float = progress * PI
			_player_state.world_x = entity.world_x + cos(angle) * 32.0
			_player_state.world_y = entity.world_y - sin(angle) * 48.0
			_player_state.rotation = int(rad_to_deg(angle))
		if entity.funnel_sphere_timer >= 1.25:
			entity.funnel_sphere_timer = 0.0
			entity.activated = false
			_player_state.is_grounded = false
			_player_state.speed_x = 0.0
			# funnel_sphere.c uses +Q(6) for the slow-entry mode and -Q(10)
			# for the fast-entry mode.
			_velocity_y = 360.0 if entity.funnel_sphere_direction > 0.0 else -600.0
			_player_state.speed_y = _velocity_y
			_player_state.char_state = 5
		else:
			_player_state.is_grounded = false
			_player_state.speed_x = 0.0
			_velocity_y = 0.0
			_player_state.char_state = 8

func _update_music_entry_state(delta: float) -> void:
	for entity in _level_state.entities:
		if not entity.active or not entity.music_entry or entity.music_entry_timer <= 0.0:
			continue
		entity.music_entry_timer += delta
		var progress: float = clampf(entity.music_entry_timer / entity.music_entry_duration, 0.0, 1.0)
		var direction := 1.0 if entity.music_entry_kind % 2 == 0 else -1.0
		_player_state.world_x = entity.world_x + direction * progress * 128.0
		_player_state.world_y = entity.world_y - sin(progress * PI) * (42.0 + entity.music_entry_kind * 4.0)
		_player_state.is_grounded = false
		_player_state.speed_x = 0.0
		_velocity_y = 0.0
		_player_state.rotation = int(sin(progress * PI) * 24.0)
		_player_state.char_state = 8
		if entity.music_entry_timer >= entity.music_entry_duration:
			entity.music_entry_timer = 0.0
			entity.activated = false
			var exit_velocity: Vector2 = _music_entry_exit_velocity(entity.music_entry_pipe, entity.music_entry_kind)
			_player_state.speed_x = exit_velocity.x
			_velocity_y = exit_velocity.y
			_player_state.speed_y = _velocity_y
			_player_state.char_state = 5

func _music_entry_duration(is_pipe: bool, kind: int) -> float:
	var frames: Array = [69, 69, 77, 77, 63, 74, 74, 80, 80] if is_pipe else [77, 86, 74]
	var index := clampi(kind, 0, frames.size() - 1)
	return float(frames[index]) / 60.0

func _music_entry_exit_velocity(is_pipe: bool, kind: int) -> Vector2:
	if is_pipe:
		var pipe_exits: Array = [Vector2(0.0, -540.0), Vector2(0.0, -720.0), Vector2(0.0, -540.0), Vector2(0.0, -720.0), Vector2(540.0, -540.0), Vector2(0.0, -540.0), Vector2(0.0, -720.0), Vector2(0.0, -540.0), Vector2(0.0, -720.0)]
		return pipe_exits[clampi(kind, 0, pipe_exits.size() - 1)]
	var horn_exits: Array = [Vector2(540.0, 0.0), Vector2(720.0, 0.0), Vector2(540.0, -540.0)]
	return horn_exits[clampi(kind, 0, horn_exits.size() - 1)]

func _update_slowing_snow_state() -> void:
	_on_slowing_snow = false
	if not _player_state.is_grounded:
		return
	for entity in _level_state.entities:
		if not entity.active or entity.type != ENTITY_SLOWING_SNOW:
			continue
		if absf(_player_state.world_x - entity.world_x) <= entity.width * 0.5 and absf(_player_state.world_y - entity.world_y) <= entity.height * 0.5:
			_on_slowing_snow = true
			return

func _update_light_bridge_state(delta: float) -> void:
	for entity in _level_state.entities:
		if not entity.active or not entity.light_bridge:
			continue
		entity.light_bridge_phase = fmod(entity.light_bridge_phase + delta * TAU / 4.0, TAU)
		entity.light_bridge_active = entity.light_bridge_phase < TAU * 0.75
		var dx: float = _player_state.world_x - entity.world_x
		var dy: float = _player_state.world_y - entity.world_y
		var in_range := false
		if entity.light_bridge_type == 0:
			in_range = absf(dx) <= 120.0 and dy >= -32.0 and dy <= -4.0
		else:
			in_range = dx >= 0.0 and dx <= 96.0 and dy >= -96.0 and dy <= 0.0
		if in_range:
			_player_layer = 0 if entity.light_bridge_active else 1

func _update_slidy_ice_state() -> void:
	_on_slidy_ice = false
	for entity in _level_state.entities:
		if not entity.active or entity.type != ENTITY_SLIDY_ICE:
			continue
		if absf(_player_state.world_x - entity.world_x) <= entity.width * 0.5 and absf(_player_state.world_y - entity.world_y) <= entity.height * 0.5:
			_on_slidy_ice = true
			return

func _update_flying_spring_motion(delta: float) -> void:
	for entity in _level_state.entities:
		if not entity.active or (not entity.flying_spring and not entity.floating_spring):
			continue
		if entity.floating_spring:
			entity.floating_spring_phase = fmod(entity.floating_spring_phase + 4.0 * TAU / 256.0 * 60.0 * delta, TAU)
			entity.world_x = entity.origin_x + sin(entity.floating_spring_phase) * entity.floating_spring_amplitude_x
			entity.world_y = entity.origin_y + sin(entity.floating_spring_phase) * entity.floating_spring_amplitude_y
			continue
		# flying_spring.c advances its shared animation in byte-sized frames.
		match entity.flying_spring_motion_state:
			0:
				entity.flying_spring_step = (entity.flying_spring_step + 2) & 0xFF
				entity.world_y = entity.origin_y + sin(float(entity.flying_spring_step * 4) / 256.0 * TAU) * 2.0
			1:
				entity.world_y = entity.origin_y + sin(float(entity.flying_spring_step * 4) / 256.0 * TAU) * 16.0
				var remaining_steps: int = (64 - entity.flying_spring_step) >> 2
				var step_delta: int = 4 if remaining_steps <= 3 else mini(6, remaining_steps)
				entity.flying_spring_step += step_delta
				if entity.flying_spring_step >= 64:
					entity.flying_spring_step = 0
					entity.flying_spring_motion_state = 2
			2:
				entity.flying_spring_step += 1
				if entity.flying_spring_step > 0:
					entity.flying_spring_step = 64
					entity.flying_spring_motion_state = 3
			3:
				entity.world_y = entity.origin_y + sin(float(entity.flying_spring_step * 4) / 256.0 * TAU) * 16.0
				entity.flying_spring_step += 8
				if entity.flying_spring_step > 127:
					entity.flying_spring_step = 128
					entity.flying_spring_motion_state = 4
			4:
				entity.flying_spring_step = (entity.flying_spring_step + 8) & 0xFF
				if entity.flying_spring_step == 128:
					entity.flying_spring_step = 0
					entity.flying_spring_motion_state = 0
				else:
					var recovery_amplitude := 6.0 if entity.flying_spring_step > 128 else 3.0
					entity.world_y = entity.origin_y + sin(float(entity.flying_spring_step * 4) / 256.0 * TAU) * recovery_amplitude

func _update_enemy_motion(delta: float) -> void:
	for entity in _level_state.entities:
		if (entity.type != ENTITY_ENEMY and entity.type != ENTITY_BUZZER and entity.type != ENTITY_BALLOON and entity.type != ENTITY_PROJECTILE and entity.type != ENTITY_BULLET_BUZZER and entity.type != ENTITY_KOURA and entity.type != ENTITY_STAR and entity.type != ENTITY_KIKI and entity.type != ENTITY_KIKI_PROJECTILE and entity.type != ENTITY_KIKI_PIECE and entity.type != ENTITY_BOSS and entity.type != ENTITY_ITEM_BOX and entity.type != ENTITY_SPECIAL_RING and entity.type != ENTITY_SCATTER_RING and entity.type != ENTITY_TRAPPED_ANIMAL and entity.type != ENTITY_RING_EFFECT and entity.type != ENTITY_HEART_EFFECT and entity.type != ENTITY_DUST_EFFECT and entity.type != ENTITY_GRIND_EFFECT and entity.type != ENTITY_CHEESE and entity.type != ENTITY_TAIL_SWIPE and entity.type != ENTITY_KNUCKLES_FIRE and entity.type != ENTITY_SONIC_SKID and entity.type != ENTITY_FAN) or not entity.active:
			continue
		if entity.type == ENTITY_TRAPPED_ANIMAL:
			_update_trapped_animal_motion(entity, delta)
			continue
		if entity.type == ENTITY_RING_EFFECT:
			_update_ring_effect_motion(entity, delta)
			continue
		if entity.type == ENTITY_HEART_EFFECT:
			_update_heart_effect_motion(entity, delta)
			continue
		if entity.type == ENTITY_DUST_EFFECT:
			_update_dust_effect_motion(entity, delta)
			continue
		if entity.type == ENTITY_GRIND_EFFECT:
			_update_grind_effect_motion(entity, delta)
			continue
		if entity.type == ENTITY_CHEESE:
			_update_cheese_motion(entity, delta)
			continue
		if entity.type == ENTITY_TAIL_SWIPE or entity.type == ENTITY_KNUCKLES_FIRE or entity.type == ENTITY_SONIC_SKID:
			_update_character_attack_effect(entity, delta)
			continue
		if entity.type == ENTITY_ITEM_BOX:
			_update_item_box_effect(entity, delta)
			continue
		if entity.type == ENTITY_SPECIAL_RING:
			_update_special_ring_motion(entity, delta)
			continue
		if entity.type == ENTITY_FAN and entity.variant == 1:
			entity.state_timer = fmod(entity.state_timer + delta * 60.0, 420.0)
			var periodic_frame: float = entity.state_timer
			if periodic_frame < 60.0:
				entity.fan_speed = 0.0
			elif periodic_frame < 120.0:
				entity.fan_speed = (periodic_frame - 60.0) / 60.0
			elif periodic_frame < 360.0:
				entity.fan_speed = 1.0
			else:
				entity.fan_speed = (420.0 - periodic_frame) / 60.0
			continue
		if entity.type == ENTITY_SCATTER_RING:
			_update_scattered_ring(entity, delta)
			continue
		if entity.type == ENTITY_BUZZER:
			_update_buzzer_motion(entity, delta)
			continue
		if entity.type == ENTITY_BALLOON:
			_update_balloon_motion(entity, delta)
			continue
		if entity.type == ENTITY_PROJECTILE:
			if entity.enemy_profile == 4 or entity.enemy_profile == 5 or entity.enemy_profile == 8:
				entity.velocity_y += 280.0 * delta
			if entity.enemy_profile == 11 or entity.enemy_profile == 14 or entity.enemy_profile == 17:
				entity.state_timer -= delta
				if entity.state_timer <= 0.0:
					entity.active = false
					continue
			entity.world_x += entity.velocity_x * delta
			entity.world_y += entity.velocity_y * delta
			if entity.world_y < _level_state.min_y - 80.0 or entity.world_y > _level_state.max_y + 80.0 or entity.world_x < _level_state.min_x - 80.0 or entity.world_x > _level_state.max_x + 80.0:
				entity.active = false
			continue
		if entity.type == ENTITY_BULLET_BUZZER:
			_update_bullet_buzzer_motion(entity, delta)
			continue
		if entity.type == ENTITY_KOURA:
			_update_koura_motion(entity, delta)
			continue
		if entity.type == ENTITY_STAR:
			_update_star_motion(entity, delta)
			continue
		if entity.type == ENTITY_KIKI:
			_update_kiki_motion(entity, delta)
			continue
		if entity.enemy_profile == 1:
			_update_pen_motion(entity, delta)
			continue
		if entity.enemy_profile == 2:
			_update_bell_motion(entity, delta)
			continue
		if entity.enemy_profile == 3:
			_update_mouse_motion(entity, delta)
			continue
		if entity.enemy_profile == 4:
			_update_circus_motion(entity, delta)
			continue
		if entity.enemy_profile == 5:
			_update_yado_motion(entity, delta)
			continue
		if entity.enemy_profile == 6:
			_update_gohla_motion(entity, delta)
			continue
		if entity.enemy_profile == 7:
			_update_hammerhead_motion(entity, delta)
			continue
		if entity.enemy_profile == 8:
			_update_kura_kura_motion(entity, delta)
			continue
		if entity.enemy_profile == 10:
			_update_gejigeji_motion(entity, delta)
			continue
		if entity.enemy_profile == 11:
			_update_kubinaga_motion(entity, delta)
			continue
		if entity.enemy_profile == 12:
			_update_madillo_motion(entity, delta)
			continue
		if entity.enemy_profile == 13:
			entity.state_timer = fmod(entity.state_timer + delta * 4.0, TAU)
			continue
		if entity.enemy_profile == 14:
			_update_kyura_motion(entity, delta)
			continue
		if entity.enemy_profile == 15:
			_update_flickey_motion(entity, delta)
			continue
		if entity.enemy_profile == 16:
			_update_mon_motion(entity, delta)
			continue
		if entity.enemy_profile == 18:
			_update_pikopiko_motion(entity, delta)
			continue
		if entity.enemy_profile == 9:
			_update_straw_motion(entity, delta)
			continue
		if entity.type == ENTITY_KIKI_PROJECTILE:
			_update_kiki_projectile(entity, delta)
			continue
		if entity.type == ENTITY_KIKI_PIECE:
			_update_kiki_piece(entity, delta)
			continue
		if entity.type == ENTITY_BOSS:
			if entity.boss_profile == 0:
				_update_hammer_tank_motion(entity, delta)
			elif entity.boss_profile == 1:
				_update_bomber_tank_motion(entity, delta)
			elif entity.boss_profile == 2:
				_update_totem_boss_motion(entity, delta)
			elif entity.boss_profile == 4:
				_update_saucer_boss_motion(entity, delta)
			elif entity.boss_profile == 5:
				_update_go_round_boss_motion(entity, delta)
			elif entity.boss_profile == 6:
				_update_frog_boss_motion(entity, delta)
			elif entity.boss_profile == 7:
				_update_super_robo_z_motion(entity, delta)
			elif entity.boss_profile == 8:
				_update_true_area_53_boss_motion(entity, delta)
			elif entity.boss_profile == 3:
				_update_aero_egg_motion(entity, delta)
			else:
				_update_boss_motion(entity, delta)
			continue
		entity.world_x += entity.velocity_x * delta
		if entity.world_x <= entity.patrol_min_x:
			entity.world_x = entity.patrol_min_x
			entity.velocity_x = abs(entity.velocity_x)
		if entity.world_x >= entity.patrol_max_x:
			entity.world_x = entity.patrol_max_x
			entity.velocity_x = -abs(entity.velocity_x)

func _update_pen_motion(entity: EntityState, delta: float) -> void:
	if entity.pen_turn_timer > 0.0:
		entity.pen_turn_timer = maxf(0.0, entity.pen_turn_timer - delta)
		if entity.pen_turn_timer <= 0.000001:
			entity.pen_turn_timer = 0.0
			entity.pen_direction = -entity.pen_direction
			entity.velocity_x = entity.pen_direction * 30.0
			entity.pen_boosting = false
		return
	var player_delta := _player_state.world_x - entity.world_x
	entity.pen_boosting = absf(player_delta) < 100.0 and signf(player_delta) == signf(entity.pen_direction) and not is_zero_approx(player_delta)
	var speed := 120.0 if entity.pen_boosting else 30.0
	entity.velocity_x = entity.pen_direction * speed
	entity.world_x += entity.velocity_x * delta
	if entity.world_x <= entity.patrol_min_x:
		entity.world_x = entity.patrol_min_x
		entity.pen_turn_timer = 18.0 / 60.0
		entity.pen_direction = -1.0
	elif entity.world_x >= entity.patrol_max_x:
		entity.world_x = entity.patrol_max_x
		entity.pen_turn_timer = 18.0 / 60.0
		entity.pen_direction = 1.0

func _update_gohla_motion(entity: EntityState, delta: float) -> void:
	# gohla.c moves its body by 0.5 px per frame and reverses at the map range.
	entity.state_timer = fmod(entity.state_timer + delta * 2.5, TAU)
	if entity.gohla_turn_timer > 0.0:
		entity.gohla_turn_timer = maxf(0.0, entity.gohla_turn_timer - delta)
		return
	entity.world_x += entity.velocity_x * delta
	if entity.world_x <= entity.patrol_min_x:
		entity.world_x = entity.patrol_min_x
		entity.velocity_x = absf(entity.velocity_x)
		entity.gohla_turn_timer = 0.25
	elif entity.world_x >= entity.patrol_max_x:
		entity.world_x = entity.patrol_max_x
		entity.velocity_x = -absf(entity.velocity_x)
		entity.gohla_turn_timer = 0.25

func _update_kura_kura_motion(entity: EntityState, delta: float) -> void:
	# kura_kura.c advances its orbit by four GBA angle units per frame.
	entity.state_timer = fmod(entity.state_timer + delta * 4.0 * TAU / 256.0 * 60.0, TAU)

func _kura_kura_fireball_position(entity: EntityState) -> Vector2:
	return Vector2(
		entity.world_x + sin(entity.state_timer) * 21.0,
		entity.world_y + cos(entity.state_timer) * 21.0
	)

func _update_bell_motion(entity: EntityState, delta: float) -> void:
	if entity.bell_phase == 0:
		entity.bell_phase_timer -= delta
		if entity.bell_phase_timer <= 0.000001:
			entity.bell_phase = 1
			entity.variant = 1
			entity.bell_phase_timer = 124.0 / 60.0 if int(entity.world_x) & 1 else 180.0 / 60.0
	else:
		entity.bell_phase_timer -= delta
		if entity.bell_phase_timer <= 0.000001:
			entity.bell_phase = 0
			entity.variant = 0
			entity.bell_phase_timer = 120.0 / 60.0

func _update_mouse_motion(entity: EntityState, delta: float) -> void:
	if entity.mouse_turn_timer > 0.0:
		entity.mouse_turn_timer = maxf(0.0, entity.mouse_turn_timer - delta)
		if entity.mouse_turn_timer <= 0.000001:
			entity.mouse_turn_timer = 0.0
			entity.mouse_direction = -entity.mouse_direction
			entity.velocity_x = entity.mouse_direction * 30.0
			entity.mouse_boosting = false
		return
	var player_delta := _player_state.world_x - entity.world_x
	entity.mouse_boosting = absf(player_delta) < 100.0 and signf(player_delta) == entity.mouse_direction and not is_zero_approx(player_delta)
	var speed := 120.0 if entity.mouse_boosting else 30.0
	entity.velocity_x = entity.mouse_direction * speed
	entity.world_x += entity.velocity_x * delta
	entity.world_y = entity.origin_y + entity.mouse_position_offset
	if entity.world_x <= entity.patrol_min_x:
		entity.world_x = entity.patrol_min_x
		entity.mouse_turn_timer = 18.0 / 60.0
		entity.mouse_direction = -1.0
	elif entity.world_x >= entity.patrol_max_x:
		entity.world_x = entity.patrol_max_x
		entity.mouse_turn_timer = 18.0 / 60.0
		entity.mouse_direction = 1.0

func _update_circus_motion(entity: EntityState, delta: float) -> void:
	entity.circus_phase_timer -= delta
	if entity.circus_phase == 0:
		if entity.circus_phase_timer > 0.000001:
			return
		entity.circus_phase = 1
		entity.circus_phase_timer = 30.0 / 60.0
		entity.circus_projectile_spawned = false
		entity.variant = 1
		return
	if entity.circus_phase == 1:
		if entity.circus_phase_timer > 0.000001:
			return
		entity.circus_phase = 2
		entity.circus_phase_timer = 50.0 / 60.0
		entity.variant = 2
		if not entity.circus_projectile_spawned:
			entity.circus_projectile_spawned = true
			var projectile := _add_entity(_level_state, ENTITY_PROJECTILE, entity.world_x, entity.world_y - 0.125)
			projectile.enemy_profile = 4
			projectile.velocity_x = 0.0
			projectile.velocity_y = -300.0
		return
	if entity.circus_phase == 2:
		if entity.circus_phase_timer > 0.000001:
			return
		entity.circus_phase = 3
		entity.circus_phase_timer = 30.0 / 60.0
		entity.variant = 3
		return
	if entity.circus_phase_timer <= 0.000001:
		entity.circus_phase = 0
		entity.circus_phase_timer = 30.0 / 60.0
		entity.variant = 0

func _update_yado_motion(entity: EntityState, delta: float) -> void:
	if entity.yado_phase == 0:
		entity.yado_phase_timer -= delta
		var player_side := -1 if _player_state.world_x < entity.world_x else 1
		if player_side != entity.yado_facing and entity.yado_phase_timer > 0.000001:
			entity.yado_facing = player_side
			entity.yado_phase = 2
			entity.yado_phase_timer = 18.0 / 60.0
			return
		if entity.yado_phase_timer <= 0.000001:
			entity.yado_phase = 1
			entity.yado_phase_timer = 2.0
			entity.yado_projectile_fired = false
			entity.variant = 1
		return
	if entity.yado_phase == 1:
		entity.yado_phase_timer -= delta
		if not entity.yado_projectile_fired and entity.yado_phase_timer <= 1.0:
			_spawn_yado_projectile(entity)
			entity.yado_projectile_fired = true
		if entity.yado_phase_timer <= 6.0 / 60.0:
			entity.variant = 2
		if entity.yado_phase_timer <= 0.000001:
			entity.yado_phase = 0
			entity.yado_phase_timer = 2.0
			entity.variant = 0
		return
	entity.yado_phase_timer -= delta
	if entity.yado_phase_timer <= 0.000001:
		entity.yado_phase = 0
		entity.yado_phase_timer = 2.0
		entity.variant = 0

func _spawn_yado_projectile(source: EntityState) -> void:
	var projectile := _add_entity(_level_state, ENTITY_PROJECTILE, source.world_x + float(source.yado_facing) * 5.0, source.world_y - 6.0)
	projectile.enemy_profile = 17
	projectile.velocity_x = float(source.yado_facing) * 90.0
	projectile.velocity_y = 0.0
	projectile.state_timer = 3.0

func _update_hammerhead_motion(entity: EntityState, delta: float) -> void:
	entity.previous_world_y = entity.world_y
	entity.state_timer = fmod(entity.state_timer + delta * 1.5 * 4.0 * TAU / 1024.0 * 60.0, TAU)
	entity.world_y = entity.origin_y + sin(entity.state_timer) * 120.0

func _update_straw_motion(entity: EntityState, delta: float) -> void:
	if entity.straw_phase == 0:
		var target := Vector2(_player_state.world_x, _player_state.world_y - 24.0)
		var offset := target - Vector2(entity.world_x, entity.world_y)
		if offset.x < 0.0:
			entity.velocity_x -= 3.75
		else:
			entity.velocity_x += 2.578125
		if offset.y < 0.0:
			entity.velocity_y -= 3.75
		else:
			entity.velocity_y += 2.578125
		entity.straw_phase_timer -= delta
		if entity.straw_phase_timer <= 0.000001:
			entity.straw_phase_timer = 100.0 / 60.0
			entity.straw_cycles -= 1
			entity.straw_phase = 2 if entity.straw_cycles <= 0 else 1
	elif entity.straw_phase == 1:
		entity.straw_phase_timer -= delta
		if entity.straw_phase_timer <= 0.000001:
			entity.straw_phase = 0
			entity.straw_phase_timer = 30.0 / 60.0
	entity.world_x += entity.velocity_x * delta
	entity.world_y += entity.velocity_y * delta

func _update_gejigeji_motion(entity: EntityState, delta: float) -> void:
	if entity.gejigeji_history.is_empty():
		for _history in range(64):
			entity.gejigeji_history.append(Vector2(entity.world_x, entity.world_y))
		for _segment in range(4):
			entity.trail_positions.append(Vector2(entity.world_x, entity.world_y))
	if entity.gejigeji_pause_timer > 0.0:
		entity.gejigeji_pause_timer = maxf(0.0, entity.gejigeji_pause_timer - delta)
	else:
		if entity.gejigeji_vertical:
			entity.world_y += entity.velocity_y * delta
			if entity.world_y <= entity.koura_patrol_min_y:
				entity.world_y = entity.koura_patrol_min_y
				entity.velocity_y = absf(entity.velocity_y)
				entity.gejigeji_pause_timer = 1.0
			elif entity.world_y >= entity.koura_patrol_max_y:
				entity.world_y = entity.koura_patrol_max_y
				entity.velocity_y = -absf(entity.velocity_y)
				entity.gejigeji_pause_timer = 1.0
		else:
			entity.world_x += entity.velocity_x * delta
			if entity.world_x <= entity.patrol_min_x:
				entity.world_x = entity.patrol_min_x
				entity.velocity_x = absf(entity.velocity_x)
				entity.gejigeji_pause_timer = 1.0
			elif entity.world_x >= entity.patrol_max_x:
				entity.world_x = entity.patrol_max_x
				entity.velocity_x = -absf(entity.velocity_x)
				entity.gejigeji_pause_timer = 1.0
	entity.gejigeji_history.push_front(Vector2(entity.world_x, entity.world_y))
	if entity.gejigeji_history.size() > 64:
		entity.gejigeji_history.pop_back()
	for i in range(4):
		var history_index := mini((i + 1) * 13, entity.gejigeji_history.size() - 1)
		entity.trail_positions[i] = entity.gejigeji_history[history_index]

func _update_kubinaga_motion(entity: EntityState, delta: float) -> void:
	var base := Vector2(entity.origin_x, entity.origin_y)
	if entity.kubinaga_phase == 0:
		entity.kubinaga_phase_timer -= delta
		entity.kubinaga_extension = 0.0
		if entity.kubinaga_phase_timer <= 0.0:
			var player_offset := Vector2(_player_state.world_x, _player_state.world_y - 16.0) - base
			if absf(player_offset.x) <= 120.0 and absf(player_offset.y) <= 100.0:
				entity.kubinaga_angle = player_offset.angle()
				entity.kubinaga_phase = 1
				entity.kubinaga_extension = 0.0
	elif entity.kubinaga_phase == 1:
		entity.kubinaga_extension = minf(68.0, entity.kubinaga_extension + 120.0 * delta)
		if entity.kubinaga_extension >= 68.0:
			entity.kubinaga_phase = 2
			entity.kubinaga_phase_timer = 32.0 / 60.0
			entity.kubinaga_shot_fired = false
	elif entity.kubinaga_phase == 2:
		entity.kubinaga_phase_timer -= delta
		if not entity.kubinaga_shot_fired and entity.kubinaga_phase_timer <= 17.0 / 60.0:
			_spawn_kubinaga_projectile(entity)
			entity.kubinaga_shot_fired = true
		if entity.kubinaga_phase_timer <= 0.0:
			entity.kubinaga_phase = 3
	else:
		entity.kubinaga_extension = maxf(0.0, entity.kubinaga_extension - 120.0 * delta)
		if entity.kubinaga_extension <= 0.0:
			entity.kubinaga_phase = 0
			entity.kubinaga_phase_timer = 120.0 / 60.0
	var head_offset := Vector2(cos(entity.kubinaga_angle), sin(entity.kubinaga_angle)) * entity.kubinaga_extension
	entity.target_x = base.x + head_offset.x
	entity.target_y = base.y + head_offset.y

func _spawn_kubinaga_projectile(source: EntityState) -> void:
	var head := Vector2(source.target_x, source.target_y)
	var projectile := _add_entity(_level_state, ENTITY_PROJECTILE, head.x, head.y)
	projectile.enemy_profile = 11
	projectile.velocity_x = cos(source.kubinaga_angle) * 75.0
	projectile.velocity_y = sin(source.kubinaga_angle) * 75.0
	projectile.state_timer = 3.0

func _update_madillo_motion(entity: EntityState, delta: float) -> void:
	if entity.variant == 0:
		var player_delta := _player_state.world_x - entity.world_x
		if absf(player_delta) < 120.0 and absf(_player_state.world_y - entity.world_y) < 50.0:
			entity.variant = 1
			if player_delta < 0.0 and entity.world_x > entity.patrol_min_x:
				entity.velocity_x = -90.0
			elif player_delta > 0.0 and entity.world_x < entity.patrol_max_x:
				entity.velocity_x = 90.0
			else:
				entity.variant = 0
				entity.velocity_x = 0.0
		return
	if entity.variant == 1:
		entity.world_x += entity.velocity_x * delta
		if (entity.velocity_x < 0.0 and entity.world_x <= entity.patrol_min_x) or (entity.velocity_x > 0.0 and entity.world_x >= entity.patrol_max_x):
			entity.world_x = clampf(entity.world_x, entity.patrol_min_x, entity.patrol_max_x)
			entity.variant = 2
			entity.madillo_return_timer = 120.0 / 60.0
		return
	entity.world_x += entity.velocity_x * delta
	entity.velocity_x *= pow(0.9, delta * 60.0)
	entity.madillo_return_timer -= delta
	if entity.madillo_return_timer <= 0.0:
		entity.variant = 0
		entity.velocity_x = 0.0

func _update_kyura_motion(entity: EntityState, delta: float) -> void:
	# kyura.c updates its orbit for 8 frames, holds for 4, then advances by 8
	# GBA angle units. The projectile counter advances only at each switch.
	entity.kyura_switch_timer -= delta
	if entity.kyura_switch_timer <= 0.000001:
		if not entity.kyura_recovering:
			entity.kyura_recovering = true
			entity.kyura_switch_timer = 4.0 / 60.0
			entity.kyura_projectile_counter -= 1
			if entity.kyura_projectile_counter == 1:
				_spawn_kyura_projectile(entity)
				entity.kyura_projectile_counter = 12
		else:
			entity.kyura_recovering = false
			entity.kyura_switch_timer = 8.0 / 60.0
			entity.kyura_phase_units = fmod(entity.kyura_phase_units + 8.0, 256.0)
	var phase := entity.kyura_phase_units * TAU / 256.0
	entity.state_timer = phase
	entity.world_x = entity.origin_x + cos(phase * 5.0) * entity.target_x
	entity.world_y = entity.origin_y + sin(phase * 3.0) * entity.target_y

func _spawn_kyura_projectile(source: EntityState) -> void:
	var projectile := _add_entity(_level_state, ENTITY_PROJECTILE, source.world_x, source.world_y + 20.0)
	projectile.enemy_profile = 14
	projectile.variant = source.kyura_projectile_variant
	projectile.velocity_x = 0.0
	projectile.velocity_y = 120.0 if source.kyura_projectile_variant == 0 else 60.0
	projectile.state_timer = 3.0
	source.kyura_projectile_variant = 1 - source.kyura_projectile_variant

func _update_flickey_motion(entity: EntityState, delta: float) -> void:
	if entity.flickey_history.is_empty():
		for _history in range(64):
			entity.flickey_history.append(Vector2(entity.world_x, entity.world_y))
		for _segment in range(4):
			entity.trail_positions.append(Vector2(entity.world_x, entity.world_y))
	if entity.flickey_turn_timer > 0.0:
		entity.flickey_turn_timer = maxf(0.0, entity.flickey_turn_timer - delta)
		if entity.flickey_turn_timer <= 0.000001:
			entity.flickey_turn_timer = 0.0
			entity.velocity_x = absf(entity.velocity_x) if entity.velocity_x < 0.0 else -absf(entity.velocity_x)
			entity.flickey_vertical_speed = -240.0
	else:
		entity.flickey_vertical_speed += 7.5 * delta * 60.0
		entity.world_x += entity.velocity_x * delta
		entity.world_y += entity.flickey_vertical_speed * delta
		var floor_y := _level_state.ground_y - 16.0
		if entity.world_y >= floor_y:
			entity.world_y = floor_y
			entity.flickey_vertical_speed = -240.0
		if (entity.velocity_x < 0.0 and entity.world_x <= entity.patrol_min_x) or (entity.velocity_x > 0.0 and entity.world_x >= entity.patrol_max_x):
			entity.world_x = clampf(entity.world_x, entity.patrol_min_x, entity.patrol_max_x)
			entity.flickey_turn_timer = 0.4
	entity.flickey_history.push_front(Vector2(entity.world_x, entity.world_y))
	if entity.flickey_history.size() > 64:
		entity.flickey_history.pop_back()
	for i in range(4):
		var history_index := mini((i + 1) * 16, entity.flickey_history.size() - 1)
		entity.trail_positions[i] = entity.flickey_history[history_index]

func _update_mon_motion(entity: EntityState, delta: float) -> void:
	if entity.variant == 0:
		if absf(_player_state.world_x - entity.world_x) < 120.0 and absf(_player_state.world_y - entity.world_y) < 50.0:
			entity.variant = 1
			entity.mon_phase_timer = 18.0 / 60.0
		return
	if entity.variant == 1:
		entity.mon_phase_timer -= delta
		if entity.mon_phase_timer <= 0.000001:
			entity.variant = 2
			entity.velocity_y = -330.0
			entity.mon_phase_timer = 0.0
		return
	if entity.variant == 3:
		entity.mon_phase_timer -= delta
		if entity.mon_phase_timer <= 0.000001:
			entity.mon_phase_timer = 0.0
			if absf(_player_state.world_x - entity.world_x) < 120.0 and absf(_player_state.world_y - entity.world_y) < 50.0:
				entity.variant = 1
				entity.mon_phase_timer = 18.0 / 60.0
			else:
				entity.variant = 0
		return
	entity.velocity_y += 12.1875 * delta * 60.0
	entity.world_y += entity.velocity_y * delta
	if entity.world_y >= entity.origin_y:
		entity.world_y = entity.origin_y
		entity.velocity_y = 0.0
		entity.variant = 3
		entity.mon_phase_timer = 18.0 / 60.0

func _update_buzzer_motion(entity: EntityState, delta: float) -> void:
	if entity.variant == 0:
		if entity.buzzer_turn_timer > 0.0:
			entity.buzzer_turn_timer = maxf(0.0, entity.buzzer_turn_timer - delta)
			if entity.buzzer_turn_timer <= 0.000001:
				entity.buzzer_turn_timer = 0.0
				entity.velocity_x = -entity.velocity_x
			return
		entity.buzzer_cooldown = maxf(0.0, entity.buzzer_cooldown - delta)
		entity.world_x += entity.velocity_x * delta
		if entity.world_x <= entity.patrol_min_x:
			entity.world_x = entity.patrol_min_x
			if entity.velocity_x < 0.0:
				entity.buzzer_turn_timer = 18.0 / 60.0
		if entity.world_x >= entity.patrol_max_x:
			entity.world_x = entity.patrol_max_x
			if entity.velocity_x > 0.0:
				entity.buzzer_turn_timer = 18.0 / 60.0
		var dx := _player_state.world_x - entity.world_x
		var player_y := _player_state.world_y - 20.0
		var facing_player := (entity.velocity_x > 0.0 and dx > 0.0 and dx < 60.0) or (entity.velocity_x < 0.0 and dx < 0.0 and dx > -60.0)
		if entity.buzzer_cooldown <= 0.000001 and _player_state.is_alive and facing_player and player_y > entity.world_y and player_y < entity.world_y + 80.0:
			entity.variant = 1
			entity.buzzer_attack_timer = 32.0 / 60.0
			entity.buzzer_attack_origin_x = entity.world_x
			entity.buzzer_attack_origin_y = entity.world_y
			entity.target_x = _player_state.world_x
			entity.target_y = player_y
		return
	if entity.variant == 1:
		entity.buzzer_attack_timer = maxf(0.0, entity.buzzer_attack_timer - delta)
		var attack_ratio := 1.0 - entity.buzzer_attack_timer / (32.0 / 60.0)
		entity.world_x = lerpf(entity.buzzer_attack_origin_x, entity.target_x, clampf(attack_ratio, 0.0, 1.0))
		entity.world_y = lerpf(entity.buzzer_attack_origin_y, entity.target_y, clampf(attack_ratio, 0.0, 1.0))
		if entity.buzzer_attack_timer <= 0.000001:
			entity.variant = 2
			entity.buzzer_attack_timer = 32.0 / 60.0
	else:
		entity.buzzer_attack_timer = maxf(0.0, entity.buzzer_attack_timer - delta)
		var return_ratio := 1.0 - entity.buzzer_attack_timer / (32.0 / 60.0)
		entity.world_x = lerpf(entity.target_x, entity.buzzer_attack_origin_x, clampf(return_ratio, 0.0, 1.0))
		entity.world_y = lerpf(entity.target_y, entity.buzzer_attack_origin_y, clampf(return_ratio, 0.0, 1.0))
		if entity.buzzer_attack_timer <= 0.000001:
			entity.variant = 0
			entity.buzzer_cooldown = 60.0 / 60.0

func _update_balloon_motion(entity: EntityState, delta: float) -> void:
	if entity.variant == 0:
		entity.state_timer -= delta
		entity.balloon_angle = fmod(entity.balloon_angle + delta * 60.0, 1024.0)
		var x_phase := entity.balloon_angle * 5.0 * TAU / 1024.0
		var y_phase := entity.balloon_angle * 3.0 * TAU / 1024.0
		entity.world_x += entity.velocity_x * delta + cos(x_phase) * entity.balloon_amplitude_x * delta * 0.5
		entity.world_y = entity.origin_y + sin(y_phase) * entity.balloon_amplitude_y
		if entity.world_x <= entity.patrol_min_x:
			entity.world_x = entity.patrol_min_x
			entity.velocity_x = absf(entity.velocity_x)
		if entity.world_x >= entity.patrol_max_x:
			entity.world_x = entity.patrol_max_x
			entity.velocity_x = -absf(entity.velocity_x)
		if entity.state_timer <= 0.0:
			entity.variant = 1
			entity.state_timer = 45.0 / 60.0
			entity.balloon_projectile_spawned = false
	elif entity.variant == 1:
		entity.state_timer -= delta
		if not entity.balloon_projectile_spawned and entity.state_timer <= 0.000001:
			entity.balloon_projectile_spawned = true
			_spawn_balloon_projectile(entity)
		if entity.state_timer <= 0.0:
			entity.variant = 0
			entity.state_timer = 120.0 / 60.0
			entity.balloon_projectile_spawned = false

func _update_item_box_effect(entity: EntityState, delta: float) -> void:
	if not entity.activated:
		return
	entity.state_timer += delta
	entity.effect_offset = minf(34.0, entity.state_timer * 92.0)
	if entity.state_timer >= 0.60:
		_apply_item_box_effect(entity)
		entity.active = false

func _apply_item_box_effect(entity: EntityState) -> void:
	match entity.item_kind:
		ITEM_BOX_KIND_SHIELD:
			_magnetic_shielded = false
			_player_state.shielded = true
		ITEM_BOX_KIND_MAGNETIC_SHIELD:
			_player_state.shielded = true
			_magnetic_shielded = true
		ITEM_BOX_KIND_INVINCIBILITY:
			_invincibility_timer = 20.0
		ITEM_BOX_KIND_ONE_UP:
			_player_state.lives = mini(255, _player_state.lives + 1)
		ITEM_BOX_KIND_SPEED_UP:
			_speed_up_timer = 20.0
		ITEM_BOX_KIND_RINGS_RANDOM:
			var ring_amounts: Array = [1, 5, 10, 30, 50]
			var random_index := posmod(int(_elapsed_time * 60.0) + int(entity.world_x), ring_amounts.size())
			_add_ring_reward(int(ring_amounts[random_index]))
		ITEM_BOX_KIND_RINGS_5:
			_add_ring_reward(5)
		ITEM_BOX_KIND_RINGS_10:
			_add_ring_reward(10)
		_:
			_add_ring_reward(maxi(1, entity.variant))

func _add_ring_reward(amount: int) -> void:
	var old_rings := _player_state.rings
	_player_state.rings = mini(999, _player_state.rings + maxi(0, amount))
	var old_ring_hundreds := old_rings / 100
	var new_ring_hundreds := _player_state.rings / 100
	if new_ring_hundreds > old_ring_hundreds and not _run_from_time_attack and not _run_from_multiplayer and _selected_level_index < _level_names.size() - 1:
		_player_state.lives = mini(255, _player_state.lives + (new_ring_hundreds - old_ring_hundreds))

func _update_scattered_ring(entity: EntityState, delta: float) -> void:
	entity.state_timer -= delta
	entity.velocity_y += 620.0 * delta
	entity.world_x += entity.velocity_x * delta
	entity.world_y += entity.velocity_y * delta
	if entity.world_y >= _level_state.ground_y - 12.0:
		entity.world_y = _level_state.ground_y - 12.0
		entity.velocity_y = -absf(entity.velocity_y) * 0.56
		entity.velocity_x *= 0.82
	if entity.state_timer <= 0.0 or entity.world_x < _level_state.min_x - 40.0 or entity.world_x > _level_state.max_x + 40.0:
		entity.active = false

func _update_bullet_buzzer_motion(entity: EntityState, delta: float) -> void:
	entity.bullet_buzzer_angle = fmod(entity.bullet_buzzer_angle + delta * 60.0, 1024.0)
	var x_phase := entity.bullet_buzzer_angle * 5.0 * TAU / 1024.0
	var y_phase := entity.bullet_buzzer_angle * 3.0 * TAU / 1024.0
	entity.world_x = entity.origin_x + cos(x_phase) * 48.0
	entity.world_y = entity.origin_y + sin(y_phase) * 28.0
	if entity.variant == 0:
		entity.state_timer -= delta
		if entity.state_timer <= 0.0:
			entity.variant = 1
			entity.bullet_buzzer_attack_timer = 50.0 / 60.0
			entity.bullet_buzzer_projectile_spawned = false
	else:
		entity.bullet_buzzer_attack_timer -= delta
		if not entity.bullet_buzzer_projectile_spawned and entity.bullet_buzzer_attack_timer <= 16.0 / 60.0:
			entity.bullet_buzzer_projectile_spawned = true
			_spawn_bullet_buzzer_projectiles(entity)
		if entity.bullet_buzzer_attack_timer <= 0.0:
			entity.variant = 0
			entity.state_timer = 60.0 / 60.0

func _update_koura_motion(entity: EntityState, delta: float) -> void:
	# koura.c uses a fixed-point half-pixel step and stage-time sine phase.
	entity.state_timer = fmod(entity.state_timer + delta * 20.0 * TAU / 256.0 * 60.0, TAU)
	if entity.koura_motion_variant < 2:
		entity.world_x += entity.velocity_x * delta
		if entity.world_x <= entity.patrol_min_x:
			entity.world_x = entity.patrol_min_x
			entity.velocity_x = absf(entity.velocity_x)
		if entity.world_x >= entity.patrol_max_x:
			entity.world_x = entity.patrol_max_x
			entity.velocity_x = -absf(entity.velocity_x)
		if entity.koura_motion_variant == 0 or entity.koura_motion_variant == 1:
			entity.world_y = entity.origin_y
		else:
			entity.world_y = entity.origin_y + sin(entity.state_timer) * 8.0
	else:
		if entity.koura_motion_variant == 2:
			entity.world_y = entity.origin_y + sin(entity.state_timer) * 8.0
		else:
			entity.world_y += entity.velocity_y * delta
			if entity.koura_patrol_min_y == entity.koura_patrol_max_y:
				entity.koura_patrol_min_y = entity.origin_y - 96.0
				entity.koura_patrol_max_y = entity.origin_y + 96.0
			if entity.world_y <= entity.koura_patrol_min_y:
				entity.world_y = entity.koura_patrol_min_y
				entity.velocity_y = absf(entity.velocity_y)
			if entity.world_y >= entity.koura_patrol_max_y:
				entity.world_y = entity.koura_patrol_max_y
				entity.velocity_y = -absf(entity.velocity_y)

func _update_star_motion(entity: EntityState, delta: float) -> void:
	entity.state_timer -= delta
	if entity.state_timer > 0.0:
		return
	match entity.variant:
		0:
			entity.variant = 1
			entity.state_timer = 0.333
		1:
			entity.variant = 2
			entity.state_timer = 2.0
		2:
			entity.variant = 3
			entity.state_timer = 0.333
		_:
			entity.variant = 0
			entity.state_timer = 2.0

func _update_kiki_motion(entity: EntityState, delta: float) -> void:
	if entity.variant == 0:
		entity.world_y += entity.kiki_vertical_direction * 60.0 * delta
		if entity.world_y >= entity.kiki_vertical_max:
			entity.world_y = entity.kiki_vertical_max
			entity.kiki_vertical_direction = -1.0
		elif entity.world_y <= entity.kiki_vertical_min:
			entity.world_y = entity.kiki_vertical_min
			entity.kiki_vertical_direction = 1.0
			entity.kiki_border_hits += 1
			if (entity.kiki_border_hits & 1) == 0:
				entity.variant = 1
				entity.kiki_attack_frames = 0
				entity.kiki_projectile_spawned = false
		return
	entity.kiki_attack_frames += 1
	if not entity.kiki_projectile_spawned and entity.kiki_attack_frames == 18:
		entity.kiki_projectile_spawned = true
		_spawn_kiki_projectile(entity)
	if entity.kiki_attack_frames >= 30:
		entity.variant = 0
		entity.kiki_projectile_spawned = false

func _update_pikopiko_motion(entity: EntityState, delta: float) -> void:
	# piko_piko.c advances its fixed-point horizontal offset by one pixel/frame.
	entity.world_x += entity.velocity_x * delta
	if entity.pikopiko_clamp_ground:
		entity.world_y = _level_state.ground_y - 16.0
	if entity.world_x <= entity.patrol_min_x:
		entity.world_x = entity.patrol_min_x
		entity.velocity_x = absf(entity.velocity_x)
	elif entity.world_x >= entity.patrol_max_x:
		entity.world_x = entity.patrol_max_x
		entity.velocity_x = -absf(entity.velocity_x)

func _update_kiki_projectile(entity: EntityState, delta: float) -> void:
	entity.state_timer -= delta
	entity.velocity_y += 156.25 * delta
	entity.world_x += entity.velocity_x * delta
	entity.world_y += entity.velocity_y * delta
	if entity.world_y >= _level_state.ground_y - 8.0 or entity.state_timer <= 0.0:
		_split_kiki_projectile(entity)

func _update_kiki_piece(entity: EntityState, delta: float) -> void:
	entity.state_timer -= delta
	entity.velocity_y += 156.25 * delta
	entity.world_x += entity.velocity_x * delta
	entity.world_y += entity.velocity_y * delta
	if entity.state_timer <= 0.0 or entity.world_y > _level_state.max_y + 40.0:
		entity.active = false

func _update_trapped_animal_motion(entity: EntityState, delta: float) -> void:
	entity.state_timer += delta
	match entity.variant:
		1:
			# Flying animals bob around their release point.
			entity.world_y = entity.origin_y + sin(entity.state_timer * 3.0) * 16.0
		2:
			# Bouncing animals use a small self-contained hop and drift.
			entity.world_x += entity.velocity_x * delta
			entity.world_y = entity.origin_y + absf(sin(entity.state_timer * 3.4)) * -24.0
			if entity.state_timer >= 1.8:
				entity.state_timer = 0.0
				entity.velocity_x = -entity.velocity_x
				entity.world_x = entity.origin_x
		_:
			pass

func _update_ring_effect_motion(entity: EntityState, delta: float) -> void:
	entity.state_timer += delta
	if entity.state_timer >= 0.34:
		entity.active = false

func _update_heart_effect_motion(entity: EntityState, delta: float) -> void:
	entity.state_timer += delta
	entity.world_x += entity.velocity_x * delta
	entity.world_y += entity.velocity_y * delta
	entity.velocity_y = move_toward(entity.velocity_y, -8.0, 18.0 * delta)
	if entity.state_timer >= 0.72:
		entity.active = false

func _update_dust_effect_motion(entity: EntityState, delta: float) -> void:
	entity.state_timer += delta
	entity.world_y -= 8.0 * delta
	if entity.state_timer >= 0.48:
		entity.active = false

func _update_grind_effect_motion(entity: EntityState, delta: float) -> void:
	entity.state_timer += delta
	if _grind_timer <= 0.0 or not _player_state.is_alive:
		entity.active = false
		if _grind_effect_entity == entity:
			_grind_effect_entity = null

func _spawn_grind_effect() -> void:
	if _grind_effect_entity != null and _grind_effect_entity.active:
		return
	_grind_effect_entity = _add_entity(_level_state, ENTITY_GRIND_EFFECT, _player_state.world_x, _player_state.world_y)
	_grind_effect_entity.state_timer = 0.0
	_grind_effect_entity.variant = 1 if _grind_velocity_x < 0.0 else 0

func _sync_grind_effect() -> void:
	if _grind_effect_entity == null or not _grind_effect_entity.active:
		return
	if _grind_timer <= 0.0:
		_grind_effect_entity.active = false
		_grind_effect_entity = null
		return
	_grind_effect_entity.world_x = _player_state.world_x
	_grind_effect_entity.world_y = _player_state.world_y

func _spawn_cheese_companion() -> void:
	_cheese_entity = _add_entity(_level_state, ENTITY_CHEESE, _player_state.world_x - 32.0, _player_state.world_y - 20.0)
	_cheese_entity.state_timer = 0.0
	_cheese_entity.origin_x = _cheese_entity.world_x
	_cheese_entity.origin_y = _cheese_entity.world_y

func _update_cheese_motion(entity: EntityState, delta: float) -> void:
	if _player_state.variant != 1 or _run_from_multiplayer or not _player_state.is_alive:
		entity.active = false
		if _cheese_entity == entity:
			_cheese_entity = null
		return
	entity.state_timer += delta
	var target_x := _player_state.world_x - _facing_direction * 34.0
	var target_y := _player_state.world_y - 24.0 + sin(entity.state_timer * 4.0) * 8.0
	entity.world_x = move_toward(entity.world_x, target_x, 300.0 * delta)
	entity.world_y = move_toward(entity.world_y, target_y, 300.0 * delta)

func _spawn_character_attack_effect(effect_type: int) -> void:
	var direction := _facing_direction
	var effect := _add_entity(_level_state, effect_type, _player_state.world_x + direction * 20.0, _player_state.world_y - 20.0)
	effect.velocity_x = direction * (40.0 if effect_type == ENTITY_TAIL_SWIPE else (55.0 if effect_type == ENTITY_SONIC_SKID else 85.0))
	effect.state_timer = 0.0
	effect.variant = 0 if direction > 0.0 else 1

func _update_character_attack_effect(entity: EntityState, delta: float) -> void:
	entity.state_timer += delta
	entity.world_x += entity.velocity_x * delta
	var lifetime := 0.28 if entity.type == ENTITY_TAIL_SWIPE else (0.32 if entity.type == ENTITY_SONIC_SKID else 0.36)
	if entity.state_timer >= lifetime:
		entity.active = false

func _spawn_dust_cloud(x: float, y: float) -> void:
	var active_clouds := 0
	for existing in _level_state.entities:
		if existing.type == ENTITY_DUST_EFFECT and existing.active:
			active_clouds += 1
	if active_clouds >= 12:
		return
	var cloud := _add_entity(_level_state, ENTITY_DUST_EFFECT, x, y)
	cloud.origin_x = x
	cloud.origin_y = y
	cloud.state_timer = 0.0

func _spawn_amy_attack_hearts() -> void:
	var offsets: Array = [
		Vector2(10.0, -27.0), Vector2(12.0, -22.0), Vector2(14.0, -13.0),
		Vector2(16.0, 0.0), Vector2(20.0, 10.0), Vector2(16.0, 23.0),
	]
	for i in range(offsets.size()):
		var offset: Vector2 = offsets[i]
		var direction := -1.0 if _player_state.speed_x < 0.0 else 1.0
		var heart := _add_entity(_level_state, ENTITY_HEART_EFFECT, _player_state.world_x + offset.x * direction, _player_state.world_y + offset.y)
		heart.origin_x = heart.world_x
		heart.origin_y = heart.world_y
		heart.velocity_x = direction * (18.0 + float(i) * 3.0)
		heart.velocity_y = -26.0 - float(i % 3) * 8.0
		heart.state_timer = 0.0

func _update_aero_egg_motion(entity: EntityState, delta: float) -> void:
	# boss_4.c advances the craft horizontally and drops bombs on a cooldown.
	entity.hit_timer = maxf(0.0, entity.hit_timer - delta)
	entity.effect_offset = _elapsed_time * 2.4 + 0.7
	entity.world_x += entity.velocity_x * delta
	entity.world_x = clampf(entity.world_x, entity.origin_x - 180.0, entity.origin_x + 180.0)
	if entity.world_x <= entity.origin_x - 180.0 or entity.world_x >= entity.origin_x + 180.0:
		entity.velocity_x *= -1.0
	entity.state_timer -= delta
	if entity.state_timer <= 0.0:
		_spawn_aero_egg_bomb(entity)
		entity.state_timer = 1.333 if entity.health <= 4 else 2.333
	entity.target_y = entity.origin_y + sin(_elapsed_time * 1.8) * 10.0
	entity.world_y = move_toward(entity.world_y, entity.target_y, 70.0 * delta)

func _update_hammer_tank_motion(entity: EntityState, delta: float) -> void:
	# boss_1.c's reset/extend/aim/plunge/slam/hold/drag/retract cycle.
	entity.hit_timer = maxf(0.0, entity.hit_timer - delta)
	entity.world_x += entity.velocity_x * delta
	entity.world_x = clampf(entity.world_x, entity.origin_x - 150.0, entity.origin_x + 150.0)
	if entity.world_x <= entity.origin_x - 150.0 or entity.world_x >= entity.origin_x + 150.0:
		entity.velocity_x *= -1.0
	var hammer_length := entity.target_x
	var hammer_angle := entity.effect_offset
	entity.state_timer -= delta
	match entity.variant:
		0:
			hammer_length = move_toward(hammer_length, 56.0, 170.0 * delta)
			hammer_angle = move_toward(hammer_angle, -PI * 0.5, 2.8 * delta)
			if entity.state_timer <= 0.0:
				entity.variant = 1
				entity.state_timer = 0.28
		1:
			hammer_length = move_toward(hammer_length, 128.0, 270.0 * delta)
			if entity.state_timer <= 0.0:
				entity.variant = 2
				entity.state_timer = 0.25
		2:
			var aim := Vector2(_player_state.world_x - entity.world_x, (_player_state.world_y - 20.0) - entity.world_y)
			if aim.length_squared() > 1.0:
				hammer_angle = lerp_angle(hammer_angle, aim.angle(), 0.18)
			if entity.state_timer <= 0.0:
				entity.variant = 3
				entity.state_timer = 0.55
		3:
			hammer_angle = move_toward(hammer_angle, PI * 0.5, 4.0 * delta)
			hammer_length = move_toward(hammer_length, 184.0, 360.0 * delta)
			if entity.state_timer <= 0.0:
				entity.variant = 4
				entity.state_timer = 0.45
				_request_screen_shake(7.0, 0.45, 0.25, false, true, false)
		4:
			if entity.state_timer <= 0.0:
				entity.variant = 5
				entity.state_timer = 0.95
		5:
			hammer_length = move_toward(hammer_length, 96.0, 90.0 * delta)
			if entity.state_timer <= 0.0:
				entity.variant = 6
				entity.state_timer = 0.78
		6:
			hammer_length = move_toward(hammer_length, 56.0, 70.0 * delta)
			if entity.state_timer <= 0.0:
				entity.variant = 7
				entity.state_timer = 0.8
		7:
			hammer_length = move_toward(hammer_length, 42.0, 140.0 * delta)
			hammer_angle = move_toward(hammer_angle, -PI * 0.5, 3.4 * delta)
			if entity.state_timer <= 0.0:
				entity.variant = 0
				entity.state_timer = 1.2
	entity.target_x = hammer_length
	entity.effect_offset = hammer_angle

func _hammer_tank_tip(entity: EntityState) -> Vector2:
	return Vector2(entity.world_x + cos(entity.effect_offset) * entity.target_x, entity.world_y + sin(entity.effect_offset) * entity.target_x)

func _update_bomber_tank_motion(entity: EntityState, delta: float) -> void:
	# boss_2.c keeps the tank moving while the cannon retargets and reloads.
	entity.hit_timer = maxf(0.0, entity.hit_timer - delta)
	entity.world_x += entity.velocity_x * delta
	entity.world_x = clampf(entity.world_x, entity.origin_x - 160.0, entity.origin_x + 160.0)
	if entity.world_x <= entity.origin_x - 160.0 or entity.world_x >= entity.origin_x + 160.0:
		entity.velocity_x *= -1.0
	var target := Vector2(_player_state.world_x - entity.world_x, (_player_state.world_y - 22.0) - entity.world_y)
	if target.length_squared() > 1.0:
		entity.effect_offset = lerp_angle(entity.effect_offset, target.angle(), 0.12)
	entity.state_timer -= delta
	if entity.state_timer <= 0.0:
		_spawn_bomber_tank_bomb(entity)
		entity.state_timer = 2.5

func _spawn_bomber_tank_bomb(source: EntityState) -> void:
	var bomb := _add_entity(_level_state, ENTITY_PROJECTILE, source.world_x - 8.0, source.world_y - 22.0)
	bomb.enemy_profile = 5
	bomb.velocity_x = cos(source.effect_offset) * 170.0
	bomb.velocity_y = sin(source.effect_offset) * 170.0
	bomb.state_timer = 4.0
	bomb.origin_x = source.world_x
	bomb.origin_y = source.world_y

func _update_totem_boss_motion(entity: EntityState, delta: float) -> void:
	# boss_3.c moves the stacked totem and periodically fires at the player.
	entity.hit_timer = maxf(0.0, entity.hit_timer - delta)
	entity.world_x += entity.velocity_x * delta
	entity.world_x = clampf(entity.world_x, entity.origin_x - 170.0, entity.origin_x + 170.0)
	if entity.world_x <= entity.origin_x - 170.0 or entity.world_x >= entity.origin_x + 170.0:
		entity.velocity_x *= -1.0
	entity.effect_offset = fmod(entity.effect_offset + delta * 1.8, TAU)
	entity.state_timer -= delta
	if entity.state_timer <= 0.0:
		_spawn_totem_bullet(entity)
		entity.state_timer = 2.2 if entity.health > 4 else 1.5

func _spawn_totem_bullet(source: EntityState) -> void:
	var bullet := _add_entity(_level_state, ENTITY_PROJECTILE, source.world_x - 40.0, source.world_y - 98.0)
	var target := Vector2(_player_state.world_x, _player_state.world_y - 20.0) - Vector2(bullet.world_x, bullet.world_y)
	if target.length_squared() < 1.0:
		target = Vector2(-1.0, 0.0)
	target = target.normalized()
	bullet.velocity_x = target.x * 190.0
	bullet.velocity_y = target.y * 190.0
	bullet.enemy_profile = 6
	bullet.origin_x = source.world_x
	bullet.origin_y = source.world_y

func _update_saucer_boss_motion(entity: EntityState, delta: float) -> void:
	# boss_5.c alternates a charge-beam window with a long recharge.
	entity.hit_timer = maxf(0.0, entity.hit_timer - delta)
	entity.world_x += entity.velocity_x * delta
	entity.world_x = clampf(entity.world_x, entity.origin_x - 130.0, entity.origin_x + 130.0)
	if entity.world_x <= entity.origin_x - 130.0 or entity.world_x >= entity.origin_x + 130.0:
		entity.velocity_x *= -1.0
	entity.world_y = entity.origin_y + sin(_elapsed_time * 1.4) * 18.0
	var target := Vector2(_player_state.world_x - entity.world_x, (_player_state.world_y - 20.0) - entity.world_y)
	if target.length_squared() > 1.0:
		entity.effect_offset = lerp_angle(entity.effect_offset, target.angle(), 0.10)
	entity.state_timer -= delta
	if entity.state_timer <= 0.0:
		if entity.variant == 0:
			entity.variant = 1
			entity.state_timer = 1.0
		else:
			entity.variant = 0
			entity.state_timer = 4.0 if entity.health > 4 else 2.5

func _saucer_beam_hits_player(entity: EntityState) -> bool:
	if entity.variant != 1:
		return false
	var beam_origin := Vector2(entity.world_x, entity.world_y - 18.0)
	var to_player := Vector2(_player_state.world_x, _player_state.world_y - 20.0) - beam_origin
	if to_player.length_squared() > 520.0 * 520.0 or to_player.length_squared() < 1.0:
		return false
	return absf(wrapf(to_player.angle() - entity.effect_offset, -PI, PI)) < 0.10

func _update_go_round_boss_motion(entity: EntityState, delta: float) -> void:
	# boss_6.c rotates four linked platforms and launches three tracked shots.
	entity.hit_timer = maxf(0.0, entity.hit_timer - delta)
	entity.world_x += entity.velocity_x * delta
	entity.world_x = clampf(entity.world_x, entity.origin_x - 150.0, entity.origin_x + 150.0)
	if entity.world_x <= entity.origin_x - 150.0 or entity.world_x >= entity.origin_x + 150.0:
		entity.velocity_x *= -1.0
	entity.effect_offset = fmod(entity.effect_offset + delta * (1.8 if entity.health > 4 else 2.8), TAU)
	entity.state_timer -= delta
	if entity.state_timer <= 0.0:
		for shot_index in range(3):
			_spawn_go_round_projectile(entity, shot_index)
		entity.state_timer = 2.8 if entity.health > 4 else 1.8

func _spawn_go_round_projectile(source: EntityState, shot_index: int) -> void:
	var bullet := _add_entity(_level_state, ENTITY_PROJECTILE, source.world_x, source.world_y + 26.0)
	var spread := (float(shot_index) - 1.0) * 0.22
	var direction := Vector2(_player_state.world_x - source.world_x, (_player_state.world_y - 20.0) - bullet.world_y)
	if direction.length_squared() < 1.0:
		direction = Vector2(-1.0, 0.0)
	direction = direction.normalized().rotated(spread)
	bullet.velocity_x = direction.x * 185.0
	bullet.velocity_y = direction.y * 185.0
	bullet.enemy_profile = 7
	bullet.origin_x = source.world_x
	bullet.origin_y = source.world_y

func _update_frog_boss_motion(entity: EntityState, delta: float) -> void:
	# boss_7.c alternates a ground run with a high jump and bomb release.
	entity.hit_timer = maxf(0.0, entity.hit_timer - delta)
	entity.world_x += entity.velocity_x * delta
	entity.world_x = clampf(entity.world_x, entity.origin_x - 150.0, entity.origin_x + 150.0)
	if entity.world_x <= entity.origin_x - 150.0 or entity.world_x >= entity.origin_x + 150.0:
		entity.velocity_x *= -1.0
	if entity.variant == 0:
		entity.state_timer -= delta
		if entity.state_timer <= 0.0:
			entity.variant = 1
			entity.velocity_y = -330.0
			entity.state_timer = 0.0
	else:
		entity.velocity_y += 640.0 * delta
		entity.world_y += entity.velocity_y * delta
		if entity.variant == 1 and entity.velocity_y < -80.0:
			_spawn_frog_bomb(entity)
			entity.variant = 2
		if entity.world_y >= entity.origin_y:
			entity.world_y = entity.origin_y
			entity.velocity_y = 0.0
			entity.variant = 0
			entity.state_timer = 1.8 if entity.health > 4 else 1.2

func _spawn_frog_bomb(source: EntityState) -> void:
	var bomb := _add_entity(_level_state, ENTITY_PROJECTILE, source.world_x + 28.0, source.world_y - 20.0)
	bomb.enemy_profile = 8
	bomb.velocity_x = 180.0 if source.velocity_x >= 0.0 else -180.0
	bomb.velocity_y = -90.0
	bomb.state_timer = 3.0
	bomb.origin_x = source.world_x
	bomb.origin_y = source.world_y

func _update_super_robo_z_motion(entity: EntityState, delta: float) -> void:
	# boss_8.c keeps two arms and three tower platforms active around the cockpit.
	entity.hit_timer = maxf(0.0, entity.hit_timer - delta)
	entity.effect_offset = fmod(entity.effect_offset + delta * 0.9, TAU)
	entity.state_timer -= delta
	if entity.state_timer <= 0.0:
		for shot_index in range(3):
			_spawn_super_robo_z_cloud(entity, shot_index)
		entity.state_timer = 2.4 if entity.health > 3 else 1.4

func _spawn_super_robo_z_cloud(source: EntityState, shot_index: int) -> void:
	var arm_angle: float = source.effect_offset + (float(shot_index) - 1.0) * 0.24
	var spawn := Vector2(source.world_x, source.world_y - 36.0) + Vector2(cos(arm_angle), sin(arm_angle)) * 48.0
	var cloud := _add_entity(_level_state, ENTITY_PROJECTILE, spawn.x, spawn.y)
	cloud.enemy_profile = 9
	cloud.velocity_x = cos(arm_angle) * 150.0
	cloud.velocity_y = sin(arm_angle) * 150.0
	cloud.state_timer = 2.4
	cloud.origin_x = source.world_x
	cloud.origin_y = source.world_y

func _update_true_area_53_boss_motion(entity: EntityState, delta: float) -> void:
	# boss_9.c alternates segmented rockets with red/yellow projectile volleys.
	entity.hit_timer = maxf(0.0, entity.hit_timer - delta)
	entity.world_x += sin(_elapsed_time * 0.8) * 18.0 * delta
	entity.world_y = entity.origin_y + sin(_elapsed_time * 1.2) * 24.0
	entity.effect_offset = fmod(entity.effect_offset + delta * 1.2, TAU)
	entity.state_timer -= delta
	if entity.state_timer <= 0.0:
		for shot_index in range(2):
			_spawn_true_area_53_projectile(entity, shot_index)
		entity.state_timer = 2.0 if entity.health > 4 else 1.1

func _spawn_true_area_53_projectile(source: EntityState, shot_index: int) -> void:
	var projectile := _add_entity(_level_state, ENTITY_PROJECTILE, source.world_x + (float(shot_index) * 26.0) - 13.0, source.world_y + 20.0)
	var angle := PI * 0.5 + (float(shot_index) - 0.5) * 0.28 + sin(source.effect_offset) * 0.18
	projectile.enemy_profile = 10
	projectile.velocity_x = cos(angle) * 175.0
	projectile.velocity_y = sin(angle) * 175.0
	projectile.state_timer = 3.0
	projectile.origin_x = source.world_x
	projectile.origin_y = source.world_y

func _spawn_aero_egg_bomb(source: EntityState) -> void:
	var bomb := _add_entity(_level_state, ENTITY_PROJECTILE, source.world_x, source.world_y + 26.0)
	bomb.enemy_profile = 4
	bomb.velocity_x = 300.0 if source.velocity_x >= 0.0 else -300.0
	bomb.velocity_y = 60.0
	bomb.state_timer = 3.0
	bomb.origin_x = source.world_x
	bomb.origin_y = source.world_y

func _update_boss_motion(entity: EntityState, delta: float) -> void:
	entity.hit_timer = maxf(0.0, entity.hit_timer - delta)
	entity.state_timer -= delta
	match entity.variant:
		0:
			var elapsed := 1.2 - entity.state_timer
			entity.world_x = entity.origin_x + sin(elapsed * 1.6) * 70.0
			entity.world_y = entity.origin_y + sin(elapsed * 2.0) * 24.0
			if entity.state_timer <= 0.0:
				entity.variant = 1
				entity.state_timer = 0.28
		1:
			if entity.state_timer <= 0.0:
				entity.variant = 2
				entity.state_timer = 0.36
		2:
			if entity.state_timer <= 0.0:
				_spawn_boss_projectile(entity)
				entity.variant = 3
				entity.state_timer = 0.30
		3:
			var plunge_ratio := clampf(1.0 - (entity.state_timer / 0.30), 0.0, 1.0)
			entity.world_y = entity.origin_y + plunge_ratio * 45.0
			if entity.state_timer <= 0.0:
				entity.variant = 4
				entity.state_timer = 0.35
		4:
			if entity.state_timer <= 0.0:
				entity.target_x = _player_state.world_x
				entity.variant = 5
				entity.state_timer = 0.60
		5:
			if entity.state_timer <= 0.0:
				entity.variant = 6
				entity.state_timer = 0.45
		6:
			entity.world_x = move_toward(entity.world_x, entity.target_x, 220.0 * delta)
			if entity.state_timer <= 0.0:
				entity.variant = 7
				entity.state_timer = 0.35
		7:
			entity.world_y = move_toward(entity.world_y, entity.origin_y, 180.0 * delta)
			if entity.state_timer <= 0.0:
				entity.variant = 0
				entity.state_timer = 0.90

func _spawn_boss_projectile(source: EntityState) -> void:
	var projectile := _add_entity(_level_state, ENTITY_PROJECTILE, source.world_x - 36.0, source.world_y + 18.0)
	var direction := Vector2(_player_state.world_x, _player_state.world_y - 20.0) - Vector2(projectile.world_x, projectile.world_y)
	if direction.length_squared() < 1.0:
		direction = Vector2(-1.0, 0.0)
	direction = direction.normalized()
	projectile.velocity_x = direction.x * 180.0
	projectile.velocity_y = direction.y * 180.0
	projectile.origin_x = source.world_x
	projectile.origin_y = source.world_y

func _spawn_kiki_projectile(source: EntityState) -> void:
	var projectile := _add_entity(_level_state, ENTITY_KIKI_PROJECTILE, source.world_x, source.world_y + 2.0)
	projectile.velocity_y = -120.0
	projectile.velocity_x = clampf((_player_state.world_x - source.world_x) * 0.5, -60.0, 60.0)
	projectile.state_timer = 1.4

func _split_kiki_projectile(projectile: EntityState) -> void:
	if not projectile.active:
		return
	projectile.active = false
	for direction in [-1.0, 1.0]:
		var piece := _add_entity(_level_state, ENTITY_KIKI_PIECE, projectile.world_x, projectile.world_y)
		piece.velocity_x = direction * 90.0
		piece.velocity_y = -220.0
		piece.state_timer = 0.85

func _spawn_balloon_projectile(source: EntityState) -> void:
	var projectile := _add_entity(_level_state, ENTITY_PROJECTILE, source.world_x, source.world_y + 22.0)
	projectile.velocity_x = 0.0
	projectile.velocity_y = 260.0
	projectile.origin_x = source.world_x
	projectile.origin_y = source.world_y

func _spawn_bullet_buzzer_projectiles(source: EntityState) -> void:
	var player_target := Vector2(_player_state.world_x, _player_state.world_y - 20.0)
	var source_position := Vector2(source.world_x, source.world_y)
	var direction := player_target - source_position
	if direction.length_squared() < 1.0:
		direction = Vector2(1.0, 0.0)
	direction = direction.normalized()
	for spread in [-0.18, 0.0, 0.18]:
		var projectile := _add_entity(_level_state, ENTITY_PROJECTILE, source.world_x, source.world_y + 14.0)
		var shot_direction := direction.rotated(spread)
		projectile.velocity_x = shot_direction.x * 220.0
		projectile.velocity_y = shot_direction.y * 220.0
		projectile.origin_x = source.world_x
		projectile.origin_y = source.world_y

func _update_platform_motion(delta: float) -> void:
	for platform in _level_state.platforms:
		if not platform.active:
			continue
		if platform.speeding_mode:
			if platform.speeding_wait_timer > 0.0:
				platform.speeding_wait_timer = maxf(0.0, platform.speeding_wait_timer - delta)
				continue
			if platform.speeding_returning:
				platform.x1 = move_toward(platform.x1, platform.speeding_base_x, 60.0 * delta)
				platform.x2 = platform.x1 + 54.0
				platform.top_y = move_toward(platform.top_y, platform.speeding_base_y, 60.0 * delta)
				platform.bottom_y = platform.top_y + platform.thickness
				if is_equal_approx(platform.x1, platform.speeding_base_x) and is_equal_approx(platform.top_y, platform.speeding_base_y):
					platform.speeding_returning = false
					platform.speeding_phase = 0
					platform.speeding_target_x = platform.speeding_first_x
					platform.speeding_target_y = platform.speeding_first_y
				continue
			if not platform.speeding_active:
				continue
			var old_speeding_x: float = platform.x1
			var old_speeding_y: float = platform.top_y
			platform.x1 = move_toward(platform.x1, platform.speeding_target_x - 27.0, 120.0 * delta)
			platform.x2 = platform.x1 + 54.0
			platform.top_y = move_toward(platform.top_y, platform.speeding_target_y, 120.0 * delta)
			platform.bottom_y = platform.top_y + platform.thickness
			if platform.speeding_player_attached:
				_player_state.world_x += platform.x1 - old_speeding_x
				_player_state.world_y += platform.top_y - old_speeding_y
			if is_equal_approx(platform.x1, platform.speeding_target_x - 27.0) and is_equal_approx(platform.top_y, platform.speeding_target_y):
				if platform.speeding_phase == 0:
					platform.speeding_phase = 1
					platform.speeding_target_x = platform.speeding_final_x
					platform.speeding_target_y = platform.speeding_final_y
				else:
					if platform.speeding_player_attached:
						_player_state.speed_x = 90.0
						_velocity_y = -18.0
						_player_state.speed_y = _velocity_y
						_player_state.is_grounded = false
					platform.speeding_player_attached = false
					platform.speeding_active = false
					platform.speeding_wait_timer = 1.0
					platform.speeding_returning = true
			continue
		if platform.arrow_mode:
			if not platform.arrow_active:
				continue
			var old_x1: float = platform.x1
			platform.x1 = move_toward(platform.x1, platform.arrow_target_x, platform.arrow_speed * delta)
			platform.x2 += platform.x1 - old_x1
			platform.top_y = move_toward(platform.top_y, platform.arrow_target_y, platform.arrow_speed * delta)
			platform.bottom_y = platform.top_y + platform.thickness
			if is_equal_approx(platform.x1, platform.arrow_target_x) and is_equal_approx(platform.top_y, platform.arrow_target_y):
				platform.arrow_active = false
			continue
		if platform.crumble_timer >= 0.0:
			if platform.crumble_phase == 1:
				platform.crumble_timer = maxf(0.0, platform.crumble_timer - delta)
				if platform.crumble_timer <= 0.0:
					platform.crumble_phase = 2
					platform.crumble_break_timer = 32.0 / 60.0
			elif platform.crumble_phase == 2:
				platform.crumble_break_timer = maxf(0.0, platform.crumble_break_timer - delta)
				if platform.crumble_break_timer <= 0.0:
					platform.crumble_phase = 3
					platform.active = false
					continue
		if not platform.moving:
			continue
		var old_x1: float = platform.x1
		var old_top_y: float = platform.top_y
		platform.motion_phase += platform.motion_speed * delta
		var offset: float = sin(platform.motion_phase) * platform.motion_amplitude
		if platform.motion_axis == 0:
			platform.x1 = old_x1 + (offset - sin(platform.motion_phase - platform.motion_speed * delta) * platform.motion_amplitude)
			platform.x2 = platform.x2 + (platform.x1 - old_x1)
		else:
			platform.top_y = old_top_y + (offset - sin(platform.motion_phase - platform.motion_speed * delta) * platform.motion_amplitude)
			platform.bottom_y = platform.top_y + platform.thickness
		var delta_x: float = platform.x1 - old_x1
		var delta_y: float = platform.top_y - old_top_y
		var player_bottom: float = _player_state.world_y + _player_half_height
		var player_top: float = _player_state.world_y - _player_half_height
		var was_over: bool = _player_state.world_x + _player_half_width > old_x1 and _player_state.world_x - _player_half_width < platform.x2 - delta_x
		var was_standing: bool = (not _gravity_inverted and absf(player_bottom - old_top_y) <= 6.0) or (_gravity_inverted and absf(player_top - (old_top_y + platform.thickness)) <= 6.0)
		if _player_state.is_grounded and was_over and was_standing:
			_player_state.world_x += delta_x
			_player_state.world_y += delta_y

func _resolve_platforms(previous_world_x: float, previous_world_y: float) -> void:
	var landed := false
	for entity in _level_state.entities:
		if not entity.active or entity.enemy_profile != 7:
			continue
		var player_left: float = _player_state.world_x - _player_half_width
		var player_right: float = _player_state.world_x + _player_half_width
		var player_top: float = _player_state.world_y - _player_half_height
		var player_bottom: float = _player_state.world_y + _player_half_height
		var old_top: float = entity.previous_world_y - entity.height * 0.5
		var current_top: float = entity.world_y - entity.height * 0.5
		var current_bottom: float = entity.world_y + entity.height * 0.5
		var overlaps_horizontally: bool = player_right > entity.world_x - entity.width * 0.5 and player_left < entity.world_x + entity.width * 0.5
		if not overlaps_horizontally:
			continue
		if not _gravity_inverted:
			if _player_state.is_grounded and absf(player_bottom - old_top) <= 6.0:
				_player_state.world_y += entity.world_y - entity.previous_world_y
			elif _velocity_y >= 0.0 and player_bottom >= current_top and previous_world_y + _player_half_height <= old_top:
				_player_state.world_y = current_top - _player_half_height
				_velocity_y = 0.0
				_player_state.speed_y = 0.0
				_player_state.is_grounded = true
				_player_state.char_state = 0
				landed = true
		else:
			if _player_state.is_grounded and absf(player_top - current_bottom) <= 6.0:
				_player_state.world_y += entity.world_y - entity.previous_world_y
			elif _velocity_y <= 0.0 and player_top <= current_bottom and previous_world_y - _player_half_height >= old_top + entity.height:
				_player_state.world_y = current_bottom + _player_half_height
				_velocity_y = 0.0
				_player_state.speed_y = 0.0
				_player_state.is_grounded = true
				_player_state.char_state = 0
				landed = true
	for platform in _level_state.platforms:
		if not platform.active:
			continue
		if platform.collision_layer >= 0 and platform.collision_layer != _player_layer:
			continue
		var player_left: float = _player_state.world_x - _player_half_width
		var player_right: float = _player_state.world_x + _player_half_width
		var player_top: float = _player_state.world_y - _player_half_height
		var player_bottom: float = _player_state.world_y + _player_half_height
		var prev_left: float = previous_world_x - _player_half_width
		var prev_right: float = previous_world_x + _player_half_width
		var prev_top: float = previous_world_y - _player_half_height
		var prev_bottom: float = previous_world_y + _player_half_height
		var platform_left: float = platform.x1
		var platform_right: float = platform.x2
		var platform_top: float = platform.top_y
		if platform.sloped and platform_right > platform_left:
			var slope_ratio := clampf((_player_state.world_x - platform_left) / (platform_right - platform_left), 0.0, 1.0)
			platform_top = lerpf(platform.slope_start_y, platform.slope_end_y, slope_ratio)
		var platform_bottom: float = platform_top + platform.thickness
		var overlaps_horizontally: bool = player_right > platform_left and player_left < platform_right
		var overlaps_vertically: bool = player_bottom > platform_top and player_top < platform_bottom

		if not _gravity_inverted:
			if _velocity_y >= 0.0 and overlaps_horizontally and prev_bottom <= platform_top and player_bottom >= platform_top:
				_player_state.world_y = platform_top - _player_half_height
				_velocity_y = 0.0
				_player_state.speed_y = 0.0
				_player_state.is_grounded = true
				_player_state.char_state = 0
				_set_surface_rotation(platform)
				_start_crumbling_platform(platform)
				if platform.arrow_mode:
					platform.arrow_active = true
				if platform.speeding_mode:
					platform.speeding_active = true
					platform.speeding_player_attached = true
				landed = true
				break

			if _velocity_y < 0.0 and overlaps_horizontally and prev_top >= platform_bottom and player_top <= platform_bottom:
				_player_state.world_y = platform_bottom + _player_half_height
				_velocity_y = 0.0
				_player_state.speed_y = 0.0
		else:
			if _velocity_y <= 0.0 and overlaps_horizontally and prev_top >= platform_bottom and player_top <= platform_bottom:
				_player_state.world_y = platform_bottom + _player_half_height
				_velocity_y = 0.0
				_player_state.speed_y = 0.0
				_player_state.is_grounded = true
				_player_state.char_state = 0
				_set_surface_rotation(platform)
				_start_crumbling_platform(platform)
				if platform.arrow_mode:
					platform.arrow_active = true
				if platform.speeding_mode:
					platform.speeding_active = true
					platform.speeding_player_attached = true
				landed = true
				break

			if _velocity_y > 0.0 and overlaps_horizontally and prev_bottom <= platform_top and player_bottom >= platform_top:
				_player_state.world_y = platform_top - _player_half_height
				_velocity_y = 0.0
				_player_state.speed_y = 0.0

		if overlaps_vertically and _player_state.is_grounded:
			if previous_world_x + _player_half_width <= platform_left and player_right >= platform_left:
				_player_state.world_x = platform_left - _player_half_width
			elif previous_world_x - _player_half_width >= platform_right and player_left <= platform_right:
				_player_state.world_x = platform_right + _player_half_width

	if not landed and not _gravity_inverted and _player_state.world_y >= _level_state.ground_y:
		_player_state.world_y = _level_state.ground_y
		_velocity_y = 0.0
		_player_state.speed_y = 0.0
		_player_state.is_grounded = true
		_player_state.char_state = 0
	if not landed and _gravity_inverted and _player_state.world_y <= _level_state.min_y + _player_half_height:
		_player_state.world_y = _level_state.min_y + _player_half_height
		_velocity_y = 0.0
		_player_state.speed_y = 0.0
		_player_state.is_grounded = true
		_player_state.char_state = 0

func _start_crumbling_platform(platform: PlatformState) -> void:
	if platform.crumble_delay < 0.0 or platform.crumble_phase != 0:
		return
	platform.crumble_timer = platform.crumble_delay
	platform.crumble_phase = 1

func _set_surface_rotation(platform: PlatformState) -> void:
	if not platform.sloped or platform.x2 <= platform.x1:
		_player_state.rotation = 0
		return
	var angle := rad_to_deg(atan2(platform.slope_end_y - platform.slope_start_y, platform.x2 - platform.x1))
	_player_state.rotation = int(clampf(angle / 5.0, -16.0, 16.0))

func _handle_fall_and_restart() -> void:
	var outside_bottom := not _gravity_inverted and _player_state.world_y > _level_state.max_y + 160.0
	var outside_top := _gravity_inverted and _player_state.world_y < _level_state.min_y - 160.0
	if not outside_bottom and not outside_top:
		return
	_player_state.lives = max(0, _player_state.lives - 1)
	if _player_state.lives == 0:
		_open_game_over()
	else:
		_respawn_player()

func _restart_level() -> void:
	_level_state = _build_level(_level_state.level_id)
	_respawn_x = _level_state.spawn_x
	_respawn_y = _level_state.spawn_y
	_checkpoint_time = 0.0
	_invincibility_timer = 0.0
	_reset_player()

func _respawn_player() -> void:
	_player_state.world_x = _respawn_x
	_player_state.world_y = _respawn_y
	_boost_position_history.clear()
	for i in range(16):
		_boost_position_history.append(Vector2(_respawn_x, _respawn_y))
	_elapsed_time = _checkpoint_time
	_velocity_y = 0.0
	_dash_timer = 0.0
	_dash_velocity_x = 0.0
	_dash_velocity_y = 0.0
	_grind_timer = 0.0
	_grind_velocity_x = 0.0
	_grind_end_x = 0.0
	_grind_y = 0.0
	_grind_end_mode = 0
	_gravity_inverted = false
	_pipe_active = false
	_pipe_timer = 0.0
	_pipe_target_entity = null
	_hook_active = false
	_hook_timer = 0.0
	_player_layer = 0
	_corkscrew_timer = 0.0
	_start_boost_timer = 0.0
	_boost_effect_timer = 0.0
	_attack_timer = 0.0
	_flight_timer = 0.0
	_glide_timer = 0.0
	_player_state.speed_x = 0.0
	_player_state.speed_y = 0.0
	_player_state.ground_speed = 0.0
	_player_state.is_grounded = true
	_player_state.char_state = 0
	_player_state.rotation = 0
	_player_state.rings = 0
	_player_state.special_rings = 0
	_player_state.shielded = false
	_invincibility_timer = 0.0
	_speed_up_timer = 0.0
	_magnetic_shielded = false
	_defeat_score_index = 0

func _open_game_over(time_over: bool = false) -> void:
	_game_state = GAME_STATE_GAME_OVER
	_player_state.is_alive = false
	_game_over_time_over = time_over
	_game_over_timer = TIME_OVER_DURATION_SECONDS if time_over else GAME_OVER_DURATION_SECONDS
	# game_over.c is an automatic cutscene; A/B do not alter its destination.
	_game_over_input_lock_timer = 0.0
	_status_text = "TIME OVER" if time_over else "GAME OVER"

func _handle_entity_interactions(held_input: int, frame_input: int, delta: float) -> void:
	for entity in _level_state.entities:
		if not entity.active:
			continue

		match entity.type:
			ENTITY_RING, ENTITY_SCATTER_RING:
				_try_collect_ring(entity)
			ENTITY_SPECIAL_RING:
				_try_collect_special_ring(entity)
			ENTITY_WHIRLWIND:
				_try_whirlwind(entity, delta)
			ENTITY_FAN:
				_try_fan(entity, held_input, delta)
			ENTITY_PROPELLER:
				_try_propeller(entity, held_input, delta)
			ENTITY_BOOSTER:
				_try_booster(entity, delta)
			ENTITY_DASH_RING:
				_try_dash_ring(entity, delta)
			ENTITY_GRIND_RAIL:
				_try_grind_rail(entity)
			ENTITY_GRAVITY_TOGGLE:
				_try_gravity_toggle(entity)
			ENTITY_NOTE_BLOCK:
				_try_note_block(entity)
			ENTITY_NOTE_SPHERE:
				_try_note_sphere(entity)
			ENTITY_BOUNCY_SPRING:
				_try_bouncy_spring(entity, delta)
			ENTITY_CONVEYOR:
				_try_conveyor(entity, delta)
			ENTITY_LAYER_TOGGLE:
				_try_layer_toggle(entity)
			ENTITY_RAMP:
				_try_ramp(entity, frame_input)
			ENTITY_ROTATING_HANDLE:
				_try_rotating_handle(entity, held_input, frame_input, delta)
			ENTITY_FLYING_HANDLE:
				_try_flying_handle(entity, frame_input)
			ENTITY_CORK_SCREW:
				_try_corkscrew(entity, frame_input, delta)
			ENTITY_CANNON:
				_try_cannon(entity, held_input, delta)
			ENTITY_LAUNCHER:
				_try_launcher(entity, frame_input, delta)
			ENTITY_PIPE_START:
				_try_pipe_start(entity, delta)
			ENTITY_HOOK_RAIL:
				_try_hook_rail(entity, frame_input, delta)
			ENTITY_SPIKES:
				_try_spikes(entity)
			ENTITY_SPIKE_PLATFORM:
				_try_spike_platform(entity)
			ENTITY_TURNAROUND_BAR:
				_try_turnaround_bar(entity)
			ENTITY_KEYBOARD:
				_try_keyboard(entity)
			ENTITY_POLE:
				_try_pole(entity, held_input, frame_input)
			ENTITY_LIGHT_GLOBE:
				_try_light_globe(entity)
			ENTITY_WINDUP_STICK:
				_try_windup_stick(entity, held_input)
			ENTITY_GERMAN_FLUTE:
				_try_german_flute(entity)
			ENTITY_SMALL_WINDMILL:
				_try_small_windmill(entity)
			ENTITY_CHORD:
				_try_chord(entity)
			ENTITY_HALF_PIPE:
				_try_half_pipe(entity)
			ENTITY_IRON_BALL:
				_try_iron_ball(entity)
			ENTITY_CRANE:
				_try_crane(entity)
			ENTITY_CEILING_SLOPE:
				_try_ceiling_slope(entity)
			ENTITY_GAPPED_LOOP:
				_try_gapped_loop(entity)
			ENTITY_FUNNEL_SPHERE:
				_try_funnel_sphere(entity)
			ENTITY_MUSIC_ENTRY:
				_try_music_entry(entity)
			ENTITY_DAMAGE_REGION:
				_try_damage_region(entity)
			ENTITY_ITEM_BOX:
				_try_item_box(entity)
			ENTITY_SPRING:
				_try_bounce_from_spring(entity, delta)
			ENTITY_ENEMY, ENTITY_BUZZER:
				_try_hit_enemy(entity)
			ENTITY_BALLOON:
				_try_hit_enemy(entity)
			ENTITY_BULLET_BUZZER:
				_try_hit_enemy(entity)
			ENTITY_KOURA:
				_try_koura(entity)
			ENTITY_STAR:
				_try_star(entity)
			ENTITY_KIKI:
				_try_hit_enemy(entity)
			ENTITY_KIKI_PROJECTILE, ENTITY_KIKI_PIECE:
				_try_projectile(entity)
			ENTITY_BOSS:
				_try_boss(entity)
			ENTITY_PROJECTILE:
				_try_projectile(entity)
			ENTITY_CHECKPOINT:
				_try_activate_checkpoint(entity)
			ENTITY_GOAL:
				_try_reach_goal(entity)
			ENTITY_LAP_TRIGGER:
				_try_lap_trigger(entity)
			ENTITY_GOAL_LEVER:
				_try_goal_lever(entity)

func _try_lap_trigger(entity: EntityState) -> void:
	# The source task only evaluates a crossing after the player leaves the trigger.
	var player_x := _player_state.world_x
	var inside := absf(player_x - entity.world_x) <= entity.width * 0.5 and absf(_player_state.world_y - entity.world_y) <= entity.height * 0.5
	if not _player_state.is_alive:
		entity.lap_count = entity.lap_highest
	if inside:
		entity.lap_touching = true
		return
	if entity.lap_touching:
		entity.lap_touching = false
		if entity.lap_previous_player_x < entity.world_x - entity.width * 0.5 and player_x > entity.world_x + entity.width * 0.5:
			if entity.lap_passed:
				entity.lap_count += 1
				if entity.lap_highest < entity.lap_count:
					entity.lap_highest = entity.lap_count
					var time_diff := _checkpoint_time - entity.lap_previous_checkpoint_time
					var bonus := 5 if time_diff > 30.0 else (10 if time_diff > 20.0 else 15)
					entity.lap_last_bonus = bonus
					_add_ring_reward(bonus)
					if _run_from_multiplayer:
						_player_state.rings = mini(255, _player_state.rings)
					_status_text = "RING BONUS +%d" % bonus
					entity.lap_previous_checkpoint_time = _checkpoint_time
			else:
				entity.lap_passed = true
				entity.lap_previous_checkpoint_time = _checkpoint_time
		elif entity.lap_previous_player_x > entity.world_x + entity.width * 0.5 and player_x < entity.world_x - entity.width * 0.5:
			if entity.lap_passed:
				entity.lap_count -= 1
	entity.lap_previous_player_x = player_x

func _try_goal_lever(entity: EntityState) -> void:
	if entity.activated or not _player_state.is_alive:
		return
	var dx := absf(_player_state.world_x - entity.world_x)
	var dy := absf((_player_state.world_y - 20.0) - entity.world_y)
	if dx < 28.0 and dy < 64.0:
		# stage_goal.c changes the lever animation; TOGGLE__GOAL owns the clear.
		entity.activated = true
		entity.collected = true


func _try_collect_ring(entity: EntityState) -> void:
	var dx: float = _player_state.world_x - entity.world_x
	var dy: float = (_player_state.world_y - 20.0) - entity.world_y
	var collect_radius := 92.0 if _magnetic_shielded else 20.0
	if dx * dx + dy * dy <= collect_radius * collect_radius:
		_spawn_ring_collection_effect(entity.world_x, entity.world_y)
		entity.active = false
		entity.collected = true
		_add_ring_reward(1)

func _spawn_ring_collection_effect(x: float, y: float) -> void:
	var active_effects := 0
	for existing in _level_state.entities:
		if existing.type == ENTITY_RING_EFFECT and existing.active:
			active_effects += 1
	if active_effects >= _ring_effect_limit:
		return
	var effect := _add_entity(_level_state, ENTITY_RING_EFFECT, x, y)
	effect.origin_x = x
	effect.origin_y = y
	effect.state_timer = 0.0

func _spawn_scattered_rings(count: int) -> void:
	var scatter_count := mini(32, count)
	for i in range(scatter_count):
		var entity := _add_entity(_level_state, ENTITY_SCATTER_RING, _player_state.world_x, _player_state.world_y - 20.0)
		var angle := -PI * 0.5 + float(i) * TAU / float(maxi(1, scatter_count))
		var speed := 150.0 + float(i % 4) * 24.0
		entity.velocity_x = cos(angle) * speed
		entity.velocity_y = sin(angle) * speed - 60.0
		entity.state_timer = 2.8

func _try_collect_special_ring(entity: EntityState) -> void:
	if _run_from_multiplayer or entity.special_ring_collected:
		return
	var dx: float = _player_state.world_x - entity.world_x
	var dy: float = (_player_state.world_y - 20.0) - entity.world_y
	if dx * dx + dy * dy <= 24.0 * 24.0:
		entity.special_ring_collected = true
		entity.special_ring_collect_timer = 30.0 / 60.0
		entity.state_timer = entity.special_ring_collect_timer
		entity.collected = true
		_player_state.special_rings = min(7, _player_state.special_rings + 1)

func _update_special_ring_motion(entity: EntityState, delta: float) -> void:
	if not entity.special_ring_collected:
		return
	entity.special_ring_collect_timer = maxf(0.0, entity.special_ring_collect_timer - delta)
	entity.state_timer = entity.special_ring_collect_timer
	if entity.special_ring_collect_timer <= 0.000001:
		entity.active = false

func _add_score(amount: int) -> void:
	if amount <= 0:
		return
	var old_score := _player_state.score
	_player_state.score += amount
	var old_score_bands := old_score / 50000
	var new_score_bands := _player_state.score / 50000
	if new_score_bands > old_score_bands and not _run_from_time_attack and not _run_from_multiplayer:
		_player_state.lives = mini(255, _player_state.lives + (new_score_bands - old_score_bands))

func _award_enemy_defeat_score() -> void:
	var defeat_scores: Array = [100, 200, 400, 800, 1000]
	var score_index := clampi(_defeat_score_index, 0, defeat_scores.size() - 1)
	_add_score(int(defeat_scores[score_index]))
	_defeat_score_index = mini(defeat_scores.size() - 1, score_index + 1)

func _try_whirlwind(entity: EntityState, delta: float) -> void:
	var half_width := entity.width * 0.5
	var half_height := entity.height * 0.5
	var dx := _player_state.world_x - entity.world_x
	var dy := _player_state.world_y - entity.world_y
	if not entity.whirlwind_active and entity.whirlwind_release_latch:
		if absf(dx) > half_width or absf(dy) > half_height:
			entity.whirlwind_release_latch = false
		else:
			return
	if not entity.whirlwind_active and (absf(dx) > half_width or absf(dy) > half_height):
		return
	if not entity.whirlwind_active:
		# whirlwind.c gives the player a bounded scripted state, rather than a
		# permanent upward impulse while the hitbox happens to overlap.
		entity.whirlwind_active = true
		entity.whirlwind_timer = 64.0 / 60.0
		_velocity_y = minf(_velocity_y, -180.0)
	entity.whirlwind_timer = maxf(0.0, entity.whirlwind_timer - delta)
	var outside_current := absf(dx) > half_width + 20.0 or _player_state.world_y < entity.world_y - half_height - 20.0
	if entity.whirlwind_timer <= 0.000001 or outside_current:
		entity.whirlwind_active = false
		entity.whirlwind_timer = 0.0
		entity.whirlwind_release_latch = true
		_velocity_y = -180.0
		_player_state.char_state = 2
		_player_state.anim_id = 2
		return
	# The source uses a gradually increasing horizontal pull and caps the
	# vertical speed while the player remains inside the scripted current.
	_player_state.world_x = move_toward(_player_state.world_x, entity.world_x, 180.0 * delta)
	_velocity_y = move_toward(_velocity_y, -300.0, 15.0 * delta * 60.0)
	_player_state.world_y = move_toward(_player_state.world_y, entity.world_y - half_height + _player_half_height, 120.0 * delta)
	_player_state.is_grounded = false
	_player_state.char_state = 3
	_player_state.anim_id = 2

func _try_fan(entity: EntityState, held_input: int, delta: float) -> void:
	var half_width := entity.width * 0.5
	var half_height := entity.height * 0.5
	var dx := _player_state.world_x - entity.world_x
	var dy := _player_state.world_y - entity.world_y
	if absf(dx) > half_width or absf(dy) > half_height:
		return
	var fan_force := entity.fan_speed
	if fan_force <= 0.000001:
		return
	var player_ratio := (dx + half_width) / maxf(1.0, entity.width)
	if entity.velocity_x < 0.0:
		player_ratio = 1.0 - player_ratio
	player_ratio = clampf(player_ratio, 0.0, 1.0)
	var player_delta_per_frame := player_ratio * 16.0 * fan_force
	var moving_with_fan := (entity.velocity_x < 0.0 and _player_state.speed_x < 0.0) or (entity.velocity_x > 0.0 and _player_state.speed_x > 0.0)
	if moving_with_fan:
		_player_state.speed_x = clampf(_player_state.speed_x + entity.velocity_x * 15.0 * fan_force, -540.0, 540.0)
		_player_state.ground_speed = _player_state.speed_x
	else:
		_player_state.world_x += entity.velocity_x * player_delta_per_frame * delta * 60.0
		var boundary := entity.world_x + (half_width - 48.0 if entity.velocity_x < 0.0 else -half_width + 48.0)
		if entity.velocity_x < 0.0:
			_player_state.world_x = minf(_player_state.world_x, boundary) if entity.variant == 0 else _player_state.world_x
		else:
			_player_state.world_x = maxf(_player_state.world_x, boundary) if entity.variant == 0 else _player_state.world_x
		_player_state.speed_x = entity.velocity_x * player_delta_per_frame * 60.0
		_player_state.ground_speed = _player_state.speed_x
	if entity.velocity_x < 0.0 and held_input & DPAD_RIGHT:
		_player_state.speed_x = -absf(_player_state.speed_x)
	elif entity.velocity_x > 0.0 and held_input & DPAD_LEFT:
		_player_state.speed_x = -absf(_player_state.speed_x)

func _try_propeller(entity: EntityState, held_input: int, delta: float) -> void:
	var half_width := entity.width * 0.5
	var half_height := entity.height * 0.5
	var dx := _player_state.world_x - entity.world_x
	var dy := _player_state.world_y - entity.world_y
	var in_current := absf(dx) <= half_width and absf(dy) <= half_height

	if entity.variant == 1:
		var in_vertical_current := _player_state.world_y >= entity.world_y - 96.0 and _player_state.world_y <= entity.world_y + 64.0
		if not in_current or not in_vertical_current:
			entity.variant = 0
			_velocity_y = -120.0 if entity.propeller_phase_units <= 128.0 else 0.0
			_player_state.speed_y = _velocity_y
			_player_state.char_state = 2
			_player_state.anim_id = 2
			return
		if _player_state.world_y > entity.world_y - 48.0:
			_player_state.world_y = move_toward(_player_state.world_y, entity.world_y - 48.0, 240.0 * delta)
			_velocity_y = 0.0
			_player_state.is_grounded = false
			_player_state.char_state = 4
			_player_state.anim_id = 2
			return
		entity.variant = 2
		entity.propeller_phase_units = 0.0
		if _player_state.speed_x >= 1.0:
			entity.propeller_horizontal_step = 2.0
		elif _player_state.speed_x < 0.0:
			entity.propeller_horizontal_step = -2.0
		else:
			entity.propeller_horizontal_step = -0.125 if _facing_direction < 0.0 else 0.125
	if entity.variant == 2:
		var active_vertical_current := _player_state.world_y >= entity.world_y - 96.0 and _player_state.world_y <= entity.world_y + 64.0
		if absf(dx) > half_width or not active_vertical_current:
			entity.variant = 0
			_player_state.char_state = 2
			_player_state.anim_id = 2
			_velocity_y = -120.0 if entity.propeller_phase_units <= 128.0 else 0.0
			_player_state.speed_y = _velocity_y
			return
		var steering := 0.0
		if held_input & DPAD_LEFT:
			steering -= 1.0
		if held_input & DPAD_RIGHT:
			steering += 1.0
		if steering != 0.0:
			entity.propeller_horizontal_step = move_toward(entity.propeller_horizontal_step, steering * 2.0, 1.0 * delta * 60.0)
		elif absf(entity.propeller_horizontal_step) < 0.125:
			entity.propeller_horizontal_step = -0.125 if entity.propeller_horizontal_step < 0.0 else 0.125
		entity.propeller_horizontal_step = clampf(entity.propeller_horizontal_step, -2.0, 2.0)
		_player_state.world_x += entity.propeller_horizontal_step * delta * 60.0
		_player_state.world_x = clampf(_player_state.world_x, _level_state.min_x, _level_state.max_x)
		_player_state.world_y -= entity.propeller_vertical_step * delta * 60.0
		entity.propeller_phase_units = fmod(entity.propeller_phase_units - 4.0 + 1024.0, 1024.0)
		entity.propeller_vertical_step = sin(entity.propeller_phase_units * 4.0 * TAU / 1024.0) * 16.0
		_velocity_y = 0.0
		_player_state.is_grounded = false
		_player_state.speed_x = entity.propeller_horizontal_step * 60.0
		_player_state.speed_y = 0.0
		_player_state.char_state = 4
		_player_state.anim_id = 2
		return

	if in_current:
		entity.variant = 1
		entity.propeller_horizontal_step = 0.0
		entity.propeller_vertical_step = 0.0
		entity.propeller_phase_units = 0.0
		_velocity_y = 0.0
		_player_state.is_grounded = false
		_player_state.char_state = 4
		_player_state.anim_id = 2

func _try_booster(entity: EntityState, delta: float) -> void:
	if not _player_state.is_grounded:
		return
	var half_width := entity.width * 0.5
	var half_height := entity.height * 0.5
	var dx := absf(_player_state.world_x - entity.world_x)
	var dy := absf(_player_state.world_y - entity.world_y)
	if dx > half_width + 14.0 or dy > half_height + 20.0:
		return
	# booster.c clamps qSpeedGround to +/-3072, or 12 pixels per GBA frame.
	var boost_speed := 720.0 * signf(entity.velocity_x)
	_player_state.world_x += boost_speed * delta
	_boost_effect_timer = 0.45
	_player_state.speed_x = boost_speed
	_player_state.ground_speed = boost_speed
	_player_state.anim_id = 1
	entity.activated = true

func _try_dash_ring(entity: EntityState, delta: float) -> void:
	var dx := _player_state.world_x - entity.world_x
	var dy := (_player_state.world_y - 20.0) - entity.world_y
	var in_ring := absf(dx) <= 24.0 and absf(dy) <= 24.0
	if not in_ring:
		entity.activated = false
		return
	if entity.activated or _dash_timer > 0.0:
		return
	var angle := -PI * 0.5 + float(entity.variant) * PI * 0.25
	_dash_velocity_x = cos(angle) * 480.0
	_dash_velocity_y = sin(angle) * 480.0
	_dash_timer = 0.85
	_boost_effect_timer = 0.85
	_player_state.world_x = entity.world_x
	_player_state.world_y = entity.world_y
	_player_state.speed_x = _dash_velocity_x
	_player_state.speed_y = _dash_velocity_y
	_player_state.is_grounded = false
	_player_state.char_state = 5
	_player_state.anim_id = 2
	entity.activated = true

func _try_grind_rail(entity: EntityState) -> void:
	if _grind_timer > 0.0 or _dash_timer > 0.0 or not entity.rail_is_start:
		return
	var half_width := entity.width * 0.5
	var dx := _player_state.world_x - entity.world_x
	var dy := _player_state.world_y - entity.world_y
	if absf(dx) > half_width or dy < -32.0 or dy > 28.0:
		return
	if entity.rail_air_start:
		if _player_state.is_grounded or _velocity_y < 0.0:
			return
	else:
		if not _player_state.is_grounded or _velocity_y < 0.0:
			return
	if entity.rail_direction > 0.0 and _player_state.world_x > entity.world_x + half_width * 0.5:
		return
	if entity.rail_direction < 0.0 and _player_state.world_x < entity.world_x - half_width * 0.5:
		return
	_grind_timer = 12.0
	_grind_velocity_x = 240.0 * entity.rail_direction
	_grind_end_x = entity.world_x + entity.rail_direction * half_width
	_grind_y = entity.world_y
	_grind_end_mode = entity.rail_end_mode
	_player_state.world_y = _grind_y
	_player_state.speed_x = _grind_velocity_x
	_player_state.speed_y = 0.0
	_player_state.is_grounded = false
	_player_state.char_state = 6
	_spawn_grind_effect()

func _try_gravity_toggle(entity: EntityState) -> void:
	var inside := absf(_player_state.world_x - entity.world_x) <= entity.width * 0.5 and absf(_player_state.world_y - entity.world_y) <= entity.height * 0.5
	if not inside:
		entity.flag_active = false
		return
	if entity.flag_active:
		return
	match entity.gravity_kind:
		GRAVITY_KIND_DOWN:
			_gravity_inverted = false
		GRAVITY_KIND_UP:
			_gravity_inverted = true
		GRAVITY_KIND_TOGGLE:
			_gravity_inverted = not _gravity_inverted
	entity.flag_active = true
	entity.activated = _gravity_inverted
	_velocity_y = 0.0
	_player_state.is_grounded = false
	_player_state.char_state = 1

func _try_bouncy_spring(entity: EntityState, delta: float) -> void:
	if entity.variant == 2:
		if not entity.activated and (_velocity_y <= 0.0 or _player_state.world_y + 4.0 >= entity.world_y):
			return
		var bar_inside := absf(_player_state.world_x - entity.world_x) <= entity.width * 0.5 and absf(_player_state.world_y - entity.world_y) <= entity.height * 0.5 + _player_half_height
		if not bar_inside:
			entity.activated = false
			entity.state_timer = 0.0
			return
		if not entity.activated:
			entity.activated = true
			entity.bouncy_landing_speed = clampi(int(_velocity_y / 240.0), 0, 2)
			entity.bouncy_launch_frame = entity.bouncy_landing_speed * 5 + 10
			entity.bouncy_landing_position = absf(_player_state.world_x - entity.world_x)
			entity.state_timer = float(entity.bouncy_launch_frame) / 60.0
			_velocity_y = 0.0
			_player_state.is_grounded = false
		if entity.state_timer > 0.0:
			entity.state_timer = maxf(0.0, entity.state_timer - delta)
			_player_state.world_y = entity.world_y - entity.height * 0.5 - 1.0
			if entity.state_timer <= 0.0:
				var launch_factor := minf(24.0, entity.bouncy_landing_position * 0.75)
				var launch_bonus := minf(180.0, launch_factor * (16.0 + entity.bouncy_landing_speed * 2.0) * entity.bouncy_spring_stiffness / 18.0)
				_velocity_y = -540.0 - launch_bonus
				_player_state.char_state = 2
				entity.activated = false
			return
	var gravity_direction := -1.0 if _gravity_inverted else 1.0
	if _velocity_y * gravity_direction < 0.0:
		return
	var half_width := entity.width * 0.5
	var half_height := entity.height * 0.5
	var player_left := _player_state.world_x - 14.0
	var player_right := _player_state.world_x + 14.0
	var player_top := _player_state.world_y - 40.0
	var player_bottom := _player_state.world_y
	var in_bounce_area := player_right >= entity.world_x - half_width and player_left <= entity.world_x + half_width and player_bottom >= entity.world_y - half_height and player_top <= entity.world_y + half_height
	if not in_bounce_area:
		entity.activated = false
		return
	if entity.activated:
		return
	var rebound := clampf(maxf(450.0, absf(_velocity_y) * entity.bounce_strength), 450.0, 720.0)
	_velocity_y = -rebound * gravity_direction
	_player_state.world_y = entity.world_y - half_height - 1.0 if not _gravity_inverted else entity.world_y + half_height + 1.0
	_player_state.is_grounded = false
	_player_state.char_state = 2
	_player_state.anim_id = 2
	entity.activated = true

func _try_conveyor(entity: EntityState, delta: float) -> void:
	if not _player_state.is_grounded:
		return
	var inside := absf(_player_state.world_x - entity.world_x) <= entity.width * 0.5 and absf(_player_state.world_y - entity.world_y) <= entity.height * 0.5 + _player_half_height
	if not inside:
		return
	_player_state.world_x += entity.surface_speed * delta
	_player_state.speed_x = entity.surface_speed
	_player_state.ground_speed = entity.surface_speed

func _try_layer_toggle(entity: EntityState) -> void:
	var inside := absf(_player_state.world_x - entity.world_x) <= entity.width * 0.5 and absf(_player_state.world_y - entity.world_y) <= entity.height * 0.5
	if not inside:
		entity.flag_active = false
		return
	if entity.flag_active:
		return
	_player_layer = entity.variant & 1
	entity.flag_active = true
	entity.activated = _player_layer == 1
	_status_text = "PLAYER LAYER: %s" % ("BACK" if _player_layer == 1 else "FRONT")

func _try_ramp(entity: EntityState, frame_input: int) -> void:
	var half_width := maxf(48.0, entity.width * 0.5)
	var half_height := maxf(28.0, entity.height * 0.5)
	var dx := _player_state.world_x - entity.world_x
	var inside := absf(dx) <= half_width and absf(_player_state.world_y - entity.world_y) <= half_height + _player_half_height
	var direction := -1.0 if (entity.variant & 1) != 0 else 1.0
	var moving_with_ramp := _player_state.speed_x * direction > 120.0
	if entity.ramp_incline:
		if not inside:
			entity.activated = false
			return
		if not _player_state.is_grounded or not moving_with_ramp:
			return
		_velocity_y = -180.0
		_player_state.speed_x = 1020.0 * direction
		_player_state.ground_speed = _player_state.speed_x
		_player_state.is_grounded = false
		_player_state.char_state = 2
		entity.activated = true
		return
	if not inside:
		if entity.activated and _player_state.is_grounded and moving_with_ramp:
			_launch_ramp(entity, direction)
		entity.activated = false
		return
	if not _player_state.is_grounded or not moving_with_ramp:
		entity.activated = false
		return
	if frame_input & A_BUTTON:
		_launch_ramp(entity, direction)
		return
	# ramp.c keeps the player stood on the slope until its exit transition.
	_player_state.world_y = entity.world_y - half_height - 1.0
	_player_state.speed_y = 0.0
	_velocity_y = 0.0
	_player_state.ground_speed = _player_state.speed_x
	entity.activated = true

func _launch_ramp(entity: EntityState, direction: float) -> void:
	_velocity_y = -330.0
	_player_state.speed_x = maxf(absf(_player_state.speed_x), 300.0) * direction
	_player_state.ground_speed = _player_state.speed_x
	_player_state.is_grounded = false
	_player_state.char_state = 5
	entity.activated = false

func _update_flying_handle_state(delta: float) -> void:
	for entity in _level_state.entities:
		if not entity.active or not entity.flying_handle:
			continue
		entity.flying_handle_cooldown = maxf(0.0, entity.flying_handle_cooldown - delta)
		entity.flying_handle_phase = fmod(entity.flying_handle_phase + delta * 60.0 * 0.015625 * TAU, TAU)
		if entity.activated:
			entity.flying_handle_speed_y = minf(180.0, entity.flying_handle_speed_y + 225.0 * delta)
			entity.world_y -= entity.flying_handle_speed_y * delta
			if entity.world_y <= entity.flying_handle_top_y:
				entity.world_y = entity.flying_handle_top_y
				entity.flying_handle_speed_y = 0.0
			entity.effect_offset = sin(entity.flying_handle_phase) * 8.0
			_player_state.world_x = entity.world_x
			_player_state.world_y = entity.world_y
			_player_state.is_grounded = false
		else:
			entity.world_y = entity.flying_handle_bottom_y
			entity.effect_offset = sin(entity.flying_handle_phase) * 8.0

func _try_flying_handle(entity: EntityState, frame_input: int) -> void:
	if entity.activated:
		_player_state.world_x = entity.world_x
		_player_state.world_y = entity.world_y
		_player_state.is_grounded = false
		_player_state.speed_x = 0.0
		_velocity_y = 0.0
		_player_state.speed_y = 0.0
		_player_state.char_state = 8
		if entity.flying_handle_cooldown <= 0.0 and frame_input & A_BUTTON:
			entity.activated = false
			entity.flying_handle_cooldown = 0.5
			_velocity_y = -_jump_speed
			_player_state.speed_y = _velocity_y
			_player_state.char_state = 5
		return
	var dx := _player_state.world_x - entity.world_x
	var dy := _player_state.world_y - entity.world_y
	if dx * dx + dy * dy > 16.0 * 16.0 or _player_state.is_grounded:
		return
	entity.activated = true
	entity.flying_handle_cooldown = 0.5
	entity.flying_handle_speed_y = -90.0
	_player_state.world_x = entity.world_x
	_player_state.world_y = entity.world_y
	_player_state.is_grounded = false
	_player_state.speed_x = 0.0
	_velocity_y = 0.0
	_player_state.char_state = 8

func _try_rotating_handle(entity: EntityState, _held_input: int, frame_input: int, delta: float) -> void:
	var dx := _player_state.world_x - entity.world_x
	var dy := _player_state.world_y - entity.world_y
	if entity.activated:
		if not _player_state.is_alive:
			entity.activated = false
			return
		# rotating_handle.c advances the handle from the player's incoming air
		# speed and keeps the player centered until the jump transition releases it.
		entity.rotating_handle_angle = fmod(entity.rotating_handle_angle + entity.rotating_handle_speed * delta, TAU)
		entity.effect_offset = entity.rotating_handle_angle
		# rotating_handle.c selects one of twelve sprite variants from rot>>4.
		entity.variant = clampi(int(fposmod(entity.rotating_handle_angle, TAU) / TAU * 1024.0) >> 4, 0, 11)
		_player_state.world_x = entity.world_x
		_player_state.world_y = entity.world_y
		_player_state.speed_x = 0.0
		_player_state.speed_y = 0.0
		_velocity_y = 0.0
		_player_state.is_grounded = false
		_player_state.char_state = 5
		if frame_input & A_BUTTON:
			# Match the source's four quadrant-specific release offsets. The GBA
			# implementation computes these in 10-bit trig units; radians are
			# equivalent here while keeping the existing Godot velocity scale.
			var angle_units := fposmod(entity.rotating_handle_angle, TAU) / TAU * 1024.0
			var release_units := angle_units
			match entity.rotating_handle_quartile:
				0:
					release_units = 32.0 - angle_units
				1:
					release_units = angle_units + 32.0
				2:
					release_units = angle_units - 32.0
				3:
					release_units = 544.0 - angle_units
			var release_angle := release_units * TAU / 1024.0
			var tangent := Vector2(cos(release_angle), sin(release_angle))
			entity.activated = false
			entity.state_timer = 0.0
			_player_state.speed_x = tangent.x * 300.0
			_velocity_y = tangent.y * 300.0
			_player_state.speed_y = _velocity_y
			_player_state.ground_speed = _player_state.speed_x
			_player_state.char_state = 1
		return
	if absf(dx) > 42.0 or absf(dy) > 42.0 or _player_state.is_grounded:
		return
	entity.activated = true
	entity.state_timer = 0.0
	entity.rotating_handle_angle = 0.0
	entity.effect_offset = 0.0
	entity.rotating_handle_speed = clampf(absf(_player_state.speed_x) + absf(_velocity_y), 220.0, 384.0)
	if _player_state.speed_x >= 0.0:
		entity.rotating_handle_quartile = 0 if _player_state.world_y > entity.world_y else 1
	else:
		entity.rotating_handle_quartile = 2 if _player_state.world_y > entity.world_y else 3
	_player_state.world_x = entity.world_x
	_player_state.world_y = entity.world_y
	_velocity_y = 0.0
	_player_state.speed_x = 0.0
	_player_state.speed_y = 0.0

func _try_corkscrew(entity: EntityState, frame_input: int, delta: float) -> void:
	var direction := 1.0 if entity.variant == 0 else -1.0
	if _corkscrew_active_entity != null and _corkscrew_active_entity != entity:
		return

	if entity.activated:
		if not _player_state.is_alive:
			_corkscrew_stop(entity, false)
			return
		var relative := (_player_state.world_x - entity.world_x) * direction
		var speed := _player_state.speed_x
		if relative > 560.0 or speed * direction < 120.0:
			_corkscrew_stop(entity, false)
			return
		_player_state.world_x += speed * delta
		relative = (_player_state.world_x - entity.world_x) * direction
		var angle := relative * 930.0 / 1024.0 * TAU
		_player_state.world_y = entity.world_y - 28.0 + sin(angle) * 24.0
		_player_state.speed_y = 0.0
		_velocity_y = 0.0
		_player_state.is_grounded = false
		_player_state.char_state = 5
		if frame_input & A_BUTTON:
			_player_state.speed_y = -292.5
			_velocity_y = _player_state.speed_y
			_corkscrew_stop(entity, true)
		elif frame_input & DPAD_DOWN:
			_player_state.char_state = 6
		return

	var dx := _player_state.world_x - entity.world_x
	var dy := _player_state.world_y - entity.world_y
	var half_width := maxf(48.0, entity.width * 0.5)
	var half_height := maxf(48.0, entity.height * 0.5)
	var is_correct_side := dx >= 0.0 if entity.variant == 0 else dx <= 0.0
	if absf(dx) > half_width or absf(dy) > half_height or not is_correct_side:
		entity.activated = false
		return
	if not _player_state.is_grounded or (_player_state.speed_x * direction) < 120.0 or frame_input & A_BUTTON:
		entity.activated = false
		return
	entity.activated = true
	_corkscrew_active_entity = entity
	_corkscrew_timer = 1.0
	_corkscrew_origin = Vector2(entity.world_x, entity.world_y)
	_corkscrew_direction = direction

func _corkscrew_stop(entity: EntityState, jumped: bool) -> void:
	entity.activated = false
	if _corkscrew_active_entity == entity:
		_corkscrew_active_entity = null
	_corkscrew_timer = 0.0
	_player_state.char_state = 1
	_player_state.ground_speed = _player_state.speed_x
	if not jumped:
		_player_state.speed_y = 0.0

func _try_cannon(entity: EntityState, held_input: int, delta: float) -> void:
	var dx := _player_state.world_x - entity.world_x
	var dy := _player_state.world_y - entity.world_y
	if entity.cannon_loading:
		_player_state.world_x = move_toward(_player_state.world_x, entity.world_x, 60.0 * delta)
		_player_state.world_y = move_toward(_player_state.world_y, entity.world_y, 60.0 * delta)
		_player_state.speed_x = 0.0
		_player_state.speed_y = 0.0
		_velocity_y = 0.0
		_player_state.char_state = 5
		if is_equal_approx(_player_state.world_x, entity.world_x) and is_equal_approx(_player_state.world_y, entity.world_y):
			entity.cannon_loading = false
			entity.cannon_active = true
			entity.cannon_timer = 0.0
			entity.cannon_aim_phase = 1 if entity.cannon_facing_right else 0
		return
	if entity.cannon_active:
		entity.cannon_timer += delta
		var aim_targets := [
			(PI * 5.0 / 4.0) if not entity.cannon_facing_right else (PI * 0.25),
			(PI * 0.75) if not entity.cannon_facing_right else (PI * 1.75),
		]
		var target_angle: float = aim_targets[entity.cannon_aim_phase]
		var angle_delta := wrapf(target_angle - entity.cannon_angle, -PI, PI)
		var angle_step := 4.0 * TAU / 1024.0
		if absf(angle_delta) < 5.0 * TAU / 1024.0:
			entity.cannon_angle = target_angle
			entity.cannon_aim_phase = 1 - entity.cannon_aim_phase
		else:
			entity.cannon_angle = fmod(entity.cannon_angle + signf(angle_delta) * angle_step + TAU, TAU)
		_player_state.world_x = entity.world_x - (40.0 if entity.cannon_facing_right else -40.0)
		_player_state.world_y = entity.world_y
		_player_state.speed_x = 0.0
		_player_state.speed_y = 0.0
		_velocity_y = 0.0
		_player_state.is_grounded = false
		_player_state.char_state = 5
		if held_input & (A_BUTTON | B_BUTTON) or entity.cannon_timer >= 512.0 / 60.0:
			var launch_direction := Vector2(cos(entity.cannon_angle), sin(entity.cannon_angle))
			if _gravity_inverted:
				launch_direction.y = -launch_direction.y
			_player_state.world_x = entity.world_x + launch_direction.x * 32.0
			_player_state.world_y = entity.world_y + launch_direction.y * 32.0
			_player_state.speed_x = launch_direction.x * 900.0
			_velocity_y = launch_direction.y * 900.0
			_player_state.speed_y = _velocity_y
			_player_state.ground_speed = _player_state.speed_x
			_player_state.rotation = int(launch_direction.y * 32.0)
			_player_state.is_grounded = false
			_player_state.char_state = 1
			entity.cannon_active = false
			entity.cannon_timer = 0.0
		return
	if absf(dx) > 44.0 or absf(dy) > 44.0:
		return
	entity.cannon_loading = true
	entity.cannon_timer = 0.0
	_player_state.speed_x = 0.0
	_player_state.speed_y = 0.0
	_velocity_y = 0.0

func _try_launcher(entity: EntityState, frame_input: int, delta: float) -> void:
	if entity.launcher_wait_timer > 0.0:
		entity.launcher_wait_timer = maxf(0.0, entity.launcher_wait_timer - delta)
		return
	if entity.launcher_returning:
		entity.launcher_cart_x = move_toward(entity.launcher_cart_x, entity.launcher_base_x, 60.0 * entity.launcher_scale * delta)
		entity.world_x = entity.launcher_cart_x
		if is_equal_approx(entity.launcher_cart_x, entity.launcher_base_x):
			entity.launcher_returning = false
		return
	if entity.launcher_active:
		entity.launcher_cart_x = move_toward(entity.launcher_cart_x, entity.launcher_target_x, 900.0 * entity.launcher_scale * delta)
		entity.world_x = entity.launcher_cart_x
		var vertical_sign := -1.0 if entity.launcher_gravity_up else 1.0
		_player_state.world_x = entity.launcher_cart_x + entity.launcher_direction * 8.0 * entity.launcher_scale
		_player_state.world_y = entity.launcher_cart_y - vertical_sign * 16.0 * entity.launcher_scale
		_player_state.speed_x = 0.0
		_player_state.speed_y = 0.0
		_velocity_y = 0.0
		_player_state.is_grounded = false
		_player_state.char_state = 5
		if frame_input & A_BUTTON:
			# launcher.c releases the scripted cart state on jump input.
			_player_state.char_state = 1
			_player_state.speed_x = entity.launcher_direction * 180.0 * entity.launcher_scale
			_velocity_y = -292.5
			_player_state.speed_y = _velocity_y
			_player_state.ground_speed = _player_state.speed_x
			entity.launcher_active = false
			entity.launcher_wait_timer = 1.0
			entity.launcher_returning = true
			return
		if is_equal_approx(entity.launcher_cart_x, entity.launcher_target_x) or not _player_state.is_alive:
			_player_state.speed_x = entity.launcher_direction * 900.0 * entity.launcher_scale
			_velocity_y = -180.0 * entity.launcher_scale
			_player_state.speed_y = _velocity_y
			_player_state.ground_speed = _player_state.speed_x
			_player_state.is_grounded = false
			_player_state.char_state = 5
			entity.launcher_active = false
			entity.launcher_wait_timer = 1.0
			entity.launcher_returning = true
		return
	if entity.launcher_gravity_up != _gravity_inverted:
		return
	if absf(_player_state.world_x - entity.launcher_cart_x) > 18.0 or absf(_player_state.world_y - entity.launcher_cart_y) > 18.0:
		return
	entity.launcher_active = true
	_player_state.speed_x = 0.0
	_player_state.speed_y = 0.0
	_velocity_y = 0.0

func _try_pipe_start(entity: EntityState, delta: float) -> void:
	if _pipe_active:
		_pipe_timer += delta
		var progress := clampf(_pipe_timer / 1.0, 0.0, 1.0)
		var eased_progress := progress * progress * (3.0 - 2.0 * progress)
		_player_state.world_x = lerpf(_pipe_origin.x, _pipe_target.x, eased_progress)
		_player_state.world_y = lerpf(_pipe_origin.y, _pipe_target.y, eased_progress)
		_player_state.speed_x = 0.0
		_player_state.speed_y = 0.0
		_velocity_y = 0.0
		_player_state.is_grounded = false
		_player_state.char_state = 5
		if progress >= 1.0:
			_pipe_active = false
			_player_layer = 1 if _pipe_target_entity != null and _pipe_target_entity.pipe_exit_back_layer else 0
			_player_state.char_state = 5 if _pipe_target_entity != null and _pipe_target_entity.pipe_exit_uncurl else 0
			_player_state.is_grounded = not (_pipe_target_entity != null and _pipe_target_entity.pipe_exit_uncurl)
			_pipe_target_entity = null
		return
	# pipe.c uses a 24x24 map rectangle and ignores a second entry while
	# the scripted in-pipe state is active.
	if absf(_player_state.world_x - entity.world_x) > 12.0 or absf(_player_state.world_y - entity.world_y) > 12.0:
		return
	var nearest_exit: EntityState = null
	var nearest_distance := INF
	for candidate in _level_state.entities:
		if candidate.type != ENTITY_PIPE_END or not candidate.active:
			continue
		var distance: float = Vector2(entity.world_x, entity.world_y).distance_squared_to(Vector2(candidate.world_x, candidate.world_y))
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_exit = candidate
	if nearest_exit == null:
		return
	_pipe_active = true
	_pipe_timer = 0.0
	_pipe_origin = Vector2(entity.world_x, entity.world_y)
	_pipe_target = Vector2(nearest_exit.world_x, nearest_exit.world_y)
	_pipe_target_entity = nearest_exit
	_player_state.world_x = entity.world_x
	_player_state.world_y = entity.world_y
	_player_state.speed_x = 0.0
	_player_state.speed_y = 0.0
	_velocity_y = 0.0
	_player_state.is_grounded = false
	_player_state.char_state = 5

func _try_hook_rail(entity: EntityState, frame_input: int, delta: float) -> void:
	if entity.variant != 0:
		return
	if _hook_active:
		if frame_input & A_BUTTON:
			_hook_active = false
			_player_state.char_state = 1
			_player_state.speed_x = 120.0 if _hook_target.x >= _hook_origin.x else -120.0
			_velocity_y = -292.5
			_player_state.speed_y = _velocity_y
			_player_state.is_grounded = false
			return
		_hook_timer += delta
		var progress := clampf(_hook_timer / 1.0, 0.0, 1.0)
		var eased_progress := progress * progress * (3.0 - 2.0 * progress)
		var horizontal := lerpf(_hook_origin.x, _hook_target.x, eased_progress)
		var arc_height := absf(_hook_target.x - _hook_origin.x) * 0.5
		_player_state.world_x = horizontal
		_player_state.world_y = lerpf(_hook_origin.y, _hook_target.y, eased_progress) + sin(eased_progress * PI) * arc_height
		_player_state.speed_x = 0.0
		_player_state.speed_y = 0.0
		_velocity_y = 0.0
		_player_state.is_grounded = false
		_player_state.char_state = 5
		if progress >= 1.0:
			_hook_active = false
			_player_state.speed_x = 90.0 if _hook_target.x >= _hook_origin.x else -90.0
			_velocity_y = -120.0
			_player_state.speed_y = _velocity_y
		return
	var rail_left := minf(entity.world_x, entity.target_x)
	var rail_right := maxf(entity.world_x, entity.target_x)
	var rail_midpoint := (rail_left + rail_right) * 0.5
	if _player_state.world_x < rail_left or _player_state.world_x > rail_right or absf(_player_state.world_y - entity.world_y) > 24.0:
		return
	# hook_rail.c's START trigger accepts the forward half of the rail;
	# the END marker is only a destination for that state.
	if _player_state.world_x > rail_midpoint:
		return
	var nearest_end: EntityState = null
	var nearest_distance := INF
	for candidate in _level_state.entities:
		if candidate.type != ENTITY_HOOK_RAIL or candidate.variant == 0 or not candidate.active:
			continue
		var distance: float = Vector2(entity.world_x, entity.world_y).distance_squared_to(Vector2(candidate.world_x, candidate.world_y))
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_end = candidate
	if nearest_end == null:
		return
	_hook_active = true
	_hook_timer = 0.0
	_hook_origin = Vector2(entity.world_x, entity.world_y)
	_hook_target = Vector2(nearest_end.world_x, nearest_end.world_y)
	_player_state.speed_x = 0.0
	_player_state.speed_y = 0.0
	_velocity_y = 0.0

func _try_bounce_from_spring(entity: EntityState, delta: float) -> void:
	if (entity.flying_spring and _velocity_y <= 0.0) or (not entity.flying_spring and _velocity_y < 0.0):
		return

	var half_width := entity.width * 0.5
	var half_height := entity.height * 0.5
	var player_left := _player_state.world_x - 14.0
	var player_right := _player_state.world_x + 14.0
	var player_top := _player_state.world_y - 40.0
	var player_bottom := _player_state.world_y

	if player_right < entity.world_x - half_width:
		return
	if player_left > entity.world_x + half_width:
		return
	if player_bottom < entity.world_y - half_height:
		return
	if player_top > entity.world_y + half_height:
		return

	var launch := Vector2.ZERO
	match entity.variant:
		SPRING_DOWN:
			launch = Vector2(0.0, _spring_jump_speed)
		SPRING_LEFT:
			launch = Vector2(-_spring_jump_speed, 0.0)
		SPRING_RIGHT:
			launch = Vector2(_spring_jump_speed, 0.0)
		SPRING_UP_LEFT:
			launch = Vector2(-_spring_jump_speed * 0.78, -_spring_jump_speed * 0.78)
		SPRING_UP_RIGHT:
			launch = Vector2(_spring_jump_speed * 0.78, -_spring_jump_speed * 0.78)
		SPRING_DOWN_LEFT:
			launch = Vector2(-_spring_jump_speed * 0.78, _spring_jump_speed * 0.78)
		SPRING_DOWN_RIGHT:
			launch = Vector2(_spring_jump_speed * 0.78, _spring_jump_speed * 0.78)
		_:
			launch = Vector2(0.0, -_spring_jump_speed)
	if entity.flying_spring:
		launch = Vector2(0.0, -330.0)
		entity.flying_spring_step = 0
		entity.flying_spring_motion_state = 1
	_velocity_y = launch.y
	_player_state.speed_x = launch.x
	_player_state.world_x += launch.x * delta
	_player_state.world_y = min(_player_state.world_y, entity.world_y - half_height - 1.0) if launch.y < 0.0 else _player_state.world_y
	_player_state.is_grounded = false
	_player_state.char_state = 2
	_player_state.anim_id = 2

func _try_hit_enemy(entity: EntityState) -> void:
	if _damage_cooldown > 0.0:
		return
	if entity.enemy_profile == 11:
		var head_position := Vector2(entity.target_x, entity.target_y)
		if Vector2(_player_state.world_x, _player_state.world_y - 20.0).distance_to(head_position) <= 16.0:
			if _attack_timer > 0.0:
				entity.kubinaga_extension = 0.0
				entity.kubinaga_phase = 0
				entity.kubinaga_phase_timer = 2.0
				return
			_apply_contact_damage(-260.0, 0.6)
			return
	if entity.enemy_profile == 15:
		var player_position := Vector2(_player_state.world_x, _player_state.world_y - 20.0)
		for iron_ball in entity.trail_positions:
			if player_position.distance_to(iron_ball) <= 14.0:
				_apply_contact_damage(-260.0, 0.6)
				return
	if entity.enemy_profile == 10:
		var player_position := Vector2(_player_state.world_x, _player_state.world_y - 20.0)
		for trail_point in entity.trail_positions:
			if player_position.distance_to(trail_point) <= 16.0:
				_apply_contact_damage(-260.0, 0.6)
				return
	if entity.enemy_profile == 8:
		var fireball := _kura_kura_fireball_position(entity)
		var fireball_delta := Vector2(_player_state.world_x, _player_state.world_y - 20.0).distance_to(fireball)
		if fireball_delta <= 16.0:
			_apply_contact_damage(-260.0, 0.6)
			return
	var dx: float = abs(_player_state.world_x - entity.world_x)
	var dy: float = abs((_player_state.world_y - 20.0) - entity.world_y)
	if dx < 20.0 and dy < 22.0:
		if entity.enemy_profile == 5 and _player_state.world_y < entity.world_y and _velocity_y >= 0.0:
			_velocity_y = -420.0
			_player_state.speed_y = _velocity_y
			_player_state.is_grounded = false
			_player_state.char_state = 2
			return
		if _attack_timer > 0.0:
			_spawn_dust_cloud(entity.world_x, entity.world_y)
			entity.active = false
			entity.collected = true
			_award_enemy_defeat_score()
			return
		_apply_contact_damage(-260.0, 0.6)

func _try_projectile(entity: EntityState) -> void:
	if _damage_cooldown > 0.0:
		return
	var dx := absf(_player_state.world_x - entity.world_x)
	var dy := absf((_player_state.world_y - 20.0) - entity.world_y)
	if dx <= 18.0 and dy <= 24.0:
		entity.active = false
		_apply_contact_damage(-180.0, 0.45)

func _try_koura(entity: EntityState) -> void:
	if _damage_cooldown > 0.0:
		return
	var dx := absf(_player_state.world_x - entity.world_x)
	var player_bottom := _player_state.world_y
	var player_top := _player_state.world_y - _player_half_height
	var shell_top := entity.world_y - entity.height * 0.5
	var shell_bottom := entity.world_y + entity.height * 0.5
	if dx > entity.width * 0.5 + _player_half_width or player_bottom < shell_top or player_top > shell_bottom:
		entity.activated = false
		return
	if _attack_timer > 0.0:
		_spawn_dust_cloud(entity.world_x, entity.world_y)
		entity.active = false
		_award_enemy_defeat_score()
		return
	if _velocity_y > 40.0 and player_top < shell_top + 8.0:
		_velocity_y = -560.0
		_player_state.world_y = shell_top - _player_half_height - 1.0
		_player_state.is_grounded = false
		_player_state.char_state = 2
		_player_state.anim_id = 2
		_add_score(200)
		entity.activated = true
		return
	_apply_contact_damage(-260.0, 0.6)

func _try_boss(entity: EntityState) -> void:
	if _damage_cooldown > 0.0:
		return
	if entity.boss_profile == 4 and _saucer_beam_hits_player(entity):
		_apply_contact_damage(-260.0, 0.7)
		return
	if entity.boss_profile == 0 and entity.variant != 4:
		var hammer_delta := Vector2(_player_state.world_x, _player_state.world_y - 20.0) - _hammer_tank_tip(entity)
		if hammer_delta.length_squared() <= 26.0 * 26.0:
			_apply_contact_damage(-300.0, 0.8)
			return
	if entity.boss_profile == 3:
		var tail_phase := _elapsed_time * 2.4 + 0.7
		var tail_tip := Vector2(entity.world_x + cos(tail_phase) * 15.0, entity.world_y + 20.0 + sin(tail_phase) * 15.0)
		var tail_delta := Vector2(_player_state.world_x, _player_state.world_y - 20.0) - tail_tip
		if tail_delta.length_squared() <= 24.0 * 24.0:
			_apply_contact_damage(-260.0, 0.7)
			return
	var dx := absf(_player_state.world_x - entity.world_x)
	var dy := absf((_player_state.world_y - 20.0) - entity.world_y)
	if dx > entity.width * 0.5 + _player_half_width or dy > entity.height * 0.5 + 20.0:
		return
	if _attack_timer > 0.0:
		if entity.hit_timer > 0.0:
			return
		entity.health = maxi(0, entity.health - 1)
		entity.hit_timer = 0.4
		_add_score(1000)
		_request_screen_shake(4.0, 0.45, 0.3, false, true, false)
		if entity.health <= 0:
			entity.active = false
			_complete_boss()
		return
	_apply_contact_damage(-300.0, 0.8)

func _complete_boss() -> void:
	if _level_complete:
		return
	_level_complete = true
	_clear_from_goal = false
	_game_state = GAME_STATE_CLEAR
	_player_state.has_cleared_level = true
	_player_state.is_grounded = true
	_velocity_y = 0.0
	_player_state.speed_x = 0.0
	_player_state.speed_y = 0.0
	_status_text = "BOSS CLEAR - START OR A TO REPLAY"
	_add_score(10000)
	_clear_time_snapshot = _elapsed_time
	_clear_score_snapshot = _player_state.score
	_clear_ring_snapshot = _player_state.rings
	_clear_special_ring_snapshot = _player_state.special_rings
	_clear_rank_text = _calculate_clear_rank(_clear_time_snapshot, _clear_score_snapshot)
	_clear_time_bonus_remaining = get_clear_time_bonus()
	_clear_ring_bonus_remaining = get_clear_ring_bonus()
	_clear_special_ring_bonus_remaining = get_clear_special_ring_bonus()
	_clear_total_display_score = _clear_score_snapshot
	_clear_final_score_snapshot = _clear_score_snapshot + _clear_time_bonus_remaining + _clear_ring_bonus_remaining + _clear_special_ring_bonus_remaining
	_clear_count_step_accumulator = 0.0
	_clear_count_delay_timer = 2.5 if not _run_from_time_attack and not _run_from_multiplayer else 0.0
	_time_attack_result_timer = 0.0
	_time_attack_exit_timer = 0.0
	_clear_input_lock_timer = 2.666 if _run_from_time_attack else 1.2
	_clear_counting_done = _run_from_time_attack
	_store_clear_time_attack_result()
	_update_progress_for_clear()

func _try_star(entity: EntityState) -> void:
	if entity.variant != 0 or _damage_cooldown > 0.0:
		return
	var dx := absf(_player_state.world_x - entity.world_x)
	var dy := absf((_player_state.world_y - 20.0) - entity.world_y)
	if dx <= entity.width * 0.5 + _player_half_width and dy <= entity.height * 0.5 + 20.0:
		_apply_contact_damage(-220.0, 0.7)

func _try_spike_platform(entity: EntityState) -> void:
	if not entity.activated:
		return
	_try_spikes(entity)

func _try_turnaround_bar(entity: EntityState) -> void:
	if entity.turnaround_timer > 0.0 or not _player_state.is_grounded:
		return
	if absf(_player_state.ground_speed) < 240.0:
		return
	if absf(_player_state.world_x - entity.world_x) > 6.0 or _player_state.world_y < entity.world_y - 32.0 or _player_state.world_y > entity.world_y:
		return
	entity.turnaround_direction = signf(_player_state.ground_speed)
	entity.turnaround_entry_speed = absf(_player_state.ground_speed)
	entity.turnaround_timer = 48.0 / 60.0
	entity.activated = true
	_player_state.world_x = entity.world_x
	_player_state.world_y = entity.world_y
	_player_state.speed_x = 0.0
	_player_state.ground_speed = 0.0
	_velocity_y = 0.0
	_player_state.rotation = 0
	_player_state.char_state = 8

func _try_keyboard(entity: EntityState) -> void:
	if entity.keyboard_timer > 0.0:
		return
	var dx := absf(_player_state.world_x - entity.world_x)
	var dy := absf((_player_state.world_y - 20.0) - entity.world_y)
	if dx > entity.width * 0.5 + 16.0 or dy > entity.height * 0.5 + 20.0:
		return
	entity.keyboard_timer = 8.0 / 60.0
	entity.activated = true
	_player_state.is_grounded = false
	_player_state.char_state = 6
	_player_state.rotation = 0
	var gravity_direction := -1.0 if _gravity_inverted else 1.0
	if entity.keyboard_type == 0:
		# keyboard.c uses 3/4 px per frame in Music Plant.
		_player_state.speed_x = entity.velocity_x * 180.0
		_velocity_y = -240.0 * gravity_direction
	else:
		_player_state.speed_x = (-1.0 if entity.keyboard_type == 1 else 1.0) * 300.0
		_velocity_y = (1.0 if entity.velocity_y >= 0.0 else -1.0) * 480.0 * gravity_direction
	_player_state.ground_speed = _player_state.speed_x
	_player_state.speed_y = _velocity_y

func _try_pole(entity: EntityState, held_input: int, frame_input: int) -> void:
	if entity.pole_sliding:
		if frame_input & A_BUTTON:
			entity.pole_sliding = false
			entity.activated = false
			_player_state.speed_x = -300.0 if held_input & DPAD_LEFT else 300.0
			_player_state.ground_speed = _player_state.speed_x
			_velocity_y = 0.0
			_player_state.speed_y = _velocity_y
			_player_state.char_state = 5
			_player_state.is_grounded = false
			return
		var gravity_direction := -1.0 if _gravity_inverted else 1.0
		_player_state.world_y += gravity_direction * 60.0 * (1.0 / 60.0)
		var still_touching := absf(_player_state.world_x - entity.world_x) <= entity.width * 0.5 and absf(_player_state.world_y - entity.world_y) <= entity.height * 0.5
		if not still_touching:
			entity.pole_sliding = false
			entity.activated = false
			_player_state.char_state = 1
			_player_state.speed_y = gravity_direction * 60.0
			_velocity_y = _player_state.speed_y
			_player_state.is_grounded = false
			return
		_player_state.world_x = entity.world_x
		_player_state.is_grounded = false
		_player_state.speed_x = 0.0
		_player_state.speed_y = 0.0
		_velocity_y = 0.0
		return
	var dx := absf(_player_state.world_x - entity.world_x)
	var dy := absf(_player_state.world_y - entity.world_y)
	if dx > entity.width * 0.5 or dy > entity.height * 0.5:
		return
	entity.pole_sliding = true
	entity.activated = true
	_player_state.world_x = entity.world_x
	_player_state.world_y = entity.world_y
	_player_state.is_grounded = false
	_player_state.speed_x = 0.0
	_player_state.ground_speed = 0.0
	_velocity_y = 0.0
	_player_state.char_state = 4

func _try_light_globe(entity: EntityState) -> void:
	var dx := _player_state.world_x - entity.world_x
	var dy := _player_state.world_y - entity.world_y
	if dx * dx + dy * dy > 29.0 * 29.0:
		return
	entity.active = false
	entity.activated = true
	_player_state.is_grounded = false
	_velocity_y = -_spring_jump_speed
	_player_state.speed_y = _velocity_y
	_player_state.char_state = 5
	_player_state.rotation = 0

func _try_windup_stick(entity: EntityState, held_input: int) -> void:
	if entity.windup_stick_timer > 0.0:
		if entity.windup_stick_mode == 1 or entity.windup_stick_mode == 2:
			if held_input & DPAD_RIGHT:
				_player_state.world_x = minf(_player_state.world_x + 30.0 / 60.0, entity.world_x + entity.width * 0.5)
			if held_input & DPAD_LEFT:
				_player_state.world_x = maxf(_player_state.world_x - 30.0 / 60.0, entity.world_x - entity.width * 0.5)
		return
	var dx := absf(_player_state.world_x - entity.world_x)
	var dy := absf((_player_state.world_y - 20.0) - entity.world_y)
	if dx > entity.width * 0.5 + 14.0 or dy > entity.height * 0.5 + 20.0:
		return
	var rising := not _player_state.is_grounded and _velocity_y < 0.0
	var falling := not _player_state.is_grounded and _velocity_y >= 0.0
	var grounded := _player_state.is_grounded
	if not rising and not falling and not grounded:
		return
	entity.windup_stick_mode = 1 if rising else (2 if falling else (3 if _player_state.speed_x >= 0.0 else 4))
	entity.windup_stick_timer = 0.24
	entity.activated = true
	_player_state.world_y = entity.world_y + 3.0
	_player_state.rotation = 0
	if rising:
		_player_state.speed_x = 0.0
		_velocity_y -= 390.0
		_player_state.is_grounded = false
	elif falling:
		_player_state.speed_x = 0.0
		_player_state.is_grounded = false
	else:
		var turn_direction := -1.0 if _player_state.speed_x < 0.0 else 1.0
		var turn_amount := 150.0 if turn_direction > 0.0 else 75.0
		_player_state.ground_speed += turn_direction * turn_amount
		_player_state.speed_x = _player_state.ground_speed
		_velocity_y = -60.0
		_player_state.is_grounded = false
	_player_state.speed_y = _velocity_y
	_player_state.char_state = 8

func _try_german_flute(entity: EntityState) -> void:
	if entity.german_flute_timer > 0.0:
		return
	var dx := absf(_player_state.world_x - entity.world_x)
	var dy := absf(_player_state.world_y - entity.world_y)
	if dx > 20.0 or dy > 32.0:
		return
	entity.german_flute_timer = 0.0001
	entity.german_flute_phase = 0
	entity.activated = true
	_player_state.world_x = entity.world_x
	_player_state.world_y = entity.world_y + 24.0
	_player_state.is_grounded = false
	_player_state.speed_x = 0.0
	_player_state.ground_speed = 0.0
	_velocity_y = 0.0
	_player_state.char_state = 8

func _try_small_windmill(entity: EntityState) -> void:
	if entity.small_windmill_timer > 0.0:
		return
	var offset := Vector2(_player_state.world_x - entity.world_x, _player_state.world_y - entity.world_y)
	if offset.length_squared() > 38.0 * 38.0:
		return
	var bit := 1
	var touch_angle := 1
	var horizontal_dominant := absf(_player_state.speed_x) > absf(_velocity_y)
	if offset.x < 0.0 and offset.y < 0.0:
		bit = 1
		touch_angle = 1 if horizontal_dominant else 2
	elif offset.x >= 0.0 and offset.y < 0.0:
		bit = 2
		touch_angle = 4 if horizontal_dominant else 3
	elif offset.x < 0.0 and offset.y >= 0.0:
		bit = 4
		touch_angle = 6 if horizontal_dominant else 5
	else:
		bit = 8
		touch_angle = 7 if horizontal_dominant else 8
	if entity.small_windmill_type != 0 and (entity.small_windmill_type & bit) == 0:
		return
	entity.small_windmill_touch_angle = touch_angle
	entity.small_windmill_angle = atan2(offset.y, offset.x)
	entity.small_windmill_timer = 0.0001
	entity.activated = true
	_player_state.is_grounded = false
	_player_state.char_state = 8

func _try_chord(entity: EntityState) -> void:
	if entity.chord_phase != 0:
		return
	var dx := absf(_player_state.world_x - entity.world_x)
	var dy := absf(_player_state.world_y - entity.world_y)
	if _velocity_y <= 0.0 or dx > 48.0 or dy > 9.0:
		return
	entity.chord_bounce_speed = clampf(maxf(240.0, _velocity_y * 1.5), 240.0, 720.0)
	entity.chord_phase = 1
	entity.chord_timer = 0.0001
	entity.activated = true
	_player_state.is_grounded = false
	_player_state.speed_y = _velocity_y
	_player_state.char_state = 6
	_player_state.rotation = 0

func _try_half_pipe(entity: EntityState) -> void:
	if entity.half_pipe_active or not _player_state.is_grounded:
		return
	var dx := _player_state.world_x - entity.world_x
	var dy := _player_state.world_y - entity.world_y
	if absf(dx) > entity.width * 0.5 or absf(dy) > entity.height * 0.5:
		return
	if entity.half_pipe_direction > 0.0 and _player_state.speed_x < 135.0:
		return
	if entity.half_pipe_direction < 0.0 and _player_state.speed_x > -135.0:
		return
	entity.half_pipe_active = true
	entity.activated = true
	entity.half_pipe_base_y = _player_state.world_y
	_player_state.char_state = 0

func _try_iron_ball(entity: EntityState) -> void:
	var dx := absf(_player_state.world_x - entity.world_x)
	var dy := absf((_player_state.world_y - 20.0) - entity.world_y)
	if dx <= entity.width * 0.5 + 14.0 and dy <= entity.height * 0.5 + 20.0:
		_apply_contact_damage(-180.0, 0.7)

func _try_crane(entity: EntityState) -> void:
	if entity.crane_timer > 0.0:
		return
	var dx := _player_state.world_x - entity.crane_hook_x
	var dy := _player_state.world_y - entity.crane_hook_y
	if dx * dx + dy * dy > 26.0 * 26.0:
		return
	entity.crane_timer = 0.9
	entity.crane_launch_speed = clampf(absf(_velocity_y) * 2.0, 450.0, 720.0)
	entity.activated = true
	_player_state.world_x = entity.crane_hook_x
	_player_state.world_y = entity.crane_hook_y
	_player_state.is_grounded = false
	_player_state.speed_x = 0.0
	_velocity_y = 0.0
	_player_state.char_state = 8

func _try_ceiling_slope(entity: EntityState) -> void:
	if entity.ceiling_slope_latched or _player_state.is_grounded or _velocity_y >= 0.0:
		return
	var dx := absf(_player_state.world_x - entity.world_x)
	var dy := absf((_player_state.world_y - 20.0) - entity.world_y)
	if dx > entity.width * 0.5 or dy > entity.height * 0.5:
		return
	entity.ceiling_slope_latched = true
	entity.ceiling_slope_timer = 0.35
	entity.activated = true
	_player_state.world_y = entity.world_y + entity.height * 0.5 + 18.0
	_velocity_y = 80.0
	_player_state.speed_y = _velocity_y
	_player_state.rotation = -8 if entity.ceiling_slope_variant == 0 else 8
	_player_state.char_state = 0

func _try_gapped_loop(entity: EntityState) -> void:
	if entity.gapped_loop_active or not _player_state.is_grounded:
		return
	if entity.gapped_loop_direction > 0.0 and _player_state.speed_x < 180.0:
		return
	if entity.gapped_loop_direction < 0.0 and _player_state.speed_x > -180.0:
		return
	var dx := _player_state.world_x - entity.gapped_loop_center_x
	var dy := _player_state.world_y - entity.gapped_loop_center_y
	if dx * dx + dy * dy > 180.0 * 180.0:
		return
	entity.gapped_loop_angle = atan2(dy, dx)
	entity.gapped_loop_active = true
	entity.activated = true
	_player_state.is_grounded = false
	_player_state.char_state = 5

func _try_funnel_sphere(entity: EntityState) -> void:
	if entity.funnel_sphere_timer > 0.0:
		return
	var dx := _player_state.world_x - entity.world_x
	var dy := _player_state.world_y - entity.world_y
	if dx * dx + dy * dy > 20.0 * 20.0:
		return
	entity.funnel_sphere_direction = 1.0 if _player_state.speed_x < 320.0 else -1.0
	entity.funnel_sphere_timer = 0.0001
	entity.activated = true
	_player_state.is_grounded = false
	_player_state.char_state = 6

func _try_music_entry(entity: EntityState) -> void:
	if entity.music_entry_timer > 0.0:
		return
	var dx := _player_state.world_x - entity.world_x
	var dy := _player_state.world_y - entity.world_y
	if dx * dx + dy * dy > 20.0 * 20.0:
		return
	entity.music_entry_timer = 0.0001
	entity.activated = true
	_player_state.world_x = entity.world_x
	_player_state.world_y = entity.world_y
	_player_state.is_grounded = false
	_player_state.speed_x = 0.0
	_velocity_y = 0.0
	_player_state.char_state = 8

func _try_damage_region(entity: EntityState) -> void:
	var dx := absf(_player_state.world_x - entity.world_x)
	var dy := absf((_player_state.world_y - 20.0) - entity.world_y)
	if dx <= entity.width * 0.5 + 14.0 and dy <= entity.height * 0.5 + 20.0:
		_apply_contact_damage(-180.0, 0.7)

func _try_spikes(entity: EntityState) -> void:
	if _damage_cooldown > 0.0:
		return
	var half_width := entity.width * 0.5
	var half_height := entity.height * 0.5
	var dx := absf(_player_state.world_x - entity.world_x)
	var player_bottom := _player_state.world_y
	var player_top := _player_state.world_y - 40.0
	var spike_top := entity.world_y - half_height
	var spike_bottom := entity.world_y + half_height
	if dx > half_width + 14.0 or player_bottom < spike_top or player_top > spike_bottom:
		return
	_apply_contact_damage(-220.0, 0.8)

func _apply_contact_damage(launch_speed: float, cooldown: float) -> void:
	if _invincibility_timer > 0.0:
		return
	_defeat_score_index = 0
	if _player_state.shielded:
		_player_state.shielded = false
		_magnetic_shielded = false
	elif _player_state.rings > 0:
		_spawn_scattered_rings(_player_state.rings)
		_player_state.rings = 0
		_player_state.score = max(0, _player_state.score - 100)
	else:
		# Unprotected contact follows SA2's damage rule: no rings means a life loss.
		_player_state.lives = max(0, _player_state.lives - 1)
		if _player_state.lives == 0:
			_open_game_over()
		else:
			_respawn_player()
		_damage_cooldown = cooldown
		return
	_velocity_y = launch_speed
	_player_state.is_grounded = false
	_player_state.char_state = 2
	_player_state.anim_id = 2
	_damage_cooldown = cooldown
	_request_screen_shake(5.0, 0.7, 0.35, true, true, true)

func _try_item_box(entity: EntityState) -> void:
	if entity.activated:
		return
	var dx := absf(_player_state.world_x - entity.world_x)
	var dy := absf((_player_state.world_y - 20.0) - entity.world_y)
	if dx > 24.0 or dy > 30.0:
		return
	entity.collected = true
	entity.activated = true
	_spawn_dust_cloud(entity.world_x, entity.world_y)
	entity.state_timer = 0.0
	entity.effect_offset = 0.0

func _try_activate_checkpoint(entity: EntityState) -> void:
	if entity.activated:
		return

	var dx: float = abs(_player_state.world_x - entity.world_x)
	var dy: float = abs(_player_state.world_y - entity.world_y)
	if dx < 24.0 and dy < 48.0:
		entity.activated = true
		entity.variant = 1
		save_checkpoint(entity.world_x, entity.world_y)
		_add_score(1000)

func _try_reach_goal(entity: EntityState) -> void:
	if _level_complete:
		return

	var reached := false
	if entity.goal_toggle:
		# stage_goal.c uses a horizontal finish line for TOGGLE__GOAL.
		reached = _player_state.world_x >= entity.world_x
	else:
		var dx: float = abs(_player_state.world_x - entity.world_x)
		var dy: float = abs(_player_state.world_y - entity.world_y)
		reached = dx < 28.0 and dy < 64.0
	if reached and _player_state.is_alive:
		_level_complete = true
		_clear_from_goal = true
		_game_state = GAME_STATE_CLEAR
		_player_state.has_cleared_level = true
		_player_state.is_grounded = true
		_velocity_y = 0.0
		_player_state.speed_x = 0.0
		_player_state.speed_y = 0.0
		_status_text = "STAGE CLEAR - START OR A TO REPLAY"
		_add_score(5000)
		if not _run_from_time_attack and not _run_from_multiplayer and _player_state.is_grounded and absf(_player_state.ground_speed) > 150.0:
			var speed := absf(_player_state.ground_speed)
			var goal_bonus := 200 if speed <= 240.0 else (300 if speed <= 540.0 else (500 if speed <= 600.0 else 800))
			_add_score(goal_bonus)
			_status_text = "STAGE CLEAR +%d" % goal_bonus
		_clear_time_snapshot = _elapsed_time
		_clear_score_snapshot = _player_state.score
		_clear_ring_snapshot = _player_state.rings
		_clear_special_ring_snapshot = _player_state.special_rings
		_clear_rank_text = _calculate_clear_rank(_clear_time_snapshot, _clear_score_snapshot)
		_clear_time_bonus_remaining = get_clear_time_bonus()
		_clear_ring_bonus_remaining = get_clear_ring_bonus()
		_clear_special_ring_bonus_remaining = get_clear_special_ring_bonus()
		_clear_total_display_score = _clear_score_snapshot
		_clear_final_score_snapshot = _clear_score_snapshot + _clear_time_bonus_remaining + _clear_ring_bonus_remaining + _clear_special_ring_bonus_remaining
		_clear_count_step_accumulator = 0.0
		_clear_count_delay_timer = 2.5 if not _run_from_time_attack and not _run_from_multiplayer else 0.0
		_time_attack_result_timer = 0.0
		_time_attack_exit_timer = 0.0
		_clear_input_lock_timer = 2.666 if _run_from_time_attack else 1.2
		_clear_counting_done = _run_from_time_attack
		_store_clear_time_attack_result()
		_update_progress_for_clear()

func _update_camera() -> void:
	var viewport := Vector2(1280.0, 720.0)
	var vp: Viewport = get_viewport()
	if vp:
		viewport = vp.get_visible_rect().size
	_camera_state.min_x = _level_state.min_x
	_camera_state.max_x = _level_state.max_x
	_camera_state.min_y = _level_state.min_y
	_camera_state.max_y = _level_state.max_y

	var camera_target_x := _player_state.world_x
	if _player_state.super_sonic:
		# sub_802BCCC keeps the extra-boss camera ahead of the player while the
		# scrolling arena moves beneath the rocket-like Super Sonic sprite.
		camera_target_x += clampf(_player_state.speed_x * 0.18, -144.0, 144.0)
	_camera_state.x = clamp(camera_target_x, viewport.x * 0.5, _level_state.max_x - viewport.x * 0.5) + _screen_shake_offset.x
	_camera_state.y = clamp(_player_state.world_y - 120.0, viewport.y * 0.5, _level_state.max_y - viewport.y * 0.5) + _screen_shake_offset.y

func _request_screen_shake(amplitude: float, duration: float, phase_speed: float, horizontal: bool, vertical: bool, random_value: bool) -> void:
	_screen_shake_amplitude = maxf(_screen_shake_amplitude, amplitude)
	_screen_shake_decay = amplitude / maxf(duration, 0.01)
	_screen_shake_phase = 0.0
	_screen_shake_phase_speed = phase_speed * TAU
	_screen_shake_timer = maxf(_screen_shake_timer, duration)
	_screen_shake_horizontal = horizontal
	_screen_shake_vertical = vertical
	_screen_shake_random = random_value

func _update_screen_shake(delta: float) -> void:
	if _screen_shake_timer <= 0.0:
		_screen_shake_offset = Vector2.ZERO
		return
	_screen_shake_timer = maxf(0.0, _screen_shake_timer - delta)
	_screen_shake_amplitude = maxf(0.0, _screen_shake_amplitude - _screen_shake_decay * delta)
	_screen_shake_phase += _screen_shake_phase_speed * delta
	var factor := randf_range(-1.0, 1.0) if _screen_shake_random else sin(_screen_shake_phase)
	var offset := factor * _screen_shake_amplitude
	_screen_shake_offset = Vector2(offset if _screen_shake_horizontal else 0.0, offset if _screen_shake_vertical else 0.0)
	if _screen_shake_timer <= 0.0:
		_clear_screen_shake()

func _clear_screen_shake() -> void:
	_screen_shake_amplitude = 0.0
	_screen_shake_decay = 0.0
	_screen_shake_phase = 0.0
	_screen_shake_phase_speed = 0.0
	_screen_shake_timer = 0.0
	_screen_shake_offset = Vector2.ZERO

func _reset_input_buffer() -> void:
	_input_frame_history.clear()
	for i in range(INPUT_BUFFER_FRAMES):
		_input_frame_history.append(0)
	_jump_buffer_timer = 0.0

func _record_input_frame(frame_input: int) -> void:
	_input_frame_history.push_front(frame_input)
	while _input_frame_history.size() > INPUT_BUFFER_FRAMES:
		_input_frame_history.pop_back()

func get_recent_input_mask(window: int = INPUT_BUFFER_FRAMES) -> int:
	var mask := 0
	var count := mini(window, _input_frame_history.size())
	for i in range(count):
		mask |= int(_input_frame_history[i])
	return mask

func _spindash_direction_from_player() -> void:
	if absf(_player_state.speed_x) > 8.0:
		_facing_direction = signf(_player_state.speed_x)

func is_player_spindashing() -> bool:
	return _spindash_charging or _spindash_release_timer > 0.0

func _reset_player() -> void:
	_player_state.world_x = _level_state.spawn_x
	_player_state.world_y = _level_state.spawn_y
	_player_state.speed_x = 0.0
	_player_state.speed_y = 0.0
	_player_state.ground_speed = 0.0
	_player_state.anim_id = 0
	_player_state.anim_frame = 0
	_player_state.variant = clampi(_selected_character_index, 0, _character_names.size() - 1)
	_player_state.rotation = 0
	_player_state.move_state = 0
	_player_state.char_state = 0
	_player_state.is_alive = true
	_player_state.is_grounded = true
	_player_state.rings = 0
	_player_state.special_rings = 0
	_player_state.shielded = false
	_player_state.score = 0
	# ApplyGameStageSettings in the source gives linked multiplayer runs one
	# life; solo and time-attack runs retain the standard three.
	_player_state.lives = 1 if _run_from_multiplayer else 3
	_player_state.has_cleared_level = false
	_player_state.super_sonic = _is_super_sonic_route()
	_player_state.super_sonic_ring_timer = 0.0
	if _player_state.super_sonic:
		# EXTRA_BOSS__INITIAL_RING_COUNT from player_super_sonic.c.
		_player_state.rings = 50
		_player_state.variant = 0
		_player_state.super_sonic_ring_timer = 1.0
		_status_text = "SUPER SONIC"
	_velocity_y = 0.0
	_reset_input_buffer()
	_spindash_charging = false
	_spindash_charge = 0.0
	_spindash_release_timer = 0.0
	_spindash_velocity_x = 0.0
	_facing_direction = 1.0
	_braking_dust_cooldown = 0.0
	_grind_effect_entity = null
	_cheese_entity = null
	_dash_timer = 0.0
	_dash_velocity_x = 0.0
	_dash_velocity_y = 0.0
	_boost_position_history.clear()
	for i in range(16):
		_boost_position_history.append(Vector2(_player_state.world_x, _player_state.world_y))
	_grind_timer = 0.0
	_grind_velocity_x = 0.0
	_grind_end_x = 0.0
	_grind_y = 0.0
	_grind_end_mode = 0
	_gravity_inverted = false
	_player_layer = 0
	_corkscrew_timer = 0.0
	_corkscrew_active_entity = null
	_speed_up_timer = 0.0
	_magnetic_shielded = false
	_defeat_score_index = 0
	_attack_timer = 0.0
	_flight_timer = 0.0
	_glide_timer = 0.0
	_update_camera()

func _is_super_sonic_route() -> bool:
	return _level_state.level_id == _level_names.size() - 1 \
		and not _run_from_time_attack \
		and not _run_from_multiplayer \
		and get_chaos_emerald_count() >= 7

func _update_super_sonic(delta: float) -> void:
	if not _player_state.super_sonic or not _player_state.is_alive:
		return
	_player_state.super_sonic_ring_timer -= delta
	while _player_state.super_sonic_ring_timer <= 0.0:
		_player_state.super_sonic_ring_timer += 1.0
		if _player_state.rings <= 0:
			# The source switches to its dead animation as soon as the drain
			# reaches zero; the Godot equivalent is the normal game-over path.
			_open_game_over()
			return
		_player_state.rings -= 1
	_player_state.anim_id = 2

func is_player_super_sonic() -> bool:
	return _player_state.super_sonic

func save_checkpoint(x: float, y: float) -> void:
	_respawn_x = x
	_respawn_y = y
	_checkpoint_time = _elapsed_time

func get_status_text() -> String:
	return _localize_status_text(_status_text)

func _localize_status_text(status: String) -> String:
	if status.is_empty() or _language_index == 1:
		return status
	if status.begins_with("CONFIRM RESET?"):
		return "%s %s %s %s %s" % [
			_language_text("CONFIRM RESET?", "RESET BESTAETIGEN?", "CONFIRMER RESET ?", "CONFIRMAR REINICIO?", "CONFERMA RESET?"),
			get_confirm_label(),
			_language_text("YES", "JA", "OUI", "SI", "SI"),
			get_secondary_label(),
			_language_text("NO", "NEIN", "NON", "NO", "NO"),
		]
	if status.begins_with("PLAYER LAYER: "):
		var layer := status.trim_prefix("PLAYER LAYER: ")
		return "%s: %s" % [_language_text("PLAYER LAYER", "SPIELEREBENE", "CALQUE JOUEUR", "CAPA DEL JUGADOR", "LIVELLO GIOCATORE"), _language_text(layer, "HINTEN", "ARRIERE", "ATRAS", "DIETRO") if layer == "BACK" else _language_text(layer, "VORNE", "AVANT", "DELANTE", "DAVANTI")]
	if status.begins_with(" "):
		return status
	if status.ends_with(" UNLOCKED"):
		var unlocked_name := status.trim_suffix(" UNLOCKED")
		return "%s %s" % [unlocked_name, _language_text("UNLOCKED", "FREIGESCHALTET", "DEVERROUILLE", "DESBLOQUEADO", "SBLOCCATO")]
	match status:
		"READY!":
			return _language_text(status, "BEREIT!", "PRET !", "LISTO!", "PRONTO!")
		"GO!":
			return _language_text(status, "LOS!", "GO !", "YA!", "VIA!")
		"BOSS READY":
			return _language_text(status, "BOSS BEREIT", "BOSS PRET", "JEFE LISTO", "BOSS PRONTO")
		"DEFEAT THE BOSS":
			return _language_text(status, "BESIEGE DEN BOSS", "BATTEZ LE BOSS", "DERROTA AL JEFE", "SCONFIGGI IL BOSS")
		"OUTRUN RIVALS":
			return _language_text(status, "HAENGE DIE RIVALEN AB", "DISTANCEZ LES RIVAUX", "DEJA ATRAS A LOS RIVALES", "SUPERA I RIVALI")
		"REACH THE GOAL":
			return _language_text(status, "ERREICHE DAS ZIEL", "ATTEIGNEZ L'ARRIVEE", "LLEGA A LA META", "RAGGIUNGI IL TRAGUARDO")
		"TIME OVER":
			return _language_text(status, "ZEIT ABGELAUFEN", "TEMPS ECOULE", "TIEMPO AGOTADO", "TEMPO SCADUTO")
		"GAME OVER":
			return _language_text(status, "GAME OVER", "GAME OVER", "FIN DE LA PARTIDA", "GAME OVER")
		"BOSS CLEAR - START OR A TO REPLAY":
			return _language_text(status, "BOSS GESCHAFFT - START ODER A ZUM WIEDERHOLEN", "BOSS TERMINE - START OU A POUR REJOUER", "JEFE COMPLETADO - START O A PARA REPETIR", "BOSS COMPLETATO - START O A PER RIPETERE")
		"STAGE CLEAR - START OR A TO REPLAY":
			return _language_text(status, "STUFE GESCHAFFT - START ODER A ZUM WIEDERHOLEN", "STAGE TERMINE - START OU A POUR REJOUER", "FASE COMPLETADA - START O A PARA REPETIR", "STAGE COMPLETATO - START O A PER RIPETERE")
		"OPTIONS":
			return _language_text(status, "OPTIONEN", "OPTIONS", "OPCIONES", "OPZIONI")
		"SELECT PROFILE LANGUAGE":
			return _language_text(status, "PROFILERSPRACHE WAEHLEN", "CHOISIR LA LANGUE DU PROFIL", "ELIGE IDIOMA DEL PERFIL", "SCEGLI LINGUA PROFILO")
		"NAME ENTRY":
			return _language_text(status, "NAMEN EINGEBEN", "SAISIE DU NOM", "INTRODUCIR NOMBRE", "INSERISCI NOME")
		"VERSUS RECORDS":
			return _language_text(status, "VS-REKORDE", "RECORDS VS", "RECORDS VS", "RECORD VS")
		"PLAYER DATA":
			return _language_text(status, "SPIELERDATEN", "DONNEES JOUEUR", "DATOS DEL JUGADOR", "DATI GIOCATORE")
		"SAVE DATA DELETED":
			return _language_text(status, "SPEICHERDATEN GELOESCHT", "DONNEES EFFACEES", "DATOS BORRADOS", "DATI CANCELLATI")
		"PROFILE NAME REQUIRED":
			return _language_text(status, "PROFILNAME ERFORDERLICH", "NOM DE PROFIL REQUIS", "NOMBRE DE PERFIL REQUERIDO", "NOME PROFILO RICHIESTO")
		"NAME SAVED":
			return _language_text(status, "NAME GESPEICHERT", "NOM ENREGISTRE", "NOMBRE GUARDADO", "NOME SALVATO")
		"CHARACTER SELECT":
			return _language_text(status, "CHARAKTER WAEHLEN", "CHOIX DU PERSONNAGE", "SELECCION DE PERSONAJE", "SCELTA PERSONAGGIO")
		"CHARACTER LOCKED":
			return _language_text(status, "CHARAKTER GESPERRT", "PERSONNAGE VERROUILLE", "PERSONAJE BLOQUEADO", "PERSONAGGIO BLOCCATO")
		"SPECIAL STAGE READY":
			return _language_text(status, "SPECIAL-STAGE BEREIT", "STAGE SPECIAL PRET", "FASE ESPECIAL LISTA", "SPECIAL STAGE PRONTA")
		"SPECIAL STAGE RUN":
			return _language_text(status, "SPECIAL-STAGE-LAUF", "COURSE SPECIALE", "RECORRIDO ESPECIAL", "CORSA SPECIALE")
		"SPECIAL STAGE RESULTS":
			return _language_text(status, "SPECIAL-STAGE-ERGEBNIS", "RESULTAT SPECIAL", "RESULTADO ESPECIAL", "RISULTATO SPECIALE")
		"SPECIAL STAGE JUMP":
			return _language_text(status, "SPECIAL-STAGE SPRUNG", "SAUT SPECIAL", "SALTO ESPECIAL", "SALTO SPECIALE")
		"COPYRIGHT":
			return _language_text(status, "URHEBERRECHT", "DROITS D'AUTEUR", "DERECHOS DE AUTOR", "DIRITTI D'AUTORE")
		"DEMO PLAYBACK":
			return _language_text(status, "DEMO-WIEDERGABE", "LECTURE DE LA DEMO", "REPRODUCCION DE DEMO", "RIPRODUZIONE DEMO")
		"ALL CHAOS EMERALDS COLLECTED":
			return _language_text(status, "ALLE CHAOS-EMERALDS GESAMMELT", "TOUS LES EMERAUDES DU CHAOS COLLECTEES", "TODAS LAS ESMERALDAS DEL CAOS REUNIDAS", "TUTTI I CHAOS EMERALD RACCOLTI")
		"COLLECT ALL CHAOS EMERALDS":
			return _language_text(status, "SAMMLE ALLE CHAOS-EMERALDS", "COLLECTEZ TOUTES LES EMERAUDES DU CHAOS", "REUNE TODAS LAS ESMERALDAS DEL CAOS", "RACCOGLI TUTTI I CHAOS EMERALD")
		"TO BE CONTINUED":
			return _language_text(status, "FORTSETZUNG FOLGT", "A SUIVRE", "CONTINUARA", "CONTINUA")
		"PRESENTED BY SEGA":
			return _language_text(status, "PRASENTIERT VON SEGA", "PRESENTE PAR SEGA", "PRESENTADO POR SEGA", "PRESENTATO DA SEGA")
		"CREATED BY SONIC TEAM":
			return _language_text(status, "ERSTELLT VON SONIC TEAM", "CREE PAR SONIC TEAM", "CREADO POR SONIC TEAM", "CREATO DA SONIC TEAM")
		"LEFT/RIGHT MOVE   A CARE   B EXIT":
			return _language_text(status, "LINKS/RECHTS BEWEGEN   A PFLEGEN   B ENDE", "GAUCHE/DROITE DEPLACER   A SOIGNER   B QUITTER", "IZQ/DER MOVER   A CUIDAR   B SALIR", "SINISTRA/DESTRA MUOVI   A CURA   B ESCI")
		"TRUE AREA 53 INTRO":
			return _language_text(status, "TRUE AREA 53 INTRO", "INTRO TRUE AREA 53", "INTRO TRUE AREA 53", "INTRO TRUE AREA 53")
		"GUARD ROBO HIT - 10 RINGS LOST":
			return _language_text(status, "GUARD ROBO GETROFFEN - 10 RINGE VERLOREN", "ROBO GARDE TOUCHE - 10 ANNEAUX PERDUS", "ROBO GUARDIA GOLPEADO - 10 ANILLOS PERDIDOS", "GUARD ROBO COLPITO - 10 ANELLI PERSI")
		"GUARD ROBO HIT - NO RINGS":
			return _language_text(status, "GUARD ROBO GETROFFEN - KEINE RINGE", "ROBO GARDE TOUCHE - AUCUN ANNEAU", "ROBO GUARDIA GOLPEADO - SIN ANILLOS", "GUARD ROBO COLPITO - NESSUN ANELLO")
	return status

func get_hud_titles() -> Dictionary:
	if _run_from_multiplayer:
		return {
			"score": _language_text("PTS", "PKT", "PTS", "PTS", "PTI"),
			"rings": _language_text("RINGS", "RINGE", "ANNEAUX", "ANILLOS", "ANELLI"),
			"time": _language_text("TIME", "ZEIT", "TEMPS", "TIEMPO", "TEMPO"),
			"lives": _language_text("VS", "VS", "VS", "VS", "VS"),
		}
	return {
		"score": _language_text("SCORE", "PUNKTE", "SCORE", "PUNTOS", "PUNTEGGIO"),
		"rings": _language_text("RINGS", "RINGE", "ANNEAUX", "ANILLOS", "ANELLI"),
		"time": _language_text("TIME", "ZEIT", "TEMPS", "TIEMPO", "TEMPO"),
		"lives": _language_text("LIFE", "LEBEN", "VIE", "VIDA", "VITE"),
	}

func get_hud_character_short_name(character_variant: int) -> String:
	match character_variant:
		1:
			return "CREAM"
		2:
			return "TAILS"
		3:
			return "KNUX"
		4:
			return "AMY"
		_:
			return "SONIC"

func get_hud_chrome_colors() -> Dictionary:
	if _run_from_multiplayer:
		return {
			"score_card": Color(0.32, 0.12, 0.10, 0.92),
			"rings_card": Color(0.44, 0.22, 0.06, 0.92),
			"lives_card": Color(0.24, 0.10, 0.18, 0.92),
			"timer_card": Color(0.30, 0.12, 0.20, 0.92),
			"status_card": Color(0.18, 0.08, 0.12, 0.90),
			"score_title": Color(1.0, 0.82, 0.52, 0.94),
			"rings_title": Color(1.0, 0.88, 0.44, 0.96),
			"time_title": Color(1.0, 0.82, 0.58, 0.94),
			"lives_title": Color(1.0, 0.74, 0.54, 0.94),
			"character": Color(1.0, 0.96, 0.88, 1.0),
			"text": Color(1.0, 0.96, 0.92, 1.0),
			"rings_value": Color(1.0, 0.92, 0.42, 1.0),
		}
	return {
		"score_card": Color(0.08, 0.16, 0.38, 0.92),
		"rings_card": Color(0.34, 0.18, 0.04, 0.92),
		"lives_card": Color(0.08, 0.14, 0.28, 0.92),
		"timer_card": Color(0.12, 0.18, 0.42, 0.92),
		"status_card": Color(0.08, 0.10, 0.18, 0.86),
		"score_title": Color(0.68, 0.86, 1.0, 0.94),
		"rings_title": Color(1.0, 0.84, 0.36, 0.96),
		"time_title": Color(0.74, 0.88, 1.0, 0.94),
		"lives_title": Color(0.72, 0.84, 1.0, 0.94),
		"character": Color(0.98, 0.98, 1.0, 1.0),
		"text": Color(0.96, 0.98, 1.0, 1.0),
		"rings_value": Color(1.0, 0.92, 0.42, 1.0),
	}

func is_multiplayer_run() -> bool:
	return _run_from_multiplayer

func is_time_attack_run() -> bool:
	return _run_from_time_attack

func _get_multiplayer_progress_value(player_index: int) -> float:
	if player_index == 0:
		var level_span: float = maxf(1.0, _level_state.max_x - _level_state.min_x)
		return clampf((_player_state.world_x - _level_state.min_x) / level_span, 0.0, 1.0)
	var rank_value: int = -1
	if player_index >= 0 and player_index < _multiplayer_player_ranks.size():
		rank_value = int(_multiplayer_player_ranks[player_index])
	var place_offset: float = float(maxi(0, rank_value))
	var host_progress: float = _get_multiplayer_progress_value(0)
	var pace_offset: float = 0.08 - place_offset * 0.11
	return clampf(host_progress + pace_offset, 0.0, 1.0)

func get_multiplayer_hud_rows() -> Array:
	var rows: Array = []
	if not _run_from_multiplayer:
		return rows
	var connected_indices: Array = []
	for i in range(_multiplayer_link_connected.size()):
		if bool(_multiplayer_link_connected[i]):
			connected_indices.append(i)
	connected_indices.sort_custom(func(a: Variant, b: Variant) -> bool:
		return _get_multiplayer_progress_value(int(a)) > _get_multiplayer_progress_value(int(b))
	)
	for place in range(connected_indices.size()):
		var player_index: int = int(connected_indices[place])
		var character_index := clampi(int(_multiplayer_player_characters[player_index]), 0, _character_names.size() - 1)
		var progress_value: float = _get_multiplayer_progress_value(player_index)
		rows.append({
			"name": get_multiplayer_link_player_name(player_index),
			"character": str(_character_names[character_index]),
			"place": place + 1,
			"place_text": "P%d" % [place + 1],
			"progress": progress_value,
			"progress_text": "%02d%%" % [int(progress_value * 100.0)],
			"is_local": player_index == 0,
		})
	return rows

func should_show_player_visual() -> bool:
	return not is_title_screen() and not is_save_options() and not is_clear_screen() and not is_intro_screen() and not is_final_intro_screen() and not is_chaos_emeralds_screen() and not is_missing_emeralds_screen() and not is_to_be_continued_screen() and not is_sega_logo_screen() and not is_sonic_team_logo_screen() and not is_credits_screen() and not is_copyright_screen() and not is_credits_end_screen() and not is_character_unlock_screen() and not is_special_stage_screen()

func get_player_visual_palette() -> Array:
	return [
		Color(0.20, 0.72, 1.0, 1.0),
		Color(0.99, 0.78, 0.32, 1.0),
		Color(0.98, 0.70, 0.18, 1.0),
		Color(0.88, 0.18, 0.18, 1.0),
		Color(0.96, 0.48, 0.64, 1.0),
	]

func get_player_visual_color(variant: int, cleared: bool = false) -> Color:
	if cleared:
		return Color(0.96, 0.86, 0.24, 1.0)
	if _player_state.super_sonic:
		return Color(1.0, 0.86, 0.18, 1.0)
	var palette := get_player_visual_palette()
	return palette[clampi(variant, 0, palette.size() - 1)]

func get_title_text() -> String:
	return _title_text

func is_touch_device() -> bool:
	return _is_touch_device()

func is_mobile_platform() -> bool:
	if OS.has_feature("mobile"):
		return true
	var platform := OS.get_name()
	return platform == "Android" or platform == "iOS"

func should_show_touch_controls() -> bool:
	return is_touch_device() and (is_mobile_platform() or _setting_enabled(TOUCH_CONTROLS_OVERRIDE_SETTING))

func should_show_touch_gameplay_controls() -> bool:
	return should_show_touch_controls() and is_gameplay_active() and not is_clear_screen() and not is_intro_screen()

func should_show_touch_menu_controls() -> bool:
	return should_show_touch_controls() and _is_touch_menu_interactive_screen() and not should_show_touch_gameplay_controls()

func should_show_touch_menu_horizontal_controls() -> bool:
	if not should_show_touch_menu_controls():
		return false
	if is_title_screen():
		return _is_touch_title_adjust_state()
	if is_save_options():
		return _is_touch_save_adjust_state()
	return false

func get_touch_menu_labels() -> Dictionary:
	var action_labels := _get_touch_menu_action_labels()
	var confirm_text := str(action_labels.get("confirm", "OK"))
	var back_text := str(action_labels.get("back", "Back"))
	var left_text := "Left"
	var right_text := "Right"
	var up_text := "Up"
	var down_text := "Down"
	if is_title_screen():
		var title_labels := _get_touch_title_adjust_labels()
		left_text = str(title_labels.get("left", left_text))
		right_text = str(title_labels.get("right", right_text))
		up_text = str(title_labels.get("up", up_text))
		down_text = str(title_labels.get("down", down_text))
	elif is_save_options():
		var save_labels := _get_touch_save_adjust_labels()
		left_text = str(save_labels.get("left", left_text))
		right_text = str(save_labels.get("right", right_text))
	var labels := {
		"confirm": _localize_touch_label(confirm_text),
		"back": _localize_touch_label(back_text),
		"left": _localize_touch_label(left_text),
		"right": _localize_touch_label(right_text),
		"up": _localize_touch_label(up_text),
		"down": _localize_touch_label(down_text),
	}
	return labels

func _localize_touch_label(label: String) -> String:
	match label:
		"Left": return _language_text("Left", "Links", "Gauche", "Izq", "Sinistra")
		"Right": return _language_text("Right", "Rechts", "Droite", "Der", "Destra")
		"Up": return _language_text("Up", "Hoch", "Haut", "Arriba", "Su")
		"Down": return _language_text("Down", "Runter", "Bas", "Abajo", "Giu")
		"Start": return _language_text("Start", "Start", "Depart", "Inicio", "Avvio")
		"Options": return _language_text("Options", "Optionen", "Options", "Opciones", "Opzioni")
		"Back": return _language_text("Back", "Zurueck", "Retour", "Atras", "Indietro")
		"Open": return _language_text("Open", "Oeffnen", "Ouvrir", "Abrir", "Apri")
		"Prev": return _language_text("Prev", "Zurueck", "Prec", "Ant", "Prec")
		"Next": return _language_text("Next", "Weiter", "Suiv", "Sig", "Succ")
		"Off": return _language_text("Off", "Aus", "Non", "No", "No")
		"On": return _language_text("On", "An", "Oui", "Si", "Si")
		"Zone": return _language_text("Zone", "Zone", "Zone", "Zona", "Zona")
		"Boss": return _language_text("Boss", "Boss", "Boss", "Jefe", "Boss")
		"Yes": return _language_text("Yes", "Ja", "Oui", "Si", "Si")
		"No": return _language_text("No", "Nein", "Non", "No", "No")
		"Apply": return _language_text("Apply", "Anwenden", "Appliquer", "Aplicar", "Applica")
		"Play": return _language_text("Play", "Abspielen", "Lire", "Reproducir", "Riproduci")
		"Stop": return _language_text("Stop", "Stopp", "Stop", "Parar", "Stop")
		"View": return _language_text("View", "Ansehen", "Voir", "Ver", "Vedi")
		"Pick": return _language_text("Pick", "Waehlen", "Choisir", "Elegir", "Scegli")
		"Delete": return _language_text("Delete", "Loeschen", "Suppr", "Borrar", "Elimina")
		"Continue": return _language_text("Continue", "Weiter", "Continuer", "Continuar", "Continua")
		"Rematch": return _language_text("Rematch", "Rueckspiel", "Rejouer", "Revancha", "Rivincita")
		"Skip": return _language_text("Skip", "Ueberspringen", "Passer", "Omitir", "Salta")
		"Fast": return _language_text("Fast", "Schnell", "Rapide", "Rapido", "Veloce")
		"Wait": return _language_text("Wait", "Warten", "Attendre", "Espera", "Attendi")
		"Lobby": return _language_text("Lobby", "Lobby", "Salle", "Sala", "Stanza")
		"Enter": return _language_text("Enter", "Eingabe", "Entrer", "Entrar", "Invio")
		"Select": return _language_text("Select", "Waehlen", "Selectionner", "Seleccionar", "Seleziona")
		"Restart": return _language_text("Restart", "Neustart", "Recommencer", "Reiniciar", "Riavvia")
		"Title": return _language_text("Title", "Titel", "Titre", "Titulo", "Titolo")
		"Link": return _language_text("Link", "Link", "Lien", "Enlace", "Collegamento")
		"Scan": return _language_text("Scan", "Suchen", "Scanner", "Buscar", "Scansione")
		"Send": return _language_text("Send", "Senden", "Envoyer", "Enviar", "Invia")
		"Sync": return _language_text("Sync", "Sync", "Sync", "Sincronizar", "Sincronizza")
		"Results": return _language_text("Results", "Ergebnisse", "Resultats", "Resultados", "Risultati")
		"Character": return _language_text("Character", "Charakter", "Personnage", "Personaje", "Personaggio")
		"Course": return _language_text("Course", "Kurs", "Parcours", "Fase", "Corso")
		"Lock": return _language_text("Lock", "Sperren", "Verrouiller", "Bloquear", "Blocca")
		"Auto": return _language_text("Auto", "Auto", "Auto", "Auto", "Auto")
		"Advance": return _language_text("Advance", "Weiter", "Avancer", "Avanzar", "Avanti")
	return label

func _is_touch_menu_interactive_screen() -> bool:
	return is_title_screen() \
		or is_multiplayer_outcome_screen() \
		or is_chaos_emeralds_screen() \
			or is_missing_emeralds_screen() \
		or is_to_be_continued_screen() \
		or is_sega_logo_screen() \
		or is_sonic_team_logo_screen() \
		or is_credits_screen() \
		or is_copyright_screen() \
		or is_credits_end_screen() \
		or is_character_unlock_screen() \
		or is_special_stage_screen() \
		or is_character_select() \
		or is_intro_screen() \
		or is_paused() \
		or is_clear_screen() \
		or is_game_over_screen() \
		or is_save_overlay_screen() \
		or is_player_data_screen() \
		or is_options_main_screen() \
		or is_time_records_screen() \
		or is_multiplayer_records_screen() \
		or is_name_entry_screen() \
		or is_language_screen() \
		or is_button_config_screen() \
		or is_sound_test_screen() \
		or is_difficulty_screen() \
		or is_time_limit_screen() \
		or is_delete_confirm_screen() \
		or is_delete_final_confirm_screen()

func _is_touch_save_adjust_state() -> bool:
	if not is_save_options():
		return false
	match _options_mode:
		OPTIONS_MODE_MAIN:
			return _options_menu_index >= 1 and _options_menu_index <= 3
		OPTIONS_MODE_LANGUAGE:
			return true
		OPTIONS_MODE_BUTTON_CONFIG:
			return true
		OPTIONS_MODE_SOUND_TEST:
			return true
		OPTIONS_MODE_DIFFICULTY, OPTIONS_MODE_TIME_LIMIT:
			return true
		OPTIONS_MODE_DELETE_CONFIRM, OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			return true
		OPTIONS_MODE_TIME_RECORDS:
			return true
		OPTIONS_MODE_NAME_ENTRY:
			return false
	return false

func _get_touch_save_adjust_labels() -> Dictionary:
	match _options_mode:
		OPTIONS_MODE_MAIN:
			match _options_menu_index:
				1:
					return {"left": "Prev", "right": "Next"}
				2:
					return {"left": "Off", "right": "On"}
				3:
					return {"left": "Prev", "right": "Next"}
		OPTIONS_MODE_LANGUAGE:
			return {"left": "Prev", "right": "Next"}
		OPTIONS_MODE_BUTTON_CONFIG:
			return {"left": "Prev", "right": "Next"}
		OPTIONS_MODE_SOUND_TEST:
			return {"left": "-1", "right": "+1", "up": "+10", "down": "-10"}
		OPTIONS_MODE_DIFFICULTY:
			return {"left": "Prev", "right": "Next"}
		OPTIONS_MODE_TIME_LIMIT:
			return {"left": "Off", "right": "On"}
		OPTIONS_MODE_DELETE_CONFIRM, OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			return {"left": "Yes", "right": "No"}
		OPTIONS_MODE_TIME_RECORDS:
			if _time_records_view == TIME_RECORDS_VIEW_MODE_CHOICE:
				return {"left": "Zone", "right": "Boss"}
			if _time_records_boss_mode:
				return {"left": "Prev", "right": "Next"}
			return {"left": "Prev", "right": "Next"}
		OPTIONS_MODE_NAME_ENTRY:
			return {"left": "Prev", "right": "Next", "up": "Up", "down": "Down"}
	return {"left": "Left", "right": "Right"}

func _is_touch_title_adjust_state() -> bool:
	match _title_phase:
		TITLE_PHASE_SINGLEPAK_RESULTS:
			return true
		TITLE_PHASE_MULTIPLAYER_LOBBY:
			return true
		TITLE_PHASE_COURSE_SELECT:
			return true
		TITLE_PHASE_TIME_ATTACK_LOBBY:
			return _time_attack_lobby_cursor == 2
	return false

func _get_touch_title_adjust_labels() -> Dictionary:
	match _title_phase:
		TITLE_PHASE_SINGLEPAK_RESULTS:
			return {"left": "Prev", "right": "Next"}
		TITLE_PHASE_MULTIPLAYER_LOBBY:
			return {"left": "Prev", "right": "Next"}
		TITLE_PHASE_COURSE_SELECT:
			return {"left": "Prev", "right": "Next", "up": "Prev", "down": "Next"}
		TITLE_PHASE_TIME_ATTACK_LOBBY:
			if _time_attack_lobby_cursor == 2:
				return {"left": "Prev", "right": "Next"}
	return {"left": "Left", "right": "Right", "up": "Up", "down": "Down"}

func _get_touch_menu_action_labels() -> Dictionary:
	if is_press_start_screen():
		return {"confirm": "Start", "back": "Options"}
	if is_title_screen():
		return _get_touch_title_action_labels()
	if is_clear_screen():
		if is_time_attack_clear_screen():
			return {"confirm": "Lobby", "back": "Wait"}
		return {"confirm": "Fast", "back": "Wait"}
	if is_to_be_continued_screen():
		return {"confirm": "Continue", "back": "Skip"}
	if is_chaos_emeralds_screen():
		return {"confirm": "Continue", "back": "Skip"}
	if is_missing_emeralds_screen():
		return {"confirm": "Continue", "back": "Skip"}
	if is_sega_logo_screen():
		return {"confirm": "Skip", "back": "Skip"}
	if is_sonic_team_logo_screen():
		return {"confirm": "Skip", "back": "Skip"}
	if is_credits_screen():
		return {"confirm": "Auto", "back": "Skip"}
	if is_copyright_screen():
		return {"confirm": "Continue", "back": "Skip"}
	if is_credits_end_screen() or is_character_unlock_screen():
		return {"confirm": "Continue", "back": "Skip"}
	if is_special_stage_screen():
		return {"confirm": "Enter", "back": "Skip"} if not is_special_stage_results_screen() else {"confirm": "Continue", "back": "Skip"}
	if is_character_select():
		return {"confirm": "Select", "back": "Back"}
	if is_intro_screen():
		return {"confirm": "Skip", "back": "Skip"}
	if is_game_over_screen():
		if _game_over_time_over and not _run_from_time_attack:
			return {"confirm": "Restart", "back": "Restart"}
		return {"confirm": "Title", "back": "Title"}
	if is_paused():
		return {"confirm": "Resume", "back": "Resume"}
	if is_save_options():
		return _get_touch_save_action_labels()
	return {"confirm": "OK", "back": "Back"}

func _get_touch_title_action_labels() -> Dictionary:
	match _title_phase:
		TITLE_PHASE_PRESS_START:
			return {"confirm": "Start", "back": "Options"}
		TITLE_PHASE_PLAY_MODE, TITLE_PHASE_SINGLE_PLAYER, TITLE_PHASE_MULTI_PLAYER, TITLE_PHASE_TIME_ATTACK, TITLE_PHASE_TINY_CHAO_GARDEN:
			var confirm_action := "Open"
			if _title_phase == TITLE_PHASE_SINGLE_PLAYER and _title_menu_index == 0:
				confirm_action = "Start"
			elif _title_phase == TITLE_PHASE_TINY_CHAO_GARDEN and _title_menu_index == 1:
				confirm_action = "Back"
			return {"confirm": confirm_action, "back": "Back"}
		TITLE_PHASE_MULTI_CONNECT:
			match _title_menu_index:
				0:
					return {"confirm": "Link" if _multiplayer_pak_mode == 0 else "Scan", "back": "Back"}
				1:
					return {"confirm": "Start" if _multiplayer_pak_mode == 0 else "Send", "back": "Back"}
				_:
					return {"confirm": "Back", "back": "Back"}
		TITLE_PHASE_SINGLEPAK_SYNC:
			match _title_menu_index:
				0:
					return {"confirm": "Sync", "back": "Back"}
				1:
					return {"confirm": "Results", "back": "Back"}
				_:
					return {"confirm": "Back", "back": "Back"}
		TITLE_PHASE_SINGLEPAK_RESULTS:
			if _singlepak_results_cursor == 0:
				return {"confirm": "Continue" if _multiplayer_result_mode == MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION else "Rematch", "back": "Back"}
			if _singlepak_results_cursor == 1:
				return {"confirm": "Back", "back": "Back"}
			return {"confirm": "OK", "back": "Back"}
		TITLE_PHASE_MULTIPLAYER_LOBBY:
			return {"confirm": "Rematch" if _multiplayer_lobby_cursor == 0 else "Title", "back": "Back"}
		TITLE_PHASE_TIME_ATTACK_LOBBY:
			match _time_attack_lobby_cursor:
				0:
					return {"confirm": "Start", "back": "Back"}
				1:
					return {"confirm": "Character", "back": "Back"}
				2:
					return {"confirm": "Course", "back": "Back"}
				_:
					return {"confirm": "Back", "back": "Back"}
		TITLE_PHASE_COURSE_SELECT:
			if is_course_select_starting():
				return {"confirm": "Wait", "back": "Back"}
			if is_course_select_busy():
				return {"confirm": "Lock", "back": "Back"}
			return {"confirm": "Lock" if _is_multiplayer_course_select() else "Start", "back": "Back"}
		TITLE_PHASE_MULTIPLAYER_OUTCOME:
			return {"confirm": "Continue", "back": "Skip"}
	return {"confirm": "OK", "back": "Back"}

func _get_touch_save_action_labels() -> Dictionary:
	match _options_mode:
		OPTIONS_MODE_MAIN:
			if _options_menu_index == get_options_menu_items().size() - 1:
				return {"confirm": "Title", "back": "Title"}
			return {"confirm": "Open", "back": "Title"}
		OPTIONS_MODE_PLAYER_DATA:
			return {"confirm": "Open", "back": "Back"}
		OPTIONS_MODE_LANGUAGE:
			return {"confirm": "Apply", "back": "Back"}
		OPTIONS_MODE_BUTTON_CONFIG:
			return {"confirm": "Advance", "back": "Back"}
		OPTIONS_MODE_SOUND_TEST:
			return {"confirm": "Play", "back": "Stop" if _sound_test_state == SOUND_TEST_STATE_PLAYING else "Back"}
		OPTIONS_MODE_DIFFICULTY, OPTIONS_MODE_TIME_LIMIT:
			return {"confirm": "Apply", "back": "Back"}
		OPTIONS_MODE_DELETE_CONFIRM, OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			return {"confirm": "Choose", "back": "Cancel"}
		OPTIONS_MODE_TIME_RECORDS:
			return {"confirm": "Open" if _time_records_view == TIME_RECORDS_VIEW_MODE_CHOICE else "View", "back": "Back"}
		OPTIONS_MODE_MULTI_RECORDS:
			return {"confirm": "View", "back": "Back"}
		OPTIONS_MODE_NAME_ENTRY:
			return {"confirm": "Pick", "back": "Delete"}
	return {"confirm": "OK", "back": "Back"}

func _is_touch_device() -> bool:
	if _setting_enabled(TOUCH_CONTROLS_OVERRIDE_SETTING):
		return true
	if is_mobile_platform():
		return true
	return false

func _setting_enabled(setting_name: String) -> bool:
	if not ProjectSettings.has_setting(setting_name):
		return false
	var value: Variant = ProjectSettings.get_setting(setting_name)
	if value is bool:
		return value
	if value is int:
		return value != 0
	if value is String:
		var normalized: String = value.strip_edges().to_lower()
		return normalized == "1" or normalized == "true" or normalized == "yes" or normalized == "on"
	return false

func get_navigation_label() -> String:
	return "SWIPE UP/DOWN" if _is_touch_device() else "UP/DOWN"

func get_confirm_label() -> String:
	return "TAP" if _is_touch_device() else "ENTER"

func get_secondary_label() -> String:
	return "TAP" if _is_touch_device() else "X"

func get_back_label() -> String:
	return "BACK" if _is_touch_device() else "X"

func get_title_prompt_text() -> String:
	match _title_phase:
		TITLE_PHASE_PRESS_START:
			return _language_text("%s OR %s TO START", "%s ODER %s ZUM STARTEN", "%s OU %s POUR COMMENCER", "%s O %s PARA EMPEZAR", "%s O %s PER INIZIARE") % [get_confirm_label(), "Z"]
		TITLE_PHASE_PLAY_MODE:
			return _language_text("%s SELECT   %s CONFIRM   %s BACK", "%s AUSWAEHLEN   %s BESTAETIGEN   %s ZURUECK", "%s SELECTIONNER   %s CONFIRMER   %s RETOUR", "%s SELECCIONAR   %s CONFIRMAR   %s ATRAS", "%s SELEZIONA   %s CONFERMA   %s INDIETRO") % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
		TITLE_PHASE_SINGLE_PLAYER:
			return _language_text("%s SELECT   %s CONFIRM   %s BACK", "%s AUSWAEHLEN   %s BESTAETIGEN   %s ZURUECK", "%s SELECTIONNER   %s CONFIRMER   %s RETOUR", "%s SELECCIONAR   %s CONFIRMAR   %s ATRAS", "%s SELEZIONA   %s CONFERMA   %s INDIETRO") % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
		TITLE_PHASE_MULTI_PLAYER:
			return _language_text("%s SELECT   %s CONFIRM   %s BACK", "%s AUSWAEHLEN   %s BESTAETIGEN   %s ZURUECK", "%s SELECTIONNER   %s CONFIRMER   %s RETOUR", "%s SELECCIONAR   %s CONFIRMAR   %s ATRAS", "%s SELEZIONA   %s CONFERMA   %s INDIETRO") % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
		TITLE_PHASE_TIME_ATTACK:
			return _language_text("%s SELECT   %s CONFIRM   %s BACK", "%s AUSWAEHLEN   %s BESTAETIGEN   %s ZURUECK", "%s SELECTIONNER   %s CONFIRMER   %s RETOUR", "%s SELECCIONAR   %s CONFIRMAR   %s ATRAS", "%s SELEZIONA   %s CONFERMA   %s INDIETRO") % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
		TITLE_PHASE_TINY_CHAO_GARDEN:
			return _language_text("%s SELECT   %s CONFIRM   %s BACK", "%s AUSWAEHLEN   %s BESTAETIGEN   %s ZURUECK", "%s SELECTIONNER   %s CONFIRMER   %s RETOUR", "%s SELECCIONAR   %s CONFIRMAR   %s ATRAS", "%s SELEZIONA   %s CONFERMA   %s INDIETRO") % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
		TITLE_PHASE_MULTI_CONNECT:
			return _language_text("%s SELECT   %s CONFIRM   %s BACK", "%s AUSWAEHLEN   %s BESTAETIGEN   %s ZURUECK", "%s SELECTIONNER   %s CONFIRMER   %s RETOUR", "%s SELECCIONAR   %s CONFIRMAR   %s ATRAS", "%s SELEZIONA   %s CONFERMA   %s INDIETRO") % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
		TITLE_PHASE_TINY_CHAO_SETUP:
			return _language_text("%s SELECT   %s CONFIRM   %s BACK", "%s AUSWAEHLEN   %s BESTAETIGEN   %s ZURUECK", "%s SELECTIONNER   %s CONFIRMER   %s RETOUR", "%s SELECCIONAR   %s CONFIRMAR   %s ATRAS", "%s SELEZIONA   %s CONFERMA   %s INDIETRO") % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
		TITLE_PHASE_SINGLEPAK_SYNC:
			return _language_text("%s SELECT   %s CONFIRM   %s BACK", "%s AUSWAEHLEN   %s BESTAETIGEN   %s ZURUECK", "%s SELECTIONNER   %s CONFIRMER   %s RETOUR", "%s SELECCIONAR   %s CONFIRMAR   %s ATRAS", "%s SELEZIONA   %s CONFERMA   %s INDIETRO") % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
		TITLE_PHASE_SINGLEPAK_RESULTS:
			return _language_text("%s SELECT   %s CONFIRM   %s BACK", "%s AUSWAEHLEN   %s BESTAETIGEN   %s ZURUECK", "%s SELECTIONNER   %s CONFIRMER   %s RETOUR", "%s SELECCIONAR   %s CONFIRMAR   %s ATRAS", "%s SELEZIONA   %s CONFERMA   %s INDIETRO") % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
		TITLE_PHASE_MULTIPLAYER_LOBBY:
			return _language_text("%s SELECT   %s CONFIRM   %s BACK", "%s AUSWAEHLEN   %s BESTAETIGEN   %s ZURUECK", "%s SELECTIONNER   %s CONFIRMER   %s RETOUR", "%s SELECCIONAR   %s CONFIRMAR   %s ATRAS", "%s SELEZIONA   %s CONFERMA   %s INDIETRO") % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
		TITLE_PHASE_TIME_ATTACK_LOBBY:
			return _language_text("%s SELECT   %s CONFIRM   LEFT/RIGHT COURSE   %s BACK", "%s AUSWAEHLEN   %s BESTAETIGEN   LINKS/RECHTS KURS   %s ZURUECK", "%s SELECTIONNER   %s CONFIRMER   PARCOURS GAUCHE/DROITE   %s RETOUR", "%s SELECCIONAR   %s CONFIRMAR   FASE IZQ/DER   %s ATRAS", "%s SELEZIONA   %s CONFERMA   CORSO SINISTRA/DESTRA   %s INDIETRO") % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
		TITLE_PHASE_COURSE_SELECT:
			if is_course_select_starting():
				return _language_text("STARTING STAGE...", "STUFE STARTET...", "DEBUT DU STAGE...", "INICIANDO FASE...", "AVVIO STAGE...")
			if is_course_select_busy():
				return _language_text("COURSE MOVING...", "KURS BEWEGT SICH...", "PARCOURS EN MOUVEMENT...", "FASE EN MOVIMIENTO...", "CORSO IN MOVIMENTO...")
			return _language_text("LEFT/RIGHT COURSE   %s START   %s BACK", "LINKS/RECHTS KURS   %s START   %s ZURUECK", "PARCOURS GAUCHE/DROITE   %s DEPART   %s RETOUR", "FASE IZQ/DER   %s INICIO   %s ATRAS", "CORSO SINISTRA/DESTRA   %s AVVIO   %s INDIETRO") % [get_confirm_label(), get_secondary_label()]
		TITLE_PHASE_MULTIPLAYER_OUTCOME:
			return _language_text("%s CONTINUE   %s SKIP", "%s WEITER   %s UEBERSPRINGEN", "%s CONTINUER   %s PASSER", "%s CONTINUAR   %s OMITIR", "%s CONTINUA   %s SALTA") % [get_confirm_label(), get_secondary_label()]
	return _language_text("%s SELECT, %s TO BEGIN, %s OPTIONS", "%s AUSWAEHLEN, %s ZUM STARTEN, %s OPTIONEN", "%s SELECTIONNER, %s POUR COMMENCER, %s OPTIONS", "%s SELECCIONAR, %s PARA EMPEZAR, %s OPCIONES", "%s SELEZIONA, %s PER INIZIARE, %s OPZIONI") % [get_navigation_label(), get_confirm_label(), get_secondary_label()]

func get_press_start_title_text() -> String:
	return get_title_text()

func get_press_start_prompt_text() -> String:
	if not _title_notice_text.is_empty():
		return get_title_notice_text()
	return get_title_prompt_text()

func get_press_start_subtitle_text() -> String:
	return _language_text("HIGH-SPEED ACTION", "HOCHGESCHWINDIGKEIT", "ACTION RAPIDE", "ACCION A TODA VELOCIDAD", "AZIONE AD ALTA VELOCITA")

func get_title_logo_source_tilemap() -> String:
	return "sa2_title_logo_jp" if _language_index == 0 else "sa2_logo_en"

func get_title_background_source_tilemap() -> String:
	return "title_screen_bg"

func get_press_start_info_rows() -> Array:
	return [
		{
			"text": _language_text("SINGLE PLAYER   MULTIPLAYER", "EINZELSPIELER   MULTIPLAYER", "JOUEUR SOLO   MULTIJOUEUR", "UN JUGADOR   MULTIJUGADOR", "GIOCATORE SINGOLO   MULTIPLAYER"),
			"position": Vector2(292.0, 382.0),
			"color": Color(0.22, 0.42, 0.78, 0.94),
			"pulse": false,
		},
		{
			"text": _language_text("PRESS START", "START DRUECKEN", "APPUYER SUR START", "PULSA START", "PREMI START"),
			"position": Vector2(444.0, 468.0),
			"color": Color(0.92, 0.42, 0.18, 0.95),
			"pulse": true,
			"pulse_min_alpha": 0.52,
		},
	]

func get_press_start_chrome_colors() -> Dictionary:
	return {
		"header": Color(1.0, 1.0, 1.0, 0.98),
		"panel": Color(0.90, 0.95, 1.0, 0.98),
		"footer": Color(0.96, 0.98, 1.0, 0.99),
	}

func adjust_title_selection(direction: int) -> void:
	if _game_state != GAME_STATE_TITLE:
		return
	if _title_phase == TITLE_PHASE_SINGLEPAK_RESULTS:
		_singlepak_results_cursor = wrapi(_singlepak_results_cursor + direction, 0, get_singlepak_results_items().size())
		_status_text = get_title_prompt_text()
		return
	if _title_phase == TITLE_PHASE_MULTIPLAYER_LOBBY:
		if _multiplayer_lobby_waiting:
			_title_notice_text = "WAITING FOR ALL LINKED PLAYERS"
			_status_text = get_title_prompt_text()
			return
		_multiplayer_lobby_cursor = wrapi(_multiplayer_lobby_cursor + direction, 0, get_multiplayer_lobby_items().size())
		_title_notice_text = "REMATCH SELECTED" if _multiplayer_lobby_cursor == 0 else "EXIT TO TITLE SELECTED"
		_status_text = get_title_prompt_text()
		return
	if _title_phase == TITLE_PHASE_COURSE_SELECT:
		_start_course_select_travel(direction)
		return
	if _title_phase != TITLE_PHASE_TIME_ATTACK_LOBBY:
		return
	if _time_attack_lobby_cursor != 2:
		return
	_selected_level_index = clampi(_selected_level_index + direction, 0, _unlocked_level_index)
	_title_notice_text = "COURSE SET TO %s" % get_selected_level_text()
	_status_text = get_title_prompt_text()
	_save_save_data()

func _start_course_select_travel(direction: int) -> void:
	if _title_phase != TITLE_PHASE_COURSE_SELECT:
		return
	if is_course_select_busy():
		return
	_course_select_from_index = _selected_level_index
	_course_select_to_index = clampi(_selected_level_index + direction, 0, _unlocked_level_index)
	if _course_select_to_index == _course_select_from_index:
		return
	_selected_level_index = _course_select_to_index
	_course_select_travel_timer = _course_select_travel_duration
	_course_select_settle_timer = 0.0
	_course_select_start_timer = 0.0
	_title_notice_text = "COURSE SET TO %s" % get_selected_level_text()
	_status_text = get_title_prompt_text()
	_save_save_data()

func move_title_selection(direction: int) -> void:
	if _game_state != GAME_STATE_TITLE:
		return
	_title_notice_text = ""
	match _title_phase:
		TITLE_PHASE_PRESS_START:
			return
		TITLE_PHASE_PLAY_MODE:
			_title_menu_index = wrapi(_title_menu_index + direction, 0, get_title_menu_items().size())
		TITLE_PHASE_SINGLE_PLAYER:
			_title_menu_index = wrapi(_title_menu_index + direction, 0, get_title_menu_items().size())
		TITLE_PHASE_MULTI_PLAYER:
			_title_menu_index = wrapi(_title_menu_index + direction, 0, get_title_menu_items().size())
		TITLE_PHASE_TIME_ATTACK:
			_title_menu_index = wrapi(_title_menu_index + direction, 0, get_title_menu_items().size())
		TITLE_PHASE_TINY_CHAO_GARDEN:
			_title_menu_index = wrapi(_title_menu_index + direction, 0, get_title_menu_items().size())
		TITLE_PHASE_MULTI_CONNECT:
			# The original link screen has no cursor; it waits for START/B only.
			return
		TITLE_PHASE_TINY_CHAO_SETUP:
			_title_menu_index = wrapi(_title_menu_index + direction, 0, get_title_menu_items().size())
		TITLE_PHASE_SINGLEPAK_SYNC:
			_title_menu_index = wrapi(_title_menu_index + direction, 0, get_title_menu_items().size())
		TITLE_PHASE_SINGLEPAK_RESULTS:
			# Multiplayer results are an automatic presentation in the original.
			return
		TITLE_PHASE_MULTIPLAYER_LOBBY:
			# The original rematch lobby is horizontal: Up/Down do not move YES/NO.
			return
		TITLE_PHASE_TIME_ATTACK_LOBBY:
			# The original lobby keeps the cursor within its four fixed rows.
			_time_attack_lobby_cursor = clampi(_time_attack_lobby_cursor + signi(direction), 0, get_time_attack_lobby_rows().size() - 1)
		TITLE_PHASE_COURSE_SELECT:
			if not is_course_select_busy():
				_start_course_select_travel(direction)
		TITLE_PHASE_MULTIPLAYER_OUTCOME:
			return
	_status_text = get_title_prompt_text()
	_save_save_data()

func start_title_selection() -> void:
	if _game_state != GAME_STATE_TITLE:
		return
	_title_notice_text = ""
	match _title_phase:
		TITLE_PHASE_PRESS_START:
			open_title_screen_at_play_mode_menu(0, "", true)
			return
		TITLE_PHASE_PLAY_MODE:
			match _title_menu_index:
				0:
					open_title_screen_at_single_player_menu(0, "", true)
					return
				1:
					open_title_screen_at_multiplayer_menu(0)
					return
		TITLE_PHASE_SINGLE_PLAYER:
			match _title_menu_index:
				0:
					if not has_profile_name():
						open_profile_name_from_game_start()
						return
					open_character_select(CHARACTER_SELECT_CONTEXT_GAME_START)
				1:
					open_title_screen_at_time_attack_menu(0)
					return
				2:
					open_options_screen()
					return
				3:
					open_tiny_chao_garden_menu(0)
					return
		TITLE_PHASE_MULTI_PLAYER:
			match _title_menu_index:
				0:
					if not has_profile_name():
						open_profile_name_from_multiplayer()
						return
					_start_multiplayer_mode(0)
				1:
					if not has_profile_name():
						open_profile_name_from_multiplayer()
						return
					_start_multiplayer_mode(1)
		TITLE_PHASE_TIME_ATTACK:
			match _title_menu_index:
				0:
					# time_attack_mode_select.c creates the carousel at Sonic.
					open_character_select(CHARACTER_SELECT_CONTEXT_TIME_ATTACK_ZONE, 0)
					return
				1:
					if not _boss_time_attack_unlocked:
						_title_notice_text = "BOSS TIME ATTACK LOCKED"
						return
					open_character_select(CHARACTER_SELECT_CONTEXT_TIME_ATTACK_BOSS, 0)
					return
		TITLE_PHASE_TIME_ATTACK_LOBBY:
			match _time_attack_lobby_cursor:
				0:
					_begin_level_run(_selected_level_index, true)
					return
				1:
					# time_attack_lobby.c resets gCurrentLevel to Zone 1 Act 1
					# before opening character select.
					_selected_level_index = 0
					open_character_select(CHARACTER_SELECT_CONTEXT_TIME_ATTACK_BOSS if _time_attack_boss_mode else CHARACTER_SELECT_CONTEXT_TIME_ATTACK_ZONE)
					return
				2:
					open_course_select(TITLE_PHASE_TIME_ATTACK_LOBBY)
					return
				3:
					open_title_screen_and_skip_intro()
					return
		TITLE_PHASE_COURSE_SELECT:
			if is_course_select_starting():
				return
			if is_course_select_busy():
				if not _is_multiplayer_course_select():
					_course_select_confirm_pending = true
					_title_notice_text = "COURSE LOCKED IN"
				_status_text = get_title_prompt_text()
				return
			_course_select_start_timer = _course_select_start_duration
			_title_notice_text = "STARTING %s" % get_selected_level_text()
			_status_text = get_title_prompt_text()
			return
		TITLE_PHASE_TINY_CHAO_GARDEN:
			match _title_menu_index:
				0:
					open_tiny_chao_setup_menu(0, "TINY CHAO GARDEN READY")
					return
				1:
					open_title_screen_at_single_player_menu(3)
					return
		TITLE_PHASE_MULTI_CONNECT:
			# Connection is automatic in the original; START only begins the
			# host-side handshake once a client is visible.
			advance_multiplayer_link_state()
			if get_multiplayer_link_count() < 2:
				_title_notice_text = "WAITING FOR %s LINK" % ["MULTI-PAK" if _multiplayer_pak_mode == 0 else "SINGLE-PAK"]
				return
			if _multiplayer_pak_mode == 0:
				_open_multiplayer_outcome(0, TITLE_PHASE_MULTI_CONNECT)
				return
			_singlepak_download_timer = 0.0
			_advance_singlepak_transfer_step()
			return
		TITLE_PHASE_MULTIPLAYER_OUTCOME:
			_resolve_multiplayer_outcome()
			return
		TITLE_PHASE_SINGLEPAK_SYNC:
			match _title_menu_index:
				0:
					if is_singlepak_sync_ready():
						_begin_level_run(_selected_level_index, false, true)
						return
					advance_singlepak_sync_state()
				1:
					if is_singlepak_sync_ready():
						_prepare_multiplayer_results_snapshot(MULTIPLAYER_RESULTS_MODE_COURSE_COMPLETE)
						open_singlepak_results_screen(MULTIPLAYER_RESULTS_MODE_COURSE_COMPLETE, 0)
					else:
						_title_notice_text = "CLIENTS STILL SYNCHRONIZING"
				2:
					if is_singlepak_transfer_started():
						_title_notice_text = "WAIT FOR CLIENT BOOT TO FINISH"
					else:
						open_title_screen_at_multiplayer_menu(1)
					return
		TITLE_PHASE_SINGLEPAK_RESULTS:
			# The source has no input handler on this screen; the timer advances it.
			return
		TITLE_PHASE_MULTIPLAYER_LOBBY:
			if _multiplayer_lobby_waiting:
				_title_notice_text = "WAITING FOR ALL LINKED PLAYERS"
				return
			_multiplayer_lobby_waiting = true
			_multiplayer_lobby_wait_timer = _multiplayer_lobby_wait_duration
			_title_notice_text = "WAITING FOR REMATCH CONFIRMATIONS" if _multiplayer_lobby_cursor == 0 else "WAITING FOR EXIT CONFIRMATIONS"
			_status_text = get_title_prompt_text()
			return
		TITLE_PHASE_TINY_CHAO_SETUP:
			match _title_menu_index:
				0:
					if _tiny_chao_session_id == "TCG-0000":
						_generate_tiny_chao_session_id()
					open_tiny_chao_garden_play()
					return
				1:
					_generate_tiny_chao_session_id()
					_title_notice_text = "NEW SESSION ID READY"
				2:
					open_tiny_chao_garden_menu(0)
					return
	_status_text = get_title_prompt_text()

func open_save_options_from_title() -> void:
	if _game_state != GAME_STATE_TITLE:
		return
	if _title_phase == TITLE_PHASE_SINGLE_PLAYER:
		open_title_screen_at_play_mode_menu(0)
		return
	if _title_phase == TITLE_PHASE_MULTI_PLAYER:
		open_title_screen_at_play_mode_menu(1)
		return
	if _title_phase == TITLE_PHASE_TIME_ATTACK:
		open_title_screen_at_single_player_menu(1)
		return
	if _title_phase == TITLE_PHASE_TIME_ATTACK_LOBBY:
		open_title_screen_at_time_attack_menu(1 if _time_attack_boss_mode else 0)
		return
	if _title_phase == TITLE_PHASE_COURSE_SELECT:
		if _is_multiplayer_course_select():
			# course_select.c has no B action for the multiplayer host.
			return
		return_from_course_select()
		return
	if _title_phase == TITLE_PHASE_TINY_CHAO_GARDEN:
		open_title_screen_at_single_player_menu(3)
		return
	if _title_phase == TITLE_PHASE_MULTI_CONNECT:
		# singlepak_connection.c ignores B once MultiBootStartMaster has
		# begun; interrupting that transfer leaves the linked client half-booted.
		if _multiplayer_pak_mode == 1 and is_singlepak_transfer_started():
			return
		_multiplayer_disconnect_timer = 5.0 / 60.0
		_title_notice_text = "DISCONNECTING LINK"
		_status_text = get_title_prompt_text()
		return
	if _title_phase == TITLE_PHASE_MULTIPLAYER_OUTCOME:
		_resolve_multiplayer_outcome()
		return
	if _title_phase == TITLE_PHASE_SINGLEPAK_SYNC:
		open_title_screen_at_multiplayer_menu(1)
		return
	if _title_phase == TITLE_PHASE_SINGLEPAK_RESULTS:
		if _multiplayer_result_mode == MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION:
			open_multiplayer_lobby_screen(0)
		else:
			open_singlepak_sync_screen(1)
		return
	if _title_phase == TITLE_PHASE_MULTIPLAYER_LOBBY:
		# The original VS lobby only commits its YES/NO choice; B must not
		# skip into a results screen from this waiting state.
		_title_notice_text = "SELECT YES OR NO TO CONTINUE"
		_status_text = get_title_prompt_text()
		return
	if _title_phase == TITLE_PHASE_TINY_CHAO_SETUP:
		open_tiny_chao_garden_menu(0)
		return
	if _title_phase == TITLE_PHASE_PLAY_MODE:
		open_title_screen_and_skip_intro()
		return
	open_options_screen()

func open_options_screen() -> void:
	_game_state = GAME_STATE_SAVE_OPTIONS
	_options_mode = OPTIONS_MODE_MAIN
	# CreateOptionsScreen starts a fresh options context. Do not let a
	# previous profile-creation route affect a normal title/options visit.
	_creating_new_profile = false
	_return_to_multiplayer_after_name_entry = false
	_return_to_title_after_new_profile = false
	_return_to_multiplayer_menu_index = 0
	_options_menu_index = 0
	_player_data_menu_index = 0
	_button_config_index = 0
	_sound_test_menu_index = 0
	_sound_test_state = SOUND_TEST_STATE_STOPPED
	_time_records_menu_index = 0
	_time_records_view = TIME_RECORDS_VIEW_MODE_CHOICE
	_time_records_context = TIME_RECORDS_CONTEXT_OPTIONS
	_time_records_boss_mode = false
	_time_records_character_index = 0
	_time_records_course_index = 0
	_time_records_act_index = 0
	_multi_records_menu_index = 0
	_name_entry_menu_index = 0
	_name_entry_cursor_col = 0
	_name_entry_cursor_row = 0
	_name_entry_matrix_page_index = 0
	_delete_confirm_index = 1
	_save_reset_pending = false
	_status_text = "OPTIONS"

func open_profile_name_from_multiplayer() -> void:
	open_options_screen()
	_return_to_multiplayer_after_name_entry = true
	_return_to_title_after_new_profile = false
	_return_to_multiplayer_menu_index = _title_menu_index
	if not has_profile_name():
		_creating_new_profile = true
		_language_index_before_edit = _language_index
		_options_mode = OPTIONS_MODE_LANGUAGE
		_status_text = "SELECT PROFILE LANGUAGE"
		return
	_options_mode = OPTIONS_MODE_NAME_ENTRY
	_reset_name_entry_navigation()
	_name_entry_snapshot = _player_profile_name.duplicate()
	_multiplayer_name_entry_snapshot = _player_profile_name.duplicate()
	_status_text = "NAME ENTRY"

func open_profile_name_from_game_start() -> void:
	open_options_screen()
	_return_to_multiplayer_after_name_entry = false
	_return_to_title_after_new_profile = true
	_creating_new_profile = true
	_language_index_before_edit = _language_index
	_options_mode = OPTIONS_MODE_LANGUAGE
	_status_text = "SELECT PROFILE LANGUAGE"

func _return_from_name_entry_to_multiplayer(saved: bool) -> void:
	if not saved and not _multiplayer_name_entry_snapshot.is_empty():
		_player_profile_name = _multiplayer_name_entry_snapshot.duplicate()
	if saved:
		_multiplayer_link_players[0] = _get_multiplayer_host_name()
		_persist_frontend_state()
	_multiplayer_name_entry_snapshot.clear()
	_return_to_multiplayer_after_name_entry = false
	_return_to_title_after_new_profile = false
	_creating_new_profile = false
	open_title_screen_at_multiplayer_menu(clampi(_return_to_multiplayer_menu_index, 0, 1), "PROFILE NAME SAVED" if saved else "")

func _reset_name_entry_navigation() -> void:
	# ProfileNameScreenInitRegisters starts non-Japanese names on the source
	# character-matrix page 99 and places the input cursor at the first empty
	# name slot. Japanese starts at the first matrix page.
	_name_entry_menu_index = _player_profile_name.size() - 1
	for i in range(_player_profile_name.size()):
		if str(_player_profile_name[i]).strip_edges().is_empty():
			_name_entry_menu_index = i
			break
	_name_entry_cursor_col = 0
	_name_entry_cursor_row = 0
	_name_entry_matrix_page_index = 0 if _language_index == 0 else 99

func _start_multiplayer_mode(pak_mode: int) -> void:
	_multiplayer_pak_mode = clampi(pak_mode, 0, 1)
	_multiplayer_link_connected = [true, false, false, false]
	_reset_multiplayer_session_state()
	_multiplayer_link_ready = false
	_singlepak_download_progress = 0
	_singlepak_sync_step = 0
	open_multiplayer_comm_screen(_multiplayer_pak_mode, 0)

func move_save_selection(direction: int) -> void:
	if _game_state != GAME_STATE_SAVE_OPTIONS:
		return
	var items: Array = get_options_active_items()
	if items.is_empty():
		return
	match _options_mode:
		OPTIONS_MODE_MAIN:
			_options_menu_index = wrapi(_options_menu_index + direction, 0, items.size())
		OPTIONS_MODE_PLAYER_DATA:
			_player_data_menu_index = wrapi(_player_data_menu_index + direction, 0, items.size())
		OPTIONS_MODE_LANGUAGE:
			_language_index = wrapi(_language_index + direction, 0, get_language_items().size())
		OPTIONS_MODE_BUTTON_CONFIG:
			return
		OPTIONS_MODE_SOUND_TEST:
			_move_sound_test_vertical(direction)
			if _sound_test_state == SOUND_TEST_STATE_STOPPED:
				_status_text = get_sound_test_status_text()
		OPTIONS_MODE_DIFFICULTY:
			# The original switch menu only reacts to Left/Right.
			return
		OPTIONS_MODE_TIME_LIMIT:
			# The original switch menu only reacts to Left/Right.
			return
		OPTIONS_MODE_MULTI_RECORDS:
			var next_index := clampi(_multi_records_menu_index + direction, 0, get_multiplayer_records_scroll_max())
			if next_index != _multi_records_menu_index:
				_multi_records_menu_index = next_index
				_status_text = "VERSUS RECORDS"
		OPTIONS_MODE_DELETE_CONFIRM, OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			# The original delete prompts only react to Left/Right.
			return
		OPTIONS_MODE_TIME_RECORDS:
			if _time_records_context == TIME_RECORDS_CONTEXT_OPTIONS and _time_records_view == TIME_RECORDS_VIEW_COURSES:
				_time_records_character_index = wrapi(_time_records_character_index + direction, 0, get_time_records_character_rows().size())
		OPTIONS_MODE_NAME_ENTRY:
			_move_name_entry_cursor_vertical(direction)

func is_save_main_menu_screen() -> bool:
	return _game_state == GAME_STATE_SAVE_OPTIONS and _options_mode == OPTIONS_MODE_MAIN

func save_direction_consumes_action(frame_input: int) -> bool:
	if _game_state != GAME_STATE_SAVE_OPTIONS:
		return false
	var vertical := bool(frame_input & (DPAD_UP | DPAD_DOWN))
	var horizontal := bool(frame_input & (DPAD_LEFT | DPAD_RIGHT))
	if _options_mode == OPTIONS_MODE_SOUND_TEST:
		# sound_test.c handles the pad first, then still reads A/B in that frame.
		return false
	match _options_mode:
		OPTIONS_MODE_PLAYER_DATA, OPTIONS_MODE_LANGUAGE, OPTIONS_MODE_NAME_ENTRY:
			return vertical
		OPTIONS_MODE_BUTTON_CONFIG, OPTIONS_MODE_DIFFICULTY, OPTIONS_MODE_TIME_LIMIT:
			return horizontal
		OPTIONS_MODE_DELETE_CONFIRM, OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			return horizontal
		OPTIONS_MODE_TIME_RECORDS:
			# The mode-choice task only returns after Left/Right. Up/Down
			# does not block A/B on that frame, unlike the courses view.
			if _time_records_view == TIME_RECORDS_VIEW_MODE_CHOICE:
				return horizontal
			return vertical or horizontal
	return false

func adjust_save_selection(direction: int) -> void:
	if _game_state != GAME_STATE_SAVE_OPTIONS:
		return
	match _options_mode:
		OPTIONS_MODE_MAIN:
			# The original top-level screen only moves its cursor vertically.
			# Settings change inside their dedicated submenus after confirmation.
			return
		OPTIONS_MODE_LANGUAGE:
			# The original language screen only moves on the vertical pad.
			return
		OPTIONS_MODE_BUTTON_CONFIG:
			_cycle_button_config_binding(direction)
		OPTIONS_MODE_SOUND_TEST:
			_sound_test_track_index = wrapi(_sound_test_track_index + direction, 0, get_sound_test_track_count())
			if _sound_test_state == SOUND_TEST_STATE_STOPPED:
				_status_text = get_sound_test_status_text()
		OPTIONS_MODE_DIFFICULTY:
			_difficulty_index = wrapi(_difficulty_index + direction, 0, 2)
		OPTIONS_MODE_TIME_LIMIT:
			# The original submenu treats either shoulder direction as a switch.
			_time_limit_enabled = not _time_limit_enabled
		OPTIONS_MODE_DELETE_CONFIRM, OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			_delete_confirm_index = wrapi(_delete_confirm_index + direction, 0, 2)
		OPTIONS_MODE_TIME_RECORDS:
			if _time_records_view == TIME_RECORDS_VIEW_MODE_CHOICE:
				_time_records_boss_mode = direction > 0
				return
			_advance_time_records_course(direction)
		OPTIONS_MODE_NAME_ENTRY:
			_move_name_entry_cursor_horizontal(direction)

func accept_save_selection() -> void:
	if _game_state != GAME_STATE_SAVE_OPTIONS:
		return
	if _save_reset_pending:
		_reset_progress()
		_save_reset_pending = false
		_options_mode = OPTIONS_MODE_PLAYER_DATA
		_player_data_menu_index = 0
		_status_text = "PLAYER DATA"
		return
	match _options_mode:
		OPTIONS_MODE_MAIN:
			# Keep the action semantic. Display labels are localized and must not
			# be used as control-flow keys.
			match _options_menu_index:
				0:
					_options_mode = OPTIONS_MODE_PLAYER_DATA
					_player_data_menu_index = 0
				1:
					_difficulty_before_edit = _difficulty_index
					_options_mode = OPTIONS_MODE_DIFFICULTY
				2:
					_time_limit_before_edit = _time_limit_enabled
					_options_mode = OPTIONS_MODE_TIME_LIMIT
				3:
					_language_index_before_edit = _language_index
					_options_mode = OPTIONS_MODE_LANGUAGE
				4:
					_options_mode = OPTIONS_MODE_BUTTON_CONFIG
					_button_config_index = 0
					_button_bindings_before_edit = _button_bindings.duplicate()
				5:
					if _sound_test_unlocked:
						_options_mode = OPTIONS_MODE_SOUND_TEST
						_sound_test_menu_index = 0
						_sound_test_state = SOUND_TEST_STATE_STOPPED
					else:
						_options_mode = OPTIONS_MODE_DELETE_CONFIRM
						_delete_confirm_index = 1
				6:
					if _sound_test_unlocked:
						_options_mode = OPTIONS_MODE_DELETE_CONFIRM
						_delete_confirm_index = 1
					else:
						_persist_frontend_state()
						open_title_screen_at_single_player_menu(0)
						return
				7:
					_persist_frontend_state()
					open_title_screen_at_single_player_menu(0)
					return
		OPTIONS_MODE_PLAYER_DATA:
			match _player_data_menu_index:
				0:
					_options_mode = OPTIONS_MODE_NAME_ENTRY
					_reset_name_entry_navigation()
					_name_entry_snapshot = _player_profile_name.duplicate()
				1:
					_options_mode = OPTIONS_MODE_TIME_RECORDS
					_time_records_menu_index = 0
					_time_records_context = TIME_RECORDS_CONTEXT_OPTIONS
					# The source skips the mode-choice screen until Boss Time
					# Attack has been unlocked.
					_time_records_view = TIME_RECORDS_VIEW_MODE_CHOICE if _boss_time_attack_unlocked else TIME_RECORDS_VIEW_COURSES
					_time_records_boss_mode = false
					_time_records_character_index = 0
					_time_records_course_index = 0
					_time_records_act_index = 0
				2:
					_options_mode = OPTIONS_MODE_MULTI_RECORDS
					_multi_records_menu_index = 0
				3:
					_options_mode = OPTIONS_MODE_MAIN
					_options_menu_index = 0
		OPTIONS_MODE_LANGUAGE:
			_language_index_before_edit = _language_index
			if _creating_new_profile:
				_player_profile_name = [" ", " ", " ", " ", " ", " "]
				_name_entry_snapshot = _player_profile_name.duplicate()
				_multiplayer_name_entry_snapshot = _player_profile_name.duplicate()
				_reset_name_entry_navigation()
				_options_mode = OPTIONS_MODE_NAME_ENTRY
				_status_text = "NAME ENTRY"
			else:
				_options_mode = OPTIONS_MODE_MAIN
				_options_menu_index = 3
		OPTIONS_MODE_BUTTON_CONFIG:
			match _button_config_index:
				0:
					_finalize_button_config_a_stage()
				1:
					_finalize_button_config_b_stage()
				2:
					_commit_button_config_bindings()
					_options_mode = OPTIONS_MODE_MAIN
					_options_menu_index = 4
		OPTIONS_MODE_SOUND_TEST:
			_sound_test_state = SOUND_TEST_STATE_PLAYING
			_status_text = get_sound_test_status_text()
			return
		OPTIONS_MODE_DIFFICULTY:
			_options_mode = OPTIONS_MODE_MAIN
			_options_menu_index = 1
		OPTIONS_MODE_TIME_LIMIT:
			_options_mode = OPTIONS_MODE_MAIN
			_options_menu_index = 2
		OPTIONS_MODE_DELETE_CONFIRM:
			if _delete_confirm_index == 0:
				_options_mode = OPTIONS_MODE_DELETE_CONFIRM_FINAL
				_delete_confirm_index = 1
			else:
				_options_mode = OPTIONS_MODE_MAIN
				_options_menu_index = _get_options_item_index("DELETE GAME DATA")
		OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			if _delete_confirm_index == 0:
				_reset_progress()
				_options_mode = OPTIONS_MODE_MAIN
				_options_menu_index = 0
				_status_text = "SAVE DATA DELETED"
				return
			_options_mode = OPTIONS_MODE_MAIN
			_options_menu_index = _get_options_item_index("DELETE GAME DATA")
		OPTIONS_MODE_TIME_RECORDS:
			if _time_records_view == TIME_RECORDS_VIEW_MODE_CHOICE:
				_time_records_view = TIME_RECORDS_VIEW_COURSES
				_time_records_menu_index = 0
			else:
				if _time_records_context == TIME_RECORDS_CONTEXT_TIME_ATTACK:
					_selected_character_index = _time_records_character_index
					_player_state.variant = _selected_character_index
					_time_attack_boss_mode = _time_records_boss_mode
					_selected_level_index = _get_time_records_level_index()
					_begin_level_run(_selected_level_index, true)
					return
				update_save_menu_status()
				return
		OPTIONS_MODE_MULTI_RECORDS:
			# The original screen is a browse-only table; A does not open a row.
			_status_text = "VERSUS RECORDS"
			return
		OPTIONS_MODE_NAME_ENTRY:
			if _is_name_entry_control_cursor():
				match _name_entry_cursor_row:
					NAME_ENTRY_CONTROL_ROW_BACK:
						_move_name_entry_active_slot(-1)
					NAME_ENTRY_CONTROL_ROW_FORWARD:
						_move_name_entry_active_slot(1)
					NAME_ENTRY_CONTROL_ROW_END:
						if not has_profile_name():
							_status_text = "PROFILE NAME REQUIRED"
							return
						_name_entry_snapshot = _player_profile_name.duplicate()
						_save_save_data()
						if _return_to_multiplayer_after_name_entry:
							_return_from_name_entry_to_multiplayer(true)
						elif _return_to_title_after_new_profile:
							_return_to_title_after_new_profile = false
							_creating_new_profile = false
							open_title_screen_at_single_player_menu(0, "PROFILE SAVED")
						else:
							_options_mode = OPTIONS_MODE_PLAYER_DATA
							_player_data_menu_index = 0
							_status_text = "NAME SAVED"
						return
			else:
				_apply_name_entry_selected_cell()
				update_save_menu_status()
				return
	update_save_menu_status()

func cancel_save_selection() -> void:
	if _game_state != GAME_STATE_SAVE_OPTIONS:
		return
	if _save_reset_pending:
		_save_reset_pending = false
		update_save_menu_status()
		return
	match _options_mode:
		OPTIONS_MODE_MAIN:
			_persist_frontend_state()
			open_title_screen_at_single_player_menu(0)
		OPTIONS_MODE_PLAYER_DATA:
			_options_mode = OPTIONS_MODE_MAIN
			_options_menu_index = 0
			update_save_menu_status()
		OPTIONS_MODE_LANGUAGE:
			_language_index = _language_index_before_edit
			if _creating_new_profile:
				_creating_new_profile = false
				if _return_to_multiplayer_after_name_entry:
					_return_to_multiplayer_after_name_entry = false
					open_title_screen_at_multiplayer_menu(clampi(_return_to_multiplayer_menu_index, 0, 1), "PROFILE CREATION CANCELED")
				else:
					_return_to_title_after_new_profile = false
					open_title_screen_at_single_player_menu(0, "PROFILE CREATION CANCELED")
				return
			_options_mode = OPTIONS_MODE_MAIN
			_options_menu_index = 3
			update_save_menu_status()
		OPTIONS_MODE_BUTTON_CONFIG:
			match _button_config_index:
				0:
					_button_bindings = _button_bindings_before_edit.duplicate()
					_options_mode = OPTIONS_MODE_MAIN
					_options_menu_index = 4
				1:
					# The original B stage starts the configuration over at A.
					_button_config_index = 0
				2:
					# The original R stage returns to the B stage, preserving the
					# preview so the last assignment can still be adjusted.
					_button_config_index = 1
			update_save_menu_status()
		OPTIONS_MODE_SOUND_TEST:
			if _sound_test_state == SOUND_TEST_STATE_PLAYING:
				_sound_test_state = SOUND_TEST_STATE_STOPPED
			else:
				_options_mode = OPTIONS_MODE_MAIN
				_options_menu_index = 5
			update_save_menu_status()
		OPTIONS_MODE_DIFFICULTY:
			_difficulty_index = _difficulty_before_edit
			_options_mode = OPTIONS_MODE_MAIN
			_options_menu_index = 1
			update_save_menu_status()
		OPTIONS_MODE_TIME_LIMIT:
			_time_limit_enabled = _time_limit_before_edit
			_options_mode = OPTIONS_MODE_MAIN
			_options_menu_index = 2
			update_save_menu_status()
		OPTIONS_MODE_DELETE_CONFIRM, OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			_options_mode = OPTIONS_MODE_MAIN
			_options_menu_index = _get_options_item_index("DELETE GAME DATA")
			update_save_menu_status()
		OPTIONS_MODE_TIME_RECORDS:
			if _time_records_context == TIME_RECORDS_CONTEXT_TIME_ATTACK:
				open_character_select(CHARACTER_SELECT_CONTEXT_TIME_ATTACK_BOSS if _time_records_boss_mode else CHARACTER_SELECT_CONTEXT_TIME_ATTACK_ZONE, _time_records_character_index)
			else:
				_options_mode = OPTIONS_MODE_PLAYER_DATA
				_player_data_menu_index = 1
			update_save_menu_status()
		OPTIONS_MODE_MULTI_RECORDS:
			_options_mode = OPTIONS_MODE_PLAYER_DATA
			_player_data_menu_index = 2
			update_save_menu_status()
		OPTIONS_MODE_NAME_ENTRY:
			_player_profile_name = _name_entry_snapshot.duplicate()
			if _return_to_multiplayer_after_name_entry:
				_return_from_name_entry_to_multiplayer(false)
			elif _return_to_title_after_new_profile:
				_return_to_title_after_new_profile = false
				_creating_new_profile = false
				open_title_screen_at_single_player_menu(0, "PROFILE CREATION CANCELED")
			else:
				_options_mode = OPTIONS_MODE_PLAYER_DATA
				_player_data_menu_index = 0
			update_save_menu_status()

func trigger_save_special_action() -> bool:
	if _game_state != GAME_STATE_SAVE_OPTIONS or _save_reset_pending:
		return false
	if _options_mode != OPTIONS_MODE_BUTTON_CONFIG:
		return false
	_button_bindings = ["JUMP", "ATTACK", "TRICK"]
	_button_bindings_before_edit = _button_bindings.duplicate()
	_save_save_data()
	_button_config_index = 0
	update_save_menu_status()
	return true

func trigger_save_start_action() -> bool:
	if _game_state != GAME_STATE_SAVE_OPTIONS or _save_reset_pending:
		return false
	if _options_mode != OPTIONS_MODE_NAME_ENTRY:
		return false
	# The original START shortcut moves to END first; a second START commits.
	if not (_name_entry_cursor_col == NAME_ENTRY_CONTROLS_COL and _name_entry_cursor_row == NAME_ENTRY_CONTROL_ROW_END):
		_name_entry_cursor_col = NAME_ENTRY_CONTROLS_COL
		_name_entry_cursor_row = NAME_ENTRY_CONTROL_ROW_END
		update_save_menu_status()
		return true
	return false

func trigger_save_secondary_action() -> bool:
	if _game_state != GAME_STATE_SAVE_OPTIONS or _save_reset_pending:
		return false
	if _options_mode != OPTIONS_MODE_NAME_ENTRY:
		return false
	_delete_name_entry_character()
	update_save_menu_status()
	return true

func handle_save_shoulder_input(frame_input: int) -> bool:
	if _game_state != GAME_STATE_SAVE_OPTIONS or _save_reset_pending:
		return false
	if _options_mode != OPTIONS_MODE_NAME_ENTRY:
		return false
	if frame_input & L_BUTTON:
		_move_name_entry_active_slot(-1)
		update_save_menu_status()
		return true
	if frame_input & R_BUTTON:
		_move_name_entry_active_slot(1)
		update_save_menu_status()
		return true
	return false

func skip_intro() -> void:
	if _game_state != GAME_STATE_INTRO:
		return
	if not can_skip_intro():
		return
	if _intro_timer > INTRO_COUNTDOWN_START:
		_intro_timer = INTRO_COUNTDOWN_START
		_intro_primed = true
		_status_text = "3"

func can_skip_final_intro() -> bool:
	return _game_state == GAME_STATE_FINAL_INTRO and _final_intro_pending

func skip_final_intro() -> void:
	if not can_skip_final_intro():
		return
	_final_intro_pending = false
	_final_intro_timer = 0.0
	_intro_timer = INTRO_TOTAL_TIME
	_intro_primed = false
	_game_state = GAME_STATE_INTRO
	_status_text = "READY!"

func can_skip_intro() -> bool:
	if _run_from_multiplayer:
		return false
	return not (_run_from_time_attack and _time_attack_boss_mode)

func _is_boss_intro() -> bool:
	return _run_from_time_attack and _time_attack_boss_mode

func clear_replay() -> void:
	if _game_state != GAME_STATE_CLEAR or not is_clear_input_ready():
		return
	if _run_from_time_attack:
		_time_attack_exit_timer = TIME_ATTACK_RESULTS_EXIT_FADE_SECONDS


func clear_return_to_title() -> void:
	if _game_state != GAME_STATE_CLEAR or not is_clear_input_ready():
		return
	# Normal stage results advance automatically, matching stage_results.c.

func skip_chaos_emeralds_message() -> void:
	# missing_emeralds.c has no input path for the completion message.
	return

func skip_missing_emeralds_message() -> void:
	# missing_emeralds.c resolves automatically.
	return

func skip_to_be_continued() -> void:
	# The ending cutscene has no input path.
	return

func get_selected_level_text() -> String:
	return _level_names[_selected_level_index]

func get_selected_level_index() -> int:
	return _selected_level_index

func get_title_phase() -> int:
	return _title_phase

func get_title_menu_items() -> Array:
	match _title_phase:
		TITLE_PHASE_PLAY_MODE:
			return ["SINGLE PLAYER", "MULTI PLAYER"]
		TITLE_PHASE_SINGLE_PLAYER:
			var items := ["GAME START", "TIME ATTACK", "OPTIONS"]
			if is_tiny_chao_unlocked():
				items.append("TINY CHAO GARDEN")
			return items
		TITLE_PHASE_MULTI_PLAYER:
			return ["MULTI-PAK", "SINGLE-PAK"]
		TITLE_PHASE_TIME_ATTACK:
			return ["ZONE", "BOSS"]
		TITLE_PHASE_TINY_CHAO_GARDEN:
			return ["LINK SETUP", "BACK"]
		TITLE_PHASE_MULTI_CONNECT:
			return ["CONNECT" if _multiplayer_pak_mode == 0 else "SCAN CLIENTS", "PRESS START" if _multiplayer_pak_mode == 0 else "START DOWNLOAD", "BACK"]
		TITLE_PHASE_TINY_CHAO_SETUP:
			return ["TRANSFER DATA", "SESSION ID", "BACK"]
		TITLE_PHASE_SINGLEPAK_SYNC:
			return ["SYNC CLIENTS", "RESULTS", "BACK"]
		TITLE_PHASE_SINGLEPAK_RESULTS:
			return get_singlepak_results_items()
		TITLE_PHASE_MULTIPLAYER_LOBBY:
			return get_multiplayer_lobby_items()
		TITLE_PHASE_MULTIPLAYER_OUTCOME:
			return ["CONTINUE"]
		TITLE_PHASE_TIME_ATTACK_LOBBY:
			return ["START", "CHARACTER", "COURSE", "TITLE"]
		TITLE_PHASE_COURSE_SELECT:
			return []
	return []

func get_play_mode_rows() -> Array:
	return [
		{
			"name": _language_text("SINGLE PLAYER", "EINZELSPIELER", "JOUEUR SOLO", "UN JUGADOR", "GIOCATORE SINGOLO"),
			"description": _language_text("STORY, STAGES AND SOLO PROGRESSION", "GESCHICHTE, LEVELS UND SOLO-FORTSCHRITT", "HISTOIRE, NIVEAUX ET PROGRESSION SOLO", "HISTORIA, FASES Y PROGRESO EN SOLITARIO", "STORIA, LIVELLI E PROGRESSIONE SOLA"),
			"status": _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"),
			"available": true,
			"selected": _title_menu_index == 0,
		},
		{
			"name": _language_text("MULTI PLAYER", "MEHRSPIELER", "MULTIJOUEUR", "MULTIJUGADOR", "MULTIGIOCATORE"),
			"description": _language_text("LINK RACES, BATTLES AND SHARED RESULTS", "LINK-RENNEN, KAEMPFE UND GEMEINSAME ERGEBNISSE", "COURSES, COMBATS ET RESULTATS PARTAGES", "CARRERAS, BATALLAS Y RESULTADOS COMPARTIDOS", "GARE, SFIDE E RISULTATI CONDIVISI"),
			"status": _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO") if has_profile_name() else _language_text("NAME REQ", "NAME NOETIG", "NOM REQUIS", "NOMBRE REQUERIDO", "NOME RICHIESTO"),
			"available": has_profile_name(),
			"selected": _title_menu_index == 1,
		},
	]

func get_play_mode_title_text() -> String:
	return _language_text("PLAY MODE", "SPIELMODUS", "MODE DE JEU", "MODO DE JUEGO", "MODALITA DI GIOCO")

func get_play_mode_prompt_text() -> String:
	if not _title_notice_text.is_empty():
		return get_title_notice_text()
	return _language_text("SELECT A PLAY STYLE", "SPIELART AUSWAEHLEN", "CHOISIR UN MODE", "SELECCIONA UN MODO", "SCEGLI UNA MODALITA")

func get_play_mode_detail_text() -> String:
	return get_title_prompt_text()

func get_play_mode_info_text() -> String:
	if _title_menu_index == 0:
		return _language_text("START THE SINGLE-PLAYER FRONT END", "EINZELSPIELER-MENUE STARTEN", "LANCER LE MENU SOLO", "INICIAR EL MENU EN SOLITARIO", "AVVIA IL MENU GIOCATORE SINGOLO")
	return _language_text("OPEN THE MULTIPLAYER MODE SELECT", "MEHRSPIELER-MODUS OEFFNEN", "OUVRIR LE CHOIX MULTIJOUEUR", "ABRIR SELECCION MULTIJUGADOR", "APRI LA SELEZIONE MULTIGIOCATORE")

func get_play_mode_summary_text() -> String:
	if _title_menu_index == 0:
		return "%s\n%s: %s\n%s: %s" % [_language_text("SINGLE PLAYER", "EINZELSPIELER", "JOUEUR SOLO", "UN JUGADOR", "GIOCATORE SINGOLO"), _language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), get_profile_name_text(), _language_text("START POINT", "STARTPUNKT", "POINT DE DEPART", "PUNTO DE INICIO", "PUNTO DI PARTENZA"), get_selected_level_text()]
	return "%s\n%s: %s\n%s: %s" % [_language_text("MULTIPLAYER", "MEHRSPIELER", "MULTIJOUEUR", "MULTIJUGADOR", "MULTIGIOCATORE"), _language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), get_profile_name_text(), _language_text("NAME STATUS", "NAMENSSTATUS", "STATUT DU NOM", "ESTADO DEL NOMBRE", "STATO NOME"), _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO") if has_profile_name() else _language_text("REQUIRED", "ERFORDERLICH", "REQUIS", "REQUERIDO", "RICHIESTO")]

func get_play_mode_badge_text() -> String:
	return "SOLO" if _title_menu_index == 0 else "VS"

func get_play_mode_chrome_colors() -> Dictionary:
	if _title_menu_index == 0:
		return {
			"panel": Color(0.04, 0.09, 0.19, 0.94),
			"accent": Color(0.17, 0.56, 0.92, 0.72),
			"badge": Color(0.10, 0.20, 0.34, 0.95),
			"summary": Color(0.07, 0.14, 0.25, 0.95),
		}
	return {
		"panel": Color(0.11, 0.08, 0.14, 0.95),
		"accent": Color(0.92, 0.42, 0.22, 0.78),
		"badge": Color(0.30, 0.12, 0.12, 0.96),
		"summary": Color(0.24, 0.10, 0.12, 0.95),
	}

func get_single_player_rows() -> Array:
	var rows := [
		{
			"name": _language_text("GAME START", "SPIELSTART", "DEBUT DU JEU", "INICIO", "INIZIO"),
			"description": _language_text("BEGIN THE MAIN ADVENTURE", "DAS HAUPTABENTEUER STARTEN", "COMMENCER L'AVENTURE PRINCIPALE", "COMENZAR LA AVENTURA PRINCIPAL", "INIZIA L'AVVENTURA PRINCIPALE"),
			"status": _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"),
			"available": true,
			"selected": _title_menu_index == 0,
		},
		{
			"name": _language_text("TIME ATTACK", "ZEITANGRIFF", "CONTRE LA MONTRE", "CONTRARRELOJ", "ATTACCO A TEMPO"),
			"description": _language_text("RACE FOR THE FASTEST CLEAR TIME", "UM DIE SCHNELLSTE ABSCHLUSSZEIT RENNEN", "COURIR POUR LE MEILLEUR TEMPS", "CORRE POR EL MEJOR TIEMPO", "CORRI PER IL TEMPO MIGLIORE"),
			"status": _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"),
			"available": true,
			"selected": _title_menu_index == 1,
		},
		{
			"name": _language_text("OPTIONS", "OPTIONEN", "OPTIONS", "OPCIONES", "OPZIONI"),
			"description": _language_text("ADJUST SAVE DATA AND SYSTEM SETTINGS", "SPEICHER- UND SYSTEMEINSTELLUNGEN AENDERN", "REGLER LES DONNEES ET LE SYSTEME", "AJUSTAR DATOS Y SISTEMA", "REGOLA DATI E IMPOSTAZIONI"),
			"status": _language_text("SETUP", "EINSTELLUNGEN", "CONFIGURATION", "AJUSTES", "CONFIGURA"),
			"available": true,
			"selected": _title_menu_index == 2,
		},
	]
	if is_tiny_chao_unlocked():
		rows.append({
			"name": _language_text("TINY CHAO GARDEN", "KLEINER CHAO-GARTEN", "MINI JARDIN CHAO", "JARDIN CHAO", "GIARDINO CHAO"),
			"description": _language_text("OPEN THE HANDHELD CHAO GARDEN LINK", "CHAO-GARTEN-LINK OEFFNEN", "OUVRIR LE LIEN DU JARDIN CHAO", "ABRIR EL ENLACE DEL JARDIN CHAO", "APRI IL COLLEGAMENTO GIARDINO CHAO"),
			"status": _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"),
			"available": true,
			"selected": _title_menu_index == 3,
		})
	return rows

func get_single_player_title_text() -> String:
	return _language_text("SINGLE PLAYER", "EINZELSPIELER", "JOUEUR SOLO", "UN JUGADOR", "GIOCATORE SINGOLO")

func get_single_player_prompt_text() -> String:
	if not _title_notice_text.is_empty():
		return get_title_notice_text()
	return _language_text("SELECT A MODE", "MODUS AUSWAEHLEN", "CHOISIR UN MODE", "SELECCIONA UN MODO", "SCEGLI UNA MODALITA")

func get_single_player_detail_text() -> String:
	return get_title_prompt_text()

func get_single_player_info_text() -> String:
	match _title_menu_index:
		0:
			return _language_text("START A STANDARD STORY RUN", "STANDARD-GESCHICHTE STARTEN", "LANCER UNE AVENTURE STANDARD", "INICIAR UNA HISTORIA ESTANDAR", "AVVIA UNA STORIA STANDARD")
		1:
			return _language_text("REPLAY CLEARED STAGES FOR BEST TIMES", "GESCHAFFTE LEVELS FUER BESTZEITEN SPIELEN", "REJOUER LES NIVEAUX POUR LES RECORDS", "REPITE FASES PARA MEJORES TIEMPOS", "RIGIOCA I LIVELLI PER I RECORD")
		2:
			return _language_text("PROFILE, SAVE, SOUND, AND CONTROL SETTINGS", "PROFIL-, SPEICHER-, TON- UND STEUERUNGSOPTIONEN", "PROFIL, SAUVEGARDE, SON ET COMMANDES", "PERFIL, DATOS, SONIDO Y CONTROLES", "PROFILO, SALVATAGGI, AUDIO E COMANDI")
		3:
			if is_tiny_chao_unlocked():
				return _language_text("DIRECT HANDOFF TO TINY CHAO GARDEN", "DIREKTE UEBERGABE ZUM CHAO-GARTEN", "TRANSFERT DIRECT AU JARDIN CHAO", "ENLACE DIRECTO AL JARDIN CHAO", "COLLEGAMENTO DIRETTO AL GIARDINO CHAO")
	return _language_text("SELECT A MODE", "MODUS WAEHLEN", "CHOISIR UN MODE", "SELECCIONA UN MODO", "SCEGLI UNA MODALITA")

func get_single_player_summary_title() -> String:
	match _title_menu_index:
		0:
			return _language_text("GAME START", "SPIELSTART", "DEBUT DU JEU", "INICIO", "INIZIO")
		1:
			return _language_text("TIME ATTACK", "ZEITANGRIFF", "CONTRE LA MONTRE", "CONTRARRELOJ", "ATTACCO A TEMPO")
		2:
			return _language_text("OPTIONS", "OPTIONEN", "OPTIONS", "OPCIONES", "OPZIONI")
		3:
			if is_tiny_chao_unlocked():
				return _language_text("TINY CHAO GARDEN", "KLEINER CHAO-GARTEN", "MINI JARDIN CHAO", "JARDIN CHAO", "GIARDINO CHAO")
	return _language_text("SINGLE PLAYER", "EINZELSPIELER", "JOUEUR SOLO", "UN JUGADOR", "GIOCATORE SINGOLO")

func get_single_player_summary_text() -> String:
	match _title_menu_index:
		0:
			return "%s\n%s: %s\n%s: %s" % [_language_text("MAIN GAME", "HAUPTSPIEL", "JEU PRINCIPAL", "JUEGO PRINCIPAL", "GIOCO PRINCIPALE"), _language_text("CURRENT RUNNER", "AKTUELLER CHARAKTER", "PERSONNAGE ACTUEL", "PERSONAJE ACTUAL", "PERSONAGGIO ATTUALE"), get_selected_character_name(), _language_text("START POINT", "STARTPUNKT", "POINT DE DEPART", "PUNTO DE INICIO", "PUNTO DI PARTENZA"), get_selected_level_text()]
		1:
			return "%s\n%s: %s\n%s: SOLO" % [_language_text("TIME ATTACK", "ZEITANGRIFF", "CONTRE LA MONTRE", "CONTRARRELOJ", "ATTACCO A TEMPO"), _language_text("BOSS ATTACK", "BOSS-ANGRIFF", "ATTAQUE BOSS", "ATAQUE BOSS", "ATTACCO BOSS"), _language_text("UNLOCKED", "FREIGESCHALTET", "DEBLOQUE", "DESBLOQUEADO", "SBLOCCATO") if _boss_time_attack_unlocked else _language_text("LOCKED", "GESPERRT", "VERROUILLE", "BLOQUEADO", "BLOCCATO"), _language_text("BEST MODE", "BESTER MODUS", "MEILLEUR MODE", "MEJOR MODO", "MODALITA MIGLIORE")]
		2:
			return "%s\n%s: %s\n%s: %s" % [_language_text("SAVE OPTIONS", "SPEICHEROPTIONEN", "OPTIONS DE SAUVEGARDE", "OPCIONES DE DATOS", "OPZIONI SALVATAGGIO"), _language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), get_profile_name_text(), _language_text("LANGUAGE", "SPRACHE", "LANGUE", "IDIOMA", "LINGUA"), get_language_text()]
		3:
			if is_tiny_chao_unlocked():
				return "%s\n%s: %s\n%s: %s" % [_language_text("TINY CHAO GARDEN", "KLEINER CHAO-GARTEN", "MINI JARDIN CHAO", "JARDIN CHAO", "GIARDINO CHAO"), _language_text("SESSION ID", "SITZUNGS-ID", "ID SESSION", "ID DE SESION", "ID SESSIONE"), _tiny_chao_session_id, _language_text("STATUS", "STATUS", "STATUT", "ESTADO", "STATO"), _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO")]
	return ""

func get_single_player_chrome_colors() -> Dictionary:
	match _title_menu_index:
		1:
			return {
				"header": Color(0.12, 0.18, 0.34, 0.96),
				"summary": Color(0.08, 0.14, 0.28, 0.96),
			}
		2:
			return {
				"header": Color(0.15, 0.16, 0.26, 0.96),
				"summary": Color(0.10, 0.11, 0.20, 0.96),
			}
		3:
			if is_tiny_chao_unlocked():
				return {
					"header": Color(0.08, 0.20, 0.18, 0.96),
					"summary": Color(0.06, 0.16, 0.14, 0.96),
				}
	return {
		"header": Color(0.09, 0.16, 0.31, 0.95),
		"summary": Color(0.07, 0.13, 0.23, 0.95),
	}

func get_multiplayer_mode_rows() -> Array:
	var multi_pak := _language_text("MULTI-PAK", "MULTI-PAK", "MULTI-PAK", "MULTI-PAK", "MULTI-PAK")
	var single_pak := _language_text("SINGLE-PAK", "SINGLE-PAK", "SINGLE-PAK", "SINGLE-PAK", "SINGLE-PAK")
	var ready := _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO")
	var name_required := _language_text("NAME REQ", "NAME NOETIG", "NOM REQUIS", "NOMBRE REQ", "NOME RICHIESTO")
	return [
		{
			"name": multi_pak,
			"description": _language_text("2-4 PLAYERS USING ONE GAME PAK EACH", "2-4 SPIELER MIT JE EINEM GAME PAK", "2-4 JOUEURS AVEC UN GAME PAK CHACUN", "2-4 JUGADORES CON UN GAME PAK CADA UNO", "2-4 GIOCATORI CON UN GAME PAK CIASCUNO"),
			"status": ready if has_profile_name() else name_required,
			"available": has_profile_name(),
			"selected": _title_menu_index == 0,
		},
		{
			"name": single_pak,
			"description": _language_text("HOST A DOWNLOAD MATCH FROM ONE GAME PAK", "DOWNLOAD-MATCH MIT EINEM GAME PAK HOSTEN", "HEBER UNE PARTIE TELECHARGEE DEPUIS UN GAME PAK", "ALBERGAR UNA PARTIDA DESCARGADA DESDE UN GAME PAK", "OSPITA UNA PARTITA DOWNLOAD DA UN GAME PAK"),
			"status": ready if has_profile_name() else name_required,
			"available": has_profile_name(),
			"selected": _title_menu_index == 1,
		},
	]

func get_multiplayer_mode_title_text() -> String:
	return _language_text("SELECT PAK MODE", "PAK-MODUS", "MODE PAK", "MODO PAK", "MODALITA PAK")

func get_multiplayer_mode_prompt_text() -> String:
	if not _title_notice_text.is_empty():
		return get_title_notice_text()
	return _language_text("CHOOSE A LINK STYLE", "LINK-ART AUSWAEHLEN", "CHOISIR UN MODE DE LIAISON", "ELIGE UN TIPO DE ENLACE", "SCEGLI UN TIPO DI COLLEGAMENTO")

func get_multiplayer_mode_summary_text() -> String:
	var mode_label := _language_text("MODE", "MODUS", "MODE", "MODO", "MODALITA")
	var players_label := _language_text("PLAYERS", "SPIELER", "JOUEURS", "JUGADORES", "GIOCATORI")
	var profile_label := _language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO")
	if _title_menu_index == 0:
		return "%s\nMULTI-PAK\n\n%s\n2-4 LINKED SYSTEMS\n\n%s\n%s" % [mode_label, players_label, profile_label, get_profile_name_text()]
	return "%s\nSINGLE-PAK\n\n%s\n1 HOST + CLIENT DOWNLOADS\n\n%s\n%s" % [mode_label, players_label, profile_label, get_profile_name_text()]

func get_multiplayer_mode_detail_text() -> String:
	if has_profile_name():
		return "%s SELECT   %s CONFIRM   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
	return "PROFILE NAME REQUIRED BEFORE LINK PLAY\n%s SELECT   %s CONFIRM   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]

func get_multiplayer_mode_info_text() -> String:
	if _title_menu_index == 0:
		return _language_text("ONE GAME PAK PER PLAYER.\nSTART A STANDARD LINK SESSION.", "EIN GAME PAK PRO SPIELER.\nSTANDARD-LINKSESSION STARTEN.", "UN GAME PAK PAR JOUEUR.\nLANCER UNE SESSION STANDARD.", "UN GAME PAK POR JUGADOR.\nINICIA UNA SESION ESTANDAR.", "UN GAME PAK PER GIOCATORE.\nAVVIA UNA SESSIONE STANDARD.")
	return _language_text("THE HOST SENDS THE CLIENT PROGRAM.\nBEST FOR QUICK LOCAL MATCHES.", "DER HOST SENDT DAS CLIENT-PROGRAMM.\nIDEAL FUER SCHNELLE LOKALE PARTIEN.", "L'HOTE ENVOIE LE PROGRAMME CLIENT.\nIDEAL POUR DES PARTIES LOCALES RAPIDES.", "EL HOST ENVIA EL PROGRAMA CLIENT.\nIDEAL PARA PARTIDAS LOCALES RAPIDAS.", "L'HOST INVIA IL PROGRAMMA CLIENT.\nIDEALE PER PARTITE LOCALI RAPIDE.")

func get_multiplayer_mode_badge_text() -> String:
	return "LINK" if _title_menu_index == 0 else "DL"

func is_multiplayer_link_mode() -> bool:
	return _title_menu_index == 0

func get_multiplayer_mode_chrome_colors() -> Dictionary:
	if _title_menu_index == 0:
		return {
			"accent": Color(0.95, 0.52, 0.18, 1.0),
			"badge": Color(0.96, 0.72, 0.18, 1.0),
			"summary": Color(0.96, 0.94, 0.88, 0.98),
		}
	return {
		"accent": Color(0.86, 0.38, 0.24, 1.0),
		"badge": Color(0.88, 0.50, 0.22, 1.0),
		"summary": Color(0.96, 0.90, 0.84, 0.98),
	}

func get_time_attack_mode_rows() -> Array:
	return [
		{
			"name": _language_text("ZONE", "ZONE", "ZONE", "ZONA", "ZONA"),
			"description": _language_text("CLEAR A ZONE AS FAST AS POSSIBLE", "EINE ZONE SO SCHNELL WIE MOEGLICH ABSCHLIESSEN", "TERMINER UNE ZONE LE PLUS VITE POSSIBLE", "SUPERA UNA ZONA LO MAS RAPIDO POSIBLE", "COMPLETA UNA ZONA IL PIU VELOCE POSSIBILE"),
			"status": _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"),
			"locked": false,
			"selected": _title_menu_index == 0,
		},
		{
			"name": _language_text("BOSS", "BOSS", "BOSS", "JEFE", "BOSS"),
			"description": _language_text("DEFEAT A BOSS AS FAST AS POSSIBLE", "EINEN BOSS SO SCHNELL WIE MOEGLICH BESIEGEN", "VAINCRE UN BOSS LE PLUS VITE POSSIBLE", "DERROTA AL JEFE LO MAS RAPIDO POSIBLE", "SCONFIGGI UN BOSS IL PIU VELOCE POSSIBILE"),
			"status": _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO") if _boss_time_attack_unlocked else _language_text("LOCKED", "GESPERRT", "VERROUILLE", "BLOQUEADO", "BLOCCATO"),
			"locked": not _boss_time_attack_unlocked,
			"selected": _title_menu_index == 1,
		},
	]

func get_time_attack_mode_title_text() -> String:
	return _language_text("TIME ATTACK", "ZEITANGRIFF", "CONTRE LA MONTRE", "CONTRARRELOJ", "ATTACCO A TEMPO")

func get_time_attack_mode_prompt_text() -> String:
	if not _title_notice_text.is_empty():
		return get_title_notice_text()
	return _language_text("SELECT ATTACK MODE", "ANGRIFFSMODUS WAEHLEN", "CHOISIR LE MODE D'ATTAQUE", "ELIGE MODO DE ATAQUE", "SCEGLI MODALITA ATTACCO")

func get_time_attack_mode_detail_text() -> String:
	return "%s\n%s SELECT   %s CONFIRM   %s BACK" % [_language_text("CLEAR RECORDS AND BOSS CHALLENGES", "REKORDE UND BOSS-HERAUSFORDERUNGEN", "RECORDS ET DEFIS BOSS", "RECORDS Y RETOS DE JEFE", "RECORD E SFIDE BOSS"), get_navigation_label(), get_confirm_label(), get_secondary_label()]

func get_time_attack_mode_summary_text() -> String:
	match _title_menu_index:
		0:
			return "%s\n%s: %s\n%s: %s" % [_language_text("ZONE TIME ATTACK", "ZONEN-ZEITANGRIFF", "CONTRE-LA-MONTRE ZONE", "CONTRARRELOJ DE ZONA", "ATTACCO A TEMPO ZONA"), _language_text("COURSE", "KURS", "PARCOURS", "FASE", "CORSO"), get_selected_level_text(), _language_text("CHARACTER", "CHARAKTER", "PERSONNAGE", "PERSONAJE", "PERSONAGGIO"), get_selected_character_name()]
		1:
			return "%s\n%s: %s\n%s: %s" % [_language_text("BOSS TIME ATTACK", "BOSS-ZEITANGRIFF", "CONTRE-LA-MONTRE BOSS", "CONTRARRELOJ DE JEFE", "ATTACCO A TEMPO BOSS"), _language_text("STATUS", "STATUS", "STATUT", "ESTADO", "STATO"), _language_text("UNLOCKED", "FREIGESCHALTET", "DEBLOQUE", "DESBLOQUEADO", "SBLOCCATO") if _boss_time_attack_unlocked else _language_text("LOCKED", "GESPERRT", "VERROUILLE", "BLOQUEADO", "BLOCCATO"), _language_text("CHARACTER", "CHARAKTER", "PERSONNAGE", "PERSONAJE", "PERSONAGGIO"), get_selected_character_name()]
	return ""

func get_time_attack_mode_info_text() -> String:
	if _title_menu_index == 1:
		if _boss_time_attack_unlocked:
			return _language_text("DEFEAT THE BOSS AS FAST AS POSSIBLE", "BOSS SO SCHNELL WIE MOEGLICH BESIEGEN", "VAINCRE LE BOSS LE PLUS VITE POSSIBLE", "DERROTA AL JEFE LO MAS RAPIDO POSIBLE", "SCONFIGGI IL BOSS IL PIU VELOCE POSSIBILE")
		return _language_text("CAN'T PLAY THIS YET", "NOCH NICHT SPIELBAR", "PAS ENCORE DISPONIBLE", "AUN NO DISPONIBLE", "NON ANCORA DISPONIBILE")
	return _language_text("CLEAR THE ZONE AS FAST AS POSSIBLE", "DIE ZONE SO SCHNELL WIE MOEGLICH ABSCHLIESSEN", "TERMINER LA ZONE LE PLUS VITE POSSIBLE", "SUPERA LA ZONA LO MAS RAPIDO POSIBLE", "COMPLETA LA ZONA IL PIU VELOCE POSSIBILE")

func get_tiny_chao_rows() -> Array:
	if _title_phase == TITLE_PHASE_TINY_CHAO_GARDEN_PLAY:
		var rows: Array = []
		for i in range(_tiny_chao_roster.size()):
			var chao: Dictionary = _tiny_chao_roster[i]
			rows.append({
				"name": str(chao.get("name", "CHAO")),
				"description": _language_text("MOOD %03d%%   CARE %d", "STIMMUNG %03d%%   PFLEGE %d", "HUMEUR %03d%%   SOINS %d", "ANIMO %03d%%   CUIDADO %d", "UMORE %03d%%   CURA %d") % [int(chao.get("mood", 0)), int(chao.get("care", 0))],
				"status": (_language_text("FRUIT %d", "FRUECHTE %d", "FRUITS %d", "FRUTA %d", "FRUTTA %d") % _tiny_chao_fruit) if i == _tiny_chao_selected_index else _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"),
				"ready": true,
				"back": false,
				"selected": i == _tiny_chao_selected_index,
			})
		return rows
	if _title_phase == TITLE_PHASE_TINY_CHAO_SETUP:
		return [
			{
				"name": _language_text("ENTER GARDEN", "GARTEN OEFFNEN", "ENTRER DANS LE JARDIN", "ENTRAR AL JARDIN", "ENTRA NEL GIARDINO"),
				"description": _language_text("PREPARE THE HANDOFF DATA", "UEBERGABEDATEN VORBEREITEN", "PREPARER LES DONNEES DE TRANSFERT", "PREPARAR DATOS DE ENTREGA", "PREPARA DATI PASSAGGIO"),
				"status": _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"),
				"ready": true,
				"back": false,
				"selected": _title_menu_index == 0,
			},
			{
				"name": _language_text("NEW SESSION", "NEUE SITZUNG", "NOUVELLE SESSION", "NUEVA SESION", "NUOVA SESSIONE"),
				"description": _language_text("BUILD A FRESH LINK TOKEN", "NEUEN LINK-TOKEN ERSTELLEN", "CREER UN NOUVEAU JETON", "CREAR UN TOKEN NUEVO", "CREA UN NUOVO TOKEN LINK"),
				"status": _tiny_chao_session_id,
				"ready": true,
				"back": false,
				"selected": _title_menu_index == 1,
			},
			{
				"name": _language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO"),
				"description": _language_text("RETURN TO TINY CHAO GARDEN", "ZUM TINY CHAO GARTEN", "RETOUR AU JARDIN TINY CHAO", "VOLVER AL JARDIN TINY CHAO", "TORNA AL GIARDINO TINY CHAO"),
				"status": _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"),
				"ready": true,
				"back": true,
				"selected": _title_menu_index == 2,
			},
		]
	return [
		{
			"name": _language_text("ENTER GARDEN", "GARTEN OEFFNEN", "ENTRER DANS LE JARDIN", "ENTRAR AL JARDIN", "ENTRA NEL GIARDINO"),
			"description": _language_text("OPEN THE TINY CHAO GARDEN HANDOFF", "TINY CHAO GARTEN UEBERGABE OEFFNEN", "OUVRIR LE TRANSFERT DU JARDIN TINY CHAO", "ABRIR ENTREGA DEL JARDIN TINY CHAO", "APRI IL PASSAGGIO DEL GIARDINO TINY CHAO"),
			"status": _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"),
			"ready": true,
			"back": false,
			"selected": _title_menu_index == 0,
		},
		{
			"name": _language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO"),
			"description": _language_text("RETURN TO SINGLE PLAYER", "ZUM EINZELSPIELER", "RETOUR AU MODE SOLO", "VOLVER A UN JUGADOR", "TORNA AL GIOCATORE SINGOLO"),
			"status": _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"),
			"ready": true,
			"back": true,
			"selected": _title_menu_index == 1,
		},
	]

func get_tiny_chao_title_text() -> String:
	return _language_text("TINY CHAO GARDEN", "TINY CHAO GARTEN", "JARDIN TINY CHAO", "JARDIN TINY CHAO", "GIARDINO TINY CHAO")

func get_tiny_chao_prompt_text() -> String:
	var notice := get_title_notice_text()
	if not notice.is_empty():
		return notice
	if _title_phase == TITLE_PHASE_TINY_CHAO_GARDEN_PLAY:
		return _tiny_chao_action_text
	if _title_phase == TITLE_PHASE_TINY_CHAO_SETUP:
		return _language_text("PREPARE THE GARDEN HANDOFF", "GARTEN-UEBERGABE VORBEREITEN", "PREPARER LE TRANSFERT DU JARDIN", "PREPARAR ENTREGA DEL JARDIN", "PREPARA IL PASSAGGIO DEL GIARDINO")
	return _language_text("OPEN THE TINY CHAO GARDEN", "TINY CHAO GARTEN OEFFNEN", "OUVRIR LE JARDIN TINY CHAO", "ABRIR EL JARDIN TINY CHAO", "APRI IL GIARDINO TINY CHAO")

func get_tiny_chao_detail_text() -> String:
	if _title_phase == TITLE_PHASE_TINY_CHAO_GARDEN_PLAY:
		return _language_text("LEFT/RIGHT/UP/DOWN MOVE   %s CARE   %s EXIT", "LINKS/RECHTS/HOCH/RUNTER BEWEGEN   %s PFLEGEN   %s AUSGANG", "GAUCHE/DROITE/HAUT/BAS BOUGER   %s SOIN   %s SORTIE", "IZQ/DER/ARRIBA/ABAJO MOVER   %s CUIDAR   %s SALIR", "SINISTRA/DESTRA/SU/GIU MUOVI   %s CURA   %s ESCI") % [get_confirm_label(), get_secondary_label()]
	if _title_phase == TITLE_PHASE_TINY_CHAO_SETUP:
		return _language_text("PREPARE SCORE, LANGUAGE, AND SESSION DATA\n%s SELECT   %s CONFIRM   %s BACK", "PUNKTZAHL, SPRACHE UND SITZUNG VORBEREITEN\n%s AUSWAEHLEN   %s BESTAETIGEN   %s ZURUECK", "PREPARER SCORE, LANGUE ET SESSION\n%s SELECTIONNER   %s CONFIRMER   %s RETOUR", "PREPARAR PUNTOS, IDIOMA Y SESION\n%s SELECCIONAR   %s CONFIRMAR   %s ATRAS", "PREPARA PUNTEGGIO, LINGUA E SESSIONE\n%s SELEZIONA   %s CONFERMA   %s INDIETRO") % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
	return _language_text("THIS BRANCH DIRECTLY HANDS OFF TO TINY CHAO GARDEN\n%s SELECT   %s CONFIRM   %s BACK", "DIESER ZWEIG UEBERGIBT DIREKT AN DEN TINY CHAO GARTEN\n%s AUSWAEHLEN   %s BESTAETIGEN   %s ZURUECK", "CE BRANCHE PASSE DIRECTEMENT AU JARDIN TINY CHAO\n%s SELECTIONNER   %s CONFIRMER   %s RETOUR", "ESTA RAMA PASA DIRECTAMENTE AL JARDIN TINY CHAO\n%s SELECCIONAR   %s CONFIRMAR   %s ATRAS", "QUESTO RAMO PASSA DIRETTAMENTE AL GIARDINO TINY CHAO\n%s SELEZIONA   %s CONFERMA   %s INDIETRO") % [get_navigation_label(), get_confirm_label(), get_secondary_label()]

func get_tiny_chao_summary_text() -> String:
	if _title_phase == TITLE_PHASE_TINY_CHAO_GARDEN_PLAY:
		var selected_name := str(_tiny_chao_roster[_tiny_chao_selected_index].get("name", "CHAO")) if not _tiny_chao_roster.is_empty() else "CHAO"
		return _language_text("%s STATUS\nHUNGER: %d%%\nMOOD: %d%%\nCARE: %d\nFRUIT: %d", "%s STATUS\nHUNGER: %d%%\nSTIMMUNG: %d%%\nPFLEGE: %d\nFRUECHTE: %d", "%s STATUT\nFAIM: %d%%\nHUMEUR: %d%%\nSOINS: %d\nFRUITS: %d", "%s ESTADO\nHAMBRE: %d%%\nANIMO: %d%%\nCUIDADO: %d\nFRUTA: %d", "%s STATO\nFAME: %d%%\nUMORE: %d%%\nCURA: %d\nFRUTTA: %d") % [selected_name, _tiny_chao_hunger, _tiny_chao_mood, _tiny_chao_care_count, _tiny_chao_fruit]
	if _title_phase == TITLE_PHASE_TINY_CHAO_SETUP:
		return _language_text("HANDOFF READY\nTOKEN: %s\nPROFILE: %s", "UEBERGABE BEREIT\nTOKEN: %s\nPROFIL: %s", "TRANSFERT PRET\nJETON: %s\nPROFIL: %s", "ENTREGA LISTA\nTOKEN: %s\nPERFIL: %s", "PASSAGGIO PRONTO\nTOKEN: %s\nPROFILO: %s") % [_tiny_chao_session_id, get_profile_name_text()]
	return _language_text("DIRECT BRANCH\nUNLOCKED: %s\nPROFILE: %s", "DIREKTZWEIG\nFREIGESCHALTET: %s\nPROFIL: %s", "BRANCHE DIRECTE\nDEVERROUILLE: %s\nPROFIL: %s", "RAMA DIRECTA\nDESBLOQUEADO: %s\nPERFIL: %s", "RAMO DIRETTO\nSBLOCCATO: %s\nPROFILO: %s") % [_language_text("YES", "JA", "OUI", "SI", "SI") if _tiny_chao_unlocked else _language_text("NO", "NEIN", "NON", "NO", "NO"), get_profile_name_text()]

func get_tiny_chao_status_title_text() -> String:
	return _language_text("GARDEN STATUS", "GARTENSTATUS", "STATUT DU JARDIN", "ESTADO DEL JARDIN", "STATO DEL GIARDINO")

func get_tiny_chao_badge_text() -> String:
	return _language_text("CHAO", "CHAO", "CHAO", "CHAO", "CHAO")

func get_tiny_chao_info_rows() -> Array:
	if _title_phase == TITLE_PHASE_TINY_CHAO_GARDEN_PLAY:
		return [
			"SELECTED  %s" % (_tiny_chao_roster[_tiny_chao_selected_index].get("name", "CHAO") if not _tiny_chao_roster.is_empty() else "CHAO"),
			"POSITION  %+.2f, %+.2f" % [_tiny_chao_play_x, _tiny_chao_play_y],
			"HUNGER   %03d%%   MOOD %03d%%" % [_tiny_chao_hunger, _tiny_chao_mood],
			"SESSION  %s" % _tiny_chao_session_id,
		]
	var setup_phase := _title_phase == TITLE_PHASE_TINY_CHAO_SETUP
	return [
		"SCORE  %d" % get_profile_score(),
		# title_screen.c maps Italian to the Tiny Chao Garden English build.
		"LANG   %s" % get_tiny_chao_language_text(),
		"TOKEN  %s" % _tiny_chao_session_id,
		"MODE   %s" % ("HANDOFF" if setup_phase else "DIRECT"),
	]

func get_tiny_chao_language_text() -> String:
	match _language_index:
		0:
			return "JAPANESE"
		2:
			return "GERMAN"
		3:
			return "FRENCH"
		4:
			return "SPANISH"
		_:
			return "ENGLISH"

func get_title_menu_index() -> int:
	return _title_menu_index

func get_title_notice_text() -> String:
	return _localize_title_notice(_title_notice_text)

func _localize_title_notice(notice: String) -> String:
	if notice.is_empty() or _language_index == 1:
		return notice
	match notice:
		"WAITING FOR ALL LINKED PLAYERS":
			return _language_text(notice, "WARTE AUF ALLE VERBUNDENEN SPIELER", "EN ATTENTE DE TOUS LES JOUEURS", "ESPERANDO A TODOS LOS JUGADORES", "IN ATTESA DI TUTTI I GIOCATORI")
		"REMATCH SELECTED":
			return _language_text(notice, "RUECKSPIEL AUSGEWAEHLT", "REVANCHE SELECTIONNEE", "REVANCHA SELECCIONADA", "RIVINCITA SELEZIONATA")
		"EXIT TO TITLE SELECTED":
			return _language_text(notice, "TITEL AUSGEWAEHLT", "TITRE SELECTIONNE", "TITULO SELECCIONADO", "TITOLO SELEZIONATO")
		"BOSS TIME ATTACK LOCKED":
			return _language_text(notice, "BOSS-ZEITANGRIFF GESPERRT", "ATTAQUE BOSS VERROUILLEE", "ATAQUE AL JEFE BLOQUEADO", "ATTACCO BOSS BLOCCATO")
		"COURSE LOCKED IN":
			return _language_text(notice, "KURS FESTGELEGT", "PARCOURS VERROUILLE", "FASE FIJADA", "CORSO BLOCCATO")
		"CLIENTS STILL SYNCHRONIZING":
			return _language_text(notice, "CLIENTS SYNCHRONISIEREN NOCH", "CLIENTS ENCORE EN SYNCHRONISATION", "CLIENTES AUN SINCRONIZANDO", "CLIENT ANCORA IN SINCRONIZZAZIONE")
		"WAIT FOR CLIENT BOOT TO FINISH":
			return _language_text(notice, "AUF CLIENT-START WARTEN", "ATTENDRE LE DEMARRAGE DES CLIENTS", "ESPERA EL ARRANQUE DE CLIENTES", "ATTENDI AVVIO CLIENT")
		"WAITING FOR REMATCH CONFIRMATIONS":
			return _language_text(notice, "WARTE AUF RUECKSPIEL-BESTAETIGUNGEN", "EN ATTENTE DES CONFIRMATIONS DE REVANCHE", "ESPERANDO CONFIRMACIONES DE REVANCHA", "IN ATTESA DI CONFERME RIVINCITA")
		"WAITING FOR EXIT CONFIRMATIONS":
			return _language_text(notice, "WARTE AUF ENDE-BESTAETIGUNGEN", "EN ATTENTE DES CONFIRMATIONS DE SORTIE", "ESPERANDO CONFIRMACIONES DE SALIDA", "IN ATTESA DI CONFERME USCITA")
		"NEW SESSION ID READY":
			return _language_text(notice, "NEUE SITZUNGS-ID BEREIT", "NOUVEL ID DE SESSION PRET", "NUEVO ID DE SESION LISTO", "NUOVO ID SESSIONE PRONTO")
		"DISCONNECTING LINK":
			return _language_text(notice, "VERBINDUNG WIRD GETRENNT", "DECONNEXION DE LA LIAISON", "DESCONECTANDO ENLACE", "DISCONNESSIONE COLLEGAMENTO")
		"SELECT YES OR NO TO CONTINUE":
			return _language_text(notice, "JA ODER NEIN ZUM FORTFAHREN WAEHLEN", "CHOISIR OUI OU NON POUR CONTINUER", "ELIGE SI O NO PARA CONTINUAR", "SCEGLI SI O NO PER CONTINUARE")
		"PROFILE SAVED", "PROFILE NAME SAVED":
			return _language_text(notice, "PROFIL GESPEICHERT", "PROFIL ENREGISTRE", "PERFIL GUARDADO", "PROFILO SALVATO")
		"PROFILE CREATION CANCELED":
			return _language_text(notice, "PROFILERSTELLUNG ABGEBROCHEN", "CREATION DU PROFIL ANNULEE", "CREACION DE PERFIL CANCELADA", "CREAZIONE PROFILO ANNULLATA")
		"COMMUNICATION ERROR":
			return _language_text(notice, "KOMMUNIKATIONSFEHLER", "ERREUR DE COMMUNICATION", "ERROR DE COMUNICACION", "ERRORE COMUNICAZIONE")
		"DOWNLOAD COMPLETE":
			return _language_text(notice, "DOWNLOAD ABGESCHLOSSEN", "TELECHARGEMENT TERMINE", "DESCARGA COMPLETA", "DOWNLOAD COMPLETATO")
		"CHARACTER SELECTION CANCELED":
			return _language_text(notice, "CHARAKTERWAHL ABGEBROCHEN", "CHOIX DU PERSONNAGE ANNULE", "SELECCION DE PERSONAJE CANCELADA", "SCELTA PERSONAGGIO ANNULLATA")
		"RETURNED TO MULTIPLAYER MENU":
			return _language_text(notice, "ZURUECK IM MULTIPLAYER-MENUE", "RETOUR AU MENU MULTIJOUEUR", "REGRESO AL MENU MULTIJUGADOR", "TORNATO AL MENU MULTIGIOCATORE")
		"LINK SESSION RESET":
			return _language_text(notice, "LINK-SITZUNG ZURUECKGESETZT", "SESSION DE LIAISON REINITIALISEE", "SESION DE ENLACE REINICIADA", "SESSIONE COLLEGAMENTO RESETTATA")
		"TINY CHAO GARDEN READY":
			return _language_text(notice, "TINY CHAO GARTEN BEREIT", "JARDIN TINY CHAO PRET", "JARDIN TINY CHAO LISTO", "GIARDINO TINY CHAO PRONTO")
		"NEW COURSE PATH UNLOCKING":
			return _language_text(notice, "NEUER KURSPFAD WIRD FREIGESCHALTET", "NOUVEAU PARCOURS EN DEVERROUILLAGE", "DESBLOQUEANDO NUEVA RUTA", "SBLOCCO NUOVO PERCORSO")
		"NEW COURSE PATH OPEN":
			return _language_text(notice, "NEUER KURSPFAD OFFEN", "NOUVEAU PARCOURS OUVERT", "NUEVA RUTA ABIERTA", "NUOVO PERCORSO APERTO")
		"MOVING TO NEW COURSE":
			return _language_text(notice, "WECHSEL ZUM NEUEN KURS", "VERS LE NOUVEAU PARCOURS", "YENDO A LA NUEVA FASE", "VERSO IL NUOVO CORSO")
		"NEW COURSE READY":
			return _language_text(notice, "NEUER KURS BEREIT", "NOUVEAU PARCOURS PRET", "NUEVA FASE LISTA", "NUOVO CORSO PRONTO")
	if notice.begins_with("STARTING "):
		return "%s %s" % [_language_text("STARTING", "STARTET", "DEMARRAGE", "INICIANDO", "AVVIO"), notice.trim_prefix("STARTING ")]
	if notice.begins_with("COURSE READY: "):
		return "%s %s" % [_language_text("COURSE READY:", "KURS BEREIT:", "PARCOURS PRET :", "FASE LISTA:", "CORSO PRONTO:"), notice.trim_prefix("COURSE READY: ")]
	if notice.begins_with("COURSE SET TO "):
		return "%s %s" % [_language_text("COURSE SET TO", "KURS GESETZT AUF", "PARCOURS REGLE SUR", "FASE AJUSTADA A", "CORSO IMPOSTATO SU"), notice.trim_prefix("COURSE SET TO ")]
	if notice.begins_with("COURSE LOCKED: "):
		return "%s %s" % [_language_text("COURSE LOCKED:", "KURS GESPERRT:", "PARCOURS VERROUILLE :", "FASE BLOQUEADA:", "CORSO BLOCCATO:"), notice.trim_prefix("COURSE LOCKED: ")]
	if notice.begins_with("COURSE SENT: "):
		return "%s %s" % [_language_text("COURSE SENT:", "KURS GESENDET:", "PARCOURS ENVOYE :", "FASE ENVIADA:", "CORSO INVIATO:"), notice.trim_prefix("COURSE SENT: ")]
	if notice.begins_with("NEW COURSE UNLOCKED: "):
		return "%s %s" % [_language_text("NEW COURSE UNLOCKED:", "NEUER KURS FREIGESCHALTET:", "NOUVEAU PARCOURS DEVERROUILLE :", "NUEVA FASE DESBLOQUEADA:", "NUOVO CORSO SBLOCCATO:"), notice.trim_prefix("NEW COURSE UNLOCKED: ")]
	return notice

func is_title_main_screen() -> bool:
	if _game_state != GAME_STATE_TITLE:
		return false
	return _title_phase == TITLE_PHASE_PRESS_START or _title_phase == TITLE_PHASE_PLAY_MODE or _title_phase == TITLE_PHASE_SINGLE_PLAYER

func is_press_start_screen() -> bool:
	return _game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_PRESS_START

func is_play_mode_screen() -> bool:
	return _game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_PLAY_MODE

func is_single_player_menu_screen() -> bool:
	return _game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_SINGLE_PLAYER

func is_singlepak_results_screen() -> bool:
	return _game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_SINGLEPAK_RESULTS

func is_multiplayer_lobby_screen() -> bool:
	return _game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_MULTIPLAYER_LOBBY

func is_multiplayer_mode_screen() -> bool:
	return _game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_MULTI_PLAYER

func is_time_attack_mode_screen() -> bool:
	return _game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_TIME_ATTACK

func is_time_attack_lobby_screen() -> bool:
	return _game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_TIME_ATTACK_LOBBY

func is_course_select_screen() -> bool:
	return _game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_COURSE_SELECT

func is_multiplayer_course_select_screen() -> bool:
	return is_course_select_screen() and _is_multiplayer_course_select()

func is_tiny_chao_screen() -> bool:
	return _game_state == GAME_STATE_TITLE and (_title_phase == TITLE_PHASE_TINY_CHAO_GARDEN or _title_phase == TITLE_PHASE_TINY_CHAO_SETUP or _title_phase == TITLE_PHASE_TINY_CHAO_GARDEN_PLAY)

func is_tiny_chao_garden_play_screen() -> bool:
	return _game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_TINY_CHAO_GARDEN_PLAY

func is_multiplayer_comm_screen() -> bool:
	return _game_state == GAME_STATE_TITLE and (_title_phase == TITLE_PHASE_MULTI_CONNECT or _title_phase == TITLE_PHASE_SINGLEPAK_SYNC)

func is_multiplayer_connection_screen() -> bool:
	return _game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_MULTI_CONNECT

func is_multiplayer_outcome_screen() -> bool:
	return _game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_MULTIPLAYER_OUTCOME

func _open_multiplayer_outcome(outcome: int, return_phase: int) -> void:
	open_multiplayer_outcome_screen(outcome, return_phase)

func _resolve_multiplayer_outcome() -> void:
	_multiplayer_outcome_timer = 0.0
	if _multiplayer_outcome_type == 0:
		_multiplayer_link_ready = true
		var linked_notice := "ROOM LINKED: %d SYSTEMS READY" % get_multiplayer_link_count()
		if _multiplayer_outcome_return_phase == TITLE_PHASE_MULTI_CONNECT and _multiplayer_pak_mode == 0:
			# SA2 enters character selection immediately after a successful Multi-Pak link.
			open_character_select(CHARACTER_SELECT_CONTEXT_MULTIPLAYER, 0)
		else:
			open_multiplayer_outcome_return_phase(_multiplayer_outcome_return_phase, linked_notice)
	else:
		_multiplayer_link_ready = false
		open_title_screen_at_multiplayer_menu(_multiplayer_pak_mode, "COMMUNICATION ERROR")

func get_multiplayer_outcome_title() -> String:
	return _language_text("CONNECTION SUCCESS", "VERBINDUNG ERFOLGREICH", "CONNEXION REUSSIE", "CONEXION CORRECTA", "CONNESSIONE RIUSCITA") if _multiplayer_outcome_type == 0 else _language_text("COMMUNICATION ERROR", "KOMMUNIKATIONSFEHLER", "ERREUR DE COMMUNICATION", "ERROR DE COMUNICACION", "ERRORE DI COMUNICAZIONE")

func get_multiplayer_outcome_prompt() -> String:
	if _multiplayer_outcome_type == 0:
		return _language_text("LET'S PLAY WITH %dP", "SPIELEN WIR MIT %dP", "JOUONS A %d", "JUGUEMOS CON %dP", "GIOCHIAMO IN %d") % max(2, get_multiplayer_link_count())
	return _language_text("LINK COULD NOT BE MAINTAINED", "VERBINDUNG KONNTE NICHT GEHALTEN WERDEN", "LA LIAISON A ECHOUE", "NO SE PUDO MANTENER EL ENLACE", "COLLEGAMENTO INTERROTTO")

func get_multiplayer_outcome_detail() -> String:
	if _multiplayer_outcome_type == 0:
		return _language_text("SYSTEMS LINKED: %d/4   MODE: %s\n%s CONTINUE   %s SKIP", "SYSTEME VERBUNDEN: %d/4   MODUS: %s\n%s WEITER   %s UEBERSPRINGEN", "SYSTEMES LIES: %d/4   MODE: %s\n%s CONTINUER   %s PASSER", "SISTEMAS ENLAZADOS: %d/4   MODO: %s\n%s CONTINUAR   %s OMITIR", "SISTEMI COLLEGATI: %d/4   MODALITA: %s\n%s CONTINUA   %s SALTA") % [get_multiplayer_link_count(), get_multiplayer_pak_mode_name(), get_confirm_label(), get_secondary_label()]
	return _language_text("RETURNING TO MULTIPLAYER MODE SELECT\n%s CONTINUE   %s SKIP", "ZUR MULTIPLAYER-MODUSWAHL\n%s WEITER   %s UEBERSPRINGEN", "RETOUR AU CHOIX DU MODE MULTIJOUEUR\n%s CONTINUER   %s PASSER", "VOLVIENDO A SELECCION DE MODO\n%s CONTINUAR   %s OMITIR", "RITORNO ALLA SELEZIONE MODALITA\n%s CONTINUA   %s SALTA") % [get_confirm_label(), get_secondary_label()]

func get_multiplayer_outcome_summary_text() -> String:
	var status_label := _language_text("STATUS", "STATUS", "STATUT", "ESTADO", "STATO")
	var players_label := _language_text("PLAYERS", "SPIELER", "JOUEURS", "JUGADORES", "GIOCATORI")
	var next_label := _language_text("NEXT", "NAECHSTER SCHRITT", "SUIVANT", "SIGUIENTE", "PROSSIMO")
	var mode_label := _language_text("MODE", "MODUS", "MODE", "MODO", "MODALITA")
	if _multiplayer_outcome_type == 0:
		return "%s\n%s\n\n%s\n%d\n\n%s\n%s" % [status_label, _language_text("LINK OK", "LINK OK", "LIAISON OK", "ENLACE OK", "LINK OK"), players_label, get_multiplayer_link_count(), next_label, _language_text("ROOM READY", "RAUM BEREIT", "SALLE PRETE", "SALA LISTA", "STANZA PRONTA")]
	return "%s\n%s\n\n%s\n%s\n\n%s\n%s" % [status_label, _language_text("ERROR", "FEHLER", "ERREUR", "ERROR", "ERRORE"), mode_label, get_multiplayer_pak_mode_name(), next_label, _language_text("RESET ROOM", "RAUM ZURUECKSETZEN", "REINITIALISER LA SALLE", "REINICIAR SALA", "RESETTA STANZA")]

func get_multiplayer_outcome_badge_text() -> String:
	return _language_text("OK", "OK", "OK", "OK", "OK") if _multiplayer_outcome_type == 0 else _language_text("ERR", "FEHLER", "ERR", "ERR", "ERR")

func get_multiplayer_outcome_player_rows() -> Array:
	var rows: Array = []
	var host_label := _language_text("HOST", "HOST", "HOTE", "HOST", "HOST")
	var link_ok_label := _language_text("LINK OK", "LINK OK", "LIAISON OK", "ENLACE OK", "LINK OK")
	var offline_label := _language_text("OFFLINE", "OFFLINE", "HORS LIGNE", "DESCONECTADO", "OFFLINE")
	for i in range(_multiplayer_link_players.size()):
		var connected := bool(_multiplayer_link_connected[i])
		var character_name: String = str(_character_names[clampi(int(_multiplayer_player_characters[i]), 0, _character_names.size() - 1)])
		rows.append({
			"name": get_multiplayer_link_player_name(i),
			"status": ("%s  %s" % [host_label, character_name]) if i == 0 else ("%s  %s" % [character_name, link_ok_label] if connected else ("%s  %s" % [character_name, offline_label])),
			"connected": connected or i == 0,
		})
	return rows

func get_multiplayer_outcome_chrome_colors() -> Dictionary:
	if _multiplayer_outcome_type == 0:
		return {
			"accent": Color(0.96, 0.72, 0.24, 1.0),
			"panel": Color(0.12, 0.18, 0.28, 0.96),
			"summary": Color(0.16, 0.22, 0.18, 0.98),
		}
	return {
		"accent": Color(0.92, 0.34, 0.24, 1.0),
		"panel": Color(0.20, 0.10, 0.12, 0.96),
		"summary": Color(0.22, 0.12, 0.14, 0.98),
	}

func get_multiplayer_comm_title() -> String:
	return _language_text("COMMUNICATION", "KOMMUNIKATION", "COMMUNICATION", "COMUNICACION", "COMUNICAZIONE") if _title_phase == TITLE_PHASE_MULTI_CONNECT else _language_text("SINGLE-PAK SYNC", "SINGLE-PAK-SYNC", "SYNC SINGLE-PAK", "SYNC SINGLE-PAK", "SYNC SINGLE-PAK")

func get_multiplayer_comm_prompt() -> String:
	if not _title_notice_text.is_empty():
		return get_title_notice_text()
	if _title_phase == TITLE_PHASE_MULTI_CONNECT:
		if _multiplayer_pak_mode == 0:
			if _multiplayer_link_ready:
				return _language_text("PRESS START ON THE HOST TO BEGIN", "START AM HOST ZUM BEGINN DRUECKEN", "APPUYEZ SUR START SUR L'HOTE", "PULSA START EN EL HOST PARA EMPEZAR", "PREMI START SULL'HOST PER INIZIARE")
			if get_multiplayer_link_count() > 1:
				return _language_text("WAITING FOR THE HOST TO CONFIRM", "WARTE AUF HOST-BESTAETIGUNG", "EN ATTENTE DE LA CONFIRMATION DE L'HOTE", "ESPERANDO CONFIRMACION DEL HOST", "IN ATTESA DELLA CONFERMA DELL'HOST")
			return _language_text("WAITING FOR OTHER PLAYERS", "WARTE AUF ANDERE SPIELER", "EN ATTENTE DES AUTRES JOUEURS", "ESPERANDO A OTROS JUGADORES", "IN ATTESA DEGLI ALTRI GIOCATORI")
		if not is_singlepak_transfer_started():
			return _language_text("WAIT FOR CLIENT SYSTEMS TO JOIN", "WARTE AUF CLIENT-SYSTEME", "EN ATTENTE DES SYSTEMES CLIENTS", "ESPERANDO A LOS CLIENTES", "IN ATTESA DEI CLIENT")
		return _language_text("SENDING THE CLIENT PROGRAM", "CLIENT-PROGRAMM WIRD GESENDET", "ENVOI DU PROGRAMME CLIENT", "ENVIANDO EL PROGRAMA CLIENTE", "INVIO DEL PROGRAMMA CLIENT")
	return _language_text("WAIT FOR CLIENT BOOT TO COMPLETE", "WARTE AUF CLIENT-START", "ATTENDEZ LE DEMARRAGE DU CLIENT", "ESPERA EL ARRANQUE DEL CLIENTE", "ATTENDI L'AVVIO DEL CLIENT")

func get_multiplayer_comm_prompt_color() -> Color:
	if _title_phase == TITLE_PHASE_MULTI_CONNECT:
		return Color(0.88, 0.44, 0.18, 1.0)
	return Color(0.72, 0.28, 0.22, 1.0)

func get_multiplayer_comm_detail_text() -> String:
	if _title_phase == TITLE_PHASE_MULTI_CONNECT:
		var mode_name := get_multiplayer_pak_mode_name()
		if _multiplayer_pak_mode == 0:
			if _multiplayer_link_ready:
				return _language_text("MODE: %s   COURSE: %s\nROOM COMPLETE   %s CONFIRM TO START   %s BACK", "MODUS: %s   KURS: %s\nRAUM KOMPLETT   %s ZUM START BESTAETIGEN   %s ZURUECK", "MODE: %s   PARCOURS: %s\nSALLE COMPLETE   %s CONFIRMER POUR COMMENCER   %s RETOUR", "MODO: %s   FASE: %s\nSALA COMPLETA   %s CONFIRMA PARA EMPEZAR   %s ATRAS", "MODALITA: %s   ZONA: %s\nSTANZA COMPLETA   %s CONFERMA PER INIZIARE   %s INDIETRO") % [mode_name, get_multiplayer_session_course_text(), get_confirm_label(), get_secondary_label()]
			return _language_text("MODE: %s   COURSE: %s\nBUILD THE LINK ROOM BEFORE STARTING\n%s SELECT   %s CONFIRM   %s BACK", "MODUS: %s   KURS: %s\nBAUE DEN VERBINDUNGSRAUM VOR DEM START\n%s AUSWAEHLEN   %s BESTAETIGEN   %s ZURUECK", "MODE: %s   PARCOURS: %s\nFORMEZ LA SALLE AVANT DE COMMENCER\n%s SELECTIONNER   %s CONFIRMER   %s RETOUR", "MODO: %s   FASE: %s\nCREA LA SALA ANTES DE EMPEZAR\n%s SELECCIONAR   %s CONFIRMAR   %s ATRAS", "MODALITA: %s   ZONA: %s\nCREA LA STANZA PRIMA DI INIZIARE\n%s SELEZIONA   %s CONFERMA   %s INDIETRO") % [mode_name, get_multiplayer_session_course_text(), get_navigation_label(), get_confirm_label(), get_secondary_label()]
		if not is_singlepak_transfer_started():
			return _language_text("MODE: %s   COURSE: %s\nCLIENTS: %d   PRESS START AFTER THEY JOIN\n%s SELECT   %s CONFIRM   %s BACK", "MODUS: %s   KURS: %s\nCLIENTS: %d   START NACH BEITRITT DRUECKEN\n%s AUSWAEHLEN   %s BESTAETIGEN   %s ZURUECK", "MODE: %s   PARCOURS: %s\nCLIENTS: %d   APPUYEZ SUR START APRES LEUR ARRIVEE\n%s SELECTIONNER   %s CONFIRMER   %s RETOUR", "MODO: %s   FASE: %s\nCLIENTES: %d   PULSA START CUANDO ENTREN\n%s SELECCIONAR   %s CONFIRMAR   %s ATRAS", "MODALITA: %s   ZONA: %s\nCLIENT: %d   PREMI START DOPO L'ACCESSO\n%s SELEZIONA   %s CONFERMA   %s INDIETRO") % [mode_name, get_multiplayer_session_course_text(), max(0, get_multiplayer_link_count() - 1), get_navigation_label(), get_confirm_label(), get_secondary_label()]
		return _language_text("MODE: %s   COURSE: %s\nCLIENTS: %d   DOWNLOAD: %d%%\nTRANSFER ACTIVE   %s BACK LOCKED", "MODUS: %s   KURS: %s\nCLIENTS: %d   DOWNLOAD: %d%%\nUEBERTRAGUNG AKTIV   %s ZURUECK GESPERRT", "MODE: %s   PARCOURS: %s\nCLIENTS: %d   TELECHARGEMENT: %d%%\nTRANSFERT ACTIF   %s RETOUR VERROUILLE", "MODO: %s   FASE: %s\nCLIENTES: %d   DESCARGA: %d%%\nTRANSFERENCIA ACTIVA   %s ATRAS BLOQUEADO", "MODALITA: %s   ZONA: %s\nCLIENT: %d   DOWNLOAD: %d%%\nTRASFERIMENTO ATTIVO   %s INDIETRO BLOCCATO") % [mode_name, get_multiplayer_session_course_text(), max(0, get_multiplayer_link_count() - 1), get_singlepak_download_progress(), get_secondary_label()]
	if is_singlepak_sync_ready():
		return _language_text("COURSE: %s   SYNC STEP: %d/3\nCLIENT BOOT COMPLETE   %s CONFIRM TO START   %s BACK", "KURS: %s   SYNC-SCHRITT: %d/3\nCLIENT-START KOMPLETT   %s ZUM START BESTAETIGEN   %s ZURUECK", "PARCOURS: %s   ETAPE SYNC: %d/3\nDEMARRAGE CLIENT TERMINE   %s CONFIRMER POUR COMMENCER   %s RETOUR", "FASE: %s   PASO SYNC: %d/3\nARRANQUE DEL CLIENTE COMPLETO   %s CONFIRMA PARA EMPEZAR   %s ATRAS", "ZONA: %s   PASSO SYNC: %d/3\nAVVIO CLIENT COMPLETO   %s CONFERMA PER INIZIARE   %s INDIETRO") % [get_multiplayer_session_course_text(), get_singlepak_sync_step(), get_confirm_label(), get_secondary_label()]
	return _language_text("COURSE: %s   SYNC STEP: %d/3\nDOWNLOAD: %d%%   WAIT FOR CLIENT BOOT\n%s SELECT   %s CONFIRM   %s BACK LOCKED", "KURS: %s   SYNC-SCHRITT: %d/3\nDOWNLOAD: %d%%   WARTE AUF CLIENT-START\n%s AUSWAEHLEN   %s BESTAETIGEN   %s ZURUECK GESPERRT", "PARCOURS: %s   ETAPE SYNC: %d/3\nTELECHARGEMENT: %d%%   ATTENDEZ LE DEMARRAGE CLIENT\n%s SELECTIONNER   %s CONFIRMER   %s RETOUR VERROUILLE", "FASE: %s   PASO SYNC: %d/3\nDESCARGA: %d%%   ESPERA EL ARRANQUE DEL CLIENTE\n%s SELECCIONAR   %s CONFIRMAR   %s ATRAS BLOQUEADO", "ZONA: %s   PASSO SYNC: %d/3\nDOWNLOAD: %d%%   ATTENDI AVVIO CLIENT\n%s SELEZIONA   %s CONFERMA   %s INDIETRO BLOCCATO") % [get_multiplayer_session_course_text(), get_singlepak_sync_step(), get_singlepak_download_progress(), get_navigation_label(), get_confirm_label(), get_secondary_label()]

func get_multiplayer_comm_info_text() -> String:
	if _title_phase == TITLE_PHASE_MULTI_CONNECT:
		if _multiplayer_pak_mode == 0:
			return _language_text("FORM A MULTI-PAK ROOM FOR %s", "MULTI-PAK-RAUM FUER %s BILDEN", "FORMER UNE SALLE MULTI-PAK POUR %s", "CREAR UNA SALA MULTI-PAK PARA %s", "CREA UNA STANZA MULTI-PAK PER %s") % get_multiplayer_session_course_text()
		if not is_singlepak_transfer_started():
			return _language_text("WAIT FOR CLIENTS, THEN SEND THE MULTIBOOT PROGRAM", "AUF CLIENTS WARTEN, DANN MULTIBOOT SENDEN", "ATTENDRE LES CLIENTS PUIS ENVOYER LE MULTIBOOT", "ESPERA A LOS CLIENTES Y ENVIA EL MULTIBOOT", "ATTENDI I CLIENT E INVIA IL MULTIBOOT")
		return _language_text("TRANSFER THE CLIENT PROGRAM FOR %s", "CLIENT-PROGRAMM FUER %s UEBERTRAGEN", "TRANSFERER LE PROGRAMME CLIENT POUR %s", "TRANSFERIR EL PROGRAMA CLIENTE PARA %s", "TRASFERISCI IL PROGRAMMA CLIENT PER %s") % get_multiplayer_session_course_text()
	return _language_text("WAIT FOR CLIENT BOOT AND FINAL SYNCHRONIZATION", "WARTE AUF CLIENT-START UND SYNC", "ATTENDRE LE DEMARRAGE ET LA SYNCHRONISATION", "ESPERA EL ARRANQUE Y LA SINCRONIZACION", "ATTENDI AVVIO E SINCRONIZZAZIONE DEL CLIENT")

func get_multiplayer_comm_summary_text() -> String:
	var mode_label := _language_text("MODE", "MODUS", "MODE", "MODO", "MODALITA")
	var players_label := _language_text("PLAYERS", "SPIELER", "JOUEURS", "JUGADORES", "GIOCATORI")
	var clients_label := _language_text("CLIENTS", "CLIENTS", "CLIENTS", "CLIENTES", "CLIENT")
	var course_label := _language_text("COURSE", "KURS", "PARCOURS", "FASE", "ZONA")
	var state_label := _language_text("STATE", "STATUS", "ETAT", "ESTADO", "STATO")
	var linked_label := _language_text("LINKED", "VERBUNDEN", "LIES", "ENLAZADOS", "COLLEGATI")
	var ready_label := _language_text("READY", "BEREIT", "PRETS", "LISTOS", "PRONTI")
	var waiting_label := _language_text("WAITING", "WARTEN", "ATTENTE", "ESPERA", "ATTESA")
	var booting_label := _language_text("BOOTING", "STARTET", "DEMARRAGE", "ARRANCANDO", "AVVIO")
	if _title_phase == TITLE_PHASE_MULTI_CONNECT:
		if _multiplayer_pak_mode == 0:
			return "%s\nMULTI-PAK\n\n%s\n%d/4 %s\n\n%s\n%s" % [mode_label, players_label, get_multiplayer_link_count(), linked_label, course_label, get_selected_level_text()]
		return "%s\nSINGLE-PAK\n\n%s\n%d %s\n\n%s\n%s" % [mode_label, clients_label, max(0, get_multiplayer_link_count() - 1), ready_label, state_label, (waiting_label if not is_singlepak_transfer_started() else "DOWNLOAD %d%%" % get_singlepak_download_progress())]
	return _language_text("SYNC STEP", "SYNC-SCHRITT", "ETAPE SYNC", "PASO SYNC", "PASSO SYNC") + "\n%d/3\n\n%s\n%s\n\n%s\n%s" % [get_singlepak_sync_step(), course_label, get_selected_level_text(), state_label, ready_label if _singlepak_sync_step >= 3 else booting_label]

func get_multiplayer_comm_signal_text() -> String:
	return _language_text("LINK", "LINK", "LIAISON", "ENLACE", "LINK") if _title_phase == TITLE_PHASE_MULTI_CONNECT else _language_text("SYNC", "SYNC", "SYNC", "SYNC", "SYNC")

func get_multiplayer_comm_section_text() -> String:
	return _language_text("PLAYER STATUS", "SPIELERSTATUS", "STATUT JOUEUR", "ESTADO DEL JUGADOR", "STATO GIOCATORE")

func get_multiplayer_comm_chrome_colors() -> Dictionary:
	if _title_phase == TITLE_PHASE_MULTI_CONNECT:
		if _multiplayer_pak_mode == 0:
			return {
				"accent": Color(0.90, 0.48, 0.22, 1.0),
				"card": Color(0.96, 0.90, 0.82, 0.98),
			}
		return {
			"accent": Color(0.84, 0.34, 0.24, 1.0),
			"card": Color(0.94, 0.86, 0.80, 0.98),
		}
	return {
		"accent": Color(0.76, 0.28, 0.22, 1.0),
		"card": Color(0.94, 0.84, 0.82, 0.98),
	}

func get_multiplayer_comm_rows() -> Array:
	var rows: Array = []
	var ready_label := _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO")
	var wait_label := _language_text("WAIT", "WARTEN", "ATTENTE", "ESPERA", "ATTESA")
	var locked_label := _language_text("LOCKED", "GESPERRT", "VERROUILLE", "BLOQUEADO", "BLOCCATO")
	if _title_phase == TITLE_PHASE_MULTI_CONNECT:
		rows.append({
			"label": _language_text("CONNECT", "VERBINDEN", "CONNECTER", "CONECTAR", "COLLEGA") if _multiplayer_pak_mode == 0 else _language_text("SCAN CLIENTS", "CLIENTS SUCHEN", "RECHERCHER LES CLIENTS", "BUSCAR CLIENTES", "CERCA CLIENT"),
			"value": (_language_text("%d OF 4 SYSTEMS PRESENT", "%d VON 4 SYSTEMEN VORHANDEN", "%d SYSTEMES SUR 4 PRESENTS", "%d DE 4 SISTEMAS PRESENTES", "%d SISTEMI SU 4 PRESENTI") % get_multiplayer_link_count()) if _multiplayer_pak_mode == 0 else (_language_text("%d CLIENT SYSTEMS DETECTED", "%d CLIENT-SYSTEME GEFUNDEN", "%d SYSTEMES CLIENTS DETECTES", "%d CLIENTES DETECTADOS", "%d CLIENT RILEVATI") % max(0, get_multiplayer_link_count() - 1)),
			"status": ready_label,
			"ready": true,
			"waiting": false,
			"locked": false,
			"selected": _title_menu_index == 0,
		})
		rows.append({
			"label": _language_text("START MATCH", "MATCH STARTEN", "LANCER LA PARTIE", "INICIAR PARTIDA", "AVVIA PARTITA") if _multiplayer_pak_mode == 0 and _multiplayer_link_ready else (_language_text("PRESS START", "START DRUECKEN", "APPUYER SUR START", "PULSA START", "PREMI START") if _multiplayer_pak_mode == 0 else _language_text("START DOWNLOAD", "DOWNLOAD STARTEN", "DEMARRER LE TELECHARGEMENT", "INICIAR DESCARGA", "AVVIA DOWNLOAD")),
			"value": _language_text("HOST MAY BEGIN THE MATCH", "HOST KANN MATCH STARTEN", "L'HOTE PEUT LANCER LA PARTIE", "EL HOST PUEDE INICIAR", "L'HOST PUO AVVIARE LA PARTITA") if _multiplayer_pak_mode == 0 and _multiplayer_link_ready else (_language_text("WAIT FOR THE ROOM TO FILL", "WARTE BIS RAUM VOLL IST", "ATTENDEZ QUE LA SALLE SOIT PLEINE", "ESPERA A LLENAR LA SALA", "ATTENDI CHE LA STANZA SIA PIENA") if _multiplayer_pak_mode == 0 else (_language_text("PRESS START AFTER CLIENTS JOIN", "START NACH CLIENT-BEITRITT DRUECKEN", "APPUYER SUR START APRES LES CLIENTS", "PULSA START TRAS UNIR CLIENTES", "PREMI START DOPO L'ACCESSO DEI CLIENT") if not is_singlepak_transfer_started() else (_language_text("TRANSFER %d%% COMPLETE", "UEBERTRAGUNG ZU %d%% FERTIG", "TRANSFERT TERMINE A %d%%", "TRANSFERENCIA AL %d%%", "TRASFERIMENTO AL %d%%") % get_singlepak_download_progress()))),
			"status": ready_label if (_multiplayer_link_ready or (_multiplayer_pak_mode == 1 and get_multiplayer_link_count() >= 2)) else wait_label,
			"ready": _multiplayer_link_ready or (_multiplayer_pak_mode == 1 and get_multiplayer_link_count() >= 2),
			"waiting": not (_multiplayer_link_ready or (_multiplayer_pak_mode == 1 and get_multiplayer_link_count() >= 2)),
			"locked": false,
			"selected": _title_menu_index == 1,
		})
		rows.append({
			"label": _language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO"),
			"value": _language_text("RETURN TO PAK MODE SELECT", "ZUR PAK-MODUSWAHL", "RETOUR AU CHOIX DU MODE PAK", "VOLVER A SELECCION DE MODO", "TORNA ALLA SELEZIONE MODALITA PAK"),
			"status": ready_label if _multiplayer_pak_mode == 0 or not is_singlepak_transfer_started() else locked_label,
			"ready": _multiplayer_pak_mode == 0 or not is_singlepak_transfer_started(),
			"waiting": false,
			"locked": _multiplayer_pak_mode == 1 and is_singlepak_transfer_started(),
			"selected": _title_menu_index == 2,
		})
		return rows
	var sync_ready := is_singlepak_sync_ready()
	rows.append({
		"label": _language_text("START MATCH", "MATCH STARTEN", "LANCER LA PARTIE", "INICIAR PARTIDA", "AVVIA PARTITA") if sync_ready else _language_text("SYNC CLIENTS", "CLIENTS SYNCHRONISIEREN", "SYNCHRONISER LES CLIENTS", "SINCRONIZAR CLIENTES", "SINCRONIZZA CLIENT"),
		"value": _language_text("CLIENTS FINISHED BOOTING", "CLIENT-START ABGESCHLOSSEN", "DEMARRAGE CLIENTS TERMINE", "ARRANQUE DE CLIENTES COMPLETO", "AVVIO CLIENT COMPLETATO") if sync_ready else (_language_text("BOOT STATE %d OF 3", "STARTSTATUS %d VON 3", "ETAT DEMARRAGE %d SUR 3", "ESTADO DE ARRANQUE %d DE 3", "STATO AVVIO %d DI 3") % get_singlepak_sync_step()),
		"status": ready_label if sync_ready else wait_label,
		"ready": sync_ready,
		"waiting": not sync_ready,
		"locked": false,
		"selected": _title_menu_index == 0,
	})
	rows.append({
		"label": _language_text("RESULTS", "ERGEBNISSE", "RESULTATS", "RESULTADOS", "RISULTATI"),
		"value": _language_text("OPEN THE POST-MATCH RESULT EXCHANGE", "ERGEBNISAUSTAUSCH NACH DEM MATCH OEFFNEN", "OUVRIR LES RESULTATS APRES LE MATCH", "ABRIR RESULTADOS TRAS LA PARTIDA", "APRI LO SCAMBIO RISULTATI POST-PARTITA"),
		"status": ready_label if sync_ready else locked_label,
		"ready": sync_ready,
		"waiting": false,
		"locked": not sync_ready,
		"selected": _title_menu_index == 1,
	})
	rows.append({
		"label": _language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO"),
		"value": _language_text("WAIT FOR CLIENT BOOT TO FINISH", "WARTE AUF CLIENT-START", "ATTENDEZ LA FIN DU DEMARRAGE CLIENT", "ESPERA A QUE TERMINE EL ARRANQUE", "ATTENDI LA FINE DELL'AVVIO CLIENT"),
		"status": locked_label,
		"ready": false,
		"waiting": false,
		"locked": true,
		"selected": _title_menu_index == 2,
	})
	return rows

func get_multiplayer_comm_player_rows() -> Array:
	_ensure_multiplayer_session_arrays()
	var rows: Array = []
	for i in range(_multiplayer_link_players.size()):
		var connected := bool(_multiplayer_link_connected[i])
		var character_name: String = str(_character_names[clampi(int(_multiplayer_player_characters[i]), 0, _character_names.size() - 1)])
		var rank_text: String = ""
		if connected and i < _multiplayer_player_ranks.size() and int(_multiplayer_player_ranks[i]) >= 0:
			rank_text = "  RANK %d" % [int(_multiplayer_player_ranks[i]) + 1]
		var status: String = "HOST %s%s" % [character_name, rank_text] if i == 0 else ("%s READY%s" % [character_name, rank_text] if connected else "%s WAITING" % character_name)
		if _title_phase == TITLE_PHASE_SINGLEPAK_SYNC and i > 0 and connected:
			status = "%s BOOT %d/3" % [character_name, min(3, max(1, _singlepak_sync_step))]
		rows.append({
			"name": get_multiplayer_link_player_name(i),
			"status": status,
			"connected": connected or i == 0,
		})
	return rows

func get_multiplayer_pak_mode_name() -> String:
	return "MULTI-PAK" if _multiplayer_pak_mode == 0 else "SINGLE-PAK"

func get_multiplayer_link_player_name(index: int) -> String:
	if index < 0 or index >= _multiplayer_link_players.size():
		return ""
	return _multiplayer_link_players[index]

func is_multiplayer_link_player_connected(index: int) -> bool:
	if index < 0 or index >= _multiplayer_link_connected.size():
		return false
	return _multiplayer_link_connected[index]

func is_multiplayer_link_ready() -> bool:
	return _multiplayer_link_ready

func get_multiplayer_link_count() -> int:
	_ensure_multiplayer_session_arrays()
	var count := 0
	for connected in _multiplayer_link_connected:
		if bool(connected):
			count += 1
	return count

func _ensure_multiplayer_session_arrays() -> void:
	# Link screens are also reachable after an interrupted or older save. Keep
	# their four-player presentation total instead of indexing partial state.
	const player_slots := 4
	while _multiplayer_link_players.size() < player_slots:
		_multiplayer_link_players.append("P%d" % (_multiplayer_link_players.size() + 1))
	while _multiplayer_link_connected.size() < player_slots:
		_multiplayer_link_connected.append(false)
	while _multiplayer_player_characters.size() < player_slots:
		_multiplayer_player_characters.append(0)
	while _multiplayer_player_ranks.size() < player_slots:
		_multiplayer_player_ranks.append(-1)
	if _multiplayer_link_players.size() > player_slots:
		_multiplayer_link_players.resize(player_slots)
	if _multiplayer_link_connected.size() > player_slots:
		_multiplayer_link_connected.resize(player_slots)
	if _multiplayer_player_characters.size() > player_slots:
		_multiplayer_player_characters.resize(player_slots)
	if _multiplayer_player_ranks.size() > player_slots:
		_multiplayer_player_ranks.resize(player_slots)
	_multiplayer_link_connected[0] = true

func _get_multiplayer_host_name() -> String:
	var host_name := get_profile_name_text().strip_edges()
	if host_name.is_empty():
		return "YOU"
	return host_name

func _get_multiplayer_remote_name_pool() -> Array:
	var pool: Array = []
	for entry_variant in _multi_record_rows:
		if entry_variant is not Dictionary:
			continue
		var entry: Dictionary = entry_variant
		var candidate_name: String = str(entry.get("name", "")).strip_edges().to_upper()
		if candidate_name.is_empty():
			continue
		if candidate_name == _get_multiplayer_host_name().to_upper():
			continue
		if pool.has(candidate_name):
			continue
		pool.append(candidate_name)
	if pool.is_empty():
		pool = ["MILES", "AMY", "CREAM", "KNUX", "ROUGE", "SHADOW"]
	return pool

func _reset_multiplayer_session_state() -> void:
	_ensure_multiplayer_session_arrays()
	var remote_name_pool: Array = _get_multiplayer_remote_name_pool()
	_multiplayer_link_players = [_get_multiplayer_host_name(), "P2", "P3", "P4"]
	for i in range(1, _multiplayer_link_players.size()):
		var pool_index: int = (i - 1) % remote_name_pool.size()
		_multiplayer_link_players[i] = str(remote_name_pool[pool_index])
		_insert_or_promote_multiplayer_record(_multiplayer_link_players[i])
	_multiplayer_player_characters = [_selected_character_index, 1, 2, 3]
	_multiplayer_player_ranks = [0, 1, 2, 3]
	_refresh_multiplayer_remote_characters()
	_refresh_multiplayer_rankings()

func _refresh_multiplayer_remote_characters() -> void:
	_ensure_multiplayer_session_arrays()
	var used: Dictionary = {_selected_character_index: true}
	_multiplayer_player_characters[0] = _selected_character_index
	for i in range(1, _multiplayer_player_characters.size()):
		var candidate: int = int(_multiplayer_player_characters[i])
		if used.has(candidate) or not is_character_unlocked(candidate):
			candidate = _find_next_multiplayer_character(used)
		_multiplayer_player_characters[i] = candidate
		used[candidate] = true

func _find_next_multiplayer_character(used: Dictionary) -> int:
	for i in range(_character_names.size()):
		if not is_character_unlocked(i):
			continue
		if not used.has(i):
			return i
	return 0

func _get_multiplayer_rank_sort_value(player_index: int) -> int:
	var character_index := clampi(int(_multiplayer_player_characters[player_index]), 0, _character_names.size() - 1)
	return (_selected_level_index + 1) * 19 + character_index * 7 + player_index * 5 + _multiplayer_pak_mode * 11

func _refresh_multiplayer_rankings() -> void:
	_multiplayer_player_ranks = [-1, -1, -1, -1]
	var connected_indices: Array = []
	for i in range(_multiplayer_link_connected.size()):
		if bool(_multiplayer_link_connected[i]):
			connected_indices.append(i)
	for i in range(connected_indices.size()):
		for j in range(i + 1, connected_indices.size()):
			var left_index: int = int(connected_indices[i])
			var right_index: int = int(connected_indices[j])
			if _get_multiplayer_rank_sort_value(right_index) > _get_multiplayer_rank_sort_value(left_index):
				connected_indices[i] = right_index
				connected_indices[j] = left_index
	for rank in range(connected_indices.size()):
		_multiplayer_player_ranks[int(connected_indices[rank])] = rank

func advance_multiplayer_link_state() -> void:
	for i in range(1, _multiplayer_link_connected.size()):
		if not _multiplayer_link_connected[i]:
			_multiplayer_link_connected[i] = true
			_refresh_multiplayer_remote_characters()
			_refresh_multiplayer_rankings()
			return

func get_multiplayer_pak_mode() -> int:
	return _multiplayer_pak_mode

func get_multiplayer_session_course_text() -> String:
	return "%s VS" % get_selected_level_text()

func get_multiplayer_intro_character_text() -> String:
	return "P1 %s" % get_selected_character_name()

func get_time_attack_lobby_rows() -> Array:
	var rows: Array = []
	rows.append({
		"name": _language_text("START", "START", "DEPART", "EMPEZAR", "AVVIA"),
		"description": _language_text("BEGIN THE CURRENT TIME ATTACK RUN", "AKTUELLEN ZEITANGRIFF STARTEN", "LANCER LE CONTRE-LA-MONTRE", "INICIAR EL CONTRARRELOJ", "INIZIA L'ATTACCO A TEMPO"),
		"status": _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"),
		"selected": _time_attack_lobby_cursor == 0,
	})
	rows.append({
		"name": _language_text("CHARACTER", "CHARAKTER", "PERSONNAGE", "PERSONAJE", "PERSONAGGIO"),
		"description": _language_text("CHANGE THE ACTIVE RUNNER", "AKTIVEN CHARAKTER WECHSELN", "CHANGER DE PERSONNAGE ACTIF", "CAMBIAR EL PERSONAJE ACTIVO", "CAMBIA IL PERSONAGGIO ATTIVO"),
		"status": get_selected_character_name(),
		"selected": _time_attack_lobby_cursor == 1,
	})
	rows.append({
		"name": (_language_text("COURSE", "KURS", "PARCOURS", "FASE", "CORSO") if not _time_attack_boss_mode else _language_text("BOSS COURSE", "BOSS-KURS", "PARCOURS BOSS", "FASE DEL JEFE", "CORSO BOSS")),
		"description": _language_text("LEFT/RIGHT OR CONFIRM TO CHANGE COURSE", "LINKS/RECHTS ODER BESTAETIGEN ZUM WECHSELN", "GAUCHE/DROITE OU CONFIRMER POUR CHANGER", "IZQUIERDA/DERECHA O CONFIRMAR PARA CAMBIAR", "SINISTRA/DESTRA O CONFERMA PER CAMBIARE"),
		"status": get_selected_level_text(),
		"selected": _time_attack_lobby_cursor == 2,
	})
	rows.append({
		"name": _language_text("TITLE", "TITEL", "TITRE", "TITULO", "TITOLO"),
		"description": _language_text("RETURN TO THE TIME ATTACK MENU", "ZUR ZEITANGRIFF-MENUE ZURUECK", "RETOUR AU MENU CONTRE-LA-MONTRE", "VOLVER AL MENU CONTRARRELOJ", "TORNA AL MENU ATTACCO A TEMPO"),
		"status": _language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO"),
		"selected": _time_attack_lobby_cursor == 3,
	})
	return rows

func get_time_attack_lobby_cursor() -> int:
	return _time_attack_lobby_cursor

func is_boss_time_attack() -> bool:
	return _time_attack_boss_mode

func get_boss_hud_state() -> Dictionary:
	for entity_variant in _level_state.entities:
		if not entity_variant is EntityState:
			continue
		var entity: EntityState = entity_variant as EntityState
		if entity.type != ENTITY_BOSS or not entity.active:
			continue
		var phase_names := ["RESET", "EXTEND", "AIM", "PLUNGE", "SLAM", "HOLD", "DRAG", "RETRACT"]
		var phase_index := clampi(entity.variant, 0, phase_names.size() - 1)
		var max_health := maxi(1, entity.max_health)
		return {
			"active": true,
			"health": clampi(entity.health, 0, max_health),
			"max_health": max_health,
			"phase": phase_names[phase_index],
			"phase_index": phase_index,
		}
	return {"active": false, "health": 0, "max_health": 0, "phase": "", "phase_index": 0}

func get_time_attack_lobby_title() -> String:
	if _time_attack_boss_mode:
		return _language_text("BOSS TIME ATTACK", "BOSS-ZEITANGRIFF", "ATTAQUE BOSS", "ATAQUE AL JEFE", "ATTACCO BOSS")
	return _language_text("TIME ATTACK", "ZEITANGRIFF", "CONTRE-LA-MONTRE", "CONTRARRELOJ", "ATTACCO A TEMPO")

func get_time_attack_lobby_prompt() -> String:
	if not _title_notice_text.is_empty():
		return get_title_notice_text()
	return _language_text("TRY AGAIN", "NOCH EINMAL", "REESSAYER", "INTENTAR DE NUEVO", "RIPROVA")

func get_time_attack_lobby_detail() -> String:
	return "%s SELECT   %s CONFIRM   LEFT/RIGHT %s   %s BACK" % [get_navigation_label(), get_confirm_label(), _language_text("COURSE", "KURS", "PARCOURS", "FASE", "CORSO"), get_secondary_label()]

func get_time_attack_lobby_summary_text() -> String:
	return "CHARACTER\n%s\n\nCOURSE\n%s\n\nBEST\n%s" % [get_selected_character_name(), get_selected_level_text(), get_time_attack_lobby_record_text()]

func get_time_attack_lobby_character_text() -> String:
	return "%s\n%s" % [_language_text("CHARACTER", "CHARAKTER", "PERSONNAGE", "PERSONAJE", "PERSONAGGIO"), get_selected_character_name()]

func get_time_attack_lobby_course_text() -> String:
	return "%s\n%s\n%s" % [_language_text("COURSE", "KURS", "PARCOURS", "FASE", "CORSO"), get_selected_level_text(), get_time_attack_lobby_course_badge_text()]

func get_time_attack_lobby_mode_text() -> String:
	var mode_text := _language_text("BOSS ATTACK", "BOSS-ANGRIFF", "ATTAQUE BOSS", "ATAQUE AL JEFE", "ATTACCO BOSS") if _time_attack_boss_mode else _language_text("ZONE ATTACK", "ZONEN-ANGRIFF", "ATTAQUE DE ZONE", "ATAQUE DE ZONA", "ATTACCO ZONA")
	return "%s\n%s\n%s" % [_language_text("MODE", "MODUS", "MODE", "MODO", "MODALITA"), mode_text, get_time_attack_lobby_focus_text()]

func get_time_attack_lobby_record_text() -> String:
	var record_key := _get_time_attack_record_key(_selected_character_index, _selected_level_index, 0, _time_attack_boss_mode)
	var best_time := _get_time_attack_best_time(record_key)
	if best_time < 0.0:
		return "NO RECORD"
	return get_formatted_time(best_time)

func get_time_attack_lobby_record_label_text() -> String:
	return "%s\n%s" % [_language_text("BEST", "BESTE", "MEILLEUR", "MEJOR", "MIGLIORE"), get_time_attack_lobby_record_text()]

func get_time_attack_lobby_course_badge_text() -> String:
	var course_index := _selected_level_index
	var zone_text := "FINAL ZONE" if course_index == _level_names.size() - 2 else ("TRUE AREA 53" if course_index == _level_names.size() - 1 else "ZONE %d" % [int(course_index / 2) + 1])
	if _time_attack_boss_mode:
		return "%s   BOSS" % zone_text
	return "%s   ACT %d" % [zone_text, (course_index % 2) + 1]

func get_time_attack_lobby_focus_text() -> String:
	match _time_attack_lobby_cursor:
		0:
			return _language_text("RUN READY", "LAUF BEREIT", "COURSE PRET", "FASE LISTA", "CORSA PRONTA")
		1:
			return _language_text("CHANGE RUNNER", "CHARAKTER WECHSELN", "CHANGER DE PERSONNAGE", "CAMBIAR PERSONAJE", "CAMBIA PERSONAGGIO")
		2:
			return _language_text("CHANGE COURSE", "KURS WECHSELN", "CHANGER DE PARCOURS", "CAMBIAR FASE", "CAMBIA CORSO")
		3:
			return _language_text("BACK TO MENU", "ZUM MENUE", "RETOUR AU MENU", "VOLVER AL MENU", "TORNA AL MENU")
	return "STANDBY"

func get_time_attack_lobby_character_accent_color() -> Color:
	var palette := get_player_visual_palette()
	var variant := clampi(_selected_character_index, 0, palette.size() - 1)
	var color: Color = palette[variant]
	if _time_attack_boss_mode:
		return Color(minf(1.0, color.r + 0.14), maxf(0.0, color.g - 0.12), maxf(0.0, color.b - 0.08), 1.0)
	return color

func get_time_attack_lobby_emblem_text() -> String:
	var compact_name := get_selected_character_name().replace(" ", "")
	return compact_name.left(2) if compact_name.length() >= 2 else compact_name

func get_time_attack_lobby_chrome_colors() -> Dictionary:
	if _time_attack_boss_mode:
		return {
			"accent": Color(0.78, 0.30, 0.22, 0.74),
			"card": Color(0.18, 0.10, 0.14, 0.96),
			"selected": Color(0.42, 0.20, 0.24, 0.98),
		}
	return {
		"accent": Color(0.34, 0.68, 1.0, 0.74),
		"card": Color(0.09, 0.15, 0.28, 0.96),
		"selected": Color(0.18, 0.30, 0.48, 0.98),
	}

func open_course_select(return_phase: int = TITLE_PHASE_TIME_ATTACK_LOBBY) -> void:
	open_course_select_screen(return_phase)

func _is_multiplayer_course_select() -> bool:
	return _course_select_return_phase == TITLE_PHASE_SINGLEPAK_RESULTS and _multiplayer_result_mode == MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION

func _continue_multiplayer_after_course_select() -> void:
	_game_state = GAME_STATE_TITLE
	_multiplayer_link_ready = true
	if _multiplayer_pak_mode == 0:
		open_multiplayer_comm_screen(0, 1, "COURSE LOCKED: %s" % get_selected_level_text())
	else:
		_singlepak_download_progress = 100
		_singlepak_sync_step = 3
		open_singlepak_sync_screen(1, "COURSE SENT: %s" % get_selected_level_text())

func get_course_select_title() -> String:
	if _is_multiplayer_course_select():
		return _language_text("MULTIPLAYER COURSE", "MULTIPLAYER-KURS", "PARCOURS MULTIJOUEUR", "FASE MULTIJUGADOR", "CORSO MULTIGIOCATORE")
	return _language_text("COURSE SELECT", "KURSAUSWAHL", "CHOIX DU PARCOURS", "SELECCION DE FASE", "SCELTA CORSO")

func get_course_select_prompt() -> String:
	if _is_multiplayer_course_select():
		if is_course_select_starting():
			return _language_text("LOCKING ROOM COURSE", "RAUM-KURS WIRD FESTGELEGT", "PARCOURS DE SALLE VERROUILLE", "FIJANDO FASE DE SALA", "BLOCCO CORSO STANZA")
		if is_course_select_busy():
			return _language_text("SHIFTING ROOM COURSE", "RAUM-KURS WIRD VERSCHOBEN", "DEPLACEMENT DU PARCOURS", "CAMBIANDO FASE DE SALA", "SPOSTAMENTO CORSO STANZA")
		return _language_text("SELECT A VS COURSE", "VS-KURS AUSWAEHLEN", "CHOISISSEZ UN PARCOURS VS", "ELIGE UNA FASE VS", "SCEGLI UN CORSO VS")
	if is_course_select_unlocking():
		match get_course_select_unlock_phase():
			COURSE_UNLOCK_PHASE_PATH:
				return _language_text("OPENING NEW COURSE PATH", "NEUER KURSPFAD OEFFNET SICH", "OUVERTURE D'UN NOUVEAU PARCOURS", "ABRIENDO NUEVA RUTA", "APERTURA NUOVO PERCORSO")
			COURSE_UNLOCK_PHASE_SCROLL_BACK:
				return _language_text("RETURNING TO COURSE MAP", "ZUR KURSKARTE ZURUECK", "RETOUR A LA CARTE", "VOLVIENDO AL MAPA", "RITORNO ALLA MAPPA")
			COURSE_UNLOCK_PHASE_SCROLL_NEXT:
				return _language_text("TRAVELLING TO NEW COURSE", "ZUM NEUEN KURS", "DEPLACEMENT VERS LE NOUVEAU PARCOURS", "VIAJANDO A LA NUEVA FASE", "VIAGGIO AL NUOVO CORSO")
			COURSE_UNLOCK_PHASE_PAUSE:
				return _language_text("NEW COURSE UNLOCKED", "NEUER KURS FREIGESCHALTET", "NOUVEAU PARCOURS DEBLOQUE", "NUEVA FASE DESBLOQUEADA", "NUOVO CORSO SBLOCCATO")
	if is_course_select_starting():
		return _language_text("STARTING COURSE", "KURS STARTET", "DEMARRAGE DU PARCOURS", "INICIANDO FASE", "AVVIO CORSO")
	if is_course_select_busy():
		return _language_text("LOCKING COURSE", "KURS WIRD FESTGELEGT", "PARCOURS VERROUILLE", "FIJANDO FASE", "BLOCCO CORSO")
	return _language_text("SELECT A COURSE", "KURS AUSWAEHLEN", "CHOISISSEZ UN PARCOURS", "ELIGE UNA FASE", "SCEGLI UN CORSO")

func get_course_select_detail() -> String:
	var character_label := _language_text("CHARACTER", "CHARAKTER", "PERSONNAGE", "PERSONAJE", "PERSONAGGIO")
	var mode_label := _language_text("MODE", "MODUS", "MODE", "MODO", "MODALITA")
	var notice := get_title_notice_text()
	if notice.is_empty():
		if _is_multiplayer_course_select():
			notice = "%s SELECT   %s LOCK   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
		else:
			notice = "%s SELECT   %s START   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
	return "%s\n%s: %s   %s: %s" % [notice, character_label, get_selected_character_name(), mode_label, get_course_select_type_label()]

func get_course_select_summary_text() -> String:
	var course_label := _language_text("ROOM COURSE", "RAUM-KURS", "PARCOURS DE SALLE", "FASE DE SALA", "CORSO STANZA")
	var pak_label := _language_text("PAK MODE", "PAK-MODUS", "MODE PAK", "MODO PAK", "MODALITA PAK")
	var runner_label := _language_text("RUNNER", "LAEUFER", "COUREUR", "CORREDOR", "CORRIDORE")
	if _is_multiplayer_course_select():
		return "%s\n%s\n\n%s\n%s\n\n%s\n%s" % [course_label, get_course_select_banner_text(), pak_label, get_multiplayer_pak_mode_name(), runner_label, get_selected_character_name()]
	return "%s\n%s\n\n%s\n%s\n\n%s\n%s" % [_language_text("CURRENT COURSE", "AKTUELLER KURS", "PARCOURS ACTUEL", "FASE ACTUAL", "CORSO ATTUALE"), get_course_select_banner_text(), _language_text("RECORD", "REKORD", "RECORD", "RECORD", "RECORD"), get_selected_level_description(), _language_text("CHARACTER", "CHARAKTER", "PERSONNAGE", "PERSONAJE", "PERSONAGGIO"), get_selected_character_name()]

func get_course_select_banner_text() -> String:
	if _is_multiplayer_course_select():
		return "%s VS" % get_selected_level_text()
	if _time_attack_boss_mode:
		return "%s BOSS" % get_selected_level_text()
	return get_selected_level_text()

func get_course_select_rows() -> Array:
	var rows: Array = []
	# The original map has one moving selection, while the modern panel shows
	# a four-course window around it. Keep the selected course in that window.
	var window_size := mini(4, _level_names.size())
	var first_index := clampi(_selected_level_index - 1, 0, maxi(0, _level_names.size() - window_size))
	for index in range(first_index, first_index + window_size):
		var cleared := index < _level_cleared_flags.size() and bool(_level_cleared_flags[index])
		var unlocked := index <= _unlocked_level_index
		rows.append({
			"index": index,
			"name": get_level_name_by_index(index),
			"value": get_selected_level_description() if index == _selected_level_index else "%s: %d" % [_language_text("BEST", "BESTE", "RECORD", "MEJOR", "MIGLIORE"), get_level_best_score(index)],
			"status": get_level_status(index),
			"cleared": cleared,
			"unlocked": unlocked,
			"selected": index == _selected_level_index,
		})
	return rows

func is_course_select_traveling() -> bool:
	return _course_select_travel_timer > 0.0

func is_course_select_settling() -> bool:
	return _course_select_settle_timer > 0.0

func is_course_select_unlocking() -> bool:
	return _course_select_unlock_timer > 0.0

func _start_course_select_unlock_cutscene() -> void:
	_course_select_unlock_phase = COURSE_UNLOCK_PHASE_PATH
	_course_select_unlock_phase_duration = float(COURSE_UNLOCK_PATH_FRAMES) / 60.0
	_course_select_unlock_phase_timer = _course_select_unlock_phase_duration
	_course_select_unlock_timer = _course_select_unlock_phase_timer
	_title_notice_text = "NEW COURSE PATH UNLOCKING"
	_status_text = get_title_prompt_text()

func _advance_course_select_unlock_cutscene(delta: float) -> void:
	_course_select_unlock_phase_timer = maxf(0.0, _course_select_unlock_phase_timer - delta)
	if _course_select_unlock_phase_timer > 0.0:
		_course_select_unlock_timer = _course_select_unlock_phase_timer
		return
	match _course_select_unlock_phase:
		COURSE_UNLOCK_PHASE_PATH:
			_course_select_unlock_phase = COURSE_UNLOCK_PHASE_SCROLL_BACK
			_course_select_unlock_phase_duration = 0.35
			_course_select_unlock_phase_timer = _course_select_unlock_phase_duration
			_title_notice_text = "NEW COURSE PATH OPEN"
		COURSE_UNLOCK_PHASE_SCROLL_BACK:
			_course_select_unlock_phase = COURSE_UNLOCK_PHASE_SCROLL_NEXT
			_course_select_unlock_phase_duration = 0.55
			_course_select_unlock_phase_timer = _course_select_unlock_phase_duration
			_title_notice_text = "MOVING TO NEW COURSE"
		COURSE_UNLOCK_PHASE_SCROLL_NEXT:
			_course_select_unlock_phase = COURSE_UNLOCK_PHASE_PAUSE
			_course_select_unlock_phase_duration = float(COURSE_UNLOCK_PAUSE_FRAMES) / 60.0
			_course_select_unlock_phase_timer = _course_select_unlock_phase_duration
			_title_notice_text = "NEW COURSE READY"
		COURSE_UNLOCK_PHASE_PAUSE:
			_course_select_unlock_phase_timer = 0.0
			_course_select_unlock_timer = 0.0
			_title_notice_text = "COURSE READY: %s" % get_selected_level_text()
	if _course_select_unlock_phase != COURSE_UNLOCK_PHASE_PAUSE:
		_course_select_unlock_timer = _course_select_unlock_phase_timer
	_status_text = get_title_prompt_text()

func get_course_select_unlock_phase() -> int:
	return _course_select_unlock_phase

func get_course_select_unlock_progress() -> float:
	if _course_select_unlock_phase_duration <= 0.0:
		return 1.0
	return clampf(1.0 - (_course_select_unlock_phase_timer / _course_select_unlock_phase_duration), 0.0, 1.0)

func is_course_select_starting() -> bool:
	return _course_select_start_timer > 0.0

func is_course_select_intro() -> bool:
	return _course_select_intro_timer > 0.0

func get_course_select_intro_progress() -> float:
	if _course_select_intro_duration <= 0.0:
		return 1.0
	return clampf(1.0 - (_course_select_intro_timer / _course_select_intro_duration), 0.0, 1.0)

func is_course_select_busy() -> bool:
	return is_course_select_unlocking() or is_course_select_traveling() or is_course_select_settling()

func get_course_select_travel_progress() -> float:
	if _course_select_travel_duration <= 0.0:
		return 1.0
	if _course_select_travel_timer <= 0.0:
		return 1.0
	return clampf(1.0 - (_course_select_travel_timer / _course_select_travel_duration), 0.0, 1.0)

func get_course_select_travel_from_index() -> int:
	return _course_select_from_index

func get_course_select_travel_to_index() -> int:
	return _course_select_to_index

func get_course_select_settle_progress() -> float:
	if _course_select_settle_duration <= 0.0:
		return 1.0
	if _course_select_settle_timer <= 0.0:
		return 1.0
	return clampf(1.0 - (_course_select_settle_timer / _course_select_settle_duration), 0.0, 1.0)

func get_course_select_start_progress() -> float:
	if _course_select_start_duration <= 0.0:
		return 1.0
	if _course_select_start_timer <= 0.0:
		return 1.0
	return clampf(1.0 - (_course_select_start_timer / _course_select_start_duration), 0.0, 1.0)

func get_course_select_map_nodes() -> Array:
	var nodes: Array = []
	var count: int = _level_names.size()
	if count <= 0:
		return nodes
	var points: Array[Vector2] = [
		Vector2(62.0, 198.0),
		Vector2(138.0, 160.0),
		Vector2(214.0, 182.0),
		Vector2(270.0, 122.0),
		Vector2(246.0, 72.0),
		Vector2(166.0, 58.0),
		Vector2(92.0, 88.0),
		Vector2(54.0, 132.0),
		Vector2(78.0, 204.0),
		Vector2(156.0, 176.0),
		Vector2(232.0, 198.0),
		Vector2(286.0, 146.0),
		Vector2(260.0, 88.0),
		Vector2(184.0, 48.0),
		Vector2(104.0, 70.0),
		Vector2(48.0, 118.0),
	]
	for i in range(count):
		nodes.append({
			"index": i,
			"name": get_level_name_by_index(i),
			"position": points[i % points.size()],
			"selected": i == _selected_level_index,
			"unlocked": i <= _unlocked_level_index,
			"cleared": i < _level_cleared_flags.size() and bool(_level_cleared_flags[i]),
		})
	return nodes

func get_course_select_zone_label() -> String:
	if _is_multiplayer_course_select():
		return "VS %d" % [_selected_level_index + 1]
	if _selected_level_index >= _level_names.size() - 2:
		return _language_text("FINAL", "FINAL", "FINAL", "FINAL", "FINALE")
	return "%s %d" % [_language_text("ZONE", "ZONE", "ZONE", "ZONA", "ZONA"), int(_selected_level_index / 2) + 1]

func get_course_select_act_label() -> String:
	if _is_multiplayer_course_select():
		return _language_text("MATCH", "MATCH", "MATCH", "PARTIDA", "PARTITA")
	if _time_attack_boss_mode:
		return _language_text("BOSS", "BOSS", "BOSS", "JEFE", "BOSS")
	if _selected_level_index >= _level_names.size() - 2:
		return _language_text("SPECIAL", "SPEZIAL", "SPECIAL", "ESPECIAL", "SPECIALE")
	return "%s %d" % [_language_text("ACT", "AKT", "ACTE", "ACTO", "ATTO"), (_selected_level_index % 2) + 1]

func get_course_select_type_label() -> String:
	if _is_multiplayer_course_select():
		return _language_text("MULTIPLAYER", "MEHRSPIELER", "MULTIJOUEUR", "MULTIJUGADOR", "MULTIGIOCATORE")
	return _language_text("BOSS ATTACK", "BOSS-ANGRIFF", "ATTAQUE BOSS", "ATAQUE DE JEFE", "ATTACCO BOSS") if _time_attack_boss_mode else _language_text("ZONE ATTACK", "ZONEN-ANGRIFF", "ATTAQUE ZONE", "ATAQUE DE ZONA", "ATTACCO ZONA")

func get_course_select_emerald_rows() -> Array:
	var badges: Array = []
	var total: int = 7
	for i in range(total):
		# The original course screen reads each saved emerald bit, rather than
		# treating stage progression as a substitute for collection progress.
		var active := false
		if not _is_multiplayer_course_select():
			active = (_get_selected_chaos_emerald_mask() & (1 << i)) != 0
		badges.append({
			"label": "E%d" % [i + 1],
			"active": active,
		})
	return badges

func get_singlepak_download_progress() -> int:
	return _singlepak_download_progress

func advance_singlepak_download() -> void:
	if _singlepak_download_progress < 100:
		_singlepak_download_progress = min(100, _singlepak_download_progress + 25)

func _advance_singlepak_transfer_step() -> void:
	advance_singlepak_download()
	if _singlepak_download_progress >= 100:
		_multiplayer_link_ready = true
		open_singlepak_sync_screen(0, "DOWNLOAD COMPLETE")
	else:
		_title_notice_text = "SENDING MULTIBOOT PROGRAM"

func get_singlepak_sync_step() -> int:
	return _singlepak_sync_step

func is_singlepak_transfer_started() -> bool:
	return _singlepak_download_progress > 0

func is_singlepak_transfer_complete() -> bool:
	return _singlepak_download_progress >= 100

func is_singlepak_sync_ready() -> bool:
	return _singlepak_sync_step >= 3 and _multiplayer_link_ready

func advance_singlepak_sync_state() -> void:
	if _singlepak_sync_step < 3:
		_singlepak_sync_step += 1
	if _singlepak_sync_step >= 3:
		_title_notice_text = "CLIENTS BOOTED AND READY"
	else:
		_title_notice_text = "EXCHANGING CLIENT DATA"

func _prepare_multiplayer_results_snapshot(mode: int) -> void:
	_multiplayer_result_mode = mode
	_multiplayer_result_snapshot = []
	var connected_indices: Array = []
	for i in range(_multiplayer_link_connected.size()):
		if bool(_multiplayer_link_connected[i]):
			connected_indices.append(i)
	if connected_indices.is_empty():
		connected_indices.append(0)
	var rank_titles := ["1ST", "2ND", "3RD", "4TH"]
	_refresh_multiplayer_rankings()
	if mode == MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION:
		for player_index_variant in connected_indices:
			var player_index: int = int(player_index_variant)
			var character_index := clampi(int(_multiplayer_player_characters[player_index]), 0, _character_names.size() - 1)
			_multiplayer_result_snapshot.append({
				"player_index": player_index,
				"name": get_multiplayer_link_player_name(player_index),
				"character": _character_names[character_index],
				"rank": player_index + 1,
				"rank_text": "P%d" % [player_index + 1],
				"rings": 0,
				"wins": 0,
				"score": 0,
				"winner": false,
				"stat_text": _language_text("%s   LOCKED IN", "%s   FESTGELEGT", "%s   VERROUILLE", "%s   FIJADO", "%s   BLOCCATO") % _character_names[character_index],
			})
		return
	_commit_multiplayer_course_results()
	var ranked_indices := connected_indices.duplicate()
	ranked_indices.sort_custom(func(a: Variant, b: Variant) -> bool:
		return int(_multiplayer_player_ranks[int(a)]) < int(_multiplayer_player_ranks[int(b)])
	)
	for place in range(ranked_indices.size()):
		var player_index: int = int(ranked_indices[place])
		var character_index := clampi(int(_multiplayer_player_characters[player_index]), 0, _character_names.size() - 1)
		var rings: int = max(0, _player_state.rings) if player_index == 0 else max(12, 84 - place * 16 + (player_index % 2) * 7)
		var wins: int = max(0, ranked_indices.size() - place - 1)
		var score: int = max(0, _player_state.score) if player_index == 0 else rings * 100 + wins * 750
		_multiplayer_result_snapshot.append({
			"player_index": player_index,
			"name": get_multiplayer_link_player_name(player_index),
			"character": _character_names[character_index],
			"rank": place + 1,
			"rank_text": rank_titles[min(place, rank_titles.size() - 1)],
			"rings": rings,
			"wins": wins,
			"score": score,
			"winner": place == 0,
			"stat_text": _language_text("%s   RINGS %d   SCORE %d", "%s   RINGE %d   PUNKTE %d", "%s   ANNEAUX %d   SCORE %d", "%s   ANILLOS %d   PUNTOS %d", "%s   ANELLI %d   PUNTEGGIO %d") % [_character_names[character_index], rings, score],
		})

func get_singlepak_results_items() -> Array:
	if _multiplayer_result_mode == MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION:
		return [_language_text("CONTINUE", "WEITER", "CONTINUER", "CONTINUAR", "CONTINUA"), _language_text("BACK TO LOBBY", "ZUR LOBBY", "RETOUR A LA SALLE", "VOLVER A LA SALA", "TORNA ALLA STANZA")]
	return [_language_text("REMATCH", "RUECKSPIEL", "REJOUER", "REVANCHA", "RIVINCITA"), _language_text("BACK TO MULTI PLAYER", "ZUR MULTIPLAYER-AUSWAHL", "RETOUR AU MULTIJOUEUR", "VOLVER A MULTIJUGADOR", "TORNA AL MULTIPLAYER")]

func get_singlepak_results_cursor() -> int:
	return _singlepak_results_cursor

func get_singlepak_results_time_remaining() -> float:
	return maxf(0.0, _singlepak_results_timer)

func _advance_singlepak_results_flow() -> void:
	_singlepak_results_timer = 0.0
	if _multiplayer_result_mode == MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION:
		if _singlepak_results_cursor == 1:
			open_multiplayer_lobby_screen(0, "CHARACTER SELECTION CANCELED")
			return
		open_course_select(TITLE_PHASE_SINGLEPAK_RESULTS)
		_title_notice_text = "SELECT A MULTIPLAYER COURSE"
		return
	if _singlepak_results_cursor == 1:
		open_title_screen_at_multiplayer_menu(_multiplayer_pak_mode, "RETURNED TO MULTIPLAYER MENU")
		return
	open_multiplayer_lobby_screen(0)

func _resolve_multiplayer_lobby_choice() -> void:
	if _game_state != GAME_STATE_TITLE or _title_phase != TITLE_PHASE_MULTIPLAYER_LOBBY:
		return
	_multiplayer_lobby_waiting = false
	_multiplayer_lobby_wait_timer = 0.0
	if _multiplayer_link_connected.is_empty() or _multiplayer_player_characters.size() < _multiplayer_link_connected.size():
		# Keep a damaged link snapshot from reaching character select and crashing.
		open_title_screen_at_multiplayer_menu(0, "LINK SESSION RESET")
		return
	if _multiplayer_lobby_cursor == 0:
		open_character_select(CHARACTER_SELECT_CONTEXT_MULTIPLAYER, 0)
		return
	# The source starts Cheese's 120-frame wave/fade before destroying the
	# multiplayer lobby task and returning to the title screen.
	_multiplayer_lobby_waiting = true
	_multiplayer_lobby_exit_timer = MULTIPLAYER_LOBBY_EXIT_DURATION
	_title_notice_text = "CLOSING MULTIPLAYER ROOM"
	_status_text = get_title_prompt_text()

func get_multiplayer_results_title() -> String:
	if _multiplayer_result_mode == MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION:
		return _language_text("CHARACTERS SELECTED", "CHARAKTER GEWAEHLT", "PERSONNAGES CHOISIS", "PERSONAJES ELEGIDOS", "PERSONAGGI SCELTI")
	return _language_text("MULTIPLAYER RESULTS", "MULTIPLAYER-ERGEBNIS", "RESULTATS MULTIJOUEUR", "RESULTADOS MULTIJUGADOR", "RISULTATI MULTIGIOCATORE")

func is_multiplayer_character_selection_results() -> bool:
	return _multiplayer_result_mode == MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION

func get_multiplayer_results_prompt() -> String:
	var seconds_left := ceili(get_singlepak_results_time_remaining())
	if _multiplayer_result_mode == MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION:
		if _multiplayer_result_snapshot.is_empty():
			return _language_text("CHARACTER ORDER LOCKED IN", "CHARAKTERREIHENFOLGE FESTGELEGT", "ORDRE DES PERSONNAGES FIXE", "ORDEN DE PERSONAJES FIJADO", "ORDINE DEI PERSONAGGI FISSATO")
		return _language_text("READY: %s ON %s   NEXT IN %d", "BEREIT: %s AUF %s   WEITER IN %d", "PRET: %s SUR %s   SUITE DANS %d", "LISTO: %s EN %s   SIGUIENTE EN %d", "PRONTO: %s SU %s   PROSSIMO TRA %d") % [str(_multiplayer_result_snapshot[0]["character"]), get_multiplayer_session_course_text(), seconds_left]
	if _multiplayer_result_snapshot.is_empty():
		return _language_text("COLLECT RINGS SUMMARY", "RING-SAMMELERGEBNIS", "RESUME DES ANNEAUX", "RESUMEN DE ANILLOS", "RIEPILOGO ANELLI")
	return _language_text("WINNER: %s   COURSE: %s   NEXT IN %d", "SIEGER: %s   KURS: %s   WEITER IN %d", "VAINQUEUR: %s   PARCOURS: %s   SUITE DANS %d", "GANADOR: %s   FASE: %s   SIGUIENTE EN %d", "VINCITORE: %s   CORSO: %s   PROSSIMO TRA %d") % [str(_multiplayer_result_snapshot[0]["name"]), get_multiplayer_session_course_text(), seconds_left]

func get_multiplayer_results_detail() -> String:
	if _multiplayer_result_mode == MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION:
		return _language_text("AUTO ADVANCE TO COURSE SELECT   %s SKIP NOW", "AUTOMATISCH ZUR KURSWAHL   %s JETZT UEBERSPRINGEN", "PASSAGE AUTO AU CHOIX DU PARCOURS   %s PASSER", "AVANCE AUTO A SELECCION DE FASE   %s OMITIR", "AVANZAMENTO AUTO ALLA SCELTA CORSO   %s SALTA") % get_confirm_label()
	return _language_text("AUTO ADVANCE TO PLAY AGAIN?   %s SKIP NOW", "AUTOMATISCH ERNEUT SPIELEN?   %s JETZT UEBERSPRINGEN", "REJOUER AUTOMATIQUEMENT?   %s PASSER", "JUGAR DE NUEVO AUTOMATICAMENTE?   %s OMITIR", "GIOCARE ANCORA AUTOMATICAMENTE?   %s SALTA") % get_confirm_label()

func get_multiplayer_results_summary_text() -> String:
	var mode_text := _language_text("COURSE COMPLETE", "KURS BEENDET", "PARCOURS TERMINE", "FASE COMPLETADA", "CORSO COMPLETATO") if _multiplayer_result_mode == MULTIPLAYER_RESULTS_MODE_COURSE_COMPLETE else _language_text("CHARACTER SELECTION", "CHARAKTERWAHL", "CHOIX DU PERSONNAGE", "SELECCION DE PERSONAJE", "SCELTA PERSONAGGIO")
	var mode_label := _language_text("MODE", "MODUS", "MODE", "MODO", "MODALITA")
	var players_label := _language_text("PLAYERS", "SPIELER", "JOUEURS", "JUGADORES", "GIOCATORI")
	if _multiplayer_result_snapshot.is_empty():
		return "%s\n%s\n\n%s\n0" % [mode_label, mode_text, players_label]
	var winner: Dictionary = _multiplayer_result_snapshot[0]
	if _multiplayer_result_mode == MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION:
		return "%s\n%s\n\n%s\n%s\n\n%s\n%s" % [
			mode_label,
			mode_text,
			_language_text("LEAD PICK", "ERSTE WAHL", "PREMIER CHOIX", "PRIMERA ELECCION", "PRIMA SCELTA"),
			str(winner["character"]),
			_language_text("NEXT STEP", "NAECHSTER SCHRITT", "ETAPE SUIVANTE", "SIGUIENTE PASO", "PROSSIMO PASSO"),
			_language_text("COURSE SELECT", "KURSAUSWAHL", "CHOIX DU PARCOURS", "SELECCION DE FASE", "SELEZIONE CORSO"),
		]
	return "%s\n%s\n\n%s\n%s\n\n%s\n%s" % [mode_label, mode_text, _language_text("WINNER", "SIEGER", "VAINQUEUR", "GANADOR", "VINCITORE"), str(winner["name"]), _language_text("NEXT STEP", "NAECHSTER SCHRITT", "ETAPE SUIVANTE", "SIGUIENTE PASO", "PROSSIMO PASSO"), _language_text("PLAY AGAIN?", "NOCHMAL SPIELEN?", "REJOUER?", "JUGAR DE NUEVO?", "GIOCARE ANCORA?")]

func get_multiplayer_results_badge_text() -> String:
	return _language_text("SEL", "AUS", "SEL", "SEL", "SEL") if _multiplayer_result_mode == MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION else "VS"

func get_multiplayer_results_chrome_colors() -> Dictionary:
	if _multiplayer_result_mode == MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION:
		return {
			"accent": Color(0.92, 0.42, 0.24, 1.0),
			"panel": Color(0.10, 0.14, 0.22, 0.96),
			"summary": Color(0.18, 0.12, 0.14, 0.98),
			"card": Color(0.16, 0.12, 0.16, 0.96),
			"selected": Color(0.40, 0.20, 0.18, 0.98),
		}
	return {
		"accent": Color(0.96, 0.68, 0.22, 1.0),
		"panel": Color(0.10, 0.14, 0.22, 0.96),
		"summary": Color(0.14, 0.18, 0.28, 0.98),
		"card": Color(0.12, 0.18, 0.30, 0.96),
		"selected": Color(0.20, 0.32, 0.50, 0.98),
	}

func get_multiplayer_result_option_rows() -> Array:
	var items := get_singlepak_results_items()
	var rows: Array = []
	for i in range(items.size()):
		var label := str(items[i])
		rows.append({
			"label": label,
			"status": _language_text("SELECTED", "AUSGEWAEHLT", "SELECTIONNE", "SELECCIONADO", "SELEZIONATO") if i == _singlepak_results_cursor else (_language_text("NEXT", "WEITER", "SUIVANT", "SIGUIENTE", "PROSSIMO") if i == 0 else _language_text("RETURN", "ZURUECK", "RETOUR", "VOLVER", "RITORNO")),
			"selected": i == _singlepak_results_cursor,
		})
	return rows

func get_multiplayer_lobby_items() -> Array:
	return [
		_language_text("YES", "JA", "OUI", "SI", "SI"),
		_language_text("NO", "NEIN", "NON", "NO", "NO"),
	]

func get_multiplayer_lobby_cursor() -> int:
	return _multiplayer_lobby_cursor

func get_multiplayer_lobby_title() -> String:
	return _language_text("CONTINUE?", "WEITER?", "CONTINUER?", "CONTINUAR?", "CONTINUARE?")

func get_multiplayer_lobby_prompt() -> String:
	var notice := get_title_notice_text()
	if not notice.is_empty():
		return notice
	if _multiplayer_lobby_waiting:
		return _language_text("WAITING FOR ALL LINKED PLAYERS", "WARTE AUF ALLE VERBUNDENEN SPIELER", "EN ATTENTE DE TOUS LES JOUEURS", "ESPERANDO A TODOS LOS JUGADORES", "IN ATTESA DI TUTTI I GIOCATORI")
	if _multiplayer_lobby_cursor == 0:
		return _language_text("HOST WILL START ANOTHER MATCH ON %s", "HOST STARTET EIN WEITERES MATCH AUF %s", "L'HOTE RELANCERA UNE PARTIE SUR %s", "EL HOST INICIARA OTRA PARTIDA EN %s", "L'HOST AVVIERA UN'ALTRA PARTITA SU %s") % get_multiplayer_session_course_text()
	return _language_text("HOST WILL CLOSE THE ROOM AFTER %s", "HOST SCHLIESST DEN RAUM NACH %s", "L'HOTE FERMERA LA SALLE APRES %s", "EL HOST CERRARA LA SALA TRAS %s", "L'HOST CHIUDERA LA STANZA DOPO %s") % get_multiplayer_session_course_text()

func get_multiplayer_lobby_detail() -> String:
	if _multiplayer_lobby_waiting:
		return _language_text("COURSE: %s   SYSTEMS: %d/4   HOST: P1\nDECISION SENT   HOLD FOR LINKED PLAYERS", "KURS: %s   SYSTEME: %d/4   HOST: P1\nENTSCHEIDUNG GESENDET   AUF VERBUNDENE SPIELER WARTEN", "PARCOURS: %s   SYSTEMES: %d/4   HOTE: P1\nDECISION ENVOYEE   ATTENTE DES JOUEURS", "FASE: %s   SISTEMAS: %d/4   HOST: P1\nDECISION ENVIADA   ESPERA A LOS JUGADORES", "CORSO: %s   SISTEMI: %d/4   HOST: P1\nDECISIONE INVIATA   ATTENDI I GIOCATORI") % [get_multiplayer_session_course_text(), get_multiplayer_link_count()]
	return _language_text("COURSE: %s   SYSTEMS: %d/4   HOST: P1\nLEFT/RIGHT CHOICE   %s CONFIRM   %s BACK", "KURS: %s   SYSTEME: %d/4   HOST: P1\nLINKS/RECHTS WAHL   %s BESTAETIGEN   %s ZURUECK", "PARCOURS: %s   SYSTEMES: %d/4   HOTE: P1\nCHOIX GAUCHE/DROITE   %s CONFIRMER   %s RETOUR", "FASE: %s   SISTEMAS: %d/4   HOST: P1\nELECCION IZQ/DER   %s CONFIRMAR   %s ATRAS", "CORSO: %s   SISTEMI: %d/4   HOST: P1\nSCELTA SINISTRA/DESTRA   %s CONFERMA   %s INDIETRO") % [get_multiplayer_session_course_text(), get_multiplayer_link_count(), get_confirm_label(), get_secondary_label()]

func get_multiplayer_lobby_info_text() -> String:
	if _multiplayer_lobby_waiting:
		return _language_text("SYNCING THE HOST DECISION WITH EVERY LINKED SYSTEM", "HOST-ENTSCHEIDUNG WIRD MIT SYSTEMEN SYNCHRONISIERT", "SYNCHRONISATION DE LA DECISION DE L'HOTE", "SINCRONIZANDO DECISION DEL HOST", "SINCRONIZZAZIONE DECISIONE HOST")
	if _multiplayer_lobby_cursor == 0:
		return _language_text("SEND A CONTINUE VOTE TO EVERY LINKED SYSTEM", "FORTSETZUNGSSTIMME AN SYSTEME SENDEN", "ENVOYER UN VOTE CONTINUER AUX SYSTEMES", "ENVIAR VOTO DE CONTINUAR A LOS SISTEMAS", "INVIA VOTO CONTINUA AI SISTEMI")
	return _language_text("SEND AN EXIT VOTE AND RETURN TO RESULTS", "AUSSTIEGSSTIMME SENDEN UND ZU ERGEBNISSEN", "ENVOYER UN VOTE DE SORTIE ET RETOURNER AUX RESULTATS", "ENVIAR VOTO DE SALIDA Y VOLVER A RESULTADOS", "INVIA VOTO USCITA E TORNA AI RISULTATI")

func get_multiplayer_lobby_summary_text() -> String:
	var partners: int = max(0, get_multiplayer_link_count() - 1)
	var choice := _language_text("YES", "JA", "OUI", "SI", "SI") if _multiplayer_lobby_cursor == 0 else _language_text("NO", "NEIN", "NON", "NO", "NO")
	var choice_label := _language_text("CHOICE", "WAHL", "CHOIX", "ELECCION", "SCELTA")
	var state_label := _language_text("STATE", "STATUS", "ETAT", "ESTADO", "STATO")
	var partners_label := _language_text("PARTNERS", "PARTNER", "PARTENAIRES", "SOCIOS", "PARTNER")
	if _multiplayer_lobby_waiting:
		return "%s\n%s\n\n%s\n%s\n\n%s\n%d" % [choice_label, choice, state_label, _language_text("WAITING", "WARTEN", "ATTENTE", "ESPERA", "ATTESA"), partners_label, partners]
	var next_label := _language_text("NEXT", "NAECHSTER SCHRITT", "SUIVANT", "SIGUIENTE", "PROSSIMO")
	var next_step := _language_text("START REMATCH", "RUECKSPIEL STARTEN", "LANCER LA REVANCHE", "INICIAR REVANCHA", "AVVIA RIVINCITA") if _multiplayer_lobby_cursor == 0 else _language_text("SHOW END RESULTS", "ENDRESULTATE ZEIGEN", "AFFICHER LES RESULTATS FINAUX", "MOSTRAR RESULTADOS FINALES", "MOSTRA RISULTATI FINALI")
	return "%s\n%s\n\n%s\n%s\n\n%s\n%d" % [choice_label, choice, next_label, next_step, partners_label, partners]

func get_multiplayer_lobby_badge_text() -> String:
	return _language_text("YES", "JA", "OUI", "SI", "SI") if _multiplayer_lobby_cursor == 0 else _language_text("NO", "NEIN", "NON", "NO", "NO")

func get_multiplayer_lobby_section_text() -> String:
	return _language_text("NEXT PACKET", "NAECHSTES PAKET", "PROCHAIN PAQUET", "SIGUIENTE PAQUETE", "PROSSIMO PACCHETTO")

func get_multiplayer_lobby_chrome_colors() -> Dictionary:
	if _multiplayer_lobby_waiting:
		return {
			"accent": Color(0.92, 0.64, 0.24, 1.0),
			"badge": Color(1.0, 0.88, 0.48, 0.96),
			"summary": Color(0.96, 0.92, 0.84, 0.98),
		}
	if _multiplayer_lobby_cursor == 0:
		return {
			"accent": Color(0.95, 0.54, 0.24, 1.0),
			"badge": Color(0.98, 0.84, 0.44, 0.96),
			"summary": Color(0.94, 0.94, 0.88, 0.98),
		}
	return {
		"accent": Color(0.82, 0.34, 0.24, 1.0),
		"badge": Color(0.92, 0.62, 0.36, 0.96),
		"summary": Color(0.92, 0.88, 0.84, 0.98),
	}

func get_multiplayer_lobby_option_rows() -> Array:
	var items := get_multiplayer_lobby_items()
	var rows: Array = []
	for i in range(items.size()):
		rows.append({
			"label": str(items[i]),
			"status": (_language_text("WAIT", "WARTEN", "ATTENTE", "ESPERA", "ATTESA") if i == _multiplayer_lobby_cursor else _language_text("HOLD", "HALTEN", "MAINTIEN", "MANTENER", "MANTIENI")) if _multiplayer_lobby_waiting else (_language_text("REMATCH", "RUECKSPIEL", "REVANCHE", "REVANCHA", "RIVINCITA") if i == 0 else _language_text("RESULTS", "ERGEBNISSE", "RESULTATS", "RESULTADOS", "RISULTATI")),
			"selected": i == _multiplayer_lobby_cursor,
		})
	return rows

func get_multiplayer_lobby_player_rows() -> Array:
	_ensure_multiplayer_session_arrays()
	var rows: Array = []
	for i in range(_multiplayer_link_connected.size()):
		var character_name: String = str(_character_names[clampi(int(_multiplayer_player_characters[i]), 0, _character_names.size() - 1)])
		var rank_value: int = int(_multiplayer_player_ranks[i]) if i < _multiplayer_player_ranks.size() else -1
		var rank_text: String = ""
		if rank_value >= 0 and bool(_multiplayer_link_connected[i]):
			rank_text = "  P%d" % [rank_value + 1]
		var connected := bool(_multiplayer_link_connected[i])
		var status_text := ""
		if i == 0:
			if _multiplayer_lobby_waiting:
				status_text = _language_text("HOST  %s  SENDING %s%s", "HOST  %s  SENDET %s%s", "HOTE  %s  ENVOIE %s%s", "HOST  %s  ENVIANDO %s%s", "HOST  %s  INVIA %s%s") % [character_name, _language_text("REMATCH", "RUECKSPIEL", "REVANCHE", "REVANCHA", "RIVINCITA") if _multiplayer_lobby_cursor == 0 else _language_text("EXIT", "AUSSTIEG", "SORTIE", "SALIDA", "USCITA"), rank_text]
			else:
				status_text = _language_text("HOST  %s  SELECTING%s", "HOST  %s  WAEHLT%s", "HOTE  %s  CHOISIT%s", "HOST  %s  ELIGIENDO%s", "HOST  %s  SCEGLIE%s") % [character_name, rank_text]
		elif connected:
			status_text = (_language_text("%s  READY TO %s%s", "%s  BEREIT FUER %s%s", "%s  PRET POUR %s%s", "%s  LISTO PARA %s%s", "%s  PRONTO PER %s%s") % [character_name, _language_text("REMATCH", "RUECKSPIEL", "REVANCHE", "REVANCHA", "RIVINCITA") if _multiplayer_lobby_cursor == 0 else _language_text("EXIT", "AUSSTIEG", "SORTIE", "SALIDA", "USCITA"), rank_text]) if _multiplayer_lobby_waiting else (_language_text("%s  LINK OK%s", "%s  LINK OK%s", "%s  LIAISON OK%s", "%s  ENLACE OK%s", "%s  LINK OK%s") % [character_name, rank_text])
		else:
			status_text = _language_text("%s  WAITING FOR LINK", "%s  WARTE AUF LINK", "%s  ATTENTE DE LIAISON", "%s  ESPERANDO ENLACE", "%s  IN ATTESA DEL LINK") % character_name
		rows.append({
			"name": get_multiplayer_link_player_name(i),
			"status": status_text,
			"connected": connected,
			"host": i == 0,
		})
	return rows

func get_tiny_chao_session_id() -> String:
	return _tiny_chao_session_id

func get_tiny_chao_play_position() -> Vector2:
	return Vector2(_tiny_chao_play_x, _tiny_chao_play_y)

func get_tiny_chao_mood() -> int:
	return _tiny_chao_mood

func is_tiny_chao_unlocked() -> bool:
	return _tiny_chao_unlocked

func _generate_tiny_chao_session_id() -> void:
	# The original handoff combines two random values with the current frame
	# count, so repeated launches must not reuse the same session token.
	var entropy := (randi() ^ (Time.get_ticks_usec() << 8) ^ (Engine.get_process_frames() << 3)) & 0xFFFF
	_tiny_chao_session_id = "TCG-%04X" % entropy

func get_singlepak_result_rows() -> Array:
	if _multiplayer_result_snapshot.is_empty():
		_prepare_multiplayer_results_snapshot(MULTIPLAYER_RESULTS_MODE_COURSE_COMPLETE)
	var rows: Array = _multiplayer_result_snapshot.duplicate(true)
	for row_variant in rows:
		var row: Dictionary = row_variant
		var character_name := str(row.get("character", "SONIC"))
		if _multiplayer_result_mode == MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION:
			row["stat_text"] = _language_text("%s   LOCKED IN", "%s   FESTGELEGT", "%s   VERROUILLE", "%s   FIJADO", "%s   BLOCCATO") % character_name
		else:
			row["stat_text"] = _language_text("%s   RINGS %d   SCORE %d", "%s   RINGE %d   PUNKTE %d", "%s   ANNEAUX %d   SCORE %d", "%s   ANILLOS %d   PUNTOS %d", "%s   ANELLI %d   PUNTEGGIO %d") % [character_name, int(row.get("rings", 0)), int(row.get("score", 0))]
	return rows

func open_character_select(context: int = CHARACTER_SELECT_CONTEXT_GAME_START, initial_selection: int = -1) -> void:
	_game_state = GAME_STATE_CHARACTER_SELECT
	var requested_character := _selected_character_index if initial_selection < 0 else initial_selection
	_selected_character_index = clampi(requested_character, 0, _character_names.size() - 1)
	if context != CHARACTER_SELECT_CONTEXT_MULTIPLAYER and not is_character_unlocked(_selected_character_index):
		_selected_character_index = _get_default_character_select_index()
	_character_select_context = context
	_character_select_intro_timer = 100.0 / 60.0
	_status_text = "CHARACTER SELECT"

func is_character_select() -> bool:
	return _game_state == GAME_STATE_CHARACTER_SELECT

func is_multiplayer_character_select_screen() -> bool:
	return _game_state == GAME_STATE_CHARACTER_SELECT and _character_select_context == CHARACTER_SELECT_CONTEXT_MULTIPLAYER

func is_character_select_input_ready() -> bool:
	return _game_state == GAME_STATE_CHARACTER_SELECT and _character_select_intro_timer <= 0.0

func get_character_select_intro_progress() -> float:
	if not is_character_select():
		return 1.0
	return clampf(1.0 - (_character_select_intro_timer / (100.0 / 60.0)), 0.0, 1.0)

func skip_character_select_intro() -> void:
	if _game_state != GAME_STATE_CHARACTER_SELECT or is_multiplayer_character_select_screen():
		return
	_character_select_intro_timer = 0.0

func move_character_selection(direction: int) -> void:
	if _game_state != GAME_STATE_CHARACTER_SELECT:
		return
	var available_indices := get_character_select_available_indices()
	if available_indices.is_empty():
		return
	var current_slot := available_indices.find(_selected_character_index)
	if current_slot < 0:
		current_slot = 0
	current_slot = wrapi(current_slot + direction, 0, available_indices.size())
	_selected_character_index = int(available_indices[current_slot])

func confirm_character_selection() -> void:
	if _game_state != GAME_STATE_CHARACTER_SELECT:
		return
	if not is_character_select_character_available(_selected_character_index):
		_status_text = "CHARACTER LOCKED"
		return
	_player_state.variant = _selected_character_index
	if _character_select_context != CHARACTER_SELECT_CONTEXT_MULTIPLAYER:
		_sync_active_character_level_progress()
	if _character_select_context == CHARACTER_SELECT_CONTEXT_TIME_ATTACK_ZONE:
		open_time_attack_level_select_screen(false)
		return
	if _character_select_context == CHARACTER_SELECT_CONTEXT_TIME_ATTACK_BOSS:
		open_time_attack_level_select_screen(true)
		return
	if _character_select_context == CHARACTER_SELECT_CONTEXT_MULTIPLAYER:
		_multiplayer_player_characters[0] = _selected_character_index
		_multiplayer_link_players[0] = _get_multiplayer_host_name()
		_refresh_multiplayer_remote_characters()
		_prepare_multiplayer_results_snapshot(MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION)
		open_singlepak_results_screen(MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION, 0, "%s LOCKED IN FOR REMATCH" % get_selected_character_name())
		return
	_selected_level_index = 0
	open_course_select_screen(TITLE_PHASE_SINGLE_PLAYER, "%s READY: SELECT A COURSE" % get_selected_character_name())

func cancel_character_selection() -> void:
	if _game_state != GAME_STATE_CHARACTER_SELECT:
		return
	if _character_select_context == CHARACTER_SELECT_CONTEXT_MULTIPLAYER:
		# The original multiplayer carousel has no local cancel branch.
		return
	if _character_select_context == CHARACTER_SELECT_CONTEXT_TIME_ATTACK_ZONE:
		open_title_screen_at_time_attack_menu(0)
		return
	elif _character_select_context == CHARACTER_SELECT_CONTEXT_TIME_ATTACK_BOSS:
		open_title_screen_at_time_attack_menu(1)
		return
	elif _character_select_context == CHARACTER_SELECT_CONTEXT_MULTIPLAYER:
		open_multiplayer_lobby_screen(0)
		return
	else:
		open_title_screen_at_single_player_menu(0)
		return

func open_time_attack_lobby(is_boss_mode: bool) -> void:
	_game_state = GAME_STATE_TITLE
	_title_phase = TITLE_PHASE_TIME_ATTACK_LOBBY
	_time_attack_boss_mode = is_boss_mode
	_time_attack_lobby_cursor = 0
	_title_notice_text = "%s READY FOR %s" % [_character_names[_selected_character_index], "BOSS TIME ATTACK" if is_boss_mode else "ZONE TIME ATTACK"]
	_status_text = get_title_prompt_text()

func get_character_menu_index() -> int:
	return _selected_character_index

func get_character_names() -> Array:
	return _character_names

func get_selected_character_name() -> String:
	return _character_names[_selected_character_index]

func get_selected_character_description() -> String:
	return _get_character_description_text(_selected_character_index)

func get_character_select_rows() -> Array:
	var rows: Array = []
	var available_indices := get_character_select_available_indices()
	for i in available_indices:
		var character_index := int(i)
		rows.append({
			"name": str(_character_names[character_index]),
			"description": _get_character_description_text(character_index),
			"status": get_character_select_status_text(character_index),
			"available": is_character_select_character_available(character_index),
			"selected": character_index == _selected_character_index,
		})
	return rows

func get_character_select_summary_text() -> String:
	return "%s\n%s\n\n%s\n%s\n\n%s\n%s" % [
		_language_text("RUNNER", "LAEUFER", "COUREUR", "CORREDOR", "CORRIDORE"),
		get_selected_character_name(),
		_language_text("STYLE", "STIL", "STYLE", "ESTILO", "STILE"),
		get_selected_character_description(),
		_language_text("STATE", "STATUS", "ETAT", "ESTADO", "STATO"),
		get_character_select_status_text(_selected_character_index),
	]

func get_character_select_chrome_colors() -> Dictionary:
	match _character_select_context:
		CHARACTER_SELECT_CONTEXT_TIME_ATTACK_ZONE:
			return {
				"chip": Color(0.18, 0.38, 0.86, 0.96),
				"glow_ready": Color(0.30, 0.78, 0.98, 0.34),
				"glow_locked": Color(0.42, 0.44, 0.52, 0.26),
			}
		CHARACTER_SELECT_CONTEXT_TIME_ATTACK_BOSS:
			return {
				"chip": Color(0.78, 0.24, 0.20, 0.96),
				"glow_ready": Color(0.96, 0.58, 0.30, 0.30),
				"glow_locked": Color(0.42, 0.44, 0.52, 0.26),
			}
		CHARACTER_SELECT_CONTEXT_MULTIPLAYER:
			return {
				"chip": Color(0.84, 0.34, 0.20, 0.96),
				"glow_ready": Color(0.98, 0.70, 0.28, 0.30),
				"glow_locked": Color(0.42, 0.44, 0.52, 0.26),
			}
	return {
		"chip": Color(0.20, 0.62, 0.42, 0.96),
		"glow_ready": Color(0.30, 0.78, 0.98, 0.34),
		"glow_locked": Color(0.42, 0.44, 0.52, 0.26),
	}

func get_character_select_context_label() -> String:
	match _character_select_context:
		CHARACTER_SELECT_CONTEXT_TIME_ATTACK_ZONE:
			return _language_text("ZONE ATTACK", "ZONEN-ANGRIFF", "ATTAQUE ZONE", "ATAQUE DE ZONA", "ATTACCO ZONA")
		CHARACTER_SELECT_CONTEXT_TIME_ATTACK_BOSS:
			return _language_text("BOSS ATTACK", "BOSS-ANGRIFF", "ATTAQUE BOSS", "ATAQUE DE JEFE", "ATTACCO BOSS")
		CHARACTER_SELECT_CONTEXT_MULTIPLAYER:
			return _language_text("MULTIPLAYER", "MEHRSPIELER", "MULTIJOUEUR", "MULTIJUGADOR", "MULTIGIOCATORE")
	return _language_text("GAME START", "SPIELSTART", "DEBUT DU JEU", "INICIO", "INIZIO")

func get_character_select_title_text() -> String:
	match _character_select_context:
		CHARACTER_SELECT_CONTEXT_TIME_ATTACK_ZONE:
			return _language_text("TIME ATTACK", "ZEITANGRIFF", "CONTRE LA MONTRE", "CONTRARRELOJ", "ATTACCO A TEMPO")
		CHARACTER_SELECT_CONTEXT_TIME_ATTACK_BOSS:
			return _language_text("BOSS ATTACK", "BOSS-ANGRIFF", "ATTAQUE BOSS", "ATAQUE DE JEFE", "ATTACCO BOSS")
		CHARACTER_SELECT_CONTEXT_MULTIPLAYER:
			return _language_text("MULTIPLAYER", "MEHRSPIELER", "MULTIJOUEUR", "MULTIJUGADOR", "MULTIGIOCATORE")
	return _language_text("CHARACTER SELECT", "CHARAKTERWAHL", "CHOIX DU PERSONNAGE", "SELECCION DE PERSONAJE", "SCELTA PERSONAGGIO")

func get_character_select_prompt_text() -> String:
	if not _title_notice_text.is_empty():
		return get_title_notice_text()
	match _character_select_context:
		CHARACTER_SELECT_CONTEXT_TIME_ATTACK_ZONE:
			return _language_text("SELECT A RUNNER", "WAHLE EINEN LAUFER", "CHOISISSEZ UN COUREUR", "ELIGE UN CORREDOR", "SCEGLI UN CORRIDORE")
		CHARACTER_SELECT_CONTEXT_TIME_ATTACK_BOSS:
			return _language_text("SELECT A BOSS CHALLENGER", "WAHLE EINEN BOSS-HELDEN", "CHOISISSEZ UN DEFI BOSS", "ELIGE UN RETADOR", "SCEGLI UNO SFIDANTE BOSS")
		CHARACTER_SELECT_CONTEXT_MULTIPLAYER:
			return _language_text("SELECT A REMATCH RUNNER", "WAHLE EINEN RUCKKAMPF-LAUFER", "CHOISISSEZ UN COUREUR POUR LA REVANCHE", "ELIGE UN CORREDOR PARA LA REVANCHA", "SCEGLI UN CORRIDORE PER LA RIVINCITA")
	return _language_text("SELECT YOUR CHARACTER", "WAHLE DEINEN CHARAKTER", "CHOISISSEZ VOTRE PERSONNAGE", "ELIGE TU PERSONAJE", "SCEGLI IL PERSONAGGIO")

func get_character_select_detail_text() -> String:
	var action_text := "%s = %s   %s = %s" % [get_confirm_label(), _language_text("CONFIRM", "BESTATIGEN", "VALIDER", "CONFIRMAR", "CONFERMA"), get_secondary_label(), _language_text("BACK", "ZURUCK", "RETOUR", "ATRAS", "INDIETRO")]
	match _character_select_context:
		CHARACTER_SELECT_CONTEXT_TIME_ATTACK_ZONE:
			return get_selected_character_description() + "\n" + _language_text("ZONE RECORD ATTACK", "ZONEN-REKORDANGRIFF", "RECORD ZONE", "RECORD DE ZONA", "RECORD ZONA") + "\n" + action_text
		CHARACTER_SELECT_CONTEXT_TIME_ATTACK_BOSS:
			return get_selected_character_description() + "\n" + _language_text("BOSS RECORD ATTACK", "BOSS-REKORDANGRIFF", "RECORD BOSS", "RECORD DE JEFE", "RECORD BOSS") + "\n" + action_text
		CHARACTER_SELECT_CONTEXT_MULTIPLAYER:
			return get_selected_character_description() + "\n" + _language_text("LOCK THE REMATCH CHARACTER", "RUCKKAMPF-CHARAKTER FESTLEGEN", "VERROUILLEZ LE PERSONNAGE", "FIJA EL PERSONAJE", "BLOCCA IL PERSONAGGIO") + "\n" + action_text
	return get_selected_character_description() + "\n" + action_text

func get_character_select_status_text(index: int) -> String:
	if not is_character_select_character_available(index):
		return _language_text("LOCKED", "GESPERRT", "VERROUILLE", "BLOQUEADO", "BLOCCATO")
	if index == CHARACTER_NAMES_AMY_INDEX():
		return _language_text("SPECIAL", "SPEZIAL", "SPECIAL", "ESPECIAL", "SPECIALE")
	return _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO")

func _get_character_description_text(index: int) -> String:
	match clampi(index, 0, _character_descriptions.size() - 1):
		0:
			return _language_text("BALANCED SPEED TYPE", "AUSGEGLICHENER TEMPO-TYP", "TYPE VITESSE EQUILIBRE", "TIPO VELOCIDAD EQUILIBRADO", "TIPO VELOCITA BILANCIATO")
		1:
			return _language_text("FLIGHT AND CHEESE SUPPORT", "FLUG UND CHEESE-HILFE", "VOL ET SOUTIEN DE CHEESE", "VUELO Y APOYO DE CHEESE", "VOLO E SUPPORTO DI CHEESE")
		2:
			return _language_text("FLIGHT AND TECHNICAL ROUTES", "FLUG UND TECHNISCHE WEGE", "VOL ET PARCOURS TECHNIQUES", "VUELO Y RUTAS TECNICAS", "VOLO E PERCORSI TECNICI")
		3:
			return _language_text("POWER AND CLIMB ROUTES", "KRAFT UND KLETTERWEGE", "FORCE ET PARCOURS VERTICAUX", "FUERZA Y RUTAS VERTICALES", "FORZA E PERCORSI VERTICALI")
		_:
			return _language_text("HAMMER TECHNIQUE", "HAMMER-TECHNIK", "TECHNIQUE DU MARTEAU", "TECNICA DEL MARTILLO", "TECNICA DEL MARTELLO")

func get_character_select_available_indices() -> Array:
	# character_select.c keeps every roster slot in the carousel. Locked
	# characters are rendered as silhouettes, not removed from navigation.
	return [0, 1, 2, 3, CHARACTER_NAMES_AMY_INDEX()]

func is_character_select_character_available(index: int) -> bool:
	if index < 0 or index >= _character_unlocked.size():
		return false
	# Multi-Pak negotiation exposes the four main characters to every linked
	# player; Amy still follows the save unlock bit, matching the original.
	if _character_select_context == CHARACTER_SELECT_CONTEXT_MULTIPLAYER and index < CHARACTER_NAMES_AMY_INDEX():
		return true
	return is_character_unlocked(index)

func _get_default_character_select_index() -> int:
	var preferred_index := clampi(_player_state.variant, 0, _character_names.size() - 1)
	if is_character_unlocked(preferred_index):
		return preferred_index
	return 0

func CHARACTER_NAMES_AMY_INDEX() -> int:
	return 4

func is_boss_time_attack_unlocked() -> bool:
	return _boss_time_attack_unlocked

func is_true_area_unlocked() -> bool:
	return _true_area_unlocked

func is_character_unlocked(index: int) -> bool:
	if index < 0 or index >= _character_unlocked.size():
		return false
	return _character_unlocked[index]

func get_pause_text() -> String:
	return _language_text("TAP TO RESUME", "ZUM FORTSETZEN TIPPEN", "TOUCHER POUR REPRENDRE", "TOCA PARA CONTINUAR", "TOCCA PER RIPRENDERE") if _is_touch_device() else _language_text("PRESS ENTER TO RESUME", "ENTER ZUM FORTSETZEN DRUECKEN", "APPUYEZ SUR ENTREE POUR REPRENDRE", "PULSA ENTER PARA CONTINUAR", "PREMI INVIO PER RIPRENDERE")

func get_pause_title_text() -> String:
	return _language_text("PAUSE", "PAUSE", "PAUSE", "PAUSA", "PAUSA")

func get_pause_prompt_text() -> String:
	return _language_text("STAGE SUSPENDED", "SPIELSTUFE ANGEHALTEN", "STAGE EN PAUSE", "FASE SUSPENDIDA", "STAGE SOSPESO")

func get_pause_detail_text() -> String:
	if _run_from_time_attack or _run_from_multiplayer:
		return _language_text("%s SELECT   %s CONFIRM   %s RESUME", "%s AUSWAEHLEN   %s BESTAETIGEN   %s FORTSETZEN", "%s SELECTIONNER   %s CONFIRMER   %s REPRENDRE", "%s SELECCIONAR   %s CONFIRMAR   %s CONTINUAR", "%s SELEZIONA   %s CONFERMA   %s RIPRENDI") % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
	return _language_text("%s SELECT   %s CONFIRM   START RESUME", "%s AUSWAEHLEN   %s BESTAETIGEN   START FORTSETZEN", "%s SELECTIONNER   %s CONFIRMER   START REPRENDRE", "%s SELECCIONAR   %s CONFIRMAR   START CONTINUAR", "%s SELEZIONA   %s CONFERMA   START RIPRENDI") % [get_navigation_label(), get_confirm_label()]

func get_pause_summary_text() -> String:
	var selected := _pause_menu_index
	var rows := get_pause_menu_rows()
	if selected > 0 and selected < rows.size():
		return _language_text("LEAVE THE STAGE\n%s", "SPIELSTUFE VERLASSEN\n%s", "QUITTER LE STAGE\n%s", "SALIR DE LA FASE\n%s", "LASCIA LO STAGE\n%s") % str(rows[selected].get("value", ""))
	return _language_text("RETURN TO THE CURRENT STAGE", "ZUR AKTUELLEN SPIELSTUFE", "RETOURNER AU STAGE", "VOLVER A LA FASE ACTUAL", "TORNA ALLO STAGE ATTUALE")

func get_pause_badge_text() -> String:
	return _language_text("PAUSED", "PAUSIERT", "EN PAUSE", "EN PAUSA", "IN PAUSA")

func get_pause_chrome_colors() -> Dictionary:
	return {
		"accent": Color(0.98, 0.76, 0.20, 0.98),
		"card": Color(0.10, 0.13, 0.22, 0.98),
	}

func get_pause_menu_index() -> int:
	return _pause_menu_index

func get_pause_menu_rows() -> Array:
	var continue_label := _language_text("CONTINUE", "WEITER", "CONTINUER", "CONTINUAR", "CONTINUA")
	var quit_label := _language_text("QUIT", "BEENDEN", "QUITTER", "SALIR", "ESCI")
	var stage_label := _language_text("RETURN TO STAGE", "ZURUCK ZUM SPIEL", "RETOUR AU STAGE", "VOLVER A LA FASE", "TORNA ALLO STAGE")
	var exit_label := _language_text("RETURN TO TITLE", "ZURUCK ZUM TITEL", "RETOUR AU TITRE", "VOLVER AL TITULO", "TORNA AL TITOLO")
	if _run_from_time_attack:
		exit_label = _language_text("RETURN TO TIME ATTACK", "ZURUCK ZU TIME ATTACK", "RETOUR AU TIME ATTACK", "VOLVER A TIME ATTACK", "TORNA A TIME ATTACK")
	elif _run_from_multiplayer:
		exit_label = _language_text("RETURN TO MULTIPLAYER", "ZURUCK ZU MULTIPLAYER", "RETOUR AU MULTIJOUEUR", "VOLVER A MULTIJUGADOR", "TORNA AL MULTIPLAYER")
	return [
		{
			"label": continue_label,
			"value": stage_label,
		},
		{
			"label": quit_label,
			"value": exit_label,
		},
	]

func get_save_menu_text() -> String:
	if _save_reset_pending:
		return "CONFIRM RESET?"
	return get_options_screen_title()

func get_save_menu_index() -> int:
	match _options_mode:
		OPTIONS_MODE_MAIN:
			return _options_menu_index
		OPTIONS_MODE_PLAYER_DATA:
			return _player_data_menu_index
		OPTIONS_MODE_LANGUAGE:
			return _language_index
		OPTIONS_MODE_BUTTON_CONFIG:
			return _button_config_index
		OPTIONS_MODE_SOUND_TEST:
			return _sound_test_menu_index
		OPTIONS_MODE_DIFFICULTY:
			return _difficulty_index
		OPTIONS_MODE_TIME_LIMIT:
			return 0 if _time_limit_enabled else 1
		OPTIONS_MODE_DELETE_CONFIRM, OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			return _delete_confirm_index
		OPTIONS_MODE_TIME_RECORDS:
			if _time_records_view == TIME_RECORDS_VIEW_MODE_CHOICE:
				return 1 if _time_records_boss_mode else 0
			return _time_records_character_index if not _time_records_boss_mode else 0
		OPTIONS_MODE_MULTI_RECORDS:
			return _multi_records_menu_index
		OPTIONS_MODE_NAME_ENTRY:
			return _name_entry_menu_index
	return 0

func is_save_reset_pending() -> bool:
	return _save_reset_pending

func is_save_overlay_screen() -> bool:
	if not is_save_options():
		return false
	return _options_mode == OPTIONS_MODE_MAIN

func is_player_data_menu() -> bool:
	return _options_mode == OPTIONS_MODE_PLAYER_DATA

func is_player_data_screen() -> bool:
	return _game_state == GAME_STATE_SAVE_OPTIONS and _options_mode == OPTIONS_MODE_PLAYER_DATA and not _save_reset_pending

func is_options_main_screen() -> bool:
	return _game_state == GAME_STATE_SAVE_OPTIONS and _options_mode == OPTIONS_MODE_MAIN and not _save_reset_pending

func is_time_records_screen() -> bool:
	return _game_state == GAME_STATE_SAVE_OPTIONS and _options_mode == OPTIONS_MODE_TIME_RECORDS

func is_time_records_courses_view() -> bool:
	return is_time_records_screen() and _time_records_view == TIME_RECORDS_VIEW_COURSES

func is_time_attack_level_select_screen() -> bool:
	return is_time_records_screen() and _time_records_context == TIME_RECORDS_CONTEXT_TIME_ATTACK

func is_multiplayer_records_screen() -> bool:
	return _game_state == GAME_STATE_SAVE_OPTIONS and _options_mode == OPTIONS_MODE_MULTI_RECORDS

func is_name_entry_screen() -> bool:
	return _game_state == GAME_STATE_SAVE_OPTIONS and _options_mode == OPTIONS_MODE_NAME_ENTRY

func is_language_screen() -> bool:
	return _game_state == GAME_STATE_SAVE_OPTIONS and _options_mode == OPTIONS_MODE_LANGUAGE

func is_creating_new_profile() -> bool:
	return _game_state == GAME_STATE_SAVE_OPTIONS and _creating_new_profile

func is_button_config_screen() -> bool:
	return _game_state == GAME_STATE_SAVE_OPTIONS and _options_mode == OPTIONS_MODE_BUTTON_CONFIG

func is_sound_test_screen() -> bool:
	return _game_state == GAME_STATE_SAVE_OPTIONS and _options_mode == OPTIONS_MODE_SOUND_TEST

func is_difficulty_screen() -> bool:
	return _game_state == GAME_STATE_SAVE_OPTIONS and _options_mode == OPTIONS_MODE_DIFFICULTY

func is_time_limit_screen() -> bool:
	return _game_state == GAME_STATE_SAVE_OPTIONS and _options_mode == OPTIONS_MODE_TIME_LIMIT

func is_delete_confirm_screen() -> bool:
	return _game_state == GAME_STATE_SAVE_OPTIONS and _options_mode == OPTIONS_MODE_DELETE_CONFIRM

func is_delete_final_confirm_screen() -> bool:
	return _game_state == GAME_STATE_SAVE_OPTIONS and _options_mode == OPTIONS_MODE_DELETE_CONFIRM_FINAL

func get_options_menu_items() -> Array:
	var items := [
		"PLAYER DATA",
		"DIFFICULTY",
		"TIME LIMIT",
		"LANGUAGE",
		"BUTTON CONFIG",
		"DELETE GAME DATA",
		"EXIT",
	]
	if _sound_test_unlocked:
		items.insert(5, "SOUND TEST")
	return items

func _get_options_item_index(item_label: String) -> int:
	var index := get_options_menu_items().find(item_label)
	return maxi(0, index)

func get_options_display_items() -> Array:
	var items: Array = [
		_language_text("PLAYER DATA", "SPIELERDATEN", "DONNEES JOUEUR", "DATOS DEL JUGADOR", "DATI GIOCATORE"),
		_language_text("DIFFICULTY", "SCHWIERIGKEIT", "DIFFICULTE", "DIFICULTAD", "DIFFICOLTA"),
		_language_text("TIME LIMIT", "ZEITLIMIT", "LIMITE DE TEMPS", "LIMITE DE TIEMPO", "LIMITE DI TEMPO"),
		_language_text("LANGUAGE", "SPRACHE", "LANGUE", "IDIOMA", "LINGUA"),
		_language_text("BUTTON CONFIG", "TASTENBELEGUNG", "CONFIG BOUTONS", "CONFIG BOTONES", "CONFIG TASTI"),
		_language_text("DELETE GAME DATA", "SPIELDATEN LOESCHEN", "SUPPRIMER DONNEES", "BORRAR DATOS", "CANCELLA DATI"),
		_language_text("EXIT", "BEENDEN", "QUITTER", "SALIR", "ESCI"),
	]
	if _sound_test_unlocked:
		items.insert(5, _language_text("SOUND TEST", "MUSIKTEST", "TEST SON", "PRUEBA DE SONIDO", "TEST AUDIO"))
	return items

func get_player_data_menu_items() -> Array:
	return [
		_language_text("NAME ENTRY", "NAMEN EINGEBEN", "SAISIE DU NOM", "NOMBRE", "INSERISCI NOME"),
		_language_text("TIME RECORDS", "ZEITREKORDE", "RECORDS DE TEMPS", "RECORDS DE TIEMPO", "RECORD TEMPI"),
		_language_text("MULTI-PAK RECORDS", "MULTI-PAK REKORDE", "RECORDS MULTI-PAK", "RECORDS MULTI-PAK", "RECORD MULTI-PAK"),
		_language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO"),
	]

func get_options_screen_title() -> String:
	if _save_reset_pending:
		return "CONFIRM RESET"
	match _options_mode:
		OPTIONS_MODE_MAIN:
			return _language_text("OPTIONS", "OPTIONEN", "OPTIONS", "OPCIONES", "OPZIONI")
		OPTIONS_MODE_PLAYER_DATA:
			return _language_text("PLAYER DATA", "SPIELERDATEN", "DONNEES JOUEUR", "DATOS DEL JUGADOR", "DATI GIOCATORE")
		OPTIONS_MODE_LANGUAGE:
			return _language_text("LANGUAGE", "SPRACHE", "LANGUE", "IDIOMA", "LINGUA")
		OPTIONS_MODE_BUTTON_CONFIG:
			return _language_text("BUTTON CONFIG", "TASTENBELEGUNG", "CONFIG BOUTONS", "CONFIG BOTONES", "CONFIG TASTI")
		OPTIONS_MODE_SOUND_TEST:
			return _language_text("SOUND TEST", "MUSIKTEST", "TEST SON", "PRUEBA DE SONIDO", "TEST AUDIO")
		OPTIONS_MODE_DIFFICULTY:
			return _language_text("DIFFICULTY", "SCHWIERIGKEIT", "DIFFICULTE", "DIFICULTAD", "DIFFICOLTA")
		OPTIONS_MODE_TIME_LIMIT:
			return _language_text("TIME LIMIT", "ZEITLIMIT", "LIMITE DE TEMPS", "LIMITE DE TIEMPO", "LIMITE DI TEMPO")
		OPTIONS_MODE_DELETE_CONFIRM, OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			return _language_text("DELETE GAME DATA", "SPIELDATEN LOESCHEN", "SUPPRIMER DONNEES", "BORRAR DATOS", "CANCELLA DATI")
		OPTIONS_MODE_TIME_RECORDS:
			return _language_text("TIME RECORDS", "ZEITREKORDE", "RECORDS DE TEMPS", "RECORDS DE TIEMPO", "RECORD TEMPI")
		OPTIONS_MODE_MULTI_RECORDS:
			return _language_text("MULTI-PAK RECORDS", "MULTI-PAK REKORDE", "RECORDS MULTI-PAK", "RECORDS MULTI-PAK", "RECORD MULTI-PAK")
		OPTIONS_MODE_NAME_ENTRY:
			return _language_text("NAME ENTRY", "NAMEN EINGEBEN", "SAISIE DU NOM", "NOMBRE", "INSERISCI NOME")
	return "OPTIONS"

func get_options_screen_subtitle() -> String:
	if _save_reset_pending:
		return _language_text("SAVE DATA WILL BE ERASED", "SPEICHERDATEN WERDEN GELOESCHT", "DONNEES EFFACEES", "DATOS SERAN BORRADOS", "DATI VERRANNO CANCELLATI")
	match _options_mode:
		OPTIONS_MODE_MAIN:
			return _language_text("GAME SETTINGS", "SPIELEINSTELLUNGEN", "PARAMETRES DE JEU", "AJUSTES DEL JUEGO", "IMPOSTAZIONI GIOCO")
		OPTIONS_MODE_PLAYER_DATA:
			return _language_text("PROFILE AND RECORDS", "PROFIL UND REKORDE", "PROFIL ET RECORDS", "PERFIL Y RECORDS", "PROFILO E RECORD")
		OPTIONS_MODE_LANGUAGE:
			return _language_text("SELECT DISPLAY LANGUAGE", "ANZEIGESPRACHE WAEHLEN", "CHOISIR LA LANGUE", "ELEGIR IDIOMA", "SCEGLI LINGUA")
		OPTIONS_MODE_BUTTON_CONFIG:
			return _language_text("ASSIGN ACTION BUTTONS", "AKTIONSTASTEN ZUWEISEN", "ASSIGNER LES BOUTONS", "ASIGNAR BOTONES", "ASSEGNA PULSANTI")
		OPTIONS_MODE_SOUND_TEST:
			return _language_text("THE ORIGINAL JUKEBOX", "DIE ORIGINALE JUKEBOX", "LE JUKEBOX ORIGINAL", "LA JUKEBOX ORIGINAL", "IL JUKEBOX ORIGINALE")
		OPTIONS_MODE_DIFFICULTY:
			return _language_text("SELECT DIFFICULTY", "SCHWIERIGKEIT WAEHLEN", "CHOISIR LA DIFFICULTE", "ELEGIR DIFICULTAD", "SCEGLI DIFFICOLTA")
		OPTIONS_MODE_TIME_LIMIT:
			return _language_text("TOGGLE TIME LIMIT", "ZEITLIMIT UMSCHALTEN", "GERER LA LIMITE", "CAMBIAR LIMITE", "CAMBIA LIMITE")
		OPTIONS_MODE_DELETE_CONFIRM:
			return _language_text("DELETE ALL SAVE DATA?", "ALLE SPEICHERDATEN LOESCHEN?", "EFFACER TOUTES LES DONNEES?", "BORRAR TODOS LOS DATOS?", "CANCELLARE TUTTI I DATI?")
		OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			return _language_text("THIS CANNOT BE UNDONE", "DIES KANN NICHT RUECKGAENGIG GEMACHT WERDEN", "ACTION IRREVERSIBLE", "NO SE PUEDE DESHACER", "AZIONE IRREVERSIBILE")
		OPTIONS_MODE_TIME_RECORDS:
			return _language_text("BEST CLEAR TIMES", "BESTE ABSCHLUSSZEITEN", "MEILLEURS TEMPS", "MEJORES TIEMPOS", "MIGLIORI TEMPI")
		OPTIONS_MODE_MULTI_RECORDS:
			return _language_text("VERSUS RECORD SUMMARY", "VERSUS-REKORDUEBERSICHT", "RESUME DES RECORDS VS", "RESUMEN DE RECORDS VS", "RIEPILOGO RECORD VS")
		OPTIONS_MODE_NAME_ENTRY:
			return _language_text("EDIT PROFILE NAME", "PROFILNAMEN BEARBEITEN", "MODIFIER LE NOM", "EDITAR NOMBRE", "MODIFICA NOME")
	return _language_text("GAME SETTINGS", "SPIELEINSTELLUNGEN", "PARAMETRES DE JEU", "AJUSTES DEL JUEGO", "IMPOSTAZIONI GIOCO")

func get_options_summary_text() -> String:
	if _save_reset_pending:
		return get_save_detail_text()
	match _options_mode:
		OPTIONS_MODE_MAIN:
			return "%s: %s   %s: %s   %s: %s" % [
				_language_text("DIFFICULTY", "SCHWIERIGKEIT", "DIFFICULTE", "DIFICULTAD", "DIFFICOLTA"),
				get_difficulty_text(),
				_language_text("TIME LIMIT", "ZEITLIMIT", "LIMITE DE TEMPS", "LIMITE DE TIEMPO", "LIMITE DI TEMPO"),
				_language_text("ON", "AN", "OUI", "SI", "SI") if _time_limit_enabled else _language_text("OFF", "AUS", "NON", "NO", "NO"),
				_language_text("LANGUAGE", "SPRACHE", "LANGUE", "IDIOMA", "LINGUA"),
				get_language_text(),
			]
		OPTIONS_MODE_PLAYER_DATA:
			return "%s: %s   %s: MAIN" % [_language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), get_profile_name_text(), _language_text("SAVE SLOT", "SPEICHERPLATZ", "EMPLACEMENT", "RANURA", "SLOT SALVATAGGIO")]
		OPTIONS_MODE_LANGUAGE:
			return "%s: %s" % [_language_text("CURRENT LANGUAGE", "AKTUELLE SPRACHE", "LANGUE ACTUELLE", "IDIOMA ACTUAL", "LINGUA ATTUALE"), get_language_text()]
		OPTIONS_MODE_BUTTON_CONFIG:
			return "%s: %s   A=%s   B=%s" % [_language_text("FACE BUTTONS", "GESICHTSTASTEN", "BOUTONS", "BOTONES", "PULSANTI"), get_button_config_focus_label(), _button_bindings[0], _button_bindings[1]]
		OPTIONS_MODE_SOUND_TEST:
			return get_sound_test_summary_text().replace("\n", "   ")
		OPTIONS_MODE_DIFFICULTY:
			return "%s: %s   %s: %s" % [_language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), get_profile_name_text(), _language_text("CURRENT", "AKTUELL", "ACTUEL", "ACTUAL", "ATTUALE"), get_difficulty_text()]
		OPTIONS_MODE_TIME_LIMIT:
			return "%s: %s   %s: %s" % [_language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), get_profile_name_text(), _language_text("CURRENT", "AKTUELL", "ACTUEL", "ACTUAL", "ATTUALE"), _language_text("ON", "AN", "OUI", "SI", "SI") if _time_limit_enabled else _language_text("OFF", "AUS", "NON", "NO", "NO")]
		OPTIONS_MODE_DELETE_CONFIRM:
			return "%s: %s   %s" % [_language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), get_profile_name_text(), _language_text("DELETE ALL PROGRESS?", "ALLEN FORTSCHRITT LOESCHEN?", "EFFACER LA PROGRESSION?", "BORRAR PROGRESO?", "CANCELLARE PROGRESSI?")]
		OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			return _language_text("UNLOCKS, RECORDS, AND PROFILE SETTINGS WILL RESET", "FREISCHALTUNGEN, REKORDE UND PROFIL WERDEN ZURUECKGESETZT", "PROGRESSION, RECORDS ET PROFIL SERONT REINITIALISES", "DESBLOQUEOS, RECORDS Y PERFIL SE REINICIARAN", "SBLOCCHI, RECORD E PROFILO VERRANNO AZZERATI")
		OPTIONS_MODE_TIME_RECORDS:
			return _language_text("VIEW PERSONAL BESTS FOR EACH CHARACTER", "PERSOENLICHE BESTZEITEN ANZEIGEN", "VOIR LES RECORDS DE CHAQUE PERSONNAGE", "VER MEJORES MARCAS POR PERSONAJE", "VEDI I RECORD DI OGNI PERSONAGGIO")
		OPTIONS_MODE_MULTI_RECORDS:
			return _language_text("LOCAL MULTIPLAYER HISTORY", "LOKALE MEHRSPIELER-HISTORIE", "HISTORIQUE MULTIJOUEUR LOCAL", "HISTORIAL MULTIJUGADOR LOCAL", "CRONOLOGIA MULTIGIOCATORE LOCALE")
		OPTIONS_MODE_NAME_ENTRY:
			return "%s: %s" % [_language_text("CURRENT NAME", "AKTUELLER NAME", "NOM ACTUEL", "NOMBRE ACTUAL", "NOME ATTUALE"), get_profile_name_text()]
	return ""

func get_options_main_title_text() -> String:
	return _language_text("OPTIONS", "OPTIONEN", "OPTIONS", "OPCIONES", "OPZIONI")

func get_options_main_prompt_text() -> String:
	return _language_text("SELECT AN OPTION", "OPTION WAEHLEN", "CHOISIR UNE OPTION", "ELIGE UNA OPCION", "SCEGLI UN'OPZIONE")

func get_options_main_detail_text() -> String:
	return "%s SELECT   %s OPEN   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]

func get_player_data_title_text() -> String:
	return _language_text("PLAYER DATA", "SPIELERDATEN", "DONNEES JOUEUR", "DATOS DEL JUGADOR", "DATI GIOCATORE")

func get_player_data_prompt_text() -> String:
	return _language_text("SELECT PLAYER DATA", "SPIELERDATEN WAEHLEN", "CHOISIR LES DONNEES", "ELIGE DATOS", "SCEGLI DATI GIOCATORE")

func get_player_data_detail_text() -> String:
	return "%s SELECT   %s CONFIRM   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]

func get_player_data_header_text() -> String:
	return "%s  %s" % [_language_text("PROFILE NAME", "PROFILNAME", "NOM DU PROFIL", "NOMBRE DEL PERFIL", "NOME PROFILO"), get_profile_name_text()]

func get_player_data_slot_text() -> String:
	return "%s: MAIN" % _language_text("SAVE SLOT", "SPEICHERPLATZ", "EMPLACEMENT", "RANURA", "SLOT SALVATAGGIO")

func get_player_data_summary_text() -> String:
	var total_best := 0
	for score in _best_scores:
		total_best += int(score)
	return "%s\n%s: %s\n%s: %d" % [_language_text("PLAYER DATA", "SPIELERDATEN", "DONNEES JOUEUR", "DATOS DEL JUGADOR", "DATI GIOCATORE"), _language_text("LANGUAGE", "SPRACHE", "LANGUE", "IDIOMA", "LINGUA"), get_language_text(), _language_text("BEST TOTAL", "BESTSUMME", "TOTAL RECORD", "TOTAL MEJORES", "TOTALE RECORD"), total_best]

func get_difficulty_title_text() -> String:
	return _language_text("DIFFICULTY", "SCHWIERIGKEIT", "DIFFICULTE", "DIFICULTAD", "DIFFICOLTA")

func get_difficulty_prompt_text() -> String:
	return _language_text("LEFT/RIGHT CHANGE, ENTER CONFIRM, X BACK", "LINKS/RECHTS AENDERN, ENTER BESTAETIGEN, X ZURUECK", "GAUCHE/DROITE CHANGER, ENTREE VALIDER, X RETOUR", "IZQ/DER CAMBIAR, ENTER CONFIRMAR, X ATRAS", "SINISTRA/DESTRA CAMBIA, INVIO CONFERMA, X INDIETRO")

func get_difficulty_summary_text() -> String:
	return "%s\n%s\n\n%s\n%s" % [_language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), get_profile_name_text(), _language_text("CURRENT", "AKTUELL", "ACTUEL", "ACTUAL", "ATTUALE"), get_difficulty_text()]

func get_difficulty_detail_text() -> String:
	return "%s   %s = %s   %s = %s" % [_language_text("LEFT/RIGHT = CHANGE", "LINKS/RECHTS = AENDERN", "GAUCHE/DROITE = CHANGER", "IZQ/DER = CAMBIAR", "SINISTRA/DESTRA = CAMBIA"), get_confirm_label(), _language_text("CONFIRM", "BESTAETIGEN", "VALIDER", "CONFIRMAR", "CONFERMA"), get_secondary_label(), _language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO")]

func get_difficulty_rows() -> Array:
	return [
		{
			"label": _language_text("NORMAL", "NORMAL", "NORMAL", "NORMAL", "NORMALE"),
			"status": _language_text("STANDARD RUN", "STANDARDLAUF", "COURSE STANDARD", "CARRERA ESTANDAR", "CORSA STANDARD"),
			"selected": _difficulty_index == 0,
		},
		{
			"label": _language_text("EASY", "EINFACH", "FACILE", "FACIL", "FACILE"),
			"status": _language_text("LOWER ENEMY PRESSURE", "WENIGER GEGNERDRUCK", "MOINS D'ENNEMIS", "MENOS ENEMIGOS", "MENO NEMICI"),
			"selected": _difficulty_index == 1,
		},
	]

func get_difficulty_chrome_colors() -> Dictionary:
	return {
		"accent": Color(0.94, 0.62, 0.24, 1.0),
		"card": Color(0.98, 0.92, 0.84, 0.98),
	}

func get_time_limit_title_text() -> String:
	return _language_text("TIME LIMIT", "ZEITLIMIT", "LIMITE DE TEMPS", "LIMITE DE TIEMPO", "LIMITE DI TEMPO")

func get_time_limit_prompt_text() -> String:
	return get_difficulty_prompt_text()

func get_time_limit_summary_text() -> String:
	var value := _language_text("ON", "AN", "OUI", "SI", "SI") if _time_limit_enabled else _language_text("OFF", "AUS", "NON", "NO", "NO")
	return "%s\n%s\n\n%s\n%s" % [_language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), get_profile_name_text(), _language_text("CURRENT", "AKTUELL", "ACTUEL", "ACTUAL", "ATTUALE"), value]

func get_time_limit_detail_text() -> String:
	return get_difficulty_detail_text()

func get_time_limit_rows() -> Array:
	return [
		{
			"label": _language_text("ON", "AN", "OUI", "SI", "SI"),
			"status": _language_text("CLASSIC COUNTDOWN", "KLASSISCHER COUNTDOWN", "COMPTE A REBOURS CLASSIQUE", "CUENTA ATRAS CLASICA", "CONTO ALLA ROVESCIA CLASSICO"),
			"selected": _time_limit_enabled,
		},
		{
			"label": _language_text("OFF", "AUS", "NON", "NO", "NO"),
			"status": _language_text("FREE RUN MODE", "FREIER LAUF", "MODE LIBRE", "MODO LIBRE", "MODALITA LIBERA"),
			"selected": not _time_limit_enabled,
		},
	]

func get_time_limit_chrome_colors() -> Dictionary:
	return {
		"accent": Color(0.38, 0.82, 0.52, 1.0),
		"card": Color(0.88, 0.98, 0.90, 0.98),
	}

func get_delete_confirm_title_text() -> String:
	return _language_text("DELETE GAME DATA", "SPIELDATEN LOESCHEN", "SUPPRIMER DONNEES", "BORRAR DATOS", "CANCELLA DATI")

func get_delete_confirm_prompt_text() -> String:
	if _options_mode == OPTIONS_MODE_DELETE_CONFIRM_FINAL:
		return _language_text("LEFT/RIGHT CHOOSE, ENTER ERASE, X BACK", "LINKS/RECHTS WAEHLEN, ENTER LOESCHEN, X ZURUECK", "GAUCHE/DROITE CHOISIR, ENTREE EFFACER, X RETOUR", "IZQ/DER ELEGIR, ENTER BORRAR, X ATRAS", "SINISTRA/DESTRA SCEGLI, INVIO CANCELLA, X INDIETRO")
	return _language_text("LEFT/RIGHT CHOOSE, ENTER CONTINUE, X BACK", "LINKS/RECHTS WAEHLEN, ENTER FORTFAHREN, X ZURUECK", "GAUCHE/DROITE CHOISIR, ENTREE CONTINUER, X RETOUR", "IZQ/DER ELEGIR, ENTER CONTINUAR, X ATRAS", "SINISTRA/DESTRA SCEGLI, INVIO CONTINUA, X INDIETRO")

func get_delete_confirm_summary_text() -> String:
	if _options_mode == OPTIONS_MODE_DELETE_CONFIRM_FINAL:
		return "%s\n%s\n\n%s\n%s" % [_language_text("FINAL CHECK", "LETZTE PRUEFUNG", "VERIFICATION FINALE", "COMPROBACION FINAL", "CONTROLLO FINALE"), _language_text("ALL RECORDS RESET", "ALLE REKORDE ZURUECKGESETZT", "TOUS LES RECORDS EFFACES", "TODOS LOS RECORDS BORRADOS", "TUTTI I RECORD AZZERATI"), _language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), get_profile_name_text()]
	return "%s\n%s\n\n%s\n%02d %s" % [_language_text("ERASE PROFILE", "PROFIL LOESCHEN", "EFFACER LE PROFIL", "BORRAR PERFIL", "CANCELLA PROFILO"), get_profile_name_text(), _language_text("UNLOCKS", "FREISCHALTUNGEN", "DEBLOCAGES", "DESBLOQUEOS", "SBLOCCHI"), _unlocked_level_index + 1, _language_text("CLEARED", "GESCHAFFT", "TERMINE", "COMPLETADOS", "COMPLETATI")]

func get_delete_confirm_detail_text() -> String:
	return "%s   %s = %s   %s = %s" % [_language_text("LEFT/RIGHT = CHOOSE", "LINKS/RECHTS = WAEHLEN", "GAUCHE/DROITE = CHOISIR", "IZQ/DER = ELEGIR", "SINISTRA/DESTRA = SCEGLI"), get_confirm_label(), _language_text("CONFIRM", "BESTAETIGEN", "VALIDER", "CONFIRMAR", "CONFERMA"), get_secondary_label(), _language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO")]

func get_delete_confirm_rows() -> Array:
	return [
		{
			"label": _language_text("YES", "JA", "OUI", "SI", "SI"),
			"status": _language_text("ERASE SAVE DATA", "SPEICHERDATEN LOESCHEN", "EFFACER LES DONNEES", "BORRAR DATOS", "CANCELLA DATI"),
			"selected": _delete_confirm_index == 0,
		},
		{
			"label": _language_text("NO", "NEIN", "NON", "NO", "NO"),
			"status": _language_text("KEEP CURRENT DATA", "AKTUELLE DATEN BEHALTEN", "GARDER LES DONNEES", "CONSERVAR DATOS", "MANTIENI DATI"),
			"selected": _delete_confirm_index == 1,
		},
	]

func get_delete_confirm_chrome_colors() -> Dictionary:
	if _options_mode == OPTIONS_MODE_DELETE_CONFIRM_FINAL:
		return {
			"accent": Color(0.98, 0.28, 0.18, 1.0),
			"card": Color(0.16, 0.06, 0.06, 0.96),
			"text": Color(0.98, 0.92, 0.92, 1.0),
		}
	return {
		"accent": Color(0.94, 0.42, 0.20, 1.0),
		"card": Color(0.98, 0.90, 0.86, 0.98),
		"text": Color(0.18, 0.12, 0.12, 1.0),
	}

func get_time_records_summary_text() -> String:
	var character_rows := get_time_records_character_rows()
	var character_name: String = str(character_rows[clampi(_time_records_character_index, 0, character_rows.size() - 1)]) if not character_rows.is_empty() else "SONIC"
	if _time_records_context == TIME_RECORDS_CONTEXT_TIME_ATTACK:
		return "%s: %s\n%s: %s\n%s: %s" % [_language_text("MODE", "MODUS", "MODE", "MODO", "MODALITA"), _language_text("BOSS ATTACK", "BOSS-ANGRIFF", "ATTAQUE BOSS", "ATAQUE BOSS", "ATTACCO BOSS") if _time_records_boss_mode else _language_text("ZONE ATTACK", "ZONEN-ANGRIFF", "ATTAQUE ZONE", "ATAQUE ZONA", "ATTACCO ZONA"), _language_text("CHARACTER", "CHARAKTER", "PERSONNAGE", "PERSONAJE", "PERSONAGGIO"), character_name, _language_text("COURSE", "KURS", "PARCOURS", "FASE", "CORSO"), get_time_records_course_title_text()]
	if _time_records_view == TIME_RECORDS_VIEW_MODE_CHOICE:
		return "%s: %s\n%s\n%s: %s" % [_language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), get_profile_name_text(), _language_text("SELECT RECORD MODE", "REKORDMODUS WAEHLEN", "CHOISIR LE MODE", "ELEGIR MODO", "SCEGLI MODALITA RECORD"), _language_text("CURRENT", "AKTUELL", "ACTUEL", "ACTUAL", "ATTUALE"), _language_text("BOSS", "BOSS", "BOSS", "JEFE", "BOSS") if _time_records_boss_mode else _language_text("ZONE", "ZONE", "ZONE", "ZONA", "ZONA")]
	return "%s: %s\n%s: %s\n%s: %s" % [_language_text("CHARACTER", "CHARAKTER", "PERSONNAGE", "PERSONAJE", "PERSONAGGIO"), character_name, _language_text("COURSE", "KURS", "PARCOURS", "FASE", "CORSO"), get_time_records_course_title_text(), _language_text("TYPE", "TYP", "TYPE", "TIPO", "TIPO"), _language_text("BOSS", "BOSS", "BOSS", "JEFE", "BOSS") if _time_records_boss_mode else _language_text("ACT", "AKT", "ACTE", "ACTO", "ATTO")]

func get_time_records_title_text() -> String:
	return _language_text("TIME RECORDS", "ZEITREKORDE", "RECORDS DE TEMPS", "RECORDS DE TIEMPO", "RECORD TEMPI")

func get_time_records_prompt_text() -> String:
	if _time_records_context == TIME_RECORDS_CONTEXT_TIME_ATTACK:
		return _language_text("LEFT/RIGHT COURSE, ENTER START, X BACK", "LINKS/RECHTS KURS, ENTER START, X ZURUECK", "GAUCHE/DROITE PARCOURS, ENTREE DEMARRER, X RETOUR", "IZQ/DER FASE, ENTER INICIAR, X ATRAS", "SINISTRA/DESTRA CORSO, INVIO AVVIA, X INDIETRO")
	if _time_records_view == TIME_RECORDS_VIEW_MODE_CHOICE:
		return _language_text("LEFT/RIGHT MODE, ENTER OPEN, X BACK", "LINKS/RECHTS MODUS, ENTER OEFFNEN, X ZURUECK", "GAUCHE/DROITE MODE, ENTREE OUVRIR, X RETOUR", "IZQ/DER MODO, ENTER ABRIR, X ATRAS", "SINISTRA/DESTRA MODALITA, INVIO APRI, X INDIETRO")
	return _language_text("UP/DOWN CHARACTER, LEFT/RIGHT COURSE, X BACK", "HOCH/RUNTER CHARAKTER, LINKS/RECHTS KURS, X ZURUECK", "HAUT/BAS PERSONNAGE, GAUCHE/DROITE PARCOURS, X RETOUR", "ARRIBA/ABAJO PERSONAJE, IZQ/DER FASE, X ATRAS", "SU/GIU PERSONAGGIO, SINISTRA/DESTRA CORSO, X INDIETRO")

func get_time_records_detail_text() -> String:
	if _time_records_context == TIME_RECORDS_CONTEXT_TIME_ATTACK:
		return "%s   %s = %s   %s = %s" % [_language_text("LEFT/RIGHT = COURSE", "LINKS/RECHTS = KURS", "GAUCHE/DROITE = PARCOURS", "IZQ/DER = FASE", "SINISTRA/DESTRA = CORSO"), get_confirm_label(), _language_text("START", "START", "DEMARRER", "INICIAR", "AVVIA"), get_secondary_label(), _language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO")]
	if _time_records_view == TIME_RECORDS_VIEW_MODE_CHOICE:
		return "%s   %s = %s   %s = %s" % [_language_text("LEFT/RIGHT = MODE", "LINKS/RECHTS = MODUS", "GAUCHE/DROITE = MODE", "IZQ/DER = MODO", "SINISTRA/DESTRA = MODALITA"), get_confirm_label(), _language_text("OPEN", "OEFFNEN", "OUVRIR", "ABRIR", "APRI"), get_secondary_label(), _language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO")]
	return "%s   %s   %s = %s" % [_language_text("UP/DOWN = CHARACTER", "HOCH/RUNTER = CHARAKTER", "HAUT/BAS = PERSONNAGE", "ARRIBA/ABAJO = PERSONAJE", "SU/GIU = PERSONAGGIO"), _language_text("LEFT/RIGHT = COURSE", "LINKS/RECHTS = KURS", "GAUCHE/DROITE = PARCOURS", "IZQ/DER = FASE", "SINISTRA/DESTRA = CORSO"), get_secondary_label(), _language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO")]

func get_time_records_chrome_colors() -> Dictionary:
	if _time_records_context == TIME_RECORDS_CONTEXT_TIME_ATTACK:
		return {
			"accent": Color(0.92, 0.60, 0.22, 1.0),
			"card": Color(0.98, 0.94, 0.86, 0.98),
			"stage": Color(0.20, 0.12, 0.10, 0.94),
		}
	if _time_records_view == TIME_RECORDS_VIEW_MODE_CHOICE:
		return {
			"accent": Color(0.26, 0.52, 0.96, 1.0),
			"card": Color(0.88, 0.93, 1.0, 0.98),
			"stage": Color(0.08, 0.12, 0.22, 0.94),
		}
	return {
		"accent": Color(0.20, 0.38, 0.86, 1.0),
		"card": Color(0.92, 0.96, 1.0, 0.98),
		"stage": Color(0.08, 0.12, 0.22, 0.94),
	}

func get_time_records_character_text() -> String:
	var rows := get_time_records_character_rows()
	if rows.is_empty():
		return "SONIC"
	return rows[clampi(_time_records_character_index, 0, rows.size() - 1)]

func get_time_records_course_heading_text() -> String:
	if _time_records_view == TIME_RECORDS_VIEW_MODE_CHOICE:
		return _language_text("MODE SELECT", "MODUS WAEHLEN", "CHOIX DU MODE", "ELEGIR MODO", "SCELTA MODALITA")
	var zone_number := _time_records_course_index + 1
	if _time_records_boss_mode:
		return "%s %d   %s" % [_language_text("ZONE", "ZONE", "ZONE", "ZONA", "ZONA"), zone_number, _language_text("BOSS", "BOSS", "BOSS", "JEFE", "BOSS")]
	return "%s %d   %s %d" % [_language_text("ZONE", "ZONE", "ZONE", "ZONA", "ZONA"), zone_number, _language_text("ACT", "AKT", "ACTE", "ACTO", "ATTO"), _time_records_act_index + 1]

func get_time_records_course_subtitle_text() -> String:
	if _time_records_view == TIME_RECORDS_VIEW_MODE_CHOICE:
		return _language_text("CHOOSE ZONE OR BOSS RECORDS", "ZONEN- ODER BOSS-REKORDE WAEHLEN", "CHOISIR RECORDS ZONE OU BOSS", "ELEGIR RECORDS DE ZONA O JEFE", "SCEGLI RECORD ZONA O BOSS")
	var course_name := get_level_name_by_index(_get_time_records_level_index())
	if _time_records_boss_mode:
		return "%s %s" % [course_name, _language_text("BOSS ROUTE", "BOSS-ROUTE", "PARCOURS BOSS", "RUTA DE JEFE", "PERCORSO BOSS")]
	return course_name

func get_time_records_best_label_text(index: int) -> String:
	return "%s %d" % [_language_text("BEST", "BESTE", "MEILLEUR", "MEJOR", "MIGLIORE"), index + 1]

func get_multiplayer_records_summary_text() -> String:
	var totals := get_multiplayer_records_player_totals()
	var columns := get_multiplayer_records_column_header_text()
	return "%s: %s\n%s\n%s %02d  %s %02d  %s %02d" % [_language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"), get_profile_name_text(), _language_text("VERSUS TOTALS", "VERSUS-SUMME", "TOTAUX VS", "TOTALES VS", "TOTALI VS"), columns[0], totals["wins"], columns[1], totals["losses"], columns[2], totals["draws"]]

func get_multiplayer_records_column_header_text() -> Array:
	return [
		_language_text("W", "S", "V", "G", "V"),
		_language_text("L", "N", "D", "P", "S"),
		_language_text("D", "U", "N", "E", "P"),
	]

func get_multiplayer_records_title_text() -> String:
	return _language_text("VS RECORDS", "VS-REKORDE", "RECORDS VS", "RECORDS VS", "RECORD VS")

func get_multiplayer_records_prompt_text() -> String:
	return _language_text("UP/DOWN SCROLL TABLE, X BACK", "HOCH/RUNTER TABELLE, X ZURUECK", "HAUT/BAS DEFILER, X RETOUR", "ARRIBA/ABAJO TABLA, X ATRAS", "SU/GIU SCORRI TABELLA, X INDIETRO")

func get_multiplayer_records_detail_text() -> String:
	return "%s   %s = %s" % [_language_text("UP/DOWN = SCROLL TABLE", "HOCH/RUNTER = TABELLE", "HAUT/BAS = DEFILER", "ARRIBA/ABAJO = TABLA", "SU/GIU = SCORRI TABELLA"), get_secondary_label(), _language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO")]

func get_multiplayer_records_chrome_colors() -> Dictionary:
	return {
		"accent": Color(0.92, 0.48, 0.20, 1.0),
		"card": Color(0.98, 0.90, 0.84, 0.98),
	}

func get_multiplayer_records_player_totals() -> Dictionary:
	return _multiplayer_record_totals.duplicate(true)

func get_multiplayer_records_player_row() -> Dictionary:
	var totals := get_multiplayer_records_player_totals()
	return {
		"name": get_profile_name_text(),
		"wins": totals["wins"],
		"losses": totals["losses"],
		"draws": totals["draws"],
	}

func get_multiplayer_records_scroll_max() -> int:
	return max(0, _multi_record_rows.size() - 4)

func get_multiplayer_records_visible_rows() -> Array:
	var rows: Array = []
	var start: int = clampi(_multi_records_menu_index, 0, get_multiplayer_records_scroll_max())
	var end: int = mini(start + 4, _multi_record_rows.size())
	for i in range(start, end):
		var row: Dictionary = _multi_record_rows[i] as Dictionary
		rows.append({
			"name": str(row.get("name", "")),
			"wins": int(row.get("wins", 0)),
			"losses": int(row.get("losses", 0)),
			"draws": int(row.get("draws", 0)),
		})
	return rows

func can_multiplayer_records_scroll_up() -> bool:
	return _multi_records_menu_index > 0

func can_multiplayer_records_scroll_down() -> bool:
	return _multi_records_menu_index < get_multiplayer_records_scroll_max()

func get_multiplayer_records_scroll_hint_text() -> String:
	if get_multiplayer_records_visible_rows().is_empty():
		return _language_text("NO DATA", "KEINE DATEN", "AUCUNE DONNEE", "SIN DATOS", "NESSUN DATO")
	if can_multiplayer_records_scroll_up() and can_multiplayer_records_scroll_down():
		return _language_text("UP/DOWN", "HOCH/RUNTER", "HAUT/BAS", "ARRIBA/ABAJO", "SU/GIU")
	if can_multiplayer_records_scroll_up():
		return _language_text("UP", "HOCH", "HAUT", "ARRIBA", "SU")
	if can_multiplayer_records_scroll_down():
		return _language_text("DOWN", "RUNTER", "BAS", "ABAJO", "GIU")
	return ""

func get_name_entry_summary_text() -> String:
	if _is_name_entry_control_cursor():
		return "%s\n%s\n\n%s\n%s" % [_language_text("CONTROL", "STEUERUNG", "CONTROLE", "CONTROL", "CONTROLLO"), get_name_entry_control_label(), _language_text("NAME", "NAME", "NOM", "NOMBRE", "NOME"), get_profile_name_text()]
	return "%s %d %s\n%s\n\n%s\n%s" % [
		_language_text("LETTER", "BUCHSTABE", "LETTRE", "LETRA", "LETTERA"),
		_name_entry_menu_index + 1,
		_language_text("ACTIVE", "AKTIV", "ACTIVE", "ACTIVA", "ATTIVA"),
		get_profile_name_text(),
		_language_text("CHARACTER", "CHARAKTER", "PERSONNAGE", "PERSONAJE", "PERSONAGGIO"),
		get_name_entry_selected_character(),
	]

func get_name_entry_detail_text() -> String:
	return "Q/E %s   %s %s   %s %s   DEL %s" % [_language_text("SLOT", "PLATZ", "EMPLACEMENT", "RANURA", "SLOT"), get_confirm_label(), _language_text("PICK", "WAEHLEN", "CHOISIR", "ELEGIR", "SCEGLI"), get_secondary_label(), _language_text("DELETE", "LOESCHEN", "EFFACER", "BORRAR", "CANCELLA"), _language_text("CANCEL", "ABBRECHEN", "ANNULER", "CANCELAR", "ANNULLA")]

func get_name_entry_title_text() -> String:
	return _language_text("NAME ENTRY", "NAMEN EINGEBEN", "SAISIE DU NOM", "NOMBRE", "INSERISCI NOME")

func get_name_entry_prompt_text() -> String:
	return "%s   %s %s   %s %s" % [_language_text("UP/DOWN/LEFT/RIGHT MOVE", "HOCH/RUNTER/LINKS/RECHTS BEWEGEN", "HAUT/BAS/GAUCHE/DROITE DEPLACER", "ARRIBA/ABAJO/IZQ/DER MOVER", "SU/GIU/SINISTRA/DESTRA MUOVI"), get_confirm_label(), _language_text("PICK", "WAEHLEN", "CHOISIR", "ELEGIR", "SCEGLI"), get_secondary_label(), _language_text("DELETE", "LOESCHEN", "EFFACER", "BORRAR", "CANCELLA")]

func get_name_entry_guide_text() -> String:
	return _language_text("CHARACTER BOARD   Q/E MOVE SLOT", "CHARAKTERTAFEL   Q/E SLOT WECHSELN", "TABLEAU PERSONNAGE   Q/E CHANGER SLOT", "TABLERO PERSONA   Q/E CAMBIAR SLOT", "TAVOLA PERSONAGGIO   Q/E CAMBIA SLOT")

func get_name_entry_preview_title_text() -> String:
	return _language_text("LIVE NAME PREVIEW", "NAMENSVORSCHAU", "APERCU DU NOM", "VISTA PREVIA DEL NOMBRE", "ANTEPRIMA NOME")

func is_returning_to_multiplayer_from_name_entry() -> bool:
	return _return_to_multiplayer_after_name_entry

func get_name_entry_chrome_colors() -> Dictionary:
	if _return_to_multiplayer_after_name_entry:
		return {
			"accent": Color(0.94, 0.56, 0.26, 1.0),
			"card": Color(0.98, 0.90, 0.84, 0.98),
		}
	return {
		"accent": Color(0.22, 0.78, 0.96, 1.0),
		"card": Color(0.86, 0.94, 1.0, 0.98),
	}

func get_name_entry_active_slot_index() -> int:
	return clampi(_name_entry_menu_index, 0, max(_player_profile_name.size() - 1, 0))

func get_name_entry_cursor_row() -> int:
	return _name_entry_cursor_row

func get_name_entry_cursor_col() -> int:
	return _name_entry_cursor_col

func is_name_entry_control_cursor() -> bool:
	return _is_name_entry_control_cursor()

func get_name_entry_control_label() -> String:
	match _name_entry_cursor_row:
		NAME_ENTRY_CONTROL_ROW_BACK:
			return _language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO")
		NAME_ENTRY_CONTROL_ROW_FORWARD:
			return _language_text("FORWARD", "VOR", "AVANCER", "AVANZAR", "AVANTI")
		NAME_ENTRY_CONTROL_ROW_END:
			return _language_text("END", "ENDE", "FIN", "FIN", "FINE")
	return _language_text("BOARD", "TAFEL", "TABLEAU", "TABLERO", "TAVOLA")

func get_name_entry_control_rows() -> Array:
	return [
		_language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO"),
		_language_text("FORWARD", "VOR", "AVANCER", "AVANZAR", "AVANTI"),
		_language_text("END", "ENDE", "FIN", "FIN", "FINE"),
	]

func get_name_entry_matrix_rows() -> Array:
	var rows: Array = []
	var max_page_index := (NAME_ENTRY_MATRIX_ROWS - NAME_ENTRY_MATRIX_VISIBLE_ROWS) * NAME_ENTRY_MATRIX_COLS
	_name_entry_matrix_page_index = clampi(_name_entry_matrix_page_index, 0, max_page_index)
	for row in range(NAME_ENTRY_MATRIX_VISIBLE_ROWS):
		var row_chars: Array = []
		for col in range(NAME_ENTRY_MATRIX_COLS):
			var index := _name_entry_matrix_page_index + row * NAME_ENTRY_MATRIX_COLS + col
			if index < PROFILE_NAME_CHARS.size():
				row_chars.append(str(PROFILE_NAME_CHARS[index]))
			else:
				# Keep the full source matrix reachable even where the modern font
				# has no named glyph asset yet.
				row_chars.append("C%03d" % index)
		rows.append(row_chars)
	return rows

func get_name_entry_selected_character() -> String:
	if _is_name_entry_control_cursor():
		return get_name_entry_control_label()
	var rows := get_name_entry_matrix_rows()
	if _name_entry_cursor_row < 0 or _name_entry_cursor_row >= rows.size() or _name_entry_cursor_col >= NAME_ENTRY_CONTROLS_COL:
		return ""
	var row: Array = rows[_name_entry_cursor_row]
	if _name_entry_cursor_col < 0 or _name_entry_cursor_col >= row.size():
		return ""
	return str(row[_name_entry_cursor_col])

func get_language_summary_text() -> String:
	return "%s\n%s\n\n%s\n%d %s" % [_language_text("CURRENT LANGUAGE", "AKTUELLE SPRACHE", "LANGUE ACTUELLE", "IDIOMA ACTUAL", "LINGUA ATTUALE"), get_language_text(), _language_text("SUPPORTED", "VERFUEGBAR", "DISPONIBEL", "DISPONIBLES", "DISPONIBILI"), get_language_items().size(), _language_text("OPTIONS", "OPTIONEN", "OPTIONS", "OPCIONES", "OPZIONI")]

func get_language_title_text() -> String:
	return _language_text("LANGUAGE", "SPRACHE", "LANGUE", "IDIOMA", "LINGUA")

func get_language_prompt_text() -> String:
	return _language_text("SELECT A LANGUAGE", "SPRACHE AUSWAEHLEN", "CHOISIR UNE LANGUE", "SELECCIONA UN IDIOMA", "SCEGLI UNA LINGUA")

func get_language_detail_text() -> String:
	return "%s CHANGE   %s ACCEPT   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]

func get_language_chrome_colors() -> Dictionary:
	return {
		"accent": Color(0.24, 0.80, 0.96, 1.0),
		"card": Color(0.86, 0.94, 1.0, 0.98),
	}

func get_button_config_summary_text() -> String:
	return "%s\n\nA  %s\nB  %s\nR  %s" % [_language_text("ASSIGN EACH ACTION", "JEDE AKTION ZUWEISEN", "ASSIGNER CHAQUE ACTION", "ASIGNAR CADA ACCION", "ASSEGNA OGNI AZIONE"), _button_bindings[0], _button_bindings[1], _button_bindings[2]]

func get_button_config_title_text() -> String:
	return _language_text("BUTTON CONFIG", "TASTENBELEGUNG", "CONFIG BOUTONS", "CONFIG BOTONES", "CONFIG TASTI")

func get_button_config_prompt_text() -> String:
	return _language_text("LEFT/RIGHT SWITCH, ENTER ACCEPT, X BACK", "LINKS/RECHTS WECHSELN, ENTER ANNEHMEN, X ZURUECK", "GAUCHE/DROITE CHANGER, ENTREE ACCEPTER, X RETOUR", "IZQ/DER CAMBIAR, ENTER ACEPTAR, X ATRAS", "SINISTRA/DESTRA CAMBIA, INVIO ACCETTA, X INDIETRO")

func get_button_config_detail_text() -> String:
	return "%s %s   %s   %s = %s   %s = %s" % [
		_language_text("LAYOUT", "LAYOUT", "CONFIGURATION", "CONFIGURACION", "LAYOUT"),
		get_button_config_focus_label(),
		_language_text("LEFT/RIGHT = SWITCH", "LINKS/RECHTS = WECHSELN", "GAUCHE/DROITE = CHANGER", "IZQ/DER = CAMBIAR", "SINISTRA/DESTRA = CAMBIA"),
		get_confirm_label(),
		_language_text("ACCEPT", "ANNEHMEN", "ACCEPTER", "ACEPTAR", "ACCETTA"),
		get_secondary_label(),
		_language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO"),
	]

func get_button_config_chrome_colors() -> Dictionary:
	return {
		"accent": Color(0.92, 0.48, 0.20, 1.0),
		"card": Color(0.98, 0.90, 0.84, 0.98),
	}

func get_button_config_focus_label() -> String:
	return ["A", "B", "R"][_button_config_index] + ": " + str(_button_bindings[_button_config_index])

func get_button_config_badge_text() -> String:
	return _language_text("INPUT", "EINGABE", "ENTREE", "ENTRADA", "INPUT")

func translate_gameplay_input(raw_input: int) -> int:
	var translated := raw_input & ~(A_BUTTON | B_BUTTON | R_BUTTON)
	var physical_buttons := [A_BUTTON, B_BUTTON, R_BUTTON]
	var action_bits := {"JUMP": A_BUTTON, "ATTACK": B_BUTTON, "TRICK": R_BUTTON}
	for i in range(mini(physical_buttons.size(), _button_bindings.size())):
		if raw_input & int(physical_buttons[i]):
			var action_name := str(_button_bindings[i])
			translated |= int(action_bits.get(action_name, physical_buttons[i]))
	return translated

func _get_button_config_action_order() -> Array:
	return ["JUMP", "ATTACK", "TRICK"]

func _cycle_button_config_binding(direction: int) -> void:
	if direction == 0:
		return
	if _button_config_index >= 2:
		# The original R-stage has no D-pad branch.
		return
	var action_order := _get_button_config_action_order()
	var slot := _button_config_index
	var current_index := action_order.find(str(_button_bindings[slot]))
	if current_index < 0:
		current_index = 0
	for _step in range(action_order.size()):
		current_index = wrapi(current_index + (1 if direction > 0 else -1), 0, action_order.size())
		var candidate := str(action_order[current_index])
		if slot == 0 or candidate != str(_button_bindings[0]):
			_button_bindings[slot] = candidate
			return

func _advance_button_config_conflict(slot_index: int, blocked_actions: Array) -> void:
	if slot_index < 0 or slot_index >= _button_bindings.size():
		return
	var action_order := _get_button_config_action_order()
	var current_index := action_order.find(str(_button_bindings[slot_index]))
	if current_index < 0:
		current_index = slot_index
	for _step in range(action_order.size()):
		current_index = wrapi(current_index + 1, 0, action_order.size())
		var candidate := str(action_order[current_index])
		if not blocked_actions.has(candidate):
			_button_bindings[slot_index] = candidate
			return

func _finalize_button_config_a_stage() -> void:
	if _button_bindings[0] == _button_bindings[1]:
		_advance_button_config_conflict(1, [_button_bindings[0], _button_bindings[2]])
	if _button_bindings[0] == _button_bindings[2]:
		_advance_button_config_conflict(2, [_button_bindings[0], _button_bindings[1]])
	_button_config_index = 1

func _finalize_button_config_b_stage() -> void:
	if _button_bindings[0] == _button_bindings[2] or _button_bindings[1] == _button_bindings[2]:
		_advance_button_config_conflict(2, [_button_bindings[0], _button_bindings[1]])
	_button_config_index = 2

func _commit_button_config_bindings() -> void:
	_button_bindings_before_edit = _button_bindings.duplicate()
	_save_save_data()

func get_sound_test_available_tracks() -> Array:
	if not _has_completed_sound_test_bonus():
		return _sound_test_tracks.duplicate(true)
	var tracks_by_number: Dictionary = {}
	for track in _sound_test_tracks + _sound_test_bonus_tracks:
		tracks_by_number[int(track["number"])] = track
	var tracks: Array = []
	for number in _sound_test_completed_order:
		if tracks_by_number.has(number):
			tracks.append((tracks_by_number[number] as Dictionary).duplicate(true))
	return tracks

func _move_sound_test_vertical(direction: int) -> void:
	var track_count := get_sound_test_track_count()
	if track_count <= 0:
		return
	# The source stores a one-based song number and wraps an entire column to
	# the opposite edge instead of applying modulo arithmetic to the index.
	var track_number := _sound_test_track_index + 1
	if direction < 0:
		track_number += 10
		if track_number > track_count:
			track_number = 1
	else:
		track_number -= 10
		if track_number <= 0:
			track_number = track_count
	_sound_test_track_index = track_number - 1

func get_sound_test_track_count() -> int:
	return get_sound_test_available_tracks().size()

func get_sound_test_current_entry() -> Dictionary:
	var tracks := get_sound_test_available_tracks()
	if tracks.is_empty():
		return {"number": 1, "name": "NO DATA"}
	# The original menu displays the position in its unlocked order, not the
	# internal song-table ID carried by each track definition.
	var entry: Dictionary = tracks[clamp(_sound_test_track_index, 0, tracks.size() - 1)].duplicate(true)
	entry["song_number"] = int(entry.get("number", 1))
	entry["number"] = clampi(_sound_test_track_index + 1, 1, tracks.size())
	return entry

func get_sound_test_summary_text() -> String:
	var entry := get_sound_test_current_entry()
	var bonus_state := _language_text("ALL TRACKS", "ALLE TITEL", "TOUS LES MORCEAUX", "TODAS LAS PISTAS", "TUTTI I BRANI") if _has_completed_sound_test_bonus() else _language_text("STANDARD LIST", "STANDARDLISTE", "LISTE STANDARD", "LISTA ESTANDAR", "LISTA STANDARD")
	return "%s\n%02d\n\n%s\n%s\n\n%s\n%s" % [_language_text("TRACK NO.", "TITEL NR.", "NO. PISTE", "NO. PISTA", "N. BRANO"), int(entry["number"]), _language_text("MODE", "MODUS", "MODE", "MODO", "MODALITA"), get_sound_test_playback_label(), _language_text("LIST", "LISTE", "LISTE", "LISTA", "LISTA"), bonus_state]

func get_sound_test_title_text() -> String:
	return _language_text("SOUND TEST", "MUSIKTEST", "TEST SON", "PRUEBA DE SONIDO", "TEST AUDIO")

func get_sound_test_prompt_text() -> String:
	return _language_text("LEFT/RIGHT CHANGE 1, UP/DOWN CHANGE 10, ENTER PLAY, X STOP/BACK", "LINKS/RECHTS 1 AENDERN, HOCH/RUNTER 10, ENTER ABSPIELEN, X STOPP/ZURUECK", "GAUCHE/DROITE +/-1, HAUT/BAS +/-10, ENTREE JOUER, X STOP/RETOUR", "IZQ/DER +/-1, ARRIBA/ABAJO +/-10, ENTER REPRODUCIR, X PARAR/ATRAS", "SINISTRA/DESTRA +/-1, SU/GIU +/-10, INVIO RIPRODUCI, X STOP/INDIETRO")

func get_sound_test_detail_text() -> String:
	return "%s   %s   %s = %s   %s = %s" % [
		_language_text("LEFT/RIGHT = TRACK +/-1", "LINKS/RECHTS = TITEL +/-1", "GAUCHE/DROITE = PISTE +/-1", "IZQ/DER = PISTA +/-1", "SINISTRA/DESTRA = BRANO +/-1"),
		_language_text("UP/DOWN = TRACK +/-10", "HOCH/RUNTER = TITEL +/-10", "HAUT/BAS = PISTE +/-10", "ARRIBA/ABAJO = PISTA +/-10", "SU/GIU = BRANO +/-10"),
		get_confirm_label(),
		_language_text("PLAY", "ABSPIELEN", "JOUER", "REPRODUCIR", "RIPRODUCI"),
		get_secondary_label(),
		_language_text("STOP", "STOPP", "STOP", "PARAR", "STOP") if _sound_test_state == SOUND_TEST_STATE_PLAYING else _language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO"),
	]

func get_sound_test_chrome_colors() -> Dictionary:
	if _sound_test_state == SOUND_TEST_STATE_PLAYING:
		return {
			"accent": Color(0.24, 0.88, 0.98, 1.0),
			"glow": Color(0.30, 0.92, 1.0, 0.40),
		}
	return {
		"accent": Color(0.18, 0.78, 0.98, 1.0),
		"glow": Color(0.28, 0.88, 0.98, 0.34),
	}

func get_sound_test_status_text() -> String:
	var entry := get_sound_test_current_entry()
	if _sound_test_state == SOUND_TEST_STATE_PLAYING:
		return "%s %02d %s" % [_language_text("NOW PLAYING", "LAEUFT GERADE", "LECTURE", "REPRODUCIENDO", "IN RIPRODUZIONE"), int(entry["number"]), str(entry["name"])]
	return "%s %02d" % [_language_text("SELECT TRACK", "TITEL WAEHLEN", "CHOISIR LA PISTE", "ELEGIR PISTA", "SCEGLI BRANO"), int(entry["number"])]

func get_sound_test_playback_label() -> String:
	if _sound_test_state == SOUND_TEST_STATE_PLAYING:
		return _language_text("PLAYING", "LAEUFT", "LECTURE", "REPRODUCIENDO", "IN RIPRODUZIONE")
	return _language_text("STOPPED", "GESTOPPT", "ARRETE", "DETENIDO", "FERMO")

func is_sound_test_playing() -> bool:
	return _sound_test_state == SOUND_TEST_STATE_PLAYING

func _has_completed_sound_test_bonus() -> bool:
	return _unlocked_level_index >= _level_names.size() - 1

func get_options_active_items() -> Array:
	if _save_reset_pending:
		return [_language_text("CONFIRM RESET", "RESET BESTAETIGEN", "CONFIRMER RESET", "CONFIRMAR REINICIO", "CONFERMA RESET"), _language_text("CANCEL", "ABBRECHEN", "ANNULER", "CANCELAR", "ANNULLA")]
	match _options_mode:
		OPTIONS_MODE_MAIN:
			return get_options_display_items()
		OPTIONS_MODE_PLAYER_DATA:
			return get_player_data_menu_items()
		OPTIONS_MODE_LANGUAGE:
			return get_language_items()
		OPTIONS_MODE_BUTTON_CONFIG:
			return [_language_text("FACE BUTTONS", "GESICHTSTASTEN", "BOUTONS", "BOTONES", "PULSANTI")]
		OPTIONS_MODE_SOUND_TEST:
			return [_language_text("TRACK", "TITEL", "PISTE", "PISTA", "BRANO")]
		OPTIONS_MODE_DIFFICULTY:
			return [_language_text("NORMAL", "NORMAL", "NORMAL", "NORMAL", "NORMALE"), _language_text("EASY", "EINFACH", "FACILE", "FACIL", "FACILE")]
		OPTIONS_MODE_TIME_LIMIT:
			return [_language_text("ON", "AN", "OUI", "SI", "SI"), _language_text("OFF", "AUS", "NON", "NO", "NO")]
		OPTIONS_MODE_DELETE_CONFIRM, OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			return [_language_text("YES", "JA", "OUI", "SI", "SI"), _language_text("NO", "NEIN", "NON", "NO", "NO")]
		OPTIONS_MODE_TIME_RECORDS:
			if _time_records_view == TIME_RECORDS_VIEW_MODE_CHOICE:
				return [_language_text("ZONE", "ZONE", "ZONE", "ZONA", "ZONA"), _language_text("BOSS", "BOSS", "BOSS", "JEFE", "BOSS")]
			return [_language_text("COURSE VIEW", "KURSANSICHT", "VUE PARCOURS", "VISTA DE FASE", "VISTA CORSO")]
		OPTIONS_MODE_MULTI_RECORDS:
			return [_language_text("RECORDS", "REKORDE", "RECORDS", "RECORDS", "RECORD")]
		OPTIONS_MODE_NAME_ENTRY:
			return ["%s 1" % _language_text("LETTER", "BUCHSTABE", "LETTRE", "LETRA", "LETTERA"), "%s 2" % _language_text("LETTER", "BUCHSTABE", "LETTRE", "LETRA", "LETTERA"), "%s 3" % _language_text("LETTER", "BUCHSTABE", "LETTRE", "LETRA", "LETTERA"), "%s 4" % _language_text("LETTER", "BUCHSTABE", "LETTRE", "LETRA", "LETTERA"), _language_text("CONFIRM", "BESTAETIGEN", "VALIDER", "CONFIRMAR", "CONFERMA"), _language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO")]
	return []

func get_options_item_meta(index: int) -> String:
	if _save_reset_pending:
		return _language_text("YES", "JA", "OUI", "SI", "SI") if index == 0 else _language_text("NO", "NEIN", "NON", "NO", "NO")
	match _options_mode:
		OPTIONS_MODE_PLAYER_DATA:
			match index:
				0:
					return get_profile_name_text()
				1:
					return _language_text("BEST TIMES AND STATS", "BESTZEITEN UND STATISTIK", "MEILLEURS TEMPS ET STATS", "MEJORES TIEMPOS Y ESTADISTICAS", "MIGLIORI TEMPI E STATISTICHE")
				2:
					return _language_text("VERSUS RECORDS", "VERSUS-REKORDE", "RECORDS VS", "RECORDS VS", "RECORD VS")
				3:
					return _language_text("RETURN TO OPTIONS", "ZURUECK ZU OPTIONEN", "RETOUR AUX OPTIONS", "VOLVER A OPCIONES", "TORNA ALLE OPZIONI")
		OPTIONS_MODE_MAIN:
			match index:
				0:
					return _language_text("OPEN PLAYER-DATA SUBMENU", "SPIELERDATEN OEFFNEN", "OUVRIR DONNEES JOUEUR", "ABRIR DATOS", "APRI DATI GIOCATORE")
				1:
					return get_difficulty_text()
				2:
					return _language_text("ON", "AN", "OUI", "SI", "SI") if _time_limit_enabled else _language_text("OFF", "AUS", "NON", "NO", "NO")
				3:
					return get_language_text()
				4:
					return _language_text("EDIT ACTION BUTTONS", "AKTIONSTASTEN BEARBEITEN", "MODIFIER LES BOUTONS", "EDITAR BOTONES", "MODIFICA PULSANTI")
				5:
					return "%s %02d" % [_language_text("TRACK", "TITEL", "PISTE", "PISTA", "BRANO"), get_sound_test_track_number()]
				6:
					return _language_text("ERASE ALL PROGRESS", "ALLEN FORTSCHRITT LOESCHEN", "EFFACER TOUTE LA PROGRESSION", "BORRAR TODO EL PROGRESO", "CANCELLA TUTTI I PROGRESSI")
				7:
					return _language_text("RETURN TO TITLE", "ZURUECK ZUM TITEL", "RETOUR AU TITRE", "VOLVER AL TITULO", "TORNA AL TITOLO")
		OPTIONS_MODE_LANGUAGE:
			return _language_text("CURRENT", "AKTUELL", "ACTUEL", "ACTUAL", "ATTUALE") if index == _language_index else _language_text("AVAILABLE", "VERFUEGBAR", "DISPONIBLE", "DISPONIBLE", "DISPONIBILE")
		OPTIONS_MODE_BUTTON_CONFIG:
			return get_button_config_focus_label() if index == 0 else ""
		OPTIONS_MODE_SOUND_TEST:
			var entry := get_sound_test_current_entry()
			match index:
				0:
					return str(entry["name"])
				1:
					return "%s %02d" % [_language_text("PLAY TRACK", "TITEL ABSPIELEN", "JOUER LA PISTE", "REPRODUCIR PISTA", "RIPRODUCI BRANO"), int(entry["number"])]
				2:
					return get_sound_test_playback_label()
				3:
					return _language_text("RETURN TO OPTIONS", "ZURUECK ZU OPTIONEN", "RETOUR AUX OPTIONS", "VOLVER A OPCIONES", "TORNA ALLE OPZIONI")
		OPTIONS_MODE_DIFFICULTY:
			if index == 0:
				return _language_text("STANDARD RUN", "STANDARDLAUF", "COURSE STANDARD", "CARRERA ESTANDAR", "CORSA STANDARD")
			return _language_text("LOWER ENEMY PRESSURE", "WENIGER GEGNERDRUCK", "MOINS D'ENNEMIS", "MENOS ENEMIGOS", "MENO NEMICI")
		OPTIONS_MODE_TIME_LIMIT:
			if index == 0:
				return _language_text("CLASSIC COUNTDOWN", "KLASSISCHER COUNTDOWN", "COMPTE A REBOURS CLASSIQUE", "CUENTA ATRAS CLASICA", "CONTO ALLA ROVESCIA CLASSICO")
			return _language_text("FREE RUN MODE", "FREIER LAUF", "MODE LIBRE", "MODO LIBRE", "MODALITA LIBERA")
		OPTIONS_MODE_DELETE_CONFIRM, OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			if index == 0:
				return _language_text("ERASE SAVE DATA", "SPEICHERDATEN LOESCHEN", "EFFACER LES DONNEES", "BORRAR DATOS", "CANCELLA DATI")
			return _language_text("KEEP CURRENT DATA", "AKTUELLE DATEN BEHALTEN", "GARDER LES DONNEES", "CONSERVAR DATOS", "MANTIENI DATI")
		OPTIONS_MODE_TIME_RECORDS:
			if index < _time_record_rows.size():
				return _time_record_rows[index][1]
			return "RETURN TO PLAYER DATA"
		OPTIONS_MODE_MULTI_RECORDS:
			return _language_text("BROWSE WINS, LOSSES, AND DRAWS", "SIEGE, NIEDERLAGEN UND REMIS", "PARCOURIR VICTOIRES, DEFAITES ET NULS", "VER VICTORIAS, DERROTAS Y EMPATES", "VEDI VITTORIE, SCONFITTE E PAREGGI")
		OPTIONS_MODE_NAME_ENTRY:
			if index < _player_profile_name.size():
				return _player_profile_name[index]
			if index == _player_profile_name.size():
				return get_profile_name_text()
			return _language_text("CANCEL EDIT", "BEARBEITUNG ABBRECHEN", "ANNULER MODIFICATION", "CANCELAR EDICION", "ANNULLA MODIFICA")
	return ""

func get_options_item_status(index: int) -> String:
	if _save_reset_pending:
		return _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO")
	match _options_mode:
		OPTIONS_MODE_MAIN:
			return _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO")
		OPTIONS_MODE_PLAYER_DATA:
			return _language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO") if index == 0 else _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO")
		OPTIONS_MODE_LANGUAGE:
			return _language_text("SELECTED", "GEWAEHLT", "SELECTIONNE", "SELECCIONADO", "SELEZIONATO") if index == _language_index else _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO")
		OPTIONS_MODE_BUTTON_CONFIG:
			return _language_text("ACTIVE", "AKTIV", "ACTIF", "ACTIVO", "ATTIVO") if index == _button_config_index else _language_text("WAIT", "WARTEN", "ATTENTE", "ESPERA", "ATTESA")
		OPTIONS_MODE_SOUND_TEST:
			match index:
				0:
					return _language_text("SCROLL", "BLENDEN", "DEFILER", "DESPLAZAR", "SCORRI")
				1:
					return _language_text("PLAYING", "LAEUFT", "LECTURE", "REPRODUCIENDO", "IN RIPRODUZIONE") if _sound_test_state == SOUND_TEST_STATE_PLAYING else _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO")
				2:
					return _language_text("STOP", "STOPP", "STOP", "PARAR", "STOP") if _sound_test_state == SOUND_TEST_STATE_PLAYING else _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO")
			return _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO")
		OPTIONS_MODE_DIFFICULTY:
			return _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO")
		OPTIONS_MODE_TIME_LIMIT:
			return _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO")
		OPTIONS_MODE_DELETE_CONFIRM, OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			return _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO")
		OPTIONS_MODE_TIME_RECORDS:
			return _language_text("BEST", "BESTE", "MEILLEUR", "MEJOR", "MIGLIORE")
		OPTIONS_MODE_MULTI_RECORDS:
			return _language_text("BROWSE", "DURCHSUCHEN", "PARCOURIR", "EXPLORAR", "SFOGLIA")
		OPTIONS_MODE_NAME_ENTRY:
			if index < _player_profile_name.size():
				return _language_text("EDIT", "BEARBEITEN", "MODIFIER", "EDITAR", "MODIFICA")
			return _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO")
	return _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO")

func get_time_record_rows() -> Array:
	if _time_records_view == TIME_RECORDS_VIEW_MODE_CHOICE:
		return get_time_records_mode_choice_rows()
	var rows: Array = []
	var course_times := _build_time_record_course_times()
	var record_level_index := _get_time_records_level_index()
	for i in range(course_times.size()):
		rows.append({
			"name": "%s %d" % [_language_text("RANK", "RANG", "RANG", "RANGO", "POSIZIONE"), i + 1],
			"time": str(course_times[i]),
			"recorded": i == 0 and _has_time_attack_best_time(_get_time_attack_record_key(_time_records_character_index, record_level_index, 0, _time_records_boss_mode)),
			"selected": false,
		})
	return rows

func get_multiplayer_record_rows() -> Array:
	var rows: Array = []
	for i in range(_multi_record_rows.size()):
		var row: Dictionary = _multi_record_rows[i] as Dictionary
		rows.append({
			"name": str(row.get("name", "")),
			"wins": int(row.get("wins", 0)),
			"losses": int(row.get("losses", 0)),
			"draws": int(row.get("draws", 0)),
			"selected": i == _multi_records_menu_index,
		})
	return rows

func get_name_entry_rows() -> Array:
	var rows: Array = []
	var letter_label := _language_text("LETTER", "BUCHSTABE", "LETTRE", "LETRA", "LETTERA")
	var confirm_label := _language_text("CONFIRM", "BESTATIGEN", "VALIDER", "CONFIRMAR", "CONFERMA")
	var back_label := _language_text("BACK", "ZURUECK", "RETOUR", "ATRAS", "INDIETRO")
	for i in range(_player_profile_name.size()):
		rows.append({
			"label": "%s %d" % [letter_label, i + 1],
			"value": str(_player_profile_name[i]),
			"selected": i == _name_entry_menu_index,
		})
	rows.append({
		"label": confirm_label,
		"value": get_profile_name_text(),
		"selected": _name_entry_menu_index == _player_profile_name.size(),
	})
	rows.append({
		"label": back_label,
		"value": _language_text("CANCEL EDIT", "BEARBEITUNG ABBRECHEN", "ANNULER MODIFICATION", "CANCELAR EDICION", "ANNULLA MODIFICA"),
		"selected": _name_entry_menu_index == _player_profile_name.size() + 1,
	})
	return rows

func _is_name_entry_control_cursor() -> bool:
	return _name_entry_cursor_col == NAME_ENTRY_CONTROLS_COL

func _move_name_entry_cursor_vertical(direction: int) -> void:
	if _is_name_entry_control_cursor():
		_name_entry_cursor_row = wrapi(_name_entry_cursor_row + direction, NAME_ENTRY_CONTROL_ROW_BACK, NAME_ENTRY_CONTROL_ROW_END + 1)
		return
	if direction < 0:
		if _name_entry_cursor_row > 0:
			_name_entry_cursor_row -= 1
		elif _name_entry_matrix_page_index > 0:
			_name_entry_matrix_page_index -= NAME_ENTRY_MATRIX_COLS
		else:
			_name_entry_matrix_page_index = (NAME_ENTRY_MATRIX_ROWS - NAME_ENTRY_MATRIX_VISIBLE_ROWS) * NAME_ENTRY_MATRIX_COLS
			_name_entry_cursor_row = NAME_ENTRY_MATRIX_VISIBLE_ROWS - 1
	else:
		if _name_entry_cursor_row < NAME_ENTRY_MATRIX_VISIBLE_ROWS - 1:
			_name_entry_cursor_row += 1
		elif _name_entry_matrix_page_index < (NAME_ENTRY_MATRIX_ROWS - NAME_ENTRY_MATRIX_VISIBLE_ROWS) * NAME_ENTRY_MATRIX_COLS:
			_name_entry_matrix_page_index += NAME_ENTRY_MATRIX_COLS
		else:
			_name_entry_matrix_page_index = 0
			_name_entry_cursor_row = 0

func _move_name_entry_cursor_horizontal(direction: int) -> void:
	if _is_name_entry_control_cursor():
		_name_entry_cursor_col = NAME_ENTRY_MATRIX_COLS - 1 if direction < 0 else 0
		return
	if direction < 0 and _name_entry_cursor_col == 0 and _name_entry_cursor_row >= NAME_ENTRY_CONTROL_ROW_BACK:
		_name_entry_cursor_col = NAME_ENTRY_CONTROLS_COL
	elif direction > 0 and _name_entry_cursor_col == NAME_ENTRY_MATRIX_COLS - 1 and _name_entry_cursor_row >= NAME_ENTRY_CONTROL_ROW_BACK:
		_name_entry_cursor_col = NAME_ENTRY_CONTROLS_COL
	else:
		_name_entry_cursor_col = wrapi(_name_entry_cursor_col + direction, 0, NAME_ENTRY_MATRIX_COLS)

func _move_name_entry_active_slot(direction: int) -> void:
	_name_entry_menu_index = clampi(_name_entry_menu_index + direction, 0, max(_player_profile_name.size() - 1, 0))

func _apply_name_entry_selected_cell() -> void:
	var selected_char := get_name_entry_selected_character()
	if selected_char.is_empty():
		return
	_player_profile_name[_name_entry_menu_index] = selected_char
	if _name_entry_menu_index < _player_profile_name.size() - 1:
		_name_entry_menu_index += 1
	else:
		_name_entry_cursor_col = NAME_ENTRY_CONTROLS_COL
		_name_entry_cursor_row = NAME_ENTRY_CONTROL_ROW_END

func _delete_name_entry_character() -> void:
	if _name_entry_menu_index < 0 or _name_entry_menu_index >= _player_profile_name.size():
		return
	# The source backs up from the empty terminator slot before shifting the
	# remaining characters, so delete works immediately after typing a letter.
	var delete_index := _name_entry_menu_index
	if delete_index > 0 and str(_player_profile_name[delete_index]).strip_edges().is_empty():
		delete_index -= 1
	for i in range(delete_index, _player_profile_name.size() - 1):
		_player_profile_name[i] = _player_profile_name[i + 1]
	_player_profile_name[_player_profile_name.size() - 1] = " "
	_name_entry_menu_index = delete_index

func get_time_records_character_rows() -> Array:
	var rows: Array = []
	# The original ReadAvailableCharacters macro stops at the first locked
	# character, matching the game's ordered unlock progression.
	for i in range(_character_names.size()):
		if i > 0 and not is_character_unlocked(i):
			break
		rows.append(str(_character_names[i]))
	return rows

func get_time_records_mode_choice_rows() -> Array:
	return [
		{
			"name": "ZONE",
			"time": "CLEAR ACTS AS FAST AS POSSIBLE",
			"selected": not _time_records_boss_mode,
		},
		{
			"name": "BOSS",
			"time": "DEFEAT BOSSES AS FAST AS POSSIBLE",
			"selected": _time_records_boss_mode,
		},
	]

func get_time_records_course_count() -> int:
	if _time_records_context == TIME_RECORDS_CONTEXT_OPTIONS:
		return 7
	return 7

func get_time_records_available_course_count() -> int:
	# The original options screen browses every zone, including locked records.
	# Time Attack keeps the progression-limited course list.
	if _time_records_context == TIME_RECORDS_CONTEXT_OPTIONS and not _time_records_boss_mode:
		return get_time_records_course_count()
	var level_limit := _unlocked_level_index
	if _time_records_context in [TIME_RECORDS_CONTEXT_OPTIONS, TIME_RECORDS_CONTEXT_TIME_ATTACK] and not _character_unlocked_level_indices.is_empty():
		var character_index := clampi(_time_records_character_index, 0, _character_unlocked_level_indices.size() - 1)
		level_limit = int(_character_unlocked_level_indices[character_index])
	return mini(get_time_records_course_count(), maxi(1, (level_limit / 2) + 1))

func _get_time_records_max_act_for_course(_course_index: int) -> int:
	if _time_records_boss_mode:
		return 0
	if _time_records_context == TIME_RECORDS_CONTEXT_OPTIONS:
		return 1
	var level_limit := _unlocked_level_index
	if _time_records_context in [TIME_RECORDS_CONTEXT_OPTIONS, TIME_RECORDS_CONTEXT_TIME_ATTACK] and not _character_unlocked_level_indices.is_empty():
		var character_index := clampi(_time_records_character_index, 0, _character_unlocked_level_indices.size() - 1)
		level_limit = int(_character_unlocked_level_indices[character_index])
	return clampi(level_limit - (_course_index * 2), 0, 1)

func _get_time_records_level_index() -> int:
	return clampi((_time_records_course_index * 2) + _time_records_act_index, 0, _level_names.size() - 1)

func _advance_time_records_course(direction: int) -> void:
	var available_courses := get_time_records_available_course_count()
	if _time_records_boss_mode:
		_time_records_course_index = wrapi(_time_records_course_index + direction, 0, available_courses)
		_time_records_act_index = 0
		return
	if _time_records_context == TIME_RECORDS_CONTEXT_OPTIONS:
		# Task_TimeRecordsScreenCoursesViewMain toggles acts before changing
		# zones and wraps across all seven zones in the normal records menu.
		if direction < 0:
			if _time_records_act_index == 0:
				_time_records_act_index = 1
				_time_records_course_index = wrapi(_time_records_course_index - 1, 0, available_courses)
			else:
				_time_records_act_index = 0
		else:
			if _time_records_act_index > 0:
				_time_records_act_index = 0
				_time_records_course_index = wrapi(_time_records_course_index + 1, 0, available_courses)
			else:
				_time_records_act_index = 1
		return
	var next_act := _time_records_act_index + direction
	var current_max_act := _get_time_records_max_act_for_course(_time_records_course_index)
	if next_act < 0:
		_time_records_course_index = wrapi(_time_records_course_index - 1, 0, available_courses)
		_time_records_act_index = _get_time_records_max_act_for_course(_time_records_course_index)
	elif next_act > current_max_act:
		_time_records_course_index = wrapi(_time_records_course_index + 1, 0, available_courses)
		_time_records_act_index = 0
	else:
		_time_records_act_index = next_act

func get_time_records_course_title_text() -> String:
	var course_name := get_level_name_by_index(_get_time_records_level_index())
	if _time_records_boss_mode:
		return "%s BOSS" % course_name
	return "%s ACT %d" % [course_name, _time_records_act_index + 1]

func _build_time_record_course_times() -> Array:
	var rows: Array = []
	var level_index := _get_time_records_level_index()
	var record_key := _get_time_attack_record_key(_time_records_character_index, level_index, 0, _time_records_boss_mode)
	for saved_time in _get_time_attack_record_table(record_key):
		rows.append(get_formatted_time(float(saved_time)))
	# SA2 initializes empty time-record slots to MAX_COURSE_TIME, rendered as
	# the ten-minute sentinel rather than fabricated sample records.
	for _i in range(rows.size(), 3):
		rows.append("09'59\"99")
	return rows

func _get_time_attack_record_key(character_index: int, course_index: int, act_index: int, boss_mode: bool) -> String:
	return "%d:%d:%d:%d" % [character_index, course_index, act_index if not boss_mode else 0, 1 if boss_mode else 0]

func _get_current_time_attack_record_key() -> String:
	return _get_time_attack_record_key(_selected_character_index, _selected_level_index, 0, _time_attack_boss_mode)

func _get_time_attack_best_time(record_key: String) -> float:
	var records := _get_time_attack_record_table(record_key)
	if not records.is_empty():
		return float(records[0])
	if not _time_attack_best_times.has(record_key):
		return -1.0
	return float(_time_attack_best_times[record_key])

func _has_time_attack_best_time(record_key: String) -> bool:
	return _get_time_attack_best_time(record_key) >= 0.0

func _store_clear_time_attack_result() -> void:
	_clear_previous_best_time = -1.0
	_clear_new_best_time = false
	_clear_time_attack_record_rank = 0
	if not _run_from_time_attack:
		return
	var record_key := _get_current_time_attack_record_key()
	var records := _get_time_attack_record_table(record_key)
	if not records.is_empty():
		_clear_previous_best_time = float(records[0])
	var insert_at := records.size()
	for i in range(records.size()):
		if _clear_time_snapshot < float(records[i]):
			insert_at = i
			break
	if insert_at < 3:
		records.insert(insert_at, _clear_time_snapshot)
		if records.size() > 3:
			records.resize(3)
		_time_attack_record_tables[record_key] = records
		_clear_time_attack_record_rank = insert_at + 1
		_clear_new_best_time = insert_at == 0
		_time_attack_best_times[record_key] = float(records[0])
		_save_save_data()

func _get_time_attack_record_table(record_key: String) -> Array:
	if _time_attack_record_tables.has(record_key) and _time_attack_record_tables[record_key] is Array:
		return (_time_attack_record_tables[record_key] as Array).duplicate()
	if _time_attack_best_times.has(record_key):
		return [float(_time_attack_best_times[record_key])]
	return []

func get_language_rows() -> Array:
	var rows: Array = []
	var languages := get_language_items()
	for i in range(languages.size()):
		rows.append({
			"label": str(languages[i]),
			"status": _language_text("CURRENT", "AKTUELL", "ACTUEL", "ACTUAL", "ATTUALE") if i == _language_index else _language_text("AVAILABLE", "VERFUEGBAR", "DISPONIBLE", "DISPONIBLE", "DISPONIBILE"),
			"current": i == _language_index,
			"selected": i == _language_index,
		})
	return rows

func get_button_config_rows() -> Array:
	var rows: Array = []
	var labels := [
		_language_text("A BUTTON", "A-TASTE", "BOUTON A", "BOTON A", "PULSANTE A"),
		_language_text("B BUTTON", "B-TASTE", "BOUTON B", "BOTON B", "PULSANTE B"),
		_language_text("R SHOULDER", "R-SCHULTER", "GACHETTE R", "HOMBRO R", "SPALLA R"),
	]
	for i in range(3):
		rows.append({
			"label": labels[i],
			"value": str(_button_bindings[i]),
			"status": _language_text("ACTIVE", "AKTIV", "ACTIF", "ACTIVO", "ATTIVO") if _button_config_index == i else _language_text("WAIT", "WARTEN", "ATTENTE", "ESPERA", "ATTESA"),
			"active": _button_config_index == i,
			"selected": _button_config_index == i,
		})
	return rows

func get_player_data_rows() -> Array:
	var rows: Array = []
	var labels := get_player_data_menu_items()
	rows.append({
		"label": labels[0],
		"value": get_profile_name_text(),
		"status": _language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO"),
		"profile": true,
		"selected": _player_data_menu_index == 0,
	})
	rows.append({
		"label": labels[1],
		"value": _language_text("BEST TIMES AND STATS", "BESTZEITEN UND STATISTIK", "MEILLEURS TEMPS ET STATS", "MEJORES TIEMPOS Y ESTADISTICAS", "MIGLIORI TEMPI E STATISTICHE"),
		"status": _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"),
		"selected": _player_data_menu_index == 1,
	})
	rows.append({
		"label": labels[2],
		"value": _language_text("VERSUS HISTORY", "VERSUS-HISTORIE", "HISTORIQUE VS", "HISTORIAL VS", "CRONOLOGIA VS"),
		"status": _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"),
		"selected": _player_data_menu_index == 2,
	})
	rows.append({
		"label": labels[3],
		"value": _language_text("RETURN TO OPTIONS", "ZURUECK ZU OPTIONEN", "RETOUR AUX OPTIONS", "VOLVER A OPCIONES", "TORNA ALLE OPZIONI"),
		"status": _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"),
		"selected": _player_data_menu_index == 3,
	})
	return rows

func get_options_main_rows() -> Array:
	var rows: Array = []
	var labels := get_options_display_items()
	rows.append({
		"label": labels[0],
		"value": _language_text("PROFILE / RECORDS", "PROFIL / REKORDE", "PROFIL / RECORDS", "PERFIL / RECORDS", "PROFILO / RECORD"),
		"status": _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"),
		"visual": "profile",
	})
	rows.append({
		"label": labels[1],
		"value": get_difficulty_text(),
		"status": _language_text("OPEN", "OEFFNEN", "OUVRIR", "ABRIR", "APRI"),
		"action": "open",
	})
	rows.append({
		"label": labels[2],
		"value": _language_text("ON", "AN", "OUI", "SI", "SI") if _time_limit_enabled else _language_text("OFF", "AUS", "NON", "NO", "NO"),
		"status": _language_text("OPEN", "OEFFNEN", "OUVRIR", "ABRIR", "APRI"),
		"action": "open",
	})
	rows.append({
		"label": labels[3],
		"value": get_language_text(),
		"status": _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"),
	})
	rows.append({
		"label": labels[4],
		"value": _language_text("EDIT BINDINGS", "BELEGUNG AENDERN", "MODIFIER LES TOUCHES", "EDITAR ASIGNACIONES", "MODIFICA COMANDI"),
		"status": _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"),
	})
	if _sound_test_unlocked:
		rows.append({
			"label": labels[5],
			"value": "%s %02d" % [_language_text("TRACK", "TITEL", "PISTE", "PISTA", "BRANO"), get_sound_test_track_number()],
			"status": _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"),
		})
	rows.append({
		"label": labels[6 if _sound_test_unlocked else 5],
		"value": _language_text("ERASE PROGRESS", "FORTSCHRITT LOESCHEN", "EFFACER LA PROGRESSION", "BORRAR PROGRESO", "CANCELLA PROGRESSI"),
		"status": _language_text("ERASE", "LOESCHEN", "EFFACER", "BORRAR", "CANCELLA"),
		"action": "erase",
		"visual": "erase",
	})
	rows.append({
		"label": labels[7 if _sound_test_unlocked else 6],
		"value": _language_text("RETURN TO TITLE", "ZURUECK ZUM TITEL", "RETOUR AU TITRE", "VOLVER AL TITULO", "TORNA AL TITOLO"),
		"status": _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"),
	})
	return rows

func get_options_item_visual(index: int) -> String:
	if _options_mode != OPTIONS_MODE_MAIN:
		return ""
	var rows := get_options_main_rows()
	if index >= 0 and index < rows.size():
		return str(rows[index].get("visual", ""))
	return ""

func get_options_badge_text() -> String:
	return _language_text("OPTIONS", "OPTIONEN", "OPTIONS", "OPCIONES", "OPZIONI")

func get_switch_option_badge_text(screen_id: String) -> String:
	match screen_id:
		"difficulty":
			return _language_text("LEVEL", "STUFE", "NIVEAU", "NIVEL", "LIVELLO")
		"time_limit":
			return _language_text("CLOCK", "UHR", "HORLOGE", "RELOJ", "OROLOGIO")
		"delete_final":
			return _language_text("FINAL", "FINAL", "FINAL", "FINAL", "FINALE")
		"delete_confirm":
			return _language_text("WARN", "WARNUNG", "AVERTISSEMENT", "AVISO", "AVVISO")
	return _language_text("SET", "SETUP", "REGLAGE", "AJUSTE", "IMPOSTA")

func get_sound_test_rows() -> Array:
	var rows: Array = []
	var entry := get_sound_test_current_entry()
	rows.append({
		"label": _language_text("TRACK", "TITEL", "PISTE", "PISTA", "BRANO"),
		"value": "NO. %02d" % [int(entry["number"])],
		"status": "SCROLL",
		"selected": true,
	})
	return rows

func get_sound_test_track_number() -> int:
	return int(get_sound_test_current_entry()["number"])

func get_sound_test_track_number_text() -> String:
	return "%s %02d" % [_language_text("NO.", "NR.", "NO.", "N.", "N."), get_sound_test_track_number()]

func get_sound_test_track_name() -> String:
	return str(get_sound_test_current_entry()["name"])

func get_sound_test_tempo() -> float:
	var entry := get_sound_test_current_entry()
	# Source uses the selected unlocked-list entry to index sSoundsOrder, then
	# looks up that entry's internal song ID in sSoundTempos.
	var source_index := clampi(int(entry.get("song_number", 1)) - 1, 0, SOUND_TEST_TEMPOS.size() - 1)
	return SOUND_TEST_TEMPOS[source_index]

func get_difficulty_text() -> String:
	return _language_text("NORMAL", "NORMAL", "NORMAL", "NORMAL", "NORMALE") if _difficulty_index == 0 else _language_text("EASY", "EINFACH", "FACILE", "FACIL", "FACILE")

func get_language_text() -> String:
	var languages := get_language_items()
	return languages[clamp(_language_index, 0, languages.size() - 1)]

func get_language_items() -> Array:
	return ["JAPANESE", "ENGLISH", "GERMAN", "FRENCH", "SPANISH", "ITALIAN"]

func _language_text(english: String, german: String, french: String, spanish: String, italian: String) -> String:
	match _language_index:
		0:
			return _japanese_text(english)
		2:
			return german
		3:
			return french
		4:
			return spanish
		5:
			return italian
	return english

func _japanese_text(english: String) -> String:
	# The original menu ships Japanese as its sixth language, rather than
	# treating it as an English fallback. Keep unmigrated longer sentences
	# readable until their source text tables are ported individually.
	match english:
		"SINGLE PLAYER": return "ひとりであそぶ"
		"MULTI PLAYER": return "みんなであそぶ"
		"PLAY MODE": return "プレイモード"
		"GAME START": return "ゲームスタート"
		"TIME ATTACK": return "タイムアタック"
		"OPTIONS": return "オプション"
		"TINY CHAO GARDEN": return "ちびチャオガーデン"
		"PLAYER DATA": return "プレイヤーデータ"
		"DIFFICULTY": return "なんいど"
		"TIME LIMIT": return "じかんせいげん"
		"LANGUAGE": return "げんご"
		"BUTTON CONFIG": return "ボタンせってい"
		"SOUND TEST": return "サウンドテスト"
		"DELETE GAME DATA": return "ゲームデータをけす"
		"EXIT", "BACK": return "もどる"
		"NORMAL": return "ノーマル"
		"EASY": return "イージー"
		"ON": return "オン"
		"OFF": return "オフ"
		"NAME ENTRY": return "なまえをいれる"
		"TIME RECORDS": return "タイムレコード"
		"MULTI-PAK RECORDS": return "マルチパックレコード"
		"START": return "スタート"
		"SELECT": return "せんたく"
		"CONFIRM": return "けってい"
		"CANCEL": return "キャンセル"
		"CONTINUE": return "つづける"
		"QUIT": return "おわる"
		"RETURN TO TITLE": return "タイトルにもどる"
		"READY": return "じゅんびオーケー"
		"LOCKED": return "ロック"
		"SPECIAL": return "スペシャル"
	return english

func get_profile_name_text() -> String:
	var result := ""
	for character in _player_profile_name:
		result += str(character)
	return result

func has_profile_name() -> bool:
	return not get_profile_name_text().strip_edges().is_empty()

func get_save_detail_text() -> String:
	if _save_reset_pending:
		if _is_touch_device():
			return "TAP TO CONFIRM   BACK TO CANCEL"
		return "ENTER = CONFIRM   X = CANCEL"
	if _options_mode == OPTIONS_MODE_LANGUAGE:
		return "%s = CHANGE   %s = ACCEPT   %s = BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
	if _options_mode == OPTIONS_MODE_BUTTON_CONFIG:
		return "LEFT/RIGHT = SWITCH   %s = ACCEPT   %s = BACK" % [get_confirm_label(), get_secondary_label()]
	if _options_mode == OPTIONS_MODE_SOUND_TEST:
		return get_sound_test_detail_text()
	if _options_mode == OPTIONS_MODE_DIFFICULTY:
		return get_difficulty_detail_text()
	if _options_mode == OPTIONS_MODE_TIME_LIMIT:
		return get_time_limit_detail_text()
	if _options_mode == OPTIONS_MODE_DELETE_CONFIRM or _options_mode == OPTIONS_MODE_DELETE_CONFIRM_FINAL:
		return get_delete_confirm_detail_text()
	if _options_mode == OPTIONS_MODE_NAME_ENTRY:
		return "UP/DOWN/LEFT/RIGHT = MOVE   Q/E = SLOT   %s = PICK   %s = DELETE" % [get_confirm_label(), get_secondary_label()]
	if _is_touch_device():
		return "TAP TO SELECT   BACK TO EXIT"
	return "ENTER = SELECT   X = BACK"

func get_save_summary_text() -> String:
	return "UNLOCKED: %d/%d   BEST: %d | %d" % [_unlocked_level_index + 1, _level_names.size(), _best_scores[0], _best_scores[1]]

func update_save_menu_status() -> void:
	if _options_mode == OPTIONS_MODE_SOUND_TEST:
		_status_text = get_sound_test_status_text()
		return
	_status_text = get_options_screen_title()

func get_selected_level_description() -> String:
	var best_label := _language_text("BEST", "BESTE", "MEILLEUR", "MEJOR", "MIGLIORE")
	if _selected_level_index >= 0 and _selected_level_index < _best_scores.size():
		return "%s: %d" % [best_label, _best_scores[_selected_level_index]]
	return "%s: 0" % best_label

func get_level_name_by_index(level_index: int) -> String:
	if level_index < 0 or level_index >= _level_names.size():
		return ""
	return _level_names[level_index]

func get_level_best_score(level_index: int) -> int:
	if level_index < 0 or level_index >= _best_scores.size():
		return 0
	return _best_scores[level_index]

func get_level_status(level_index: int) -> String:
	if level_index < 0 or level_index >= _level_names.size():
		return ""
	if level_index < _level_cleared_flags.size() and _level_cleared_flags[level_index]:
		return _language_text("CLEARED", "GESCHAFFT", "TERMINE", "COMPLETADO", "COMPLETATO")
	if level_index <= _unlocked_level_index:
		return _language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO")
	return _language_text("LOCKED", "GESPERRT", "VERROUILLE", "BLOQUEADO", "BLOCCATO")

func get_level_menu_entry_text(level_index: int) -> String:
	if level_index < 0 or level_index >= _level_names.size():
		return ""

	var prefix := "> " if level_index == _selected_level_index else "  "
	var status := "LOCKED"
	if level_index <= _unlocked_level_index:
		status = "UNLOCKED"
	if level_index < _level_cleared_flags.size() and _level_cleared_flags[level_index]:
		status = "CLEARED"
	var best_score := 0
	if level_index < _best_scores.size():
		best_score = _best_scores[level_index]
	return "%s%s  [%s]  BEST %d" % [prefix, _level_names[level_index], status, best_score]

func get_intro_title_text() -> String:
	if is_final_intro_screen():
		return "TRUE AREA 53"
	if _run_from_multiplayer:
		return get_multiplayer_session_course_text()
	if _level_state.level_id >= 0 and _level_state.level_id < _level_names.size():
		return _level_names[_level_state.level_id]
	return "STAGE"

func get_intro_zone_label() -> String:
	if _run_from_multiplayer:
		return "VS COURSE"
	if _run_from_time_attack and _time_attack_boss_mode:
		return "BOSS ATTACK"
	var course_index := _level_state.level_id
	if course_index == _level_names.size() - 2:
		return "FINAL ZONE"
	if course_index == _level_names.size() - 1:
		return "TRUE AREA 53"
	if course_index >= 0 and course_index < _level_names.size() - 2:
		return "ZONE %d" % [int(course_index / 2) + 1]
	return "ZONE"

func get_intro_act_label() -> String:
	if _run_from_multiplayer:
		return "MATCH"
	if _run_from_time_attack and _time_attack_boss_mode:
		return "BOSS"
	var course_index := _level_state.level_id
	if course_index >= 0 and course_index < _level_names.size() - 2:
		return "ACT %d" % [(course_index % 2) + 1]
	return "ACT 1"

func get_intro_character_label() -> String:
	if _run_from_multiplayer:
		return get_multiplayer_intro_character_text()
	if _player_state.variant >= 0 and _player_state.variant < _character_names.size():
		return _character_names[_player_state.variant]
	return "SONIC"

func get_intro_stage_icon_text() -> String:
	if _run_from_multiplayer:
		return "VS"
	if _run_from_time_attack and _time_attack_boss_mode:
		return "BOSS"
	var title := get_intro_title_text().replace(" ", "")
	return title.left(2) if title.length() >= 2 else title

func get_intro_character_accent_color() -> Color:
	var palette := get_player_visual_palette()
	var variant := clampi(_player_state.variant, 0, palette.size() - 1)
	if _run_from_multiplayer:
		var multiplayer_palette := [
			Color(0.98, 0.56, 0.22, 1.0),
			Color(0.96, 0.34, 0.28, 1.0),
			Color(1.0, 0.82, 0.24, 1.0),
			Color(0.92, 0.44, 0.16, 1.0),
		]
		return multiplayer_palette[min(variant, multiplayer_palette.size() - 1)]
	return palette[variant]

func get_intro_stage_badges() -> Array:
	# SA2's intro wheel is grouped by zone, with separate final and boss icons;
	# acts do not occupy independent wheel slots.
	var stage_names: Array = [
		"LEAF FOREST", "HOT CRATER", "MUSIC PLANT", "ICE PARADISE",
		"SKY CANYON", "TECHNO BASE", "EGG UTOPIA", "FINAL ZONE",
		"TRUE AREA 53", "BOSS ATTACK",
	]
	var selected_badge := 9 if _run_from_time_attack and _time_attack_boss_mode else 0
	if not (_run_from_time_attack and _time_attack_boss_mode):
		if _level_state.level_id >= _level_names.size() - 2:
			selected_badge = 7 + (_level_state.level_id - (_level_names.size() - 2))
		else:
			selected_badge = clampi(int(_level_state.level_id / 2), 0, 6)
	var badges: Array = []
	for i in range(stage_names.size()):
		var level_name: String = str(stage_names[i])
		var compact_name := level_name.replace(" ", "")
		var unlocked := false
		if i < 7:
			unlocked = _unlocked_level_index >= i * 2
		elif i == 7:
			unlocked = _unlocked_level_index >= _level_names.size() - 2
		elif i == 8:
			unlocked = _unlocked_level_index >= _level_names.size() - 1
		else:
			unlocked = _boss_time_attack_unlocked
		if _run_from_multiplayer or _run_from_time_attack:
			unlocked = true if i < 9 else _boss_time_attack_unlocked
		badges.append({
			"text": compact_name.left(2) if compact_name.length() >= 2 else compact_name,
			"label": level_name,
			"selected": i == selected_badge,
			"unlocked": unlocked,
		})
	return badges

func get_intro_countdown_text() -> String:
	if is_final_intro_screen() or _is_boss_intro():
		return ""
	if _intro_timer <= INTRO_GO_TIME:
		return "GO!"
	if _intro_timer <= 1.0:
		return "1"
	if _intro_timer <= 2.0:
		return "2"
	if _intro_timer <= INTRO_COUNTDOWN_START:
		return "3"
	return ""

func get_intro_stage_frame() -> float:
	if not is_intro_screen():
		return 200.0
	var total_duration := STAGE_INTRO_DURATION if _is_boss_intro() else INTRO_TOTAL_TIME
	var elapsed := maxf(0.0, total_duration - _intro_timer)
	return clampf(elapsed * 60.0, 0.0, 200.0)

func get_intro_prompt_text() -> String:
	if is_final_intro_screen():
		return "VANILLA RESCUED"
	if _is_boss_intro():
		return "BOSS READY"
	if _run_from_multiplayer and _intro_timer > INTRO_COUNTDOWN_START:
		return "VERSUS START"
	if _intro_timer <= INTRO_GO_TIME:
		return "GO!"
	if _intro_timer <= INTRO_COUNTDOWN_START:
		return get_intro_countdown_text()
	return "READY!"

func is_intro_go_phase() -> bool:
	return not is_final_intro_screen() and not _is_boss_intro() and _intro_timer <= INTRO_GO_TIME

func get_menu_badge_text(kind: String) -> String:
	match kind:
		"START":
			return _language_text("START", "START", "DEPART", "INICIO", "AVVIO")
		"SETUP":
			return _language_text("SETUP", "EINSTELLUNG", "CONFIG", "AJUSTES", "IMPOSTA")
		"PROFILE":
			return _language_text("PROFILE", "PROFIL", "PROFIL", "PERFIL", "PROFILO")
		"AUDIO":
			return _language_text("AUDIO", "AUDIO", "AUDIO", "AUDIO", "AUDIO")
		"VERSUS":
			return _language_text("VERSUS", "VERSUS", "VERSUS", "VERSUS", "VERSUS")
		"TEXT":
			return _language_text("TEXT", "TEXT", "TEXTE", "TEXTO", "TESTO")
		"NAME":
			return _language_text("NAME", "NAME", "NOM", "NOMBRE", "NOME")
		"RECORD":
			return _language_text("RECORD", "REKORD", "RECORD", "RECORD", "RECORD")
		"TA":
			return _language_text("TA", "ZA", "TA", "TA", "TA")
		"ST":
			return _language_text("ST", "ST", "ST", "ST", "ST")
	return kind

func get_intro_detail_text() -> String:
	if is_final_intro_screen():
		return "TRUE AREA 53   START TO SKIP   SONIC AWAKENS"
	if _is_boss_intro():
		return "BOSS ENCOUNTER   START SEQUENCE LOCKED"
	if _run_from_multiplayer:
		if _intro_timer <= INTRO_GO_TIME:
			return "OUTRUN %d RIVALS" % max(1, get_multiplayer_link_count() - 1)
		if _intro_timer <= INTRO_COUNTDOWN_START:
			return "ROOM LOCKED FOR %s" % get_multiplayer_session_course_text()
		return "COURSE %s   %s TO BEGIN" % [get_multiplayer_session_course_text(), get_confirm_label()]
	if _intro_timer <= INTRO_GO_TIME:
		return "LET'S MOVE"
	if _intro_timer <= INTRO_COUNTDOWN_START:
		return "HOLD STEADY"
	if not can_skip_intro():
		return "START SEQUENCE LOCKED"
	return "%s TO BEGIN" % get_confirm_label()

func get_final_intro_source_tilemaps() -> Array:
	return ["cutscene_final_ending_fall_bg", "cutscene_final_ending_fall_clouds"]

func is_race_start_message_visible() -> bool:
	return _game_state == GAME_STATE_PLAYING and _race_start_message_timer > 0.0

func get_race_start_message_progress() -> float:
	return clampf(_race_start_message_timer, 0.0, 1.0)

func get_clear_title_text() -> String:
	if _run_from_time_attack:
		return _language_text("TIME ATTACK", "TIME ATTACK", "TIME ATTACK", "TIME ATTACK", "TIME ATTACK")
	if is_boss_course_result():
		return _language_text("BOSS DESTROYED", "BOSS BESIEGT", "BOSS DETRUIT", "JEFE DESTRUIDO", "BOSS DISTRUTTO")
	return _language_text("STAGE CLEAR", "STUFE GESCHAFFT", "STAGE TERMINE", "FASE COMPLETADA", "STAGE COMPLETATO")

func is_clear_time_attack_mode() -> bool:
	return _run_from_time_attack

func is_boss_course_result() -> bool:
	if _run_from_time_attack or _run_from_multiplayer:
		return false
	return _selected_level_index % 2 == 1

func get_clear_prompt_text() -> String:
	if _run_from_time_attack:
		if not is_clear_input_ready():
			return _language_text("RESULT DISPLAY", "ERGEBNISANZEIGE", "AFFICHAGE DU RESULTAT", "PRESENTACION DEL RESULTADO", "VISUALIZZAZIONE RISULTATO")
		return _language_text("%s  %s", "%s  %s", "%s  %s", "%s  %s", "%s  %s") % [get_clear_result_heading_text(), get_formatted_time(_clear_time_snapshot)]
	return _language_text("TIME: %s", "ZEIT: %s", "TEMPS: %s", "TIEMPO: %s", "TEMPO: %s") % get_formatted_time(_clear_time_snapshot)

func get_clear_detail_text() -> String:
	if _run_from_time_attack:
		if not is_clear_input_ready():
			return _language_text("TIME ATTACK RESULT   PLEASE WAIT", "TIME ATTACK ERGEBNIS   BITTE WARTEN", "RESULTAT TIME ATTACK   PATIENTEZ", "RESULTADO TIME ATTACK   ESPERA", "RISULTATO TIME ATTACK   ATTENDI")
		var record_text := _get_time_attack_record_text()
		return _language_text("TIME: %s   RANK: %s\n%s\n%s = LOBBY", "ZEIT: %s   RANG: %s\n%s\n%s = LOBBY", "TEMPS: %s   RANG: %s\n%s\n%s = SALLE", "TIEMPO: %s   RANGO: %s\n%s\n%s = SALA", "TEMPO: %s   RANGO: %s\n%s\n%s = STANZA") % [get_formatted_time(_clear_time_snapshot), _clear_rank_text, record_text, get_confirm_label()]
	if not is_clear_input_ready():
		return _language_text("BONUS COUNTING\n%s TO FINISH COUNT", "BONUS WIRD GEZAEHLT\n%s ZUM ABSCHLIESSEN", "COMPTE DES BONUS\n%s POUR TERMINER", "CONTANDO BONOS\n%s PARA TERMINAR", "CONTEGGIO BONUS\n%s PER TERMINARE") % get_confirm_label()
	if _selected_level_index < _level_names.size() - 1:
		return _language_text("SCORE: %d   RANK: %s\nNEXT COURSE: %s", "PUNKTZAHL: %d   RANG: %s\nNAECHSTER KURS: %s", "SCORE: %d   RANG: %s\nPROCHAIN PARCOURS: %s", "PUNTOS: %d   RANGO: %s\nSIGUIENTE FASE: %s", "PUNTEGGIO: %d   RANGO: %s\nPROSSIMA ZONA: %s") % [_clear_total_display_score, _clear_rank_text, _level_names[_selected_level_index + 1]]
	return _language_text("SCORE: %d   RANK: %s\nCOURSE COMPLETE", "PUNKTZAHL: %d   RANG: %s\nKURS KOMPLETT", "SCORE: %d   RANG: %s\nPARCOURS TERMINE", "PUNTOS: %d   RANGO: %s\nFASE COMPLETA", "PUNTEGGIO: %d   RANGO: %s\nZONA COMPLETATA") % [_clear_total_display_score, _clear_rank_text]

func get_clear_footer_text() -> String:
	if not is_clear_input_ready():
		if _run_from_time_attack:
			return _language_text("RESULT ANIMATION", "ERGEBNISANIMATION", "ANIMATION DU RESULTAT", "ANIMACION DEL RESULTADO", "ANIMAZIONE RISULTATO")
		return _language_text("%s = FAST COUNT", "%s = SCHNELL ZAEHLEN", "%s = COMPTE RAPIDE", "%s = CUENTA RAPIDA", "%s = CONTEGGIO RAPIDO") % get_confirm_label()
	if _run_from_time_attack:
		return _language_text("%s = LOBBY   AUTO RETURN IN 10 SEC", "%s = LOBBY   AUTOMATISCH ZURUECK IN 10 SEK", "%s = SALLE   RETOUR AUTO DANS 10 S", "%s = SALA   VUELTA AUTO EN 10 S", "%s = STANZA   RITORNO AUTO IN 10 S") % get_confirm_label()
	return _language_text("AUTO COURSE SELECT", "AUTOMATISCHE KURSAUSWAHL", "SELECTION AUTO DU PARCOURS", "SELECCION AUTOMATICA DE FASE", "SELEZIONE AUTOMATICA ZONA")

func get_clear_result_heading_text() -> String:
	if not _run_from_time_attack:
		return _language_text("RESULT", "ERGEBNIS", "RESULTAT", "RESULTADO", "RISULTATO")
	return _language_text("NEW RECORD", "NEUER REKORD", "NOUVEAU RECORD", "NUEVO RECORD", "NUOVO RECORD") if _clear_new_best_time else _language_text("RESULT", "ERGEBNIS", "RESULTAT", "RESULTADO", "RISULTATO")

func get_clear_result_badge_text() -> String:
	if _run_from_time_attack:
		return get_clear_time_attack_medal_text()
	return _clear_rank_text

func get_clear_time_attack_medal_text() -> String:
	match _clear_time_attack_record_rank:
		1:
			return _language_text("GOLD", "GOLD", "OR", "ORO", "ORO")
		2:
			return _language_text("SILVER", "SILBER", "ARGENT", "PLATA", "ARGENTO")
		3:
			return _language_text("BRONZE", "BRONZE", "BRONZE", "BRONCE", "BRONZO")
		_:
			return _language_text("TRY", "VERSUCH", "ESSAI", "INTENTO", "TENTATIVO")

func get_clear_time_attack_medal_rank() -> int:
	return _clear_time_attack_record_rank

func get_clear_counting_text() -> String:
	return _language_text("COUNTING", "ZAEHLEN", "COMPTE", "CONTANDO", "CONTEGGIO")

func get_clear_rank_text_value() -> String:
	return _clear_rank_text

func get_clear_chrome_colors() -> Dictionary:
	if _run_from_time_attack:
		return {
			"accent": Color(0.66, 0.84, 1.0, 0.98),
			"header": Color(0.10, 0.20, 0.34, 0.98),
			"score": Color(0.08, 0.16, 0.28, 0.98),
			"badge": Color(0.82, 0.88, 0.96, 0.98),
		}
	if is_boss_course_result():
		return {
			"accent": Color(1.0, 0.38, 0.22, 0.98),
			"header": Color(0.30, 0.08, 0.04, 0.98),
			"score": Color(0.20, 0.06, 0.03, 0.98),
			"badge": Color(0.86, 0.24, 0.12, 0.98),
		}
	return {
		"accent": Color(0.96, 0.76, 0.20, 0.98),
		"header": Color(0.28, 0.18, 0.06, 0.98),
		"score": Color(0.18, 0.12, 0.04, 0.98),
		"badge": Color(0.72, 0.50, 0.14, 0.98),
	}

func get_clear_time_bonus() -> int:
	if _clear_time_snapshot < 30.0:
		return 80000
	if _clear_time_snapshot < 50.0:
		return 50000
	if _clear_time_snapshot < 60.0:
		return 10000
	if _clear_time_snapshot < 90.0:
		return 5000
	if _clear_time_snapshot < 120.0:
		return 4000
	if _clear_time_snapshot < 180.0:
		return 3000
	if _clear_time_snapshot < 240.0:
		return 2000
	if _clear_time_snapshot < 300.0:
		return 1000
	if _clear_time_snapshot < 360.0:
		return 500
	return 0

func get_clear_ring_bonus() -> int:
	return _clear_ring_snapshot * 100

func get_clear_special_ring_bonus() -> int:
	if _clear_special_ring_snapshot == 7:
		return 10000
	return _clear_special_ring_snapshot * 1000

func get_clear_rows() -> Array:
	if _run_from_time_attack:
		return [
			{
				"label": _language_text("TIME", "ZEIT", "TEMPS", "TIEMPO", "TEMPO"),
				"value": get_formatted_time(_clear_time_snapshot),
			},
			{
				"label": _language_text("MEDAL", "MEDAILLE", "MEDAILLE", "MEDALLA", "MEDAGLIA"),
				"value": get_clear_time_attack_medal_text(),
			},
			{
				"label": _language_text("BEST", "BESTE", "MEILLEUR", "MEJOR", "MIGLIORE"),
				"value": get_clear_time_attack_best_text(),
			},
			{
				"label": _language_text("RECORD", "REKORD", "RECORD", "RECORD", "RECORD"),
				"value": get_clear_time_attack_record_status_text(),
			},
		]
	var rows: Array = [
		{
			"label": _language_text("TIME BONUS", "ZEITBONUS", "BONUS TEMPS", "BONUS DE TIEMPO", "BONUS TEMPO"),
			"value": str(_clear_time_bonus_remaining),
		},
		{
			"label": _language_text("RING BONUS", "RING-BONUS", "BONUS ANNEAUX", "BONUS DE ANILLOS", "BONUS ANELLI"),
			"value": str(_clear_ring_bonus_remaining),
		},
	]
	if _selected_level_index < _level_names.size() - 2:
		rows.append({
			"label": _language_text("SP RING BONUS", "SP-RING-BONUS", "BONUS ANNEAUX SP", "BONUS ANILLOS SP", "BONUS ANELLI SP"),
			"value": str(_clear_special_ring_bonus_remaining),
		})
	rows.append({
		"label": _language_text("TOTAL SCORE", "GESAMTPUNKTZAHL", "SCORE TOTAL", "PUNTOS TOTALES", "PUNTEGGIO TOTALE"),
			"value": str(_clear_total_display_score),
	})
	return rows

func get_clear_stage_label() -> String:
	if _run_from_time_attack and _time_attack_boss_mode:
		return _language_text("%s BOSS", "%s BOSS", "%s BOSS", "%s JEFE", "%s BOSS") % get_level_name_by_index(_selected_level_index)
	if _selected_level_index >= 0 and _selected_level_index < _level_names.size():
		return _level_names[_selected_level_index]
	return _language_text("STAGE", "STUFE", "STAGE", "FASE", "STAGE")

func _get_time_attack_record_text() -> String:
	if _clear_new_best_time:
		return _language_text("NEW RECORD", "NEUER REKORD", "NOUVEAU RECORD", "NUEVO RECORD", "NUOVO RECORD")
	if _clear_rank_text == "A":
		return _language_text("GREAT RUN", "TOLLER LAUF", "SUPER COURSE", "GRAN CARRERA", "GRANDE CORSA")
	if _clear_rank_text == "B":
		return _language_text("GOOD TIME", "GUTE ZEIT", "BON TEMPS", "BUEN TIEMPO", "BUON TEMPO")
	return _language_text("TRY AGAIN", "NOCH EINMAL", "REESSAYER", "INTENTAR DE NUEVO", "RIPROVA")

func get_clear_time_attack_record_status_text() -> String:
	if not _run_from_time_attack:
		return ""
	if _clear_new_best_time:
		return _language_text("RECORD UPDATED", "REKORD AKTUALISIERT", "RECORD MIS A JOUR", "RECORD ACTUALIZADO", "RECORD AGGIORNATO")
	if _clear_previous_best_time >= 0.0:
		return _language_text("BEST STANDS", "BESTE ZEIT BLEIBT", "MEILLEUR TEMPS CONSERVE", "MEJOR TIEMPO SE MANTIENE", "MIGLIOR TEMPO INVARIATO")
	return _language_text("FIRST CLEAR", "ERSTER ABSCHLUSS", "PREMIER PARCOURS", "PRIMERA VICTORIA", "PRIMO COMPLETAMENTO")

func get_clear_time_attack_best_text() -> String:
	if not _run_from_time_attack:
		return ""
	var best_time := _get_time_attack_best_time(_get_current_time_attack_record_key())
	if best_time >= 0.0:
		return get_formatted_time(best_time)
	return _language_text("NO DATA", "KEINE DATEN", "AUCUNE DONNEE", "SIN DATOS", "NESSUN DATO")

func get_game_over_title_text() -> String:
	return _language_text("TIME OVER", "ZEIT ABGELAUFEN", "TEMPS ECOULE", "TIEMPO AGOTADO", "TEMPO SCADUTO") if _game_over_time_over else _language_text("GAME OVER", "GAME OVER", "GAME OVER", "FIN DE LA PARTIDA", "GAME OVER")

func get_game_over_primary_word() -> String:
	return _language_text("TIME", "ZEIT", "TEMPS", "TIEMPO", "TEMPO") if _game_over_time_over else _language_text("GAME", "SPIEL", "JEU", "PARTIDA", "GIOCO")

func get_game_over_secondary_word() -> String:
	return _language_text("OVER", "VORBEI", "TERMINE", "FIN", "FINE")

func is_game_over_time_over() -> bool:
	return _game_over_time_over

func get_game_over_badge_text() -> String:
	return _language_text("TIME", "ZEIT", "TEMPS", "TIEMPO", "TEMPO") if _game_over_time_over else _language_text("OVER", "VORBEI", "TERMINE", "FIN", "FINE")

func get_game_over_prompt_text() -> String:
	if _game_over_time_over:
		if _run_from_time_attack:
			return _language_text("RETRY THE ATTACK", "ANGRIFF WIEDERHOLEN", "REESSAYER L'ATTAQUE", "REPETIR EL ATAQUE", "RIPROVA L'ATTACCO")
		return _language_text("TIME LIMIT REACHED", "ZEITLIMIT ERREICHT", "LIMITE DE TEMPS ATTEINTE", "LIMITE DE TIEMPO ALCANZADO", "LIMITE DI TEMPO RAGGIUNTO")
	return _language_text("ALL LIVES LOST", "ALLE LEBEN VERLOREN", "TOUTES LES VIES PERDUES", "TODAS LAS VIDAS PERDIDAS", "TUTTE LE VITE PERSE")

func get_game_over_detail_text() -> String:
	# The original Game Over task is an automatic cutscene; it does not expose
	# a confirm/cancel prompt while the destination timer is running.
	return ""

func get_game_over_status_text() -> String:
	if not is_game_over_input_ready():
		return ""
	if _run_from_time_attack and _game_over_time_over:
		return _language_text("TIME ATTACK STANDBY", "TIME ATTACK BEREIT", "TIME ATTACK EN ATTENTE", "TIME ATTACK EN ESPERA", "TIME ATTACK IN ATTESA")
	return _language_text("RESTARTING STAGE", "SPIELSTUFE WIRD NEUGESTARTET", "REDEMARRAGE DU STAGE", "REINICIANDO LA FASE", "RIAVVIO DELLO STAGE") if _game_over_time_over else _language_text("RETURNING TO TITLE", "ZURUECK ZUM TITEL", "RETOUR AU TITRE", "VOLVIENDO AL TITULO", "RITORNO AL TITOLO")

func get_game_over_progress() -> float:
	var total_time: float = TIME_OVER_DURATION_SECONDS if _game_over_time_over else GAME_OVER_DURATION_SECONDS
	if total_time <= 0.0:
		return 1.0
	return clampf(1.0 - (_game_over_timer / total_time), 0.0, 1.0)

func get_game_over_slide_offset() -> float:
	var progress := get_game_over_progress()
	if _game_over_time_over:
		if progress < 0.38:
			return lerpf(420.0, 0.0, progress / 0.38)
		if progress < 0.72:
			return 0.0
		return lerpf(0.0, -280.0, (progress - 0.72) / 0.28)
	if progress < 0.46:
		return lerpf(520.0, 0.0, progress / 0.46)
	return 0.0

func get_game_over_text_flash_alpha() -> float:
	if not is_game_over_input_ready():
		return 0.84 + sin(get_game_over_progress() * 28.0) * 0.16
	return 1.0

func is_game_over_input_ready() -> bool:
	return _game_state == GAME_STATE_GAME_OVER and _game_over_input_lock_timer <= 0.0

func is_game_over_screen() -> bool:
	return _game_state == GAME_STATE_GAME_OVER

func accept_game_over() -> void:
	# SA2 resolves Game Over from its animation timer, not player input.
	return

func cancel_game_over() -> void:
	# SA2 resolves Game Over from its animation timer, not player input.
	return

func is_chaos_emeralds_screen() -> bool:
	return _game_state == GAME_STATE_CHAOS_EMERALDS

func is_missing_emeralds_screen() -> bool:
	return _game_state == GAME_STATE_MISSING_EMERALDS

func is_to_be_continued_screen() -> bool:
	return _game_state == GAME_STATE_TO_BE_CONTINUED

func is_sega_logo_screen() -> bool:
	return _game_state == GAME_STATE_SEGA_LOGO

func is_sonic_team_logo_screen() -> bool:
	return _game_state == GAME_STATE_SONIC_TEAM

func is_credits_screen() -> bool:
	return _game_state == GAME_STATE_CREDITS

func is_copyright_screen() -> bool:
	return _game_state == GAME_STATE_COPYRIGHT

func is_credits_end_screen() -> bool:
	return _game_state == GAME_STATE_CREDITS_END

func is_character_unlock_screen() -> bool:
	return _game_state == GAME_STATE_CHARACTER_UNLOCK

func is_special_stage_screen() -> bool:
	return _game_state == GAME_STATE_SPECIAL_STAGE

func is_special_stage_results_screen() -> bool:
	return is_special_stage_screen() and _special_stage_phase == 2

func get_chaos_emeralds_title_text() -> String:
	return _language_text("GET THE CHAOS EMERALDS!", "HOL DIR DIE CHAOS-EMERALDE!", "OBTENEZ LES EMERAUDES CHAOS!", "CONSIGUE LAS ESMERALDAS DEL CAOS!", "OTTIENI I CHAOS EMERALD!")

func get_chaos_emeralds_prompt_text() -> String:
	return _language_text("ALL COURSES CLEARED", "ALLE KURSE GESCHAFFT", "TOUS LES PARCOURS TERMINES", "TODAS LAS FASES COMPLETADAS", "TUTTI I CORSI COMPLETATI")

func get_chaos_emeralds_detail_text() -> String:
	return _language_text("EGGMAN WON'T GET AWAY NEXT TIME\n%s CONTINUE   %s SKIP", "EGGMAN ENTKOMMT DAS NAECHSTE MAL NICHT\n%s WEITER   %s UEBERSPRINGEN", "EGGMAN NE S'ECHAPPERA PAS LA PROCHAINE FOIS\n%s CONTINUER   %s PASSER", "EGGMAN NO ESCAPARA LA PROXIMA VEZ\n%s CONTINUAR   %s OMITIR", "EGGMAN NON SCAPPERA LA PROSSIMA VOLTA\n%s CONTINUA   %s SALTA") % [get_confirm_label(), get_secondary_label()]

func get_chaos_emeralds_summary_text() -> String:
	return _language_text("EMERALDS\nALL FOUND\n\nPROFILE\n%s\n\nNEXT\nTITLE SCREEN", "EMERALDE\nALLE GEFUNDEN\n\nPROFIL\n%s\n\nNAECHSTER SCHRITT\nTITELBILDSCHIRM", "EMERAUDES\nTOUTES TROUVEES\n\nPROFIL\n%s\n\nSUIVANT\nECRAN TITRE", "ESMERALDAS\nTODAS ENCONTRADAS\n\nPERFIL\n%s\n\nSIGUIENTE\nPANTALLA DE TITULO", "EMERALD\nTUTTI TROVATI\n\nPROFILO\n%s\n\nPROSSIMO\nSCHERMATA TITOLO") % get_profile_name_text()

func get_missing_emeralds_title_text() -> String:
	return _language_text("COLLECT ALL CHAOS EMERALDS", "SAMMLE ALLE CHAOS-EMERALDE", "COLLECTEZ TOUTES LES EMERAUDES CHAOS", "RECOGE TODAS LAS ESMERALDAS DEL CAOS", "RACCOGLI TUTTI I CHAOS EMERALD")

func get_missing_emeralds_prompt_text() -> String:
	return _language_text("A NEW ADVENTURE AWAITS", "EIN NEUES ABENTEUER WARTET", "UNE NOUVELLE AVENTURE VOUS ATTEND", "UNA NUEVA AVENTURA TE ESPERA", "UNA NUOVA AVVENTURA TI ATTENDE")

func get_missing_emeralds_detail_text() -> String:
	return _language_text("%s CONTINUE   %s SKIP", "%s WEITER   %s UEBERSPRINGEN", "%s CONTINUER   %s PASSER", "%s CONTINUAR   %s OMITIR", "%s CONTINUA   %s SALTA") % [get_confirm_label(), get_secondary_label()]

func get_missing_emerald_found_label() -> String:
	return _language_text("OK", "OK", "OK", "OK", "OK")

func get_missing_emerald_unknown_label() -> String:
	return "?"

func get_missing_emeralds_count() -> int:
	return get_chaos_emerald_count()

func get_chaos_emeralds_rows() -> Array:
	return [
		{"label": _language_text("GREEN", "GRUEN", "VERT", "VERDE", "VERDE"), "active": true},
		{"label": _language_text("YELLOW", "GELB", "JAUNE", "AMARILLO", "GIALLO"), "active": true},
		{"label": _language_text("BLUE", "BLAU", "BLEU", "AZUL", "BLU"), "active": true},
		{"label": _language_text("RED", "ROT", "ROUGE", "ROJO", "ROSSO"), "active": true},
		{"label": _language_text("PURPLE", "VIOLETT", "VIOLET", "MORADO", "VIOLA"), "active": true},
		{"label": _language_text("CYAN", "CYAN", "CYAN", "CIAN", "CIANO"), "active": true},
		{"label": _language_text("WHITE", "WEISS", "BLANC", "BLANCO", "BIANCO"), "active": true},
	]

func get_to_be_continued_title_text() -> String:
	return _language_text("TO BE CONTINUED", "FORTSETZUNG FOLGT", "A SUIVRE", "CONTINUARA", "CONTINUA")

func get_to_be_continued_prompt_text() -> String:
	return _language_text("NEXT STORY CHAPTER AHEAD", "NAECHSTES STORY-KAPITEL FOLGT", "PROCHAIN CHAPITRE A VENIR", "SIGUIENTE CAPITULO DE HISTORIA", "PROSSIMO CAPITOLO DELLA STORIA")

func get_to_be_continued_detail_text() -> String:
	return _language_text("%s CONTINUE   %s SKIP", "%s WEITER   %s UEBERSPRINGEN", "%s CONTINUER   %s PASSER", "%s CONTINUAR   %s OMITIR", "%s CONTINUA   %s SALTA") % [get_confirm_label(), get_secondary_label()]

func get_sega_logo_title_text() -> String:
	return "SEGA"

func get_sega_logo_prompt_text() -> String:
	return _language_text("PRESENTED BY SEGA", "PRAESENTIERT VON SEGA", "PRESENTE PAR SEGA", "PRESENTADO POR SEGA", "PRESENTATO DA SEGA")

func get_sega_logo_detail_text() -> String:
	return _language_text("%s SKIP", "%s UEBERSPRINGEN", "%s PASSER", "%s OMITIR", "%s SALTA") % get_confirm_label()

func get_sega_logo_source_tilemap() -> String:
	return "intro_presented_by_sega"

func get_sonic_team_logo_title_text() -> String:
	return "SONIC TEAM"

func get_sonic_team_logo_prompt_text() -> String:
	return _language_text("CREATED BY SONIC TEAM", "ERSTELLT VON SONIC TEAM", "CREE PAR SONIC TEAM", "CREADO POR SONIC TEAM", "CREATO DA SONIC TEAM")

func get_sonic_team_logo_detail_text() -> String:
	return _language_text("%s SKIP   AUTO TITLE", "%s UEBERSPRINGEN   AUTO-TITEL", "%s PASSER   TITRE AUTO", "%s OMITIR   TITULO AUTO", "%s SALTA   TITOLO AUTO") % get_confirm_label()

func get_sonic_team_logo_source_tilemap() -> String:
	return "intro_created_by_sonic_team"

func get_credits_title_text() -> String:
	return "SONIC ADVANCE 2   %s" % get_ending_variant_label()

func get_credits_page_text() -> String:
	var page_text := _language_text("SOURCE TILEMAP %s", "QUELL-TILEMAP %s", "TILEMAP SOURCE %s", "TILEMAP FUENTE %s", "TILEMAP SORGENTE %s") % get_credits_source_tilemap()
	if _ending_variant == ENDING_VARIANT_EXTRA and _credits_page == 0:
		return _language_text("EXTRA ENDING", "EXTRA-ENDE", "FIN EXTRA", "FINAL EXTRA", "FINALE EXTRA") + "\n" + page_text
	if _ending_variant == ENDING_VARIANT_FINAL and _credits_page == 0:
		return _language_text("FINAL ENDING", "FINALES ENDE", "FINALE", "FINAL", "FINALE") + "\n" + page_text
	return page_text

func get_credits_source_tilemap() -> String:
	return CREDITS_SOURCE_TILES[clampi(_credits_page, 0, CREDITS_SOURCE_TILES.size() - 1)]

func get_credits_source_group_text() -> String:
	return _language_text("SOURCE GROUP %d / %d", "QUELLGRUPPE %d / %d", "GROUPE SOURCE %d / %d", "GRUPO FUENTE %d / %d", "GRUPPO SORGENTE %d / %d") % [get_credits_slide_group() + 1, CREDITS_SLIDE_GROUPS.size()]

func get_credits_detail_text() -> String:
	return _language_text("AUTO ADVANCE   START SKIP", "AUTO-WEITER   START UEBERSPRINGEN", "AVANCE AUTO   START PASSER", "AVANCE AUTO   START OMITIR", "AVANZAMENTO AUTO   START SALTA")

func get_credits_page_index_text() -> String:
	return _language_text("PAGE %02d / %02d", "SEITE %02d / %02d", "PAGE %02d / %02d", "PAGINA %02d / %02d", "PAGINA %02d / %02d") % [_credits_page + 1, _credits_page_count]

func get_credits_page_index() -> int:
	return _credits_page

func get_credits_page_count() -> int:
	return _credits_page_count

func get_credits_slide_group() -> int:
	var page_start := 0
	for group_index in range(CREDITS_SLIDE_GROUPS.size()):
		page_start += int(CREDITS_SLIDE_GROUPS[group_index])
		if _credits_page < page_start:
			return group_index
	return CREDITS_SLIDE_GROUPS.size() - 1

func can_skip_credits() -> bool:
	if _game_state != GAME_STATE_CREDITS:
		return false
	if _ending_variant == ENDING_VARIANT_FINAL:
		return bool(_completed_character_routes[CHARACTER_NAMES_AMY_INDEX()])
	return _ending_variant == ENDING_VARIANT_EXTRA and _extra_ending_credits_played

func skip_credits() -> void:
	if not can_skip_credits():
		return
	_open_credits_end()

func skip_copyright() -> void:
	# credits_end.c advances Copyright automatically; it has no input path.
	return

func advance_special_stage_screen() -> void:
	if _special_stage_phase == 1:
		# The source run advances only through its timer/gameplay state.
		return
	_advance_special_stage()

func toggle_special_stage_pause() -> void:
	if _game_state != GAME_STATE_SPECIAL_STAGE or _special_stage_phase != 1:
		return
	_special_stage_paused = not _special_stage_paused
	_special_stage_pause_cursor = 0
	_status_text = get_special_stage_title_text() if _special_stage_paused else get_special_stage_title_text()

func move_special_stage_pause_selection(direction: int) -> void:
	if not _special_stage_paused:
		return
	_special_stage_pause_cursor = clampi(_special_stage_pause_cursor + signi(direction), 0, 1)

func confirm_special_stage_pause_selection() -> void:
	if not _special_stage_paused:
		return
	if _special_stage_pause_cursor == 0:
		_special_stage_paused = false
		_status_text = get_special_stage_title_text()
	else:
		open_title_screen_and_skip_intro()

func get_special_stage_pause_text() -> String:
	var resume_prefix := "> " if _special_stage_pause_cursor == 0 else "  "
	var quit_prefix := "> " if _special_stage_pause_cursor == 1 else "  "
	return _language_text("PAUSED\n%sRESUME\n%sQUIT TO TITLE", "PAUSIERT\n%sFORTSETZEN\n%sZUM TITEL", "EN PAUSE\n%sREPRENDRE\n%sQUITTER VERS LE TITRE", "EN PAUSA\n%sCONTINUAR\n%sSALIR AL TITULO", "IN PAUSA\n%sRIPRENDI\n%sTORNA AL TITOLO") % [resume_prefix, quit_prefix]

func is_special_stage_paused() -> bool:
	return _special_stage_paused

func is_special_stage_running_screen() -> bool:
	return _game_state == GAME_STATE_SPECIAL_STAGE and _special_stage_phase == 1

func get_special_stage_title_text() -> String:
	if _special_stage_phase == 0:
		return _language_text("SPECIAL STAGE", "SPECIAL STAGE", "SPECIAL STAGE", "SPECIAL STAGE", "SPECIAL STAGE")
	if _special_stage_phase == 1:
		return _language_text("SPECIAL STAGE RUN", "SPECIAL-STAGE-LAUF", "COURSE SPECIAL", "RECORRIDO ESPECIAL", "CORSA SPECIALE")
	return _language_text("SPECIAL STAGE RESULTS", "SPECIAL-STAGE-ERGEBNIS", "RESULTAT SPECIAL", "RESULTADO ESPECIAL", "RISULTATO SPECIALE")

func get_special_stage_source_tilemap() -> String:
	return "special_stage_%d_bg" % (clampi(_special_stage_emerald_index, 0, 6) + 1)

func get_special_stage_prompt_text() -> String:
	if _special_stage_paused:
		return _language_text("SPECIAL STAGE PAUSED", "SPECIAL STAGE PAUSIERT", "SPECIAL STAGE EN PAUSE", "SPECIAL STAGE EN PAUSA", "SPECIAL STAGE IN PAUSA")
	if _special_stage_phase == 0:
		return _language_text("CHAOS EMERALD CHALLENGE READY", "CHAOS-EMERALD-HERAUSFORDERUNG BEREIT", "DEFI EMERAUDE CHAOS PRET", "DESAFIO DE ESMERALDA DEL CAOS LISTO", "SFIDA CHAOS EMERALD PRONTA")
	if _special_stage_phase == 1:
		return _language_text("COLLECT RINGS   LANE %d / 3", "RINGE SAMMELN   SPUR %d / 3", "COLLECTEZ LES ANNEAUX   VOIE %d / 3", "RECOGE ANILLOS   CARRIL %d / 3", "RACCOGLI ANELLI   CORSIA %d / 3") % (_special_stage_lane + 1)
	if _special_stage_target_reached:
		return _language_text("TARGET REACHED   EMERALD %02d", "ZIEL ERREICHT   EMERALD %02d", "CIBLE ATTEINTE   EMERAUDE %02d", "OBJETIVO ALCANZADO   ESMERALDA %02d", "OBIETTIVO RAGGIUNTO   SMERALDO %02d") % (_special_stage_emerald_index + 1)
	return _language_text("TARGET MISSED   TRY AGAIN", "ZIEL VERFEHLT   NOCH EINMAL", "CIBLE MANQUEE   REESSAYEZ", "OBJETIVO FALLIDO   INTENTA DE NUEVO", "OBIETTIVO MANCATO   RIPROVA")

func get_special_stage_detail_text() -> String:
	if _special_stage_paused:
		return _language_text("%s RESUME   %s RESUME", "%s FORTSETZEN   %s FORTSETZEN", "%s REPRENDRE   %s REPRENDRE", "%s CONTINUAR   %s CONTINUAR", "%s RIPRENDI   %s RIPRENDI") % [get_confirm_label(), get_secondary_label()]
	if _special_stage_phase == 0:
		return _language_text("7 SPECIAL RINGS FOUND\n%s ENTER   %s SKIP", "7 SPEZIALRINGE GEFUNDEN\n%s EINGABE   %s UEBERSPRINGEN", "7 ANNEAUX SPECIAUX TROUVES\n%s ENTRER   %s PASSER", "7 ANILLOS ESPECIALES ENCONTRADOS\n%s ENTRAR   %s OMITIR", "7 ANELLI SPECIALI TROVATI\n%s INVIO   %s SALTA") % [get_confirm_label(), get_secondary_label()]
	if _special_stage_phase == 1:
		return _language_text("TIME %03d   RINGS %03d / %03d   %02d%% COMPLETE\nLEFT/RIGHT CHANGE LANES", "ZEIT %03d   RINGE %03d / %03d   %02d%% FERTIG\nLINKS/RECHTS SPUR WECHSELN", "TEMPS %03d   ANNEAUX %03d / %03d   %02d%% TERMINE\nGAUCHE/DROITE CHANGER DE VOIE", "TIEMPO %03d   ANILLOS %03d / %03d   %02d%% COMPLETO\nIZQ/DER CAMBIAR CARRIL", "TEMPO %03d   ANELLI %03d / %03d   %02d%% COMPLETO\nSINISTRA/DESTRA CAMBIA CORSIA") % [ceili(_special_stage_timer), _special_stage_ring_count, _special_stage_run_target, int(_special_stage_progress * 100.0)]
	return _language_text("RINGS %03d   POINTS %05d\n%s CONTINUE   %s SKIP", "RINGE %03d   PUNKTE %05d\n%s WEITER   %s UEBERSPRINGEN", "ANNEAUX %03d   POINTS %05d\n%s CONTINUER   %s PASSER", "ANILLOS %03d   PUNTOS %05d\n%s CONTINUAR   %s OMITIR", "ANELLI %03d   PUNTI %05d\n%s CONTINUA   %s SALTA") % [_special_stage_ring_count, _special_stage_score, get_confirm_label(), get_secondary_label()]

func get_special_stage_run_display_text(motion_label: String, robo_progress: int) -> String:
	return _language_text("TIME %03d     RINGS %03d / %03d     CHAIN x%d     PROGRESS %02d%%     ROBO %02d%%     %s", "ZEIT %03d     RINGE %03d / %03d     KETTE x%d     FORTSCHRITT %02d%%     ROBO %02d%%     %s", "TEMPS %03d     ANNEAUX %03d / %03d     CHAINE x%d     PROGRES %02d%%     ROBO %02d%%     %s", "TIEMPO %03d     ANILLOS %03d / %03d     CADENA x%d     PROGRESO %02d%%     ROBO %02d%%     %s", "TEMPO %03d     ANELLI %03d / %03d     CATENA x%d     PROGRESSO %02d%%     ROBO %02d%%     %s") % [ceili(_special_stage_timer), _special_stage_ring_count, _special_stage_run_target, _special_stage_multiplier, int(_special_stage_progress * 100.0), robo_progress, motion_label]

func get_special_stage_result_display_text() -> String:
	return _language_text("RINGS %03d    SCORE %05d", "RINGE %03d    PUNKTE %05d", "ANNEAUX %03d    SCORE %05d", "ANILLOS %03d    PUNTOS %05d", "ANELLI %03d    PUNTEGGIO %05d") % [_special_stage_ring_count, _special_stage_score]

func get_special_stage_motion_text() -> String:
	if is_special_stage_jumping():
		return _language_text("JUMP", "SPRUNG", "SAUT", "SALTO", "SALTO")
	return _language_text("SPD %.1f", "GESCHW %.1f", "VIT %.1f", "VEL %.1f", "VEL %.1f") % get_special_stage_speed()

func get_special_stage_new_label() -> String:
	return _language_text("NEW", "NEU", "NOUVEAU", "NUEVO", "NUOVO")

func get_special_stage_emerald_index() -> int:
	return _special_stage_emerald_index

func is_special_stage_target_reached() -> bool:
	return _special_stage_target_reached

func get_special_stage_ring_count() -> int:
	return _special_stage_ring_count

func get_special_stage_timer() -> float:
	return _special_stage_timer

func get_special_stage_speed() -> float:
	return _special_stage_speed

func is_special_stage_jumping() -> bool:
	return _special_stage_jump_timer > 0.0

func get_special_stage_multiplier() -> int:
	return _special_stage_multiplier

func get_special_stage_guard_state() -> Dictionary:
	return {
		"progress": _special_stage_robo_progress,
		"lane": _special_stage_robo_lane,
		"speed": _special_stage_robo_speed,
		"cooldown": _special_stage_robo_cooldown,
		"near_player": absf(_special_stage_robo_progress - _special_stage_progress) <= 0.08,
	}

func get_special_stage_score() -> int:
	return _special_stage_score

func get_special_stage_lane() -> int:
	return _special_stage_lane

func get_special_stage_progress() -> float:
	return _special_stage_progress

func get_special_stage_ring_targets() -> Array:
	return _special_stage_ring_targets

func get_special_stage_run_target() -> int:
	return _special_stage_run_target

func get_copyright_title_text() -> String:
	return "SONIC ADVANCE 2"

func get_copyright_prompt_text() -> String:
	return "COPYRIGHT 2002 SEGA"

func get_copyright_detail_text() -> String:
	return _language_text("SONIC TEAM   ALL RIGHTS RESERVED\n%s CONTINUE   %s SKIP", "SONIC TEAM   ALLE RECHTE VORBEHALTEN\n%s WEITER   %s UEBERSPRINGEN", "SONIC TEAM   TOUS DROITS RESERVES\n%s CONTINUER   %s PASSER", "SONIC TEAM   TODOS LOS DERECHOS RESERVADOS\n%s CONTINUAR   %s OMITIR", "SONIC TEAM   TUTTI I DIRITTI RISERVATI\n%s CONTINUA   %s SALTA") % [get_confirm_label(), get_secondary_label()]

func get_credits_end_title_text() -> String:
	return "SONIC ADVANCE 2\n%s" % get_ending_variant_label()

func get_credits_end_source_tilemap() -> String:
	if _ending_variant == ENDING_VARIANT_EXTRA:
		return "storyframe_sonic_leaves_%d" % _credits_end_story_frame
	return "credits_sa2_logo_jp" if _language_index == 0 else "credits_sa2_logo_en"

func _advance_credits_end_story(delta: float) -> void:
	if _ending_variant != ENDING_VARIANT_EXTRA or _credits_end_story_frame >= 11:
		return
	if _credits_end_story_timer > 0.0:
		_credits_end_story_timer = maxf(0.0, _credits_end_story_timer - delta)
		return
	_credits_end_story_frame += 1
	if _credits_end_story_frame >= 1 and _credits_end_story_frame <= CREDITS_END_STORY_DELAYS.size():
		_credits_end_story_timer = float(CREDITS_END_STORY_DELAYS[_credits_end_story_frame - 1]) / 60.0

func get_credits_end_prompt_text() -> String:
	if _ending_variant == ENDING_VARIANT_EXTRA:
		return _language_text("TRUE AREA 53 COMPLETE", "TRUE AREA 53 KOMPLETT", "TRUE AREA 53 TERMINE", "TRUE AREA 53 COMPLETA", "TRUE AREA 53 COMPLETATA")
	if _ending_variant == ENDING_VARIANT_FINAL:
		return _language_text("FINAL ZONE COMPLETE", "FINALE ZONE KOMPLETT", "ZONE FINALE TERMINEE", "ZONA FINAL COMPLETA", "ZONA FINALE COMPLETATA")
	return _language_text("CONGRATULATIONS", "GLUECKWUNSCH", "FELICITATIONS", "FELICIDADES", "CONGRATULAZIONI") if get_chaos_emerald_count() >= 7 else _language_text("ADVENTURE COMPLETE", "ABENTEUER KOMPLETT", "AVENTURE TERMINEE", "AVENTURA COMPLETA", "AVVENTURA COMPLETATA")

func get_credits_end_detail_text() -> String:
	var emerald_text := _language_text("ALL CHAOS EMERALDS COLLECTED", "ALLE CHAOS-EMERALDE GESAMMELT", "TOUS LES EMERAUDES CHAOS COLLECTEES", "TODAS LAS ESMERALDAS DEL CAOS RECOGIDAS", "TUTTI I CHAOS EMERALD RACCOLTI") if get_chaos_emerald_count() >= 7 else _language_text("CHAOS EMERALDS: %d/7", "CHAOS-EMERALDE: %d/7", "EMERAUDES CHAOS: %d/7", "ESMERALDAS DEL CAOS: %d/7", "CHAOS EMERALD: %d/7") % get_chaos_emerald_count()
	return _language_text("%s\n%s\n%s CONTINUE   %s SKIP", "%s\n%s\n%s WEITER   %s UEBERSPRINGEN", "%s\n%s\n%s CONTINUER   %s PASSER", "%s\n%s\n%s CONTINUAR   %s OMITIR", "%s\n%s\n%s CONTINUA   %s SALTA") % [get_ending_variant_label(), emerald_text, get_confirm_label(), get_secondary_label()]

func get_character_unlock_title_text() -> String:
	return _language_text("NEW CHARACTER", "NEUER CHARAKTER", "NOUVEAU PERSONNAGE", "NUEVO PERSONAJE", "NUOVO PERSONAGGIO")

func get_character_unlock_prompt_text() -> String:
	if _character_unlock_pending < 0:
		return _language_text("CHARACTER UNLOCKED", "CHARAKTER FREIGESCHALTET", "PERSONNAGE DEVERROUILLE", "PERSONAJE DESBLOQUEADO", "PERSONAGGIO SBLOCCATO")
	return _language_text("%s UNLOCKED", "%s FREIGESCHALTET", "%s DEVERROUILLE", "%s DESBLOQUEADO", "%s SBLOCCATO") % _character_names[_character_unlock_pending]

func get_character_unlock_detail_text() -> String:
	if _character_unlock_pending < 0:
		return _language_text("%s CONTINUE   %s SKIP", "%s WEITER   %s UEBERSPRINGEN", "%s CONTINUER   %s PASSER", "%s CONTINUAR   %s OMITIR", "%s CONTINUA   %s SALTA") % [get_confirm_label(), get_secondary_label()]
	var description: String = str(_character_descriptions[_character_unlock_pending])
	return _language_text("%s\n%s CONTINUE   %s SKIP", "%s\n%s WEITER   %s UEBERSPRINGEN", "%s\n%s CONTINUER   %s PASSER", "%s\n%s CONTINUAR   %s OMITIR", "%s\n%s CONTINUA   %s SALTA") % [description, get_confirm_label(), get_secondary_label()]

func get_character_unlock_source_slide_tilemap() -> String:
	var source_name := _character_unlock_source_name()
	if source_name.is_empty():
		return ""
	return "storyframe_%s_unlock_%d" % [source_name, mini(_character_unlock_segment, 3)]

func get_character_unlock_source_dialogue_tilemap() -> String:
	var source_name := _character_unlock_source_name()
	if source_name.is_empty():
		return ""
	var language_names := ["jp", "en", "de", "fr", "es", "it"]
	var language_index := clampi(_language_index, 0, language_names.size() - 1)
	return "storyframe_%s_unlock_%d_dlg_%s" % [source_name, mini(_character_unlock_segment, 3), language_names[language_index]]

func _character_unlock_source_name() -> String:
	match _character_unlock_pending:
		1:
			return "cream"
		2:
			return "tails"
		3:
			return "knuckles"
	return ""

func skip_sonic_team_logo() -> void:
	if _game_state != GAME_STATE_SONIC_TEAM:
		return
	if not _boot_intro_pending:
		return
	_resolve_sonic_team_logo()

func can_skip_sonic_team_logo() -> bool:
	return _game_state == GAME_STATE_SONIC_TEAM and _boot_intro_pending

func is_clear_screen() -> bool:
	return _game_state == GAME_STATE_CLEAR

func is_clear_input_ready() -> bool:
	if _game_state != GAME_STATE_CLEAR:
		return false
	if _run_from_time_attack:
		return _clear_input_lock_timer <= 0.0 and _time_attack_exit_timer <= 0.0
	return _clear_counting_done and _clear_input_lock_timer <= 0.0

func is_time_attack_clear_screen() -> bool:
	return is_clear_screen() and _run_from_time_attack

func get_time_attack_results_progress() -> float:
	if not is_time_attack_clear_screen():
		return 0.0
	return clampf(1.0 - (_clear_input_lock_timer / 2.666), 0.0, 1.0)

func get_time_attack_results_title_text() -> String:
	return _language_text("TIME ATTACK RESULTS", "TIME ATTACK ERGEBNIS", "RESULTAT TIME ATTACK", "RESULTADOS TIME ATTACK", "RISULTATI TIME ATTACK")

func get_time_attack_results_time_text() -> String:
	return get_formatted_time(_clear_time_snapshot)

func get_time_attack_results_medal_text() -> String:
	return get_clear_time_attack_medal_text()

func get_time_attack_results_record_text() -> String:
	return get_clear_time_attack_record_status_text()

func get_time_attack_results_prompt_text() -> String:
	return get_clear_footer_text()

func is_title_screen() -> bool:
	return _game_state == GAME_STATE_TITLE

func is_paused() -> bool:
	return _game_state == GAME_STATE_PAUSED

func is_save_options() -> bool:
	return _game_state == GAME_STATE_SAVE_OPTIONS

func is_intro_screen() -> bool:
	return _game_state == GAME_STATE_INTRO

func is_final_intro_screen() -> bool:
	return _game_state == GAME_STATE_FINAL_INTRO

func is_gameplay_active() -> bool:
	return _game_state == GAME_STATE_PLAYING or _game_state == GAME_STATE_CLEAR or _game_state == GAME_STATE_INTRO

func is_level_complete() -> bool:
	return _level_complete

func get_formatted_time(seconds: float) -> String:
	if seconds >= 600.0:
		# Match MAX_COURSE_TIME rendering in time_attack_results.c.
		return "9'59\"99"
	var centiseconds := int(seconds * 100.0)
	var minutes := centiseconds / 6000
	var remainder := centiseconds % 6000
	var secs := remainder / 100
	var cs := remainder % 100
	return "%d'%02d\"%02d" % [minutes, secs, cs]

func get_total_ported_score() -> int:
	var total := 0
	for score in _best_scores:
		total += int(score)
	return total

func get_profile_score() -> int:
	return _profile_score

func restart_level() -> void:
	_init_restart()

func toggle_pause(held_input: int = 0) -> void:
	if _game_state == GAME_STATE_PLAYING:
		_game_state = GAME_STATE_PAUSED
		_pause_menu_index = 0
		_pause_a_hold_lock = bool(held_input & A_BUTTON)
		_pause_a_previous_held = bool(held_input & A_BUTTON)
		_status_text = _pause_text
	elif _game_state == GAME_STATE_PAUSED:
		resume_game()

func pause_game() -> void:
	if _game_state == GAME_STATE_PLAYING:
		_game_state = GAME_STATE_PAUSED
		_pause_menu_index = 0
		_pause_a_hold_lock = false
		_pause_a_previous_held = false
		_status_text = _pause_text

func resume_game() -> void:
	if _game_state == GAME_STATE_PAUSED:
		_game_state = GAME_STATE_PLAYING
		_pause_menu_index = 0
		_pause_a_hold_lock = false
		_pause_a_previous_held = false
		_status_text = "OUTRUN RIVALS" if _run_from_multiplayer else "REACH THE GOAL"

func move_pause_selection(direction: int) -> void:
	if _game_state != GAME_STATE_PAUSED:
		return
	if direction < 0:
		_pause_menu_index = 0
	elif direction > 0:
		_pause_menu_index = 1

func confirm_pause_selection() -> void:
	if _game_state != GAME_STATE_PAUSED:
		return
	if _pause_menu_index == 0:
		resume_game()
		return
	if _run_from_time_attack:
		open_time_attack_lobby(_time_attack_boss_mode)
	elif _run_from_multiplayer:
		open_multiplayer_lobby_screen(0)
	else:
		open_title_screen_and_skip_intro()
	_pause_menu_index = 0

func is_pause_a_hold_locked() -> bool:
	return _pause_a_hold_lock

func cancel_pause_selection() -> void:
	if _game_state != GAME_STATE_PAUSED:
		return
	# SA2 only treats B as a pause-menu close action outside the normal
	# single-player stage mode. In single-player, the menu stays open until
	# START or the selected Continue/Quit action is confirmed.
	if _run_from_time_attack or _run_from_multiplayer:
		resume_game()

func _init_restart() -> void:
	var level_id := _level_state.level_id
	var from_time_attack := _run_from_time_attack
	var from_multiplayer := _run_from_multiplayer
	# GameStageStart recreates the stage intro before gameplay resumes.
	init_level(level_id, from_time_attack, from_multiplayer)

func get_platforms() -> Array:
	return _level_state.platforms

func _update_progress_for_clear() -> void:
	# stage_results.c, time_attack_results.c, and the SA2 multiplayer finish
	# path all add the collected ring count to SaveGame.score at clear time.
	_profile_score = maxi(0, _profile_score + _player_state.rings)
	var is_final_or_extra_stage := _selected_level_index >= _level_names.size() - 2
	_special_stage_pending = _clear_from_goal and _clear_special_ring_snapshot >= 7 and not _run_from_time_attack and not _run_from_multiplayer and not is_final_or_extra_stage
	if not _run_from_time_attack and not _run_from_multiplayer and _selected_character_index == 0:
		var unlock_index := _get_story_character_unlock_for_level(_selected_level_index)
		if unlock_index >= 0 and not _character_unlocked[unlock_index]:
			_character_unlocked[unlock_index] = true
			_character_unlock_pending = unlock_index
	if _selected_level_index < _level_cleared_flags.size():
		_level_cleared_flags[_selected_level_index] = true
	if not _run_from_time_attack and not _run_from_multiplayer and _selected_level_index == _level_names.size() - 2:
		# The source only records Final Zone completion here. True Area is
		# granted later by credits_end.c after the route and emerald checks.
		_extra_zone_status = maxi(_extra_zone_status, 1)
	_try_register_completed_character_route()
	var can_unlock_true_area := _true_area_unlocked or _selected_level_index < _level_names.size() - 2
	if _selected_character_index != 0 and _selected_level_index >= _level_names.size() - 2:
		can_unlock_true_area = false
	if _selected_level_index >= _unlocked_level_index and _unlocked_level_index < _level_names.size() - 1 and can_unlock_true_area:
		_unlocked_level_index = _selected_level_index + 1
	var active_character := clampi(_selected_character_index, 0, _character_unlocked_level_indices.size() - 1)
	_character_unlocked_level_indices[active_character] = _unlocked_level_index
	_save_best_score(_selected_level_index, _clear_final_score_snapshot)
	_save_save_data()

func _get_story_character_unlock_for_level(level_index: int) -> int:
	# The source grants each runner after the zone boss. Normal Godot stages
	# flatten each zone to two acts, so the end of the second act is the
	# equivalent unlock boundary.
	return {
		1: 1,
		5: 2,
		9: 3,
	}.get(level_index, -1)

func _sync_active_character_level_progress() -> void:
	if _character_unlocked_level_indices.is_empty():
		return
	var active_character := clampi(_selected_character_index, 0, _character_unlocked_level_indices.size() - 1)
	_chaos_emerald_mask = _get_selected_chaos_emerald_mask()
	_unlocked_level_index = clampi(int(_character_unlocked_level_indices[active_character]), 0, _level_names.size() - 1)
	_selected_level_index = clampi(_selected_level_index, 0, _unlocked_level_index)

func _collect_chaos_emerald_for_clear() -> void:
	# This is called after the special-stage target is reached. Its ring total
	# is separate from the seven special rings collected in the course.
	var emerald_index := _get_selected_zone_index()
	_set_selected_chaos_emerald_mask(_get_selected_chaos_emerald_mask() | (1 << emerald_index))
	_try_register_completed_character_route()

func _get_selected_zone_index() -> int:
	# The modern course list stores two acts per zone; the original save and
	# special-stage code address the emeralds by zone, not by flattened course.
	return clampi(int(_selected_level_index / 2), 0, 6)

func _try_register_completed_character_route() -> void:
	if _run_from_time_attack or _run_from_multiplayer:
		return
	if _selected_level_index < _level_names.size() - 2 or get_chaos_emerald_count() < 7:
		return
	var character_index := clampi(_selected_character_index, 0, _completed_character_routes.size() - 1)
	if bool(_completed_character_routes[character_index]):
		return
	_completed_character_routes[character_index] = true
	if _selected_level_index >= _level_names.size() - 2 and character_index != CHARACTER_NAMES_AMY_INDEX():
		_credits_end_show_missing_emeralds = true
	_refresh_story_unlocks()
	_save_save_data()

func _refresh_story_unlocks() -> void:
	# credits_end.c unlocks extras after completed main-character routes, not
	# merely after reaching Final Zone. True Area also requires Sonic's seven
	# emeralds and all four main routes to be complete.
	var completed_count := 0
	for i in range(mini(4, _completed_character_routes.size())):
		if bool(_completed_character_routes[i]):
			completed_count += 1
	if completed_count >= 1:
		_tiny_chao_unlocked = true
	if completed_count >= 2:
		_sound_test_unlocked = true
	if completed_count >= 3:
		_boss_time_attack_unlocked = true
	if completed_count >= 4:
		_character_unlocked[4] = true
	var sonic_has_all_emeralds := not _chaos_emerald_masks.is_empty() and int(_chaos_emerald_masks[0]) == 127
	if completed_count >= 4 and sonic_has_all_emeralds:
		_true_area_unlocked = true
		_extra_zone_status = maxi(_extra_zone_status, 1)
		_unlocked_level_index = maxi(_unlocked_level_index, _level_names.size() - 1)

func get_chaos_emerald_count() -> int:
	var mask := _get_selected_chaos_emerald_mask()
	var count := 0
	for i in range(7):
		if (mask & (1 << i)) != 0:
			count += 1
	return count

func _get_selected_chaos_emerald_mask() -> int:
	if _chaos_emerald_masks.is_empty():
		_chaos_emerald_masks = [0, 0, 0, 0, 0]
	var character_index := clampi(_selected_character_index, 0, _chaos_emerald_masks.size() - 1)
	return clampi(int(_chaos_emerald_masks[character_index]), 0, 127)

func _set_selected_chaos_emerald_mask(mask: int) -> void:
	if _chaos_emerald_masks.is_empty():
		_chaos_emerald_masks = [0, 0, 0, 0, 0]
	var character_index := clampi(_selected_character_index, 0, _chaos_emerald_masks.size() - 1)
	var sanitized := clampi(mask, 0, 127)
	_chaos_emerald_masks[character_index] = sanitized
	_chaos_emerald_mask = sanitized

func _save_best_score(level_index: int, score: int) -> void:
	if level_index < 0 or level_index >= _best_scores.size():
		return
	if score > _best_scores[level_index]:
		_best_scores[level_index] = score

func _persist_frontend_state() -> void:
	_save_save_data()

func _get_default_multiplayer_record_rows() -> Array:
	return []

func _get_cleared_multiplayer_record_rows() -> Array:
	return []

func _get_default_multiplayer_record_totals() -> Dictionary:
	return {"wins": 0, "losses": 0, "draws": 0}

func _sanitize_profile_name(raw_name: Variant) -> Array:
	var default_name := ["S", "O", "N", "I", "C", " "]
	if raw_name is not Array:
		return default_name
	var source: Array = raw_name
	var sanitized: Array = []
	for i in range(6):
		if i < source.size():
			var character := str(source[i]).to_upper()
			if character.is_empty():
				sanitized.append(" ")
			else:
				sanitized.append(character.left(1))
		else:
			sanitized.append(" ")
	var joined := ""
	for character in sanitized:
		joined += str(character)
	if joined.strip_edges().is_empty():
		return default_name
	return sanitized

func _sanitize_button_bindings(raw_bindings: Variant) -> Array:
	var defaults := ["JUMP", "ATTACK", "TRICK"]
	if raw_bindings is not Array:
		return defaults
	var source: Array = raw_bindings
	var valid := ["JUMP", "ATTACK", "TRICK"]
	var sanitized: Array = []
	for value in source:
		var action := str(value).strip_edges().to_upper()
		if valid.has(action) and not sanitized.has(action):
			sanitized.append(action)
	for action in valid:
		if not sanitized.has(action):
			sanitized.append(action)
	return sanitized.slice(0, 3)

func _sanitize_multiplayer_record_rows(raw_rows: Variant) -> Array:
	if raw_rows is not Array:
		return _get_default_multiplayer_record_rows()
	var source: Array = raw_rows
	var sanitized: Array = []
	for entry in source:
		if entry is not Dictionary:
			continue
		var row: Dictionary = entry
		# save.c stores six-character names and leaves empty table slots unused.
		var name_text := str(row.get("name", "")).strip_edges().to_upper().substr(0, 6)
		if name_text.is_empty():
			continue
		var player_id := maxi(0, int(row.get("player_id", 0)))
		if player_id == 0:
			player_id = _multiplayer_record_identity(name_text)
		sanitized.append({
			"player_id": player_id,
			"name": name_text,
			"wins": clampi(int(row.get("wins", 0)), 0, 99),
			"losses": clampi(int(row.get("losses", 0)), 0, 99),
			"draws": clampi(int(row.get("draws", 0)), 0, 99),
		})
		if sanitized.size() >= 10:
			break
	if sanitized.is_empty():
		return _get_default_multiplayer_record_rows()
	return sanitized

func _multiplayer_record_identity(name: String) -> int:
	var normalized := name.strip_edges().to_upper().substr(0, 6)
	return posmod(normalized.hash(), 2147483646) + 1

func _sanitize_multiplayer_record_totals(raw_totals: Variant) -> Dictionary:
	if raw_totals is not Dictionary:
		return _get_default_multiplayer_record_totals()
	var totals: Dictionary = raw_totals
	return {
		"wins": clampi(int(totals.get("wins", 0)), 0, 99),
		"losses": clampi(int(totals.get("losses", 0)), 0, 99),
		"draws": clampi(int(totals.get("draws", 0)), 0, 99),
	}

func _insert_or_promote_multiplayer_record(name: String, player_id: int = 0) -> int:
	var normalized_name := name.strip_edges().to_upper().substr(0, 6)
	if normalized_name.is_empty():
		normalized_name = "PLAYER"
	var identity := maxi(0, player_id)
	if identity == 0:
		identity = _multiplayer_record_identity(normalized_name)
	for i in range(_multi_record_rows.size()):
		var row: Dictionary = _multi_record_rows[i] as Dictionary
		var row_id := maxi(0, int(row.get("player_id", 0)))
		var same_identity := row_id == identity or (row_id == 0 and str(row.get("name", "")).to_upper() == normalized_name)
		if same_identity and str(row.get("name", "")).to_upper() == normalized_name:
			if i > 0:
				var existing := row.duplicate(true)
				_multi_record_rows.remove_at(i)
				_multi_record_rows.insert(0, existing)
			return 0
	_multi_record_rows.insert(0, {
		"player_id": identity,
		"name": normalized_name,
		"wins": 0,
		"losses": 0,
		"draws": 0,
	})
	while _multi_record_rows.size() > 10:
		_multi_record_rows.pop_back()
	return 0

func _record_own_multiplayer_result(result_key: String) -> void:
	match result_key:
		"WIN":
			_multiplayer_record_totals["wins"] = mini(99, int(_multiplayer_record_totals.get("wins", 0)) + 1)
		"LOSS":
			_multiplayer_record_totals["losses"] = mini(99, int(_multiplayer_record_totals.get("losses", 0)) + 1)
		"DRAW":
			_multiplayer_record_totals["draws"] = mini(99, int(_multiplayer_record_totals.get("draws", 0)) + 1)

func _record_multiplayer_result(name: String, result_key: String, player_id: int = 0) -> void:
	if name.strip_edges().is_empty():
		return
	var row_index := _insert_or_promote_multiplayer_record(name, player_id)
	var row: Dictionary = (_multi_record_rows[row_index] as Dictionary).duplicate(true)
	match result_key:
		"WIN":
			row["wins"] = mini(99, int(row.get("wins", 0)) + 1)
		"LOSS":
			row["losses"] = mini(99, int(row.get("losses", 0)) + 1)
		"DRAW":
			row["draws"] = mini(99, int(row.get("draws", 0)) + 1)
	_multi_record_rows[row_index] = row

func _commit_multiplayer_course_results() -> void:
	if _multiplayer_course_results_committed:
		return
	_multiplayer_course_results_committed = true
	var host_rank := int(_multiplayer_player_ranks[0]) if not _multiplayer_player_ranks.is_empty() else -1
	if host_rank < 0:
		return
	var best_remote_rank := 999
	for i in range(1, _multiplayer_link_connected.size()):
		if not bool(_multiplayer_link_connected[i]):
			continue
		var remote_rank := int(_multiplayer_player_ranks[i]) if i < _multiplayer_player_ranks.size() else -1
		if remote_rank >= 0:
			best_remote_rank = mini(best_remote_rank, remote_rank)
		var result_key := "DRAW"
		if remote_rank > host_rank:
			result_key = "WIN"
		elif remote_rank < host_rank:
			result_key = "LOSS"
		_record_multiplayer_result(get_multiplayer_link_player_name(i), result_key)
	var own_result := "DRAW"
	if host_rank < best_remote_rank:
		own_result = "WIN"
	elif host_rank > best_remote_rank and best_remote_rank != 999:
		own_result = "LOSS"
	_record_own_multiplayer_result(own_result)
	_save_save_data()

func _sanitize_time_attack_best_times(raw_value: Variant) -> Dictionary:
	if raw_value is not Dictionary:
		return {}
	var source: Dictionary = raw_value
	var sanitized: Dictionary = {}
	for key_variant in source.keys():
		var key := str(key_variant)
		if key.is_empty():
			continue
		sanitized[key] = maxf(0.0, float(source[key_variant]))
	return sanitized

func _sanitize_time_attack_record_tables(raw_value: Variant) -> Dictionary:
	if raw_value is not Dictionary:
		return {}
	var source: Dictionary = raw_value
	var sanitized: Dictionary = {}
	for key_variant in source.keys():
		var key := str(key_variant)
		if key.is_empty() or not source[key_variant] is Array:
			continue
		var records: Array = []
		for value in source[key_variant] as Array:
			var time := maxf(0.0, float(value))
			if time > 0.0:
				records.append(time)
			if records.size() >= 3:
				break
		if not records.is_empty():
			records.sort()
			sanitized[key] = records
	return sanitized

func _get_default_tiny_chao_roster() -> Array:
	return [
		{"name": "CHAO 1", "hunger": 50, "mood": 50, "care": 0},
		{"name": "CHAO 2", "hunger": 42, "mood": 58, "care": 0},
		{"name": "CHAO 3", "hunger": 64, "mood": 44, "care": 0},
	]

func _sanitize_tiny_chao_roster(raw_value: Variant) -> Array:
	if raw_value is not Array:
		return _get_default_tiny_chao_roster()
	var sanitized: Array = []
	for i in range(mini(3, (raw_value as Array).size())):
		var value = (raw_value as Array)[i]
		if value is not Dictionary:
			continue
		var chao: Dictionary = value
		sanitized.append({
			"name": str(chao.get("name", "CHAO %d" % (i + 1))).substr(0, 12),
			"hunger": clampi(int(chao.get("hunger", 50)), 0, 100),
			"mood": clampi(int(chao.get("mood", 50)), 0, 100),
			"care": clampi(int(chao.get("care", 0)), 0, 999),
		})
	while sanitized.size() < 3:
		sanitized.append(_get_default_tiny_chao_roster()[sanitized.size()])
	return sanitized

func _load_save_data() -> void:
	_save_id = 0
	_unlocked_level_index = 0
	_character_unlocked_level_indices = [0, 0, 0, 0, 0]
	_best_scores = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	_profile_score = 0
	_level_cleared_flags = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
	_time_attack_best_times = {}
	_time_attack_record_tables = {}
	_difficulty_index = 0
	_difficulty_before_edit = _difficulty_index
	_time_limit_enabled = true
	_time_limit_before_edit = _time_limit_enabled
	_language_index = 1
	_language_index_before_edit = _language_index
	_button_bindings = ["JUMP", "ATTACK", "TRICK"]
	_button_bindings_before_edit = _button_bindings.duplicate()
	_sound_test_track_index = 0
	_sound_test_state = SOUND_TEST_STATE_STOPPED
	_sound_test_unlocked = false
	_player_profile_name = [" ", " ", " ", " ", " ", " "]
	_multi_record_rows = _get_default_multiplayer_record_rows()
	_multiplayer_record_totals = _get_default_multiplayer_record_totals()
	_boss_time_attack_unlocked = false
	_selected_character_index = 0
	_chaos_emeralds_message_seen = false
	_chaos_emerald_mask = 0
	_chaos_emerald_masks = [0, 0, 0, 0, 0]
	_character_unlocked = [true, false, false, false, false]
	_completed_character_routes = [false, false, false, false, false]
	_extra_ending_credits_played = false
	_tiny_chao_roster = _get_default_tiny_chao_roster()
	_true_area_unlocked = false
	_extra_zone_status = 0
	var parsed = _read_save_dictionary(_save_path)
	if typeof(parsed) != TYPE_DICTIONARY:
		# save.c keeps older flash sectors available when the newest sector is
		# corrupt. The backup provides the same recovery property for JSON saves.
		parsed = _read_save_dictionary(_save_path + ".bak")
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("save_id"):
		_save_id = maxi(0, int(parsed["save_id"]))
	if parsed.has("unlocked_level_index"):
		_unlocked_level_index = clamp(int(parsed["unlocked_level_index"]), 0, _level_names.size() - 1)
	if parsed.has("character_unlocked_level_indices") and parsed["character_unlocked_level_indices"] is Array:
		var character_levels: Array = parsed["character_unlocked_level_indices"]
		for i in range(min(character_levels.size(), _character_unlocked_level_indices.size())):
			_character_unlocked_level_indices[i] = clampi(int(character_levels[i]), 0, _level_names.size() - 1)
	else:
		_character_unlocked_level_indices[0] = _unlocked_level_index
	if parsed.has("true_area_unlocked"):
		_true_area_unlocked = bool(parsed["true_area_unlocked"])
	elif parsed.has("unlocked_level_index"):
		_true_area_unlocked = int(parsed["unlocked_level_index"]) >= _level_names.size() - 1
	if parsed.has("extra_zone_status"):
		_extra_zone_status = clampi(int(parsed["extra_zone_status"]), 0, 2)
	else:
		_extra_zone_status = 2 if _true_area_unlocked else 0
	if parsed.has("selected_level_index"):
		_selected_level_index = clamp(int(parsed["selected_level_index"]), 0, _unlocked_level_index)
	if parsed.has("best_scores") and parsed["best_scores"] is Array:
		var scores: Array = parsed["best_scores"]
		for i in range(min(scores.size(), _best_scores.size())):
			_best_scores[i] = int(scores[i])
	if parsed.has("profile_score"):
		_profile_score = maxi(0, int(parsed["profile_score"]))
	if parsed.has("level_cleared_flags") and parsed["level_cleared_flags"] is Array:
		var flags: Array = parsed["level_cleared_flags"]
		for i in range(min(flags.size(), _level_cleared_flags.size())):
			_level_cleared_flags[i] = bool(flags[i])
	if parsed.has("time_attack_best_times"):
		_time_attack_best_times = _sanitize_time_attack_best_times(parsed["time_attack_best_times"])
	if parsed.has("time_attack_record_tables"):
		_time_attack_record_tables = _sanitize_time_attack_record_tables(parsed["time_attack_record_tables"])
	for key in _time_attack_best_times.keys():
		if not _time_attack_record_tables.has(key):
			_time_attack_record_tables[key] = [float(_time_attack_best_times[key])]
	if parsed.has("tiny_chao_unlocked"):
		_tiny_chao_unlocked = bool(parsed["tiny_chao_unlocked"])
	if parsed.has("tiny_chao_roster"):
		_tiny_chao_roster = _sanitize_tiny_chao_roster(parsed["tiny_chao_roster"])
	_sync_tiny_chao_selection()
	if parsed.has("difficulty_index"):
		_difficulty_index = clampi(int(parsed["difficulty_index"]), 0, 1)
	if parsed.has("time_limit_enabled"):
		_time_limit_enabled = bool(parsed["time_limit_enabled"])
	if parsed.has("language_index"):
		_language_index = clampi(int(parsed["language_index"]), 0, get_language_items().size() - 1)
	_language_index_before_edit = _language_index
	if parsed.has("button_bindings"):
		_button_bindings = _sanitize_button_bindings(parsed["button_bindings"])
	_button_bindings_before_edit = _button_bindings.duplicate()
	if parsed.has("sound_test_track_index"):
		_sound_test_track_index = clampi(int(parsed["sound_test_track_index"]), 0, _sound_test_tracks.size() - 1)
	if parsed.has("sound_test_unlocked"):
		_sound_test_unlocked = bool(parsed["sound_test_unlocked"])
	if parsed.has("player_profile_name"):
		_player_profile_name = _sanitize_profile_name(parsed["player_profile_name"])
	if parsed.has("multi_record_rows"):
		_multi_record_rows = _sanitize_multiplayer_record_rows(parsed["multi_record_rows"])
	if parsed.has("multiplayer_record_totals"):
		_multiplayer_record_totals = _sanitize_multiplayer_record_totals(parsed["multiplayer_record_totals"])
	if parsed.has("boss_time_attack_unlocked"):
		_boss_time_attack_unlocked = bool(parsed["boss_time_attack_unlocked"])
	if not parsed.has("sound_test_unlocked") and _boss_time_attack_unlocked:
		_sound_test_unlocked = true
	if parsed.has("selected_character_index"):
		_selected_character_index = clampi(int(parsed["selected_character_index"]), 0, _character_names.size() - 1)
	if parsed.has("character_unlocked") and parsed["character_unlocked"] is Array:
		var characters: Array = parsed["character_unlocked"]
		for i in range(min(characters.size(), _character_unlocked.size())):
			_character_unlocked[i] = bool(characters[i])
	elif _unlocked_level_index > 0 or (_level_cleared_flags.size() > 0 and _level_cleared_flags[0]):
		_character_unlocked[1] = true
	if parsed.has("completed_character_routes") and parsed["completed_character_routes"] is Array:
		var completed_routes: Array = parsed["completed_character_routes"]
		for i in range(min(completed_routes.size(), _completed_character_routes.size())):
			_completed_character_routes[i] = bool(completed_routes[i])
	if parsed.has("extra_ending_credits_played"):
		_extra_ending_credits_played = bool(parsed["extra_ending_credits_played"])
	if parsed.has("chaos_emeralds_message_seen"):
		_chaos_emeralds_message_seen = bool(parsed["chaos_emeralds_message_seen"])
	if parsed.has("chaos_emerald_masks") and parsed["chaos_emerald_masks"] is Array:
		var emerald_masks: Array = parsed["chaos_emerald_masks"]
		for i in range(min(emerald_masks.size(), _chaos_emerald_masks.size())):
			_chaos_emerald_masks[i] = clampi(int(emerald_masks[i]), 0, 127)
	elif parsed.has("chaos_emerald_mask"):
		# Older Godot saves had one global mask; preserve it for Sonic.
		_chaos_emerald_masks[0] = clampi(int(parsed["chaos_emerald_mask"]), 0, 127)
	_chaos_emerald_mask = _get_selected_chaos_emerald_mask()
	_sync_active_character_level_progress()

func _save_save_data() -> void:
	if _save_id == 0:
		_save_id = randi()
		if _save_id == 0:
			_save_id = 1
	var payload := {
		"save_id": _save_id,
		"unlocked_level_index": _unlocked_level_index,
		"character_unlocked_level_indices": _character_unlocked_level_indices,
		"selected_level_index": _selected_level_index,
		"best_scores": _best_scores,
		"profile_score": _profile_score,
		"level_cleared_flags": _level_cleared_flags,
		"time_attack_best_times": _time_attack_best_times,
		"time_attack_record_tables": _time_attack_record_tables,
		"tiny_chao_unlocked": _tiny_chao_unlocked,
		"tiny_chao_roster": _tiny_chao_roster,
		"true_area_unlocked": _true_area_unlocked,
		"extra_zone_status": _extra_zone_status,
		"difficulty_index": _difficulty_index,
		"time_limit_enabled": _time_limit_enabled,
		"language_index": _language_index,
		"button_bindings": _button_bindings,
		"sound_test_track_index": _sound_test_track_index,
		"sound_test_unlocked": _sound_test_unlocked,
		"player_profile_name": _player_profile_name,
		"multi_record_rows": _multi_record_rows,
		"multiplayer_record_totals": _multiplayer_record_totals,
		"boss_time_attack_unlocked": _boss_time_attack_unlocked,
		"selected_character_index": _selected_character_index,
		"character_unlocked": _character_unlocked,
		"completed_character_routes": _completed_character_routes,
		"extra_ending_credits_played": _extra_ending_credits_played,
		"chaos_emeralds_message_seen": _chaos_emeralds_message_seen,
		"chaos_emerald_mask": _chaos_emerald_mask,
		"chaos_emerald_masks": _chaos_emerald_masks,
	}
	var serialized := JSON.stringify(payload)
	var previous := FileAccess.open(_save_path, FileAccess.READ)
	if previous:
		var previous_text := previous.get_as_text()
		previous.close()
		var backup := FileAccess.open(_save_path + ".bak", FileAccess.WRITE)
		if backup:
			backup.store_string(previous_text)
			backup.close()
	var file := FileAccess.open(_save_path, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(serialized)
	file.close()

func _read_save_dictionary(path: String) -> Variant:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return null
	# Corrupt primaries are expected during backup recovery. The static parser
	# returns null without logging an engine error, allowing the .bak fallback
	# to remain a normal, quiet recovery path.
	var text := file.get_as_text().strip_edges()
	if text.is_empty() or not text.begins_with("{") or not text.ends_with("}"):
		return null
	return JSON.parse_string(text)

func _reset_progress() -> void:
	# save.c preserves the selected language when it creates a fresh save.
	var preserved_language := clampi(_language_index, 0, get_language_items().size() - 1)
	_unlocked_level_index = 0
	_character_unlocked_level_indices = [0, 0, 0, 0, 0]
	_selected_level_index = 0
	_best_scores = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	_profile_score = 0
	_level_cleared_flags = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
	_time_attack_best_times = {}
	_time_attack_record_tables = {}
	_tiny_chao_unlocked = false
	_tiny_chao_roster = _get_default_tiny_chao_roster()
	_true_area_unlocked = false
	_extra_zone_status = 0
	_difficulty_index = 0
	_difficulty_before_edit = _difficulty_index
	_time_limit_enabled = true
	_time_limit_before_edit = _time_limit_enabled
	_language_index = preserved_language
	_button_bindings = ["JUMP", "ATTACK", "TRICK"]
	_button_bindings_before_edit = _button_bindings.duplicate()
	_sound_test_track_index = 0
	_sound_test_state = SOUND_TEST_STATE_STOPPED
	_sound_test_unlocked = false
	_player_profile_name = [" ", " ", " ", " ", " ", " "]
	_multi_record_rows = _get_cleared_multiplayer_record_rows()
	_multiplayer_record_totals = _get_default_multiplayer_record_totals()
	_boss_time_attack_unlocked = false
	_selected_character_index = 0
	_character_unlocked = [true, false, false, false, false]
	_completed_character_routes = [false, false, false, false, false]
	_extra_ending_credits_played = false
	_chaos_emeralds_message_seen = false
	_chaos_emerald_mask = 0
	_chaos_emerald_masks = [0, 0, 0, 0, 0]
	_save_reset_pending = false
	_save_save_data()

func load_completed_save_game() -> void:
	# save.c's GenerateCompletedSaveGame builds a profile with every route,
	# character, emerald, and extra menu unlocked. Godot stores the highest
	# usable level index rather than the source's unlocked-level count.
	var final_zone_index := maxi(0, _level_names.size() - 2)
	var true_area_index := maxi(0, _level_names.size() - 1)
	_unlocked_level_index = true_area_index
	_character_unlocked_level_indices = [true_area_index, final_zone_index, final_zone_index, final_zone_index, final_zone_index]
	_selected_level_index = 0
	_profile_score = 0
	_extra_zone_status = 2
	_level_cleared_flags.fill(true)
	_best_scores.fill(0)
	_time_attack_best_times = {}
	_time_attack_record_tables = {}
	_character_unlocked = [true, true, true, true, true]
	_completed_character_routes = [true, true, true, true, true]
	_chaos_emerald_masks = [127, 127, 127, 127, 127]
	_chaos_emerald_mask = 127
	_sound_test_unlocked = true
	_boss_time_attack_unlocked = true
	_tiny_chao_unlocked = true
	_true_area_unlocked = true
	_extra_ending_credits_played = true
	_chaos_emeralds_message_seen = false
	_sync_active_character_level_progress()
	_save_save_data()

func _calculate_clear_rank(time_seconds: float, score: int) -> String:
	if time_seconds <= 70.0 and score >= 7500:
		return "S"
	if time_seconds <= 90.0 and score >= 6500:
		return "A"
	if time_seconds <= 110.0 and score >= 5800:
		return "B"
	if time_seconds <= 140.0 and score >= 5000:
		return "C"
	return "D"
