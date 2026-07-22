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
const CLEAR_COUNT_STEP_INTERVAL := 4.0 / 60.0
# SA2's course-start countdown runs for five seconds plus ten frames unless
# the single-player intro is skipped, in which case it starts at three.
const INTRO_TOTAL_TIME = 5.1666667
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
	var target_x: float = 0.0
	var target_y: float = 0.0
	var effect_offset: float = 0.0
	var state_timer: float = 0.0
	var enemy_profile: int = 0
	var health: int = 0
	var max_health: int = 0
	var hit_timer: float = 0.0
	var flag_active: bool = false
	var item_kind: int = ITEM_BOX_KIND_RINGS
	var rail_end_mode: int = 0
	var rail_direction: float = 1.0
	var gravity_kind: int = GRAVITY_KIND_TOGGLE
	var bounce_strength: float = 1.125
	var surface_speed: float = 0.0
	var flying_spring: bool = false
	var flying_spring_phase: float = 0.0
	var flying_spring_trigger_timer: float = 0.0
	var floating_spring: bool = false
	var floating_spring_amplitude_x: float = 0.0
	var floating_spring_amplitude_y: float = 0.0
	var floating_spring_phase: float = 0.0
	var light_bridge: bool = false
	var light_bridge_type: int = 0
	var light_bridge_phase: float = 0.0
	var light_bridge_active: bool = false
	var spike_platform: bool = false
	var spike_platform_phase: float = 0.0
	var turnaround_bar: bool = false
	var turnaround_direction: float = 1.0
	var turnaround_timer: float = 0.0
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
	var small_windmill: bool = false
	var small_windmill_type: int = 0
	var small_windmill_timer: float = 0.0
	var small_windmill_angle: float = 0.0
	var chord: bool = false
	var chord_timer: float = 0.0
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
	var ceiling_slope: bool = false
	var ceiling_slope_variant: int = 0
	var ceiling_slope_timer: float = 0.0
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
	var damage_region: bool = false
	var decoration: bool = false
	var decoration_id: int = 0
	var cannon_facing_right: bool = true
	var cannon_angle: float = 0.0
	var cannon_active: bool = false
	var cannon_timer: float = 0.0
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
var _pipe_active: bool = false
var _pipe_origin: Vector2 = Vector2.ZERO
var _pipe_target: Vector2 = Vector2.ZERO
var _pipe_timer: float = 0.0
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
## missing_emeralds.c holds its notification card for 0xF0 frames.
var _chaos_emeralds_duration: float = 4.0
var _chaos_emeralds_message_seen: bool = false
var _missing_emeralds_timer: float = 0.0
var _missing_emeralds_duration: float = 4.0
var _to_be_continued_timer: float = 0.0
# endings.c holds the transition for 0xB4 frames before the ending cutscene.
var _to_be_continued_duration: float = 3.0
var _sega_logo_timer: float = 0.0
# title_screen.c holds each boot logo for FRAME_TIME_SECONDS(2).
var _sega_logo_duration: float = 2.0
var _sonic_team_timer: float = 0.0
var _sonic_team_duration: float = 2.0
var _chaos_emerald_mask: int = 0
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
var _character_unlock_timer: float = 0.0
var _character_unlock_duration: float = 5.0
var _character_unlock_pending: int = -1
var _character_select_intro_timer: float = 0.0
var _play_mode_intro_timer: float = 0.0
var _time_attack_mode_intro_timer: float = 0.0
var _multiplayer_mode_intro_timer: float = 0.0
var _special_stage_timer: float = 0.0
var _special_stage_entry_duration: float = 2.6
var _special_stage_results_duration: float = 9.0
var _special_stage_run_duration: float = 120.0
var _special_stage_phase: int = 0
var _special_stage_pending: bool = false
var _special_stage_ring_count: int = 0
var _special_stage_score: int = 0
var _special_stage_points_remaining: int = 0
var _special_stage_bonus_remaining: int = 0
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
var _level_cleared_flags: Array = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
var _time_attack_best_times: Dictionary = {}
var _time_attack_record_tables: Dictionary = {}
var _save_path: String = "user://save_data.json"
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
var _time_limit_enabled: bool = true
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
var _multiplayer_outcome_type: int = 0
var _multiplayer_outcome_timer: float = 0.0
var _multiplayer_outcome_duration: float = 1.8
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
var _course_select_unlock_timer: float = 0.0
var _course_select_unlock_duration: float = 2.0
var _course_select_start_timer: float = 0.0
var _course_select_start_duration: float = 0.24
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
	if not FileAccess.file_exists(_save_path) or not has_profile_name():
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
	_character_unlock_timer = 0.0
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
	_special_stage_points_remaining = 0
	_special_stage_bonus_remaining = 0
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
	_tiny_chao_unlocked = false
	_tiny_chao_play_x = 0.0
	_tiny_chao_play_y = 0.0
	_tiny_chao_hunger = 50
	_tiny_chao_mood = 50
	_tiny_chao_fruit = 3
	_tiny_chao_care_count = 0
	_tiny_chao_action_timer = 0.0
	_tiny_chao_action_text = "WELCOME TO THE GARDEN"
	_tiny_chao_selected_index = 0
	_tiny_chao_roster = _get_default_tiny_chao_roster()
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

func open_title_screen_at_time_attack_menu(selected_index: int = 0, notice_text: String = "") -> void:
	reset_to_title()
	_title_phase = TITLE_PHASE_TIME_ATTACK
	_title_menu_index = clampi(selected_index, 0, max(get_title_menu_items().size() - 1, 0))
	_time_attack_mode_intro_timer = 47.0 / 60.0
	_title_notice_text = notice_text
	_status_text = get_title_prompt_text()

func is_time_attack_mode_input_ready() -> bool:
	return _game_state == GAME_STATE_TITLE and _title_phase == TITLE_PHASE_TIME_ATTACK and _time_attack_mode_intro_timer <= 0.0

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
	_course_select_unlock_timer = _course_select_unlock_duration if unlock_cutscene else 0.0
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
	_intro_timer = INTRO_TOTAL_TIME
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
			_status_text = get_intro_countdown_text()
		else:
			_status_text = "READY!"
		if _intro_timer <= 0.0:
			_game_state = GAME_STATE_PLAYING
			# The original creates a separate one-second race-start message after
			# releasing the countdown lock.
			_race_start_message_timer = 1.0
			_start_boost_timer = INTRO_BOOST_DURATION if _intro_speed_boost and not _intro_boost_disabled else 0.0
			_player_state.speed_x = INTRO_BOOST_SPEED if _start_boost_timer > 0.0 else 0.0
			_player_state.ground_speed = _player_state.speed_x
			_status_text = "OUTRUN RIVALS" if _run_from_multiplayer else "REACH THE GOAL"
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
				_finish_clear_counting()
		else:
			if frame_input & START_BUTTON or frame_input & A_BUTTON:
				clear_replay()
			if frame_input & B_BUTTON or frame_input & SELECT_BUTTON:
				clear_return_to_title()
		_update_camera()
		return

	if _game_state == GAME_STATE_PAUSED:
		var a_held := bool(held_input & A_BUTTON)
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
		if frame_input & START_BUTTON:
			resume_game()
		_update_camera()
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
	_start_boost_timer = maxf(0.0, _start_boost_timer - delta)
	_attack_timer = maxf(0.0, _attack_timer - delta)
	_flight_timer = maxf(0.0, _flight_timer - delta)
	_glide_timer = maxf(0.0, _glide_timer - delta)
	var time_limit_active := _run_from_time_attack or _time_limit_enabled
	if time_limit_active and _elapsed_time >= MAX_COURSE_TIME_SECONDS:
		_open_game_over(true)
		_update_camera()
		return
	_update_enemy_motion(delta)
	_update_flying_spring_motion(delta)
	_update_slidy_ice_state()
	_update_slowing_snow_state()
	_update_light_bridge_state(delta)
	_update_spike_platform_state()
	_update_turnaround_bar_state(delta)
	_update_keyboard_state(delta)
	_update_pole_state()
	_update_light_globe_state(delta)
	_update_windup_stick_state(delta)
	_update_german_flute_state(delta)
	_update_small_windmill_state(delta)
	_update_chord_state(delta)
	_update_half_pipe_state()
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

	_handle_entity_interactions(held_input, delta)
	_sync_grind_effect()
	_store_boost_effect_position()
	_update_camera()

func advance_ui_timers(delta: float, held_input: int = 0, frame_input: int = 0) -> void:
	_update_screen_fade(delta)
	_race_start_message_timer = maxf(0.0, _race_start_message_timer - delta)
	if _game_state == GAME_STATE_FINAL_INTRO:
		_final_intro_timer = maxf(0.0, _final_intro_timer - delta)
		if _final_intro_timer <= 0.0:
			skip_final_intro()
		return
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
		_course_select_unlock_timer = maxf(0.0, _course_select_unlock_timer - delta)
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
			_time_attack_result_timer += delta
			if _time_attack_result_timer >= 10.0:
				open_time_attack_lobby(_time_attack_boss_mode)
				return
		if not _run_from_time_attack and not _clear_counting_done and _clear_count_delay_timer <= 0.0:
			_clear_count_step_accumulator += delta
			while _clear_count_step_accumulator >= CLEAR_COUNT_STEP_INTERVAL and not _clear_counting_done:
				_clear_count_step_accumulator -= CLEAR_COUNT_STEP_INTERVAL
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
		_credits_end_timer = maxf(0.0, _credits_end_timer - delta)
		if _credits_end_timer <= 0.0:
			_resolve_credits_end()
	if _game_state == GAME_STATE_CHARACTER_UNLOCK:
		_character_unlock_timer = maxf(0.0, _character_unlock_timer - delta)
		if _character_unlock_timer <= 0.0:
			_resolve_character_unlock()
	if _game_state == GAME_STATE_SPECIAL_STAGE:
		if _special_stage_paused:
			return
		if _special_stage_phase == 1:
			_update_special_stage_guard_robo(delta)
			_update_special_stage_run(delta, held_input)
		elif _special_stage_phase == 2:
			_update_special_stage_results(delta)
		_special_stage_timer = maxf(0.0, _special_stage_timer - delta)
		if _special_stage_timer <= 0.0:
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

func _finish_clear_counting() -> void:
	_clear_total_display_score += _clear_time_bonus_remaining + _clear_ring_bonus_remaining + _clear_special_ring_bonus_remaining
	_clear_time_bonus_remaining = 0
	_clear_ring_bonus_remaining = 0
	_clear_special_ring_bonus_remaining = 0
	_clear_count_step_accumulator = 0.0
	_clear_counting_done = true
	_clear_input_lock_timer = minf(_clear_input_lock_timer, 0.18)

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
	_credits_timer = 3.0
	_status_text = get_ending_variant_label()

func _advance_credits_page() -> void:
	if _game_state != GAME_STATE_CREDITS:
		return
	_credits_page += 1
	if _credits_page >= _credits_page_count:
		_open_credits_end()
		return
	_credits_timer = _credits_page_duration

func _open_credits_end() -> void:
	_game_state = GAME_STATE_CREDITS_END
	_credits_end_timer = _credits_end_duration
	_status_text = get_ending_variant_label()
	if _ending_variant == ENDING_VARIANT_EXTRA:
		_extra_ending_credits_played = true
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
			return "EXTRA ENDING"
		ENDING_VARIANT_FINAL:
			return "FINAL ENDING"
	return "ADVENTURE ENDING"

func _resolve_credits_end() -> void:
	if _game_state != GAME_STATE_CREDITS_END:
		return
	_open_copyright()

func _open_character_unlock() -> void:
	if _character_unlock_pending < 0 or _character_unlock_pending >= _character_names.size():
		return
	_game_state = GAME_STATE_CHARACTER_UNLOCK
	_character_unlock_timer = _character_unlock_duration
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
	# Ignore START during the first eight frames, matching sub_808E4C8.
	if _character_unlock_timer > _character_unlock_duration - (8.0 / 60.0):
		return
	_character_unlock_timer = 0.05

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
		_special_stage_timer = _special_stage_results_duration
		_special_stage_points_remaining = mini(99999, _special_stage_ring_count * 100)
		_special_stage_bonus_remaining = 10000 if _special_stage_target_reached else 0
		_special_stage_score = 0
		_status_text = "SPECIAL STAGE RESULTS"
		return
	if _special_stage_points_remaining > 0 or _special_stage_bonus_remaining > 0:
		_special_stage_score += _special_stage_points_remaining + _special_stage_bonus_remaining
		_special_stage_points_remaining = 0
		_special_stage_bonus_remaining = 0
		_special_stage_timer = 0.8
		return
	_finish_special_stage()

func _update_special_stage_run(delta: float, held_input: int) -> void:
	if _special_stage_phase != 1:
		return
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
	_special_stage_progress = minf(1.0, _special_stage_progress + delta / _special_stage_run_duration)
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
	if progress_gap > 0.045 or _special_stage_robo_lane != _special_stage_lane or _special_stage_robo_cooldown > 0.0:
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

func _update_special_stage_results(delta: float) -> void:
	var step := maxi(100, int(6000.0 * delta))
	if _special_stage_points_remaining > 0:
		var points_step := mini(step, _special_stage_points_remaining)
		_special_stage_points_remaining -= points_step
		_special_stage_score += points_step
	elif _special_stage_bonus_remaining > 0:
		var bonus_step := mini(step, _special_stage_bonus_remaining)
		_special_stage_bonus_remaining -= bonus_step
		_special_stage_score += bonus_step

func _finish_special_stage() -> void:
	if _game_state != GAME_STATE_SPECIAL_STAGE:
		return
	if _special_stage_target_reached:
		_collect_chaos_emerald_for_clear()
		_save_save_data()
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
	if _run_from_time_attack:
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
	return not _run_from_multiplayer and (_start_boost_timer > 0.0 or _dash_timer > 0.0 or _boost_effect_timer > 0.0)

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
	var display_time := minf(_elapsed_time, MAX_COURSE_TIME_SECONDS - 0.01) if (_run_from_time_attack or _time_limit_enabled) else _elapsed_time
	return get_formatted_time(display_time)

func is_hud_timer_warning() -> bool:
	return (_run_from_time_attack or _time_limit_enabled) and _elapsed_time >= 580.0

func get_hud_special_ring_count() -> int:
	return _player_state.special_rings

func get_hud_powerup_text() -> String:
	if _invincibility_timer > 0.0:
		return "INV %02d" % ceili(_invincibility_timer)
	if _speed_up_timer > 0.0:
		return "SPEED %02d" % ceili(_speed_up_timer)
	if _magnetic_shielded:
		return "MAGNETIC"
	if _player_state.shielded:
		return "SHIELD"
	return ""

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
		elif entity_type == ENTITY_LAYER_TOGGLE:
			source_entity.variant = 1 if kind.find("BACKGROUND") >= 0 else 0
			var fields: Array = row.get("fields", [])
			if fields.size() > 8:
				source_entity.width = maxf(32.0, float(_to_int_field(fields[7])) * 8.0 * _source_runtime_scale(source_width, source_height, level))
				source_entity.height = maxf(32.0, float(_to_int_field(fields[8])) * 8.0 * _source_runtime_scale(source_width, source_height, level))
		elif entity_type == ENTITY_RAMP:
			if kind == "INCLINE_RAMP":
				source_entity.variant = 1
			else:
				var ramp_fields: Array = row.get("fields", [])
				source_entity.variant = (_to_int_field(ramp_fields[5]) & 1) if ramp_fields.size() > 5 else 0
		elif entity_type == ENTITY_CORK_SCREW:
			source_entity.variant = 1 if kind.find("STOP") >= 0 or kind.find("END") >= 0 else 0
		elif entity_type == ENTITY_BOUNCY_SPRING and kind == "BOUNCY_BAR":
			source_entity.variant = 2
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
		elif entity_type == ENTITY_WHIRLWIND:
			source_entity.width = 128.0
			source_entity.height = 128.0
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
	var best_surface := -1
	for source_y in range(0, source_height, 8):
		var sample: Dictionary = SOURCE_MAP_LOADER.sample_floor(terrain, source_x, source_y, collision_layer)
		if bool(sample.get("solid", false)):
			best_surface = maxi(best_surface, int(sample.get("surface_y", source_y)))
	return best_surface

func _add_source_platform(level: LevelState, source_start_x: int, source_end_x: int, source_start_y: float, source_end_y: float, source_width: float, source_height: float, collision_layer: int) -> void:
	var start_position := _source_runtime_position(level, source_start_x, source_start_y, source_width, source_height)
	var end_position := _source_runtime_position(level, source_end_x + 16, source_end_y, source_width, source_height)
	var start := start_position.x
	var end := end_position.x
	if end - start >= 18.0:
		_add_sloped_platform(level, start, start_position.y + 12.0, end, end_position.y + 12.0, 12.0, collision_layer)

func _source_interactable_type(kind: String) -> int:
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
	if kind == "ROTATING_HANDLE" or kind == "FLYING_HANDLE":
		return ENTITY_ROTATING_HANDLE
	if kind.find("CORK_SCREW") >= 0 or kind.find("CORKSCREW") >= 0:
		return ENTITY_CORK_SCREW
	if kind == "BOUNCY_BAR" or kind.begins_with("NOTE_BLOCK"):
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
			entity.velocity_x = _enemy_speed * 0.75
			entity.state_timer = 0.0
		"BALLOON":
			entity.velocity_x = 42.0
			entity.state_timer = 1.2
		"BULLETBUZZER":
			entity.state_timer = 2.0
		"KOURA":
			entity.velocity_x = 82.0
		"STAR":
			entity.state_timer = 2.0
		"KIKI":
			entity.state_timer = 1.8
		"PEN":
			entity.enemy_profile = 1
			entity.velocity_x = 30.0
		"MOUSE":
			entity.enemy_profile = 3
			entity.velocity_x = 48.0
		"BELL":
			entity.enemy_profile = 2
			entity.state_timer = 2.0
		"CIRCUS":
			entity.enemy_profile = 4
			entity.state_timer = 1.5
		"PIKOPIKO":
			entity.velocity_x = -60.0
		"YADO":
			entity.enemy_profile = 5
			entity.state_timer = 2.0
		"GOHLA":
			entity.enemy_profile = 6
			entity.state_timer = 0.0
		"HAMMERHEAD":
			entity.enemy_profile = 7
			entity.state_timer = float(_to_int_field(fields[8])) / 256.0 * TAU if fields.size() > 8 else 0.0
		"STRAW":
			entity.enemy_profile = 9
			entity.state_timer = 1.0

func _source_item_kind(kind: String) -> int:
	match kind:
		"SHIELD":
			return ITEM_BOX_KIND_SHIELD
		"INVINCIBILITY":
			return ITEM_BOX_KIND_INVINCIBILITY
		"ONE_UP":
			return ITEM_BOX_KIND_ONE_UP
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
	entity.velocity_x = _enemy_speed * 0.75
	entity.patrol_min_x = patrol_min_x
	entity.patrol_max_x = patrol_max_x
	entity.origin_x = x
	entity.origin_y = y
	entity.target_x = x
	entity.target_y = y

func _add_balloon(level: LevelState, x: float, y: float, patrol_min_x: float, patrol_max_x: float) -> void:
	var entity := _add_entity(level, ENTITY_BALLOON, x, y)
	entity.velocity_x = 42.0
	entity.patrol_min_x = patrol_min_x
	entity.patrol_max_x = patrol_max_x
	entity.origin_x = x
	entity.origin_y = y
	entity.state_timer = 1.2

func _add_bullet_buzzer(level: LevelState, x: float, y: float) -> void:
	var entity := _add_entity(level, ENTITY_BULLET_BUZZER, x, y)
	entity.origin_x = x
	entity.origin_y = y
	entity.state_timer = 2.0

func _add_koura(level: LevelState, x: float, y: float, patrol_min_x: float, patrol_max_x: float) -> void:
	var entity := _add_entity(level, ENTITY_KOURA, x, y)
	entity.velocity_x = 82.0
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
	entity.state_timer = 1.8

func _add_trapped_animal(level: LevelState, x: float, y: float, animal_type: int) -> void:
	var entity := _add_entity(level, ENTITY_TRAPPED_ANIMAL, x, y)
	entity.variant = clampi(animal_type, 0, 2)
	entity.origin_x = x
	entity.origin_y = y
	entity.state_timer = 0.0
	entity.velocity_x = 16.0 if entity.variant == 2 else 0.0

func _add_boss(level: LevelState, x: float, y: float) -> void:
	var entity := _add_entity(level, ENTITY_BOSS, x, y)
	entity.width = 92.0
	entity.height = 68.0
	entity.origin_x = x
	entity.origin_y = y
	entity.state_timer = 1.2
	entity.health = 8
	entity.max_health = 8

func _add_checkpoint(level: LevelState, x: float, y: float) -> void:
	_add_entity(level, ENTITY_CHECKPOINT, x, y)

func _add_special_ring(level: LevelState, x: float, y: float) -> void:
	_add_entity(level, ENTITY_SPECIAL_RING, x, y)

func _add_whirlwind(level: LevelState, x: float, y: float, width: float, height: float) -> void:
	var entity := _add_entity(level, ENTITY_WHIRLWIND, x, y)
	entity.width = width
	entity.height = height

func _add_fan(level: LevelState, x: float, y: float, width: float, height: float, direction: float) -> void:
	var entity := _add_entity(level, ENTITY_FAN, x, y)
	entity.width = width
	entity.height = height
	entity.velocity_x = signf(direction)

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
			_player_state.speed_x = -entity.turnaround_direction * 270.0
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
			_player_state.char_state = 5

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

func _update_german_flute_state(delta: float) -> void:
	for entity in _level_state.entities:
		if not entity.active or not entity.german_flute or entity.german_flute_timer <= 0.0:
			continue
		entity.german_flute_timer += delta
		_player_state.world_x = entity.world_x
		_player_state.world_y = entity.world_y + 24.0
		_player_state.is_grounded = false
		_player_state.speed_x = 0.0
		_player_state.ground_speed = 0.0
		_player_state.rotation = 0
		if entity.german_flute_timer < 0.5:
			_velocity_y = 0.0
			_player_state.char_state = 8
		elif entity.german_flute_timer < 1.5:
			_velocity_y = -(420.0 + entity.german_flute_kind * 45.0)
			_player_state.char_state = 9
			_player_state.speed_y = _velocity_y
		else:
			entity.german_flute_timer = 0.0
			entity.activated = false
			_player_state.char_state = 0

func _update_small_windmill_state(delta: float) -> void:
	for entity in _level_state.entities:
		if not entity.active or not entity.small_windmill or entity.small_windmill_timer <= 0.0:
			continue
		entity.small_windmill_timer += delta
		if entity.small_windmill_timer < 0.7:
			entity.small_windmill_angle += delta * 8.0
			_player_state.world_x = entity.world_x + cos(entity.small_windmill_angle) * 24.0
			_player_state.world_y = entity.world_y + sin(entity.small_windmill_angle) * 24.0
			_player_state.is_grounded = false
			_player_state.speed_x = 0.0
			_player_state.ground_speed = 0.0
			_velocity_y = 0.0
			_player_state.rotation = 0
			_player_state.char_state = 8
		else:
			var release_direction := Vector2(cos(entity.small_windmill_angle), sin(entity.small_windmill_angle))
			entity.small_windmill_timer = 0.0
			entity.activated = false
			_player_state.is_grounded = false
			_player_state.speed_x = release_direction.x * 480.0
			_velocity_y = release_direction.y * 480.0
			_player_state.speed_y = _velocity_y
			_player_state.char_state = 5

func _update_chord_state(delta: float) -> void:
	for entity in _level_state.entities:
		if not entity.active or not entity.chord:
			continue
		entity.chord_timer = maxf(0.0, entity.chord_timer - delta)
		if entity.chord_timer <= 0.0:
			entity.activated = false

func _update_half_pipe_state() -> void:
	for entity in _level_state.entities:
		if not entity.active or not entity.half_pipe or not entity.half_pipe_active:
			continue
		if _frame_input & A_BUTTON:
			entity.half_pipe_active = false
			entity.activated = false
			_player_state.is_grounded = false
			_velocity_y = -_jump_speed
			_player_state.speed_y = _velocity_y
			_player_state.char_state = 5
			continue
		var distance: float = (_player_state.world_x - (entity.world_x - entity.width * 0.5)) if entity.half_pipe_direction > 0.0 else ((entity.world_x + entity.width * 0.5) - _player_state.world_x)
		var normalized := clampf(distance / maxf(1.0, entity.width), 0.0, 1.0)
		_player_state.world_y = entity.half_pipe_base_y - sin(normalized * PI) * entity.height * 0.45
		_player_state.is_grounded = true
		_player_state.speed_y = 0.0
		_velocity_y = 0.0
		_player_state.char_state = 0

func _update_iron_ball_state(delta: float) -> void:
	for entity in _level_state.entities:
		if not entity.active or not entity.iron_ball:
			continue
		entity.iron_ball_phase = fmod(entity.iron_ball_phase + delta * 3.0, TAU)
		var offset: float = sin(entity.iron_ball_phase) * entity.iron_ball_amplitude
		if entity.iron_ball_horizontal:
			entity.world_x += offset - sin(entity.iron_ball_phase - delta * 3.0) * entity.iron_ball_amplitude
		else:
			entity.world_y += offset - sin(entity.iron_ball_phase - delta * 3.0) * entity.iron_ball_amplitude

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
			_velocity_y = -420.0
			_player_state.speed_y = _velocity_y
			_player_state.char_state = 5

func _update_ceiling_slope_state(delta: float) -> void:
	for entity in _level_state.entities:
		if not entity.active or not entity.ceiling_slope:
			continue
		entity.ceiling_slope_timer = maxf(0.0, entity.ceiling_slope_timer - delta)
		if entity.ceiling_slope_timer <= 0.0:
			entity.activated = false

func _update_gapped_loop_state(delta: float) -> void:
	for entity in _level_state.entities:
		if not entity.active or not entity.gapped_loop or not entity.gapped_loop_active:
			continue
		entity.gapped_loop_angle += entity.gapped_loop_direction * delta * 4.2
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
			_player_state.world_x += 300.0 * entity.funnel_sphere_direction * delta
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
			_velocity_y = -520.0 if entity.funnel_sphere_direction > 0.0 else 520.0
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
		var progress: float = clampf(entity.music_entry_timer / 1.1, 0.0, 1.0)
		var direction := 1.0 if entity.music_entry_kind % 2 == 0 else -1.0
		_player_state.world_x = entity.world_x + direction * progress * 128.0
		_player_state.world_y = entity.world_y - sin(progress * PI) * (42.0 + entity.music_entry_kind * 4.0)
		_player_state.is_grounded = false
		_player_state.speed_x = 0.0
		_velocity_y = 0.0
		_player_state.rotation = int(sin(progress * PI) * 24.0)
		_player_state.char_state = 8
		if entity.music_entry_timer >= 1.1:
			entity.music_entry_timer = 0.0
			entity.activated = false
			_player_state.speed_x = direction * (360.0 + entity.music_entry_kind * 18.0)
			_velocity_y = -180.0 if entity.music_entry_pipe else -260.0
			_player_state.speed_y = _velocity_y
			_player_state.char_state = 5

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
		entity.flying_spring_phase = fmod(entity.flying_spring_phase + delta * 15.0, TAU)
		var amplitude := 2.0
		if entity.flying_spring_trigger_timer > 0.0:
			entity.flying_spring_trigger_timer = maxf(0.0, entity.flying_spring_trigger_timer - delta)
			amplitude = 16.0
		entity.world_y = entity.origin_y + sin(entity.flying_spring_phase) * amplitude

func _update_enemy_motion(delta: float) -> void:
	for entity in _level_state.entities:
		if (entity.type != ENTITY_ENEMY and entity.type != ENTITY_BUZZER and entity.type != ENTITY_BALLOON and entity.type != ENTITY_PROJECTILE and entity.type != ENTITY_BULLET_BUZZER and entity.type != ENTITY_KOURA and entity.type != ENTITY_STAR and entity.type != ENTITY_KIKI and entity.type != ENTITY_KIKI_PROJECTILE and entity.type != ENTITY_KIKI_PIECE and entity.type != ENTITY_BOSS and entity.type != ENTITY_ITEM_BOX and entity.type != ENTITY_SCATTER_RING and entity.type != ENTITY_TRAPPED_ANIMAL and entity.type != ENTITY_RING_EFFECT and entity.type != ENTITY_HEART_EFFECT and entity.type != ENTITY_DUST_EFFECT and entity.type != ENTITY_GRIND_EFFECT and entity.type != ENTITY_CHEESE and entity.type != ENTITY_TAIL_SWIPE and entity.type != ENTITY_KNUCKLES_FIRE and entity.type != ENTITY_SONIC_SKID and entity.type != ENTITY_FAN) or not entity.active:
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
		if entity.type == ENTITY_FAN and entity.variant == 1:
			entity.state_timer = fmod(entity.state_timer + delta, 7.0)
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
			if entity.enemy_profile == 4:
				entity.velocity_y += 280.0 * delta
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
			entity.state_timer = fmod(entity.state_timer + delta * 2.5, TAU)
			continue
		if entity.enemy_profile == 7:
			_update_hammerhead_motion(entity, delta)
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
	var direction := signf(entity.velocity_x)
	if is_zero_approx(direction):
		direction = 1.0
	var player_delta := _player_state.world_x - entity.world_x
	var threat := absf(player_delta) < 100.0 and signf(player_delta) == direction
	var speed := 120.0 if threat else 30.0
	entity.velocity_x = direction * speed
	entity.world_x += entity.velocity_x * delta
	if entity.world_x <= entity.patrol_min_x:
		entity.world_x = entity.patrol_min_x
		entity.velocity_x = absf(speed)
	elif entity.world_x >= entity.patrol_max_x:
		entity.world_x = entity.patrol_max_x
		entity.velocity_x = -absf(speed)

func _update_bell_motion(entity: EntityState, delta: float) -> void:
	entity.state_timer -= delta
	if entity.state_timer > 0.0:
		return
	if entity.variant == 0:
		entity.variant = 1
		entity.state_timer = 2.0
		var projectile := _add_entity(_level_state, ENTITY_PROJECTILE, entity.world_x, entity.world_y - 12.0)
		var aim := Vector2(_player_state.world_x - entity.world_x, (_player_state.world_y - 20.0) - entity.world_y)
		if aim.length_squared() > 0.0:
			aim = aim.normalized() * 150.0
		projectile.velocity_x = aim.x
		projectile.velocity_y = aim.y
	else:
		entity.variant = 0
		entity.state_timer = 2.0

func _update_mouse_motion(entity: EntityState, delta: float) -> void:
	var direction := signf(entity.velocity_x)
	if is_zero_approx(direction):
		direction = 1.0
	var player_delta := _player_state.world_x - entity.world_x
	var threat := absf(player_delta) < 100.0 and signf(player_delta) == direction
	var speed := 192.0 if threat else 48.0
	entity.velocity_x = direction * speed
	entity.world_x += entity.velocity_x * delta
	if entity.world_x <= entity.patrol_min_x:
		entity.world_x = entity.patrol_min_x
		entity.velocity_x = absf(speed)
	elif entity.world_x >= entity.patrol_max_x:
		entity.world_x = entity.patrol_max_x
		entity.velocity_x = -absf(speed)

func _update_circus_motion(entity: EntityState, delta: float) -> void:
	entity.state_timer -= delta
	if entity.state_timer > 0.0:
		return
	if entity.variant == 0:
		entity.variant = 1
		entity.state_timer = 0.7
		var projectile := _add_entity(_level_state, ENTITY_PROJECTILE, entity.world_x, entity.world_y - 16.0)
		projectile.enemy_profile = 4
		projectile.velocity_x = signf(_player_state.world_x - entity.world_x) * 72.0
		projectile.velocity_y = -170.0
	else:
		entity.variant = 0
		entity.state_timer = 1.5

func _update_yado_motion(entity: EntityState, delta: float) -> void:
	entity.state_timer -= delta
	if entity.state_timer > 0.0:
		return
	entity.state_timer = 2.0
	entity.variant = 1
	var projectile := _add_entity(_level_state, ENTITY_PROJECTILE, entity.world_x, entity.world_y - 6.0)
	projectile.velocity_x = -150.0 if _player_state.world_x < entity.world_x else 150.0
	projectile.velocity_y = 0.0

func _update_hammerhead_motion(entity: EntityState, delta: float) -> void:
	entity.previous_world_y = entity.world_y
	entity.state_timer = fmod(entity.state_timer + delta * 1.5, TAU)
	entity.world_y = entity.origin_y + sin(entity.state_timer) * 30.0

func _update_straw_motion(entity: EntityState, delta: float) -> void:
	entity.state_timer -= delta
	if entity.state_timer <= 0.0:
		entity.state_timer = 1.6
	var target := Vector2(_player_state.world_x, _player_state.world_y - 24.0)
	var offset := target - Vector2(entity.world_x, entity.world_y)
	if offset.length_squared() > 1.0:
		var desired := offset.normalized() * 110.0
		entity.velocity_x = move_toward(entity.velocity_x, desired.x, 140.0 * delta)
		entity.velocity_y = move_toward(entity.velocity_y, desired.y, 140.0 * delta)
	entity.world_x += entity.velocity_x * delta
	entity.world_y += entity.velocity_y * delta
	entity.world_x = clampf(entity.world_x, _level_state.min_x, _level_state.max_x)
	entity.world_y = clampf(entity.world_y, _level_state.min_y + 32.0, _level_state.max_y - 32.0)

func _update_buzzer_motion(entity: EntityState, delta: float) -> void:
	# Buzzer patrols, lunges at a nearby player, then returns to its flight path.
	if entity.variant == 0:
		entity.state_timer += delta
		entity.world_x += entity.velocity_x * delta
		entity.world_y = entity.origin_y + sin(entity.state_timer * 5.0) * 8.0
		if entity.world_x <= entity.patrol_min_x:
			entity.world_x = entity.patrol_min_x
			entity.velocity_x = abs(entity.velocity_x)
		if entity.world_x >= entity.patrol_max_x:
			entity.world_x = entity.patrol_max_x
			entity.velocity_x = -abs(entity.velocity_x)
		var dx := _player_state.world_x - entity.world_x
		var dy := (_player_state.world_y - 20.0) - entity.world_y
		if _player_state.is_alive and absf(dx) < 90.0 and absf(dy) < 55.0:
			entity.variant = 1
			entity.state_timer = 0.30
			entity.target_x = _player_state.world_x
			entity.target_y = _player_state.world_y - 20.0
			entity.velocity_x = (entity.target_x - entity.world_x) / entity.state_timer
			entity.velocity_y = (entity.target_y - entity.world_y) / entity.state_timer
	elif entity.variant == 1:
		entity.world_x += entity.velocity_x * delta
		entity.world_y += entity.velocity_y * delta
		entity.state_timer -= delta
		if entity.state_timer <= 0.0:
			entity.variant = 2
			entity.state_timer = 0.42
			entity.velocity_x = (entity.origin_x - entity.world_x) / entity.state_timer
			entity.velocity_y = (entity.origin_y - entity.world_y) / entity.state_timer
	else:
		entity.world_x += entity.velocity_x * delta
		entity.world_y += entity.velocity_y * delta
		entity.state_timer -= delta
		if entity.state_timer <= 0.0:
			entity.variant = 0
			entity.world_x = clampf(entity.origin_x, entity.patrol_min_x, entity.patrol_max_x)
			entity.world_y = entity.origin_y
			entity.velocity_y = 0.0
			entity.velocity_x = -abs(entity.velocity_x) if entity.world_x >= entity.patrol_max_x else abs(entity.velocity_x)

func _update_balloon_motion(entity: EntityState, delta: float) -> void:
	if entity.variant == 0:
		entity.state_timer -= delta
		entity.world_x += entity.velocity_x * delta
		entity.world_y = entity.origin_y + sin((1.2 - entity.state_timer) * 5.0) * 12.0
		if entity.world_x <= entity.patrol_min_x:
			entity.world_x = entity.patrol_min_x
			entity.velocity_x = abs(entity.velocity_x)
		if entity.world_x >= entity.patrol_max_x:
			entity.world_x = entity.patrol_max_x
			entity.velocity_x = -abs(entity.velocity_x)
		if entity.state_timer <= 0.0:
			entity.variant = 1
			entity.state_timer = 0.45
			entity.activated = false
	elif entity.variant == 1:
		entity.state_timer -= delta
		if not entity.activated and entity.state_timer <= 0.24:
			entity.activated = true
			_spawn_balloon_projectile(entity)
		if entity.state_timer <= 0.0:
			entity.variant = 0
			entity.state_timer = 1.2
			entity.activated = false

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
	if entity.variant == 0:
		entity.state_timer -= delta
		var elapsed := 2.0 - entity.state_timer
		entity.world_x = entity.origin_x + sin(elapsed * 5.0) * 48.0
		entity.world_y = entity.origin_y + sin(elapsed * 3.0) * 28.0
		if entity.state_timer <= 0.0:
			entity.variant = 1
			entity.state_timer = 0.55
			entity.activated = false
	else:
		entity.state_timer -= delta
		if not entity.activated and entity.state_timer <= 0.30:
			entity.activated = true
			_spawn_bullet_buzzer_projectiles(entity)
		if entity.state_timer <= 0.0:
			entity.variant = 0
			entity.state_timer = 2.0
			entity.activated = false

func _update_koura_motion(entity: EntityState, delta: float) -> void:
	entity.world_x += entity.velocity_x * delta
	entity.world_y = entity.origin_y + sin(Time.get_ticks_msec() * 0.004) * 4.0
	if entity.world_x <= entity.patrol_min_x:
		entity.world_x = entity.patrol_min_x
		entity.velocity_x = abs(entity.velocity_x)
	if entity.world_x >= entity.patrol_max_x:
		entity.world_x = entity.patrol_max_x
		entity.velocity_x = -abs(entity.velocity_x)

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
		entity.state_timer -= delta
		var elapsed := 1.8 - entity.state_timer
		entity.world_y = entity.origin_y + sin(elapsed * 3.2) * 34.0
		if entity.state_timer <= 0.0:
			entity.variant = 1
			entity.state_timer = 0.45
			entity.activated = false
	else:
		entity.state_timer -= delta
		if not entity.activated and entity.state_timer <= 0.20:
			entity.activated = true
			_spawn_kiki_projectile(entity)
		if entity.state_timer <= 0.0:
			entity.variant = 0
			entity.state_timer = 1.8
			entity.activated = false

func _update_kiki_projectile(entity: EntityState, delta: float) -> void:
	entity.state_timer -= delta
	entity.velocity_y += 520.0 * delta
	entity.world_x += entity.velocity_x * delta
	entity.world_y += entity.velocity_y * delta
	if entity.world_y >= _level_state.ground_y - 8.0 or entity.state_timer <= 0.0:
		_split_kiki_projectile(entity)

func _update_kiki_piece(entity: EntityState, delta: float) -> void:
	entity.state_timer -= delta
	entity.velocity_y += 520.0 * delta
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
	var projectile := _add_entity(_level_state, ENTITY_KIKI_PROJECTILE, source.world_x, source.world_y + 12.0)
	projectile.velocity_y = -260.0
	projectile.velocity_x = clampf((_player_state.world_x - source.world_x) * 0.6, -120.0, 120.0)
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
			platform.crumble_timer = maxf(0.0, platform.crumble_timer - delta)
			if platform.crumble_timer <= 0.0:
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
				if platform.crumble_delay >= 0.0 and platform.crumble_timer < 0.0:
					platform.crumble_timer = platform.crumble_delay
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
				if platform.crumble_delay >= 0.0 and platform.crumble_timer < 0.0:
					platform.crumble_timer = platform.crumble_delay
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
	_game_over_timer = 3.6 if _run_from_time_attack else 4.6
	_game_over_input_lock_timer = 1.6 if _run_from_time_attack else 2.2
	_status_text = "TIME OVER" if time_over else "GAME OVER"

func _handle_entity_interactions(held_input: int, delta: float) -> void:
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
			ENTITY_BOUNCY_SPRING:
				_try_bouncy_spring(entity, delta)
			ENTITY_CONVEYOR:
				_try_conveyor(entity, delta)
			ENTITY_LAYER_TOGGLE:
				_try_layer_toggle(entity)
			ENTITY_RAMP:
				_try_ramp(entity)
			ENTITY_ROTATING_HANDLE:
				_try_rotating_handle(entity, held_input, delta)
			ENTITY_CORK_SCREW:
				_try_corkscrew(entity, delta)
			ENTITY_CANNON:
				_try_cannon(entity, held_input, delta)
			ENTITY_LAUNCHER:
				_try_launcher(entity, held_input, delta)
			ENTITY_PIPE_START:
				_try_pipe_start(entity, delta)
			ENTITY_HOOK_RAIL:
				_try_hook_rail(entity, delta)
			ENTITY_SPIKES:
				_try_spikes(entity)
			ENTITY_SPIKE_PLATFORM:
				_try_spike_platform(entity)
			ENTITY_TURNAROUND_BAR:
				_try_turnaround_bar(entity)
			ENTITY_KEYBOARD:
				_try_keyboard(entity)
			ENTITY_POLE:
				_try_pole(entity, held_input)
			ENTITY_LIGHT_GLOBE:
				_try_light_globe(entity)
			ENTITY_WINDUP_STICK:
				_try_windup_stick(entity)
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
	var dx: float = _player_state.world_x - entity.world_x
	var dy: float = (_player_state.world_y - 20.0) - entity.world_y
	if dx * dx + dy * dy <= 24.0 * 24.0:
		entity.active = false
		entity.collected = true
		_player_state.special_rings = min(7, _player_state.special_rings + 1)

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
	if absf(dx) > half_width or absf(dy) > half_height:
		return
	# Sky Canyon's whirlwind centers the player before lifting them upward.
	_player_state.world_x = move_toward(_player_state.world_x, entity.world_x, 90.0 * delta)
	var top_limit := entity.world_y - half_height + _player_half_height
	if _player_state.world_y > top_limit:
		_velocity_y = -300.0
	else:
		_velocity_y = minf(_velocity_y, -80.0)
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
	var fan_force := 1.0
	if entity.variant == 1:
		# sky_canyon/fan.c cycles off, accelerate, full, and decelerate
		# over seven seconds for periodic fans.
		if entity.state_timer < 1.0:
			fan_force = 0.0
		elif entity.state_timer < 2.0:
			fan_force = entity.state_timer - 1.0
		elif entity.state_timer < 6.0:
			fan_force = 1.0
		else:
			fan_force = 7.0 - entity.state_timer
	if fan_force <= 0.0:
		return
	var resistance := 1.0
	if entity.velocity_x > 0.0 and held_input & DPAD_LEFT:
		resistance = 0.25
	elif entity.velocity_x < 0.0 and held_input & DPAD_RIGHT:
		resistance = 0.25
	_player_state.world_x += entity.velocity_x * 150.0 * fan_force * resistance * delta
	_player_state.speed_x = entity.velocity_x * 150.0 * fan_force * resistance

func _try_propeller(entity: EntityState, held_input: int, delta: float) -> void:
	var half_width := entity.width * 0.5
	var half_height := entity.height * 0.5
	var dx := _player_state.world_x - entity.world_x
	var player_center_y := _player_state.world_y - 20.0
	var dy := player_center_y - entity.world_y
	var in_current := absf(dx) <= half_width and absf(dy) <= half_height

	if entity.variant == 1:
		if not in_current:
			entity.variant = 0
			_velocity_y = -240.0
			_player_state.char_state = 2
			_player_state.anim_id = 2
			return
		var steering := 0.0
		if held_input & DPAD_LEFT:
			steering -= 1.0
		if held_input & DPAD_RIGHT:
			steering += 1.0
		entity.velocity_x = move_toward(entity.velocity_x, steering * 180.0, 480.0 * delta)
		_player_state.world_x += entity.velocity_x * delta
		_player_state.world_x = clampf(_player_state.world_x, _level_state.min_x, _level_state.max_x)
		_player_state.world_y = move_toward(_player_state.world_y, entity.world_y - 28.0, 240.0 * delta)
		_velocity_y = 0.0
		_player_state.is_grounded = false
		_player_state.speed_x = entity.velocity_x
		_player_state.speed_y = 0.0
		_player_state.char_state = 4
		_player_state.anim_id = 2
		return

	if in_current:
		entity.variant = 1
		entity.velocity_x = 0.0
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
	var boost_speed := 520.0 * signf(entity.velocity_x)
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
	_dash_velocity_x = cos(angle) * 620.0
	_dash_velocity_y = sin(angle) * 620.0
	_dash_timer = 0.85
	_boost_effect_timer = 0.85
	_player_state.world_x += _dash_velocity_x * delta
	_player_state.world_y += _dash_velocity_y * delta
	_player_state.speed_x = _dash_velocity_x
	_player_state.speed_y = _dash_velocity_y
	_player_state.is_grounded = false
	_player_state.char_state = 5
	_player_state.anim_id = 2
	entity.activated = true

func _try_grind_rail(entity: EntityState) -> void:
	if _grind_timer > 0.0 or _dash_timer > 0.0 or _velocity_y < 0.0:
		return
	var half_width := entity.width * 0.5
	var dx := _player_state.world_x - entity.world_x
	var dy := _player_state.world_y - entity.world_y
	if absf(dx) > half_width or dy < -32.0 or dy > 28.0:
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
		var bar_inside := absf(_player_state.world_x - entity.world_x) <= entity.width * 0.5 and absf(_player_state.world_y - entity.world_y) <= entity.height * 0.5 + _player_half_height
		if not bar_inside:
			entity.activated = false
			entity.state_timer = 0.0
			return
		if not entity.activated:
			entity.activated = true
			entity.state_timer = 0.22
			entity.target_x = absf(_player_state.world_x - entity.world_x)
			_velocity_y = 0.0
			_player_state.is_grounded = false
		if entity.state_timer > 0.0:
			entity.state_timer = maxf(0.0, entity.state_timer - delta)
			_player_state.world_y = entity.world_y - entity.height * 0.5 - 1.0
			if entity.state_timer <= 0.0:
				_velocity_y = -540.0 - minf(180.0, entity.target_x * 2.0)
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
	var rebound := clampf(maxf(420.0, absf(_velocity_y) * entity.bounce_strength), 420.0, 680.0)
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

func _try_ramp(entity: EntityState) -> void:
	if not _player_state.is_grounded:
		return
	var inside := absf(_player_state.world_x - entity.world_x) <= entity.width * 0.5 and absf(_player_state.world_y - entity.world_y) <= entity.height * 0.5 + _player_half_height
	if not inside:
		return
	var direction := -1.0 if entity.variant == 1 else 1.0
	if absf(_player_state.speed_x) < 120.0:
		return
	_velocity_y = -330.0
	_player_state.speed_x = maxf(absf(_player_state.speed_x), 300.0) * direction
	_player_state.ground_speed = _player_state.speed_x
	_player_state.is_grounded = false
	_player_state.char_state = 5
	entity.activated = true

func _try_rotating_handle(entity: EntityState, _held_input: int, delta: float) -> void:
	var dx := _player_state.world_x - entity.world_x
	var dy := _player_state.world_y - entity.world_y
	if entity.activated:
		entity.state_timer += delta
		var progress := clampf(entity.state_timer / 0.85, 0.0, 1.0)
		var angle := lerpf(-PI * 0.5, PI * 0.65, progress)
		_player_state.world_x = entity.world_x + cos(angle) * 54.0
		_player_state.world_y = entity.world_y + sin(angle) * 54.0
		_player_state.is_grounded = false
		_player_state.char_state = 5
		if progress >= 1.0:
			entity.activated = false
			entity.state_timer = 0.0
			_velocity_y = -360.0
			_player_state.speed_x = 300.0
			_player_state.ground_speed = 300.0
		return
	if absf(dx) > 42.0 or absf(dy) > 42.0:
		return
	entity.activated = true
	entity.state_timer = 0.0
	_velocity_y = 0.0
	_player_state.speed_x = 0.0
	_player_state.speed_y = 0.0

func _try_corkscrew(entity: EntityState, delta: float) -> void:
	if entity.variant == 1:
		if _corkscrew_timer > 0.0 and absf(_player_state.world_x - entity.world_x) <= 48.0 and absf(_player_state.world_y - entity.world_y) <= 64.0:
			_corkscrew_timer = 0.0
		return
	if _corkscrew_timer > 0.0:
		_corkscrew_timer = maxf(0.0, _corkscrew_timer - delta)
		var progress := 1.0 - (_corkscrew_timer / 1.8)
		var angle := progress * TAU * 1.5 * _corkscrew_direction
		_player_state.world_x = _corkscrew_origin.x + progress * 160.0 * _corkscrew_direction
		_player_state.world_y = _corkscrew_origin.y + sin(angle) * (46.0 * (1.0 - progress * 0.35))
		_player_state.speed_x = 160.0 * _corkscrew_direction
		_player_state.speed_y = 0.0
		_player_state.is_grounded = false
		_player_state.char_state = 5
		if _corkscrew_timer <= 0.0:
			_player_state.speed_x = 260.0 * _corkscrew_direction
			_player_state.ground_speed = _player_state.speed_x
		return
	var dx := _player_state.world_x - entity.world_x
	var dy := _player_state.world_y - entity.world_y
	if absf(dx) > 36.0 or absf(dy) > 48.0:
		return
	_corkscrew_timer = 1.8
	_corkscrew_origin = Vector2(entity.world_x, entity.world_y)
	_corkscrew_direction = 1.0 if _player_state.speed_x >= 0.0 else -1.0
	_player_state.is_grounded = false
	_player_state.char_state = 5

func _try_cannon(entity: EntityState, held_input: int, delta: float) -> void:
	var dx := _player_state.world_x - entity.world_x
	var dy := _player_state.world_y - entity.world_y
	if entity.cannon_active:
		entity.cannon_timer += delta
		var aim_offset := sin(entity.cannon_timer * 2.4) * (PI * 0.25)
		entity.cannon_angle = aim_offset if entity.cannon_facing_right else PI - aim_offset
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
	entity.cannon_active = true
	entity.cannon_timer = 0.0
	_player_state.speed_x = 0.0
	_player_state.speed_y = 0.0
	_velocity_y = 0.0

func _try_launcher(entity: EntityState, _held_input: int, delta: float) -> void:
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
			_player_state.char_state = 0
			_player_state.is_grounded = true
		return
	if absf(_player_state.world_x - entity.world_x) > 24.0 or absf(_player_state.world_y - entity.world_y) > 24.0:
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
	_player_state.speed_x = 0.0
	_player_state.speed_y = 0.0
	_velocity_y = 0.0

func _try_hook_rail(entity: EntityState, delta: float) -> void:
	if entity.variant != 0:
		return
	if _hook_active:
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
	if absf(_player_state.world_x - entity.world_x) > entity.width * 0.5 or absf(_player_state.world_y - entity.world_y) > 24.0:
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
	if _velocity_y < 0.0:
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
	_velocity_y = launch.y
	if entity.flying_spring:
		entity.flying_spring_trigger_timer = 0.85
	_player_state.speed_x = launch.x
	_player_state.world_x += launch.x * delta
	_player_state.world_y = min(_player_state.world_y, entity.world_y - half_height - 1.0) if launch.y < 0.0 else _player_state.world_y
	_player_state.is_grounded = false
	_player_state.char_state = 2
	_player_state.anim_id = 2

func _try_hit_enemy(entity: EntityState) -> void:
	if _damage_cooldown > 0.0:
		return
	var dx: float = abs(_player_state.world_x - entity.world_x)
	var dy: float = abs((_player_state.world_y - 20.0) - entity.world_y)
	if dx < 20.0 and dy < 22.0:
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
	if absf(_player_state.world_x - entity.world_x) > 12.0 or absf(_player_state.world_y - entity.world_y) > 32.0:
		return
	entity.turnaround_direction = signf(_player_state.ground_speed)
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
	_player_state.char_state = 5
	_player_state.rotation = 0
	var gravity_direction := -1.0 if _gravity_inverted else 1.0
	if entity.keyboard_type == 0:
		_player_state.speed_x = entity.velocity_x * 210.0
		_velocity_y = -430.0 * gravity_direction
	else:
		_player_state.speed_x = (-1.0 if entity.keyboard_type == 1 else 1.0) * 330.0
		_velocity_y = (1.0 if entity.velocity_y >= 0.0 else -1.0) * 360.0 * gravity_direction
	_player_state.ground_speed = _player_state.speed_x
	_player_state.speed_y = _velocity_y

func _try_pole(entity: EntityState, held_input: int) -> void:
	var dx := absf(_player_state.world_x - entity.world_x)
	var dy := absf(_player_state.world_y - entity.world_y)
	if entity.pole_sliding:
		_player_state.world_x = entity.world_x
		_player_state.world_y = entity.world_y
		_player_state.is_grounded = false
		_player_state.speed_x = 0.0
		_velocity_y = 0.0
		return
	if dx > entity.width * 0.5 + 14.0 or dy > entity.height * 0.5 + 20.0:
		return
	if _player_state.is_grounded and absf(_player_state.speed_x) < 20.0:
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
	if _frame_input & A_BUTTON:
		entity.pole_sliding = false
		_player_state.speed_x = -300.0 if held_input & DPAD_LEFT else 300.0
		_velocity_y = -330.0
		_player_state.speed_y = _velocity_y
		_player_state.char_state = 5

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

func _try_windup_stick(entity: EntityState) -> void:
	if entity.windup_stick_timer > 0.0:
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
	_player_state.world_y = entity.world_y
	_player_state.rotation = 0
	if rising:
		_velocity_y = -520.0
		_player_state.is_grounded = false
	elif falling:
		_velocity_y = 260.0
		_player_state.is_grounded = false
	else:
		_player_state.ground_speed = -_player_state.speed_x if absf(_player_state.speed_x) > 1.0 else 240.0
		_player_state.speed_x = _player_state.ground_speed
		_velocity_y = -180.0
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
	if offset.x < 0.0 and offset.y < 0.0:
		bit = 1
	elif offset.x >= 0.0 and offset.y < 0.0:
		bit = 2
	elif offset.x < 0.0 and offset.y >= 0.0:
		bit = 4
	else:
		bit = 8
	if entity.small_windmill_type != 0 and (entity.small_windmill_type & bit) == 0:
		return
	entity.small_windmill_angle = atan2(offset.y, offset.x)
	entity.small_windmill_timer = 0.0001
	entity.activated = true
	_player_state.is_grounded = false
	_player_state.char_state = 8

func _try_chord(entity: EntityState) -> void:
	if entity.chord_timer > 0.0:
		return
	var dx := absf(_player_state.world_x - entity.world_x)
	var dy := absf((_player_state.world_y - 20.0) - entity.world_y)
	if dx > 30.0 or dy > 28.0:
		return
	entity.chord_timer = 0.35
	entity.activated = true
	_player_state.is_grounded = false
	_velocity_y = -590.0
	_player_state.speed_y = _velocity_y
	_player_state.char_state = 5
	_player_state.rotation = 0

func _try_half_pipe(entity: EntityState) -> void:
	if entity.half_pipe_active or not _player_state.is_grounded:
		return
	var dx := _player_state.world_x - entity.world_x
	var dy := _player_state.world_y - entity.world_y
	if absf(dx) > entity.width * 0.5 or absf(dy) > entity.height * 0.5:
		return
	if entity.half_pipe_direction > 0.0 and _player_state.speed_x < 220.0:
		return
	if entity.half_pipe_direction < 0.0 and _player_state.speed_x > -220.0:
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
	entity.activated = true
	_player_state.world_x = entity.crane_hook_x
	_player_state.world_y = entity.crane_hook_y
	_player_state.is_grounded = false
	_player_state.speed_x = 0.0
	_velocity_y = 0.0
	_player_state.char_state = 8

func _try_ceiling_slope(entity: EntityState) -> void:
	if entity.ceiling_slope_timer > 0.0 or _player_state.is_grounded or _velocity_y >= 0.0:
		return
	var dx := absf(_player_state.world_x - entity.world_x)
	var dy := absf((_player_state.world_y - 20.0) - entity.world_y)
	if dx > entity.width * 0.5 + 14.0 or dy > entity.height * 0.5 + 20.0:
		return
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
	if entity.gapped_loop_direction > 0.0 and _player_state.speed_x < 200.0:
		return
	if entity.gapped_loop_direction < 0.0 and _player_state.speed_x > -200.0:
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
	if entity.funnel_sphere_timer > 0.0 or not _player_state.is_grounded:
		return
	var dx := _player_state.world_x - entity.world_x
	var dy := _player_state.world_y - entity.world_y
	if dx * dx + dy * dy > 20.0 * 20.0:
		return
	entity.funnel_sphere_direction = 1.0 if _player_state.speed_x < 320.0 else -1.0
	entity.funnel_sphere_timer = 0.0001
	entity.activated = true
	_player_state.is_grounded = false
	_player_state.char_state = 8

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

	var dx: float = abs(_player_state.world_x - entity.world_x)
	var dy: float = abs(_player_state.world_y - entity.world_y)
	if dx < 28.0 and dy < 64.0:
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

	_camera_state.x = clamp(_player_state.world_x, viewport.x * 0.5, _level_state.max_x - viewport.x * 0.5) + _screen_shake_offset.x
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
	_speed_up_timer = 0.0
	_magnetic_shielded = false
	_defeat_score_index = 0
	_attack_timer = 0.0
	_flight_timer = 0.0
	_glide_timer = 0.0
	_update_camera()

func save_checkpoint(x: float, y: float) -> void:
	_respawn_x = x
	_respawn_y = y
	_checkpoint_time = _elapsed_time

func get_status_text() -> String:
	return _status_text

func get_hud_titles() -> Dictionary:
	if _run_from_multiplayer:
		return {
			"score": "PTS",
			"rings": "RINGS",
			"time": "TIME",
			"lives": "VS",
		}
	return {
		"score": "SCORE",
		"rings": "RINGS",
		"time": "TIME",
		"lives": "LIFE",
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
	return is_touch_device() and is_mobile_platform()

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
	return {
		"confirm": confirm_text,
		"back": back_text,
		"left": left_text,
		"right": right_text,
		"up": up_text,
		"down": down_text,
	}

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
		return {"confirm": "Next", "back": "Skip"}
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
		if get_game_over_title_text() == "TIME OVER" and not _run_from_time_attack:
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
			var items := get_title_menu_items()
			if _title_menu_index >= 0 and _title_menu_index < items.size():
				var item_text := str(items[_title_menu_index])
				if item_text.contains("BACK"):
					return {"confirm": "Back", "back": "Back"}
				if item_text.contains("START"):
					return {"confirm": "Start", "back": "Back"}
				if item_text.contains("OPTIONS"):
					return {"confirm": "Open", "back": "Back"}
			return {"confirm": "Open", "back": "Back"}
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
			var result_items := get_singlepak_results_items()
			if _singlepak_results_cursor >= 0 and _singlepak_results_cursor < result_items.size():
				var result_text := str(result_items[_singlepak_results_cursor])
				return {"confirm": "Continue" if result_text.contains("CONTINUE") else ("Rematch" if result_text.contains("REMATCH") else "Back"), "back": "Back"}
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
			return "%s OR %s TO START" % [get_confirm_label(), "Z"]
		TITLE_PHASE_PLAY_MODE:
			return "%s SELECT   %s CONFIRM   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
		TITLE_PHASE_SINGLE_PLAYER:
			return "%s SELECT   %s CONFIRM   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
		TITLE_PHASE_MULTI_PLAYER:
			return "%s SELECT   %s CONFIRM   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
		TITLE_PHASE_TIME_ATTACK:
			return "%s SELECT   %s CONFIRM   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
		TITLE_PHASE_TINY_CHAO_GARDEN:
			return "%s SELECT   %s CONFIRM   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
		TITLE_PHASE_MULTI_CONNECT:
			return "%s SELECT   %s CONFIRM   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
		TITLE_PHASE_TINY_CHAO_SETUP:
			return "%s SELECT   %s CONFIRM   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
		TITLE_PHASE_SINGLEPAK_SYNC:
			return "%s SELECT   %s CONFIRM   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
		TITLE_PHASE_SINGLEPAK_RESULTS:
			return "%s SELECT   %s CONFIRM   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
		TITLE_PHASE_MULTIPLAYER_LOBBY:
			return "%s SELECT   %s CONFIRM   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
		TITLE_PHASE_TIME_ATTACK_LOBBY:
			return "%s SELECT   %s CONFIRM   LEFT/RIGHT COURSE   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
		TITLE_PHASE_COURSE_SELECT:
			if is_course_select_starting():
				return "STARTING STAGE..."
			if is_course_select_busy():
				return "COURSE MOVING..."
			return "LEFT/RIGHT COURSE   %s START   %s BACK" % [get_confirm_label(), get_secondary_label()]
		TITLE_PHASE_MULTIPLAYER_OUTCOME:
			return "%s CONTINUE   %s SKIP" % [get_confirm_label(), get_secondary_label()]
	return "%s SELECT, %s TO BEGIN, %s OPTIONS" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]

func get_press_start_title_text() -> String:
	return get_title_text()

func get_press_start_prompt_text() -> String:
	if not _title_notice_text.is_empty():
		return _title_notice_text
	return get_title_prompt_text()

func get_press_start_subtitle_text() -> String:
	return "HIGH-SPEED ACTION"

func get_press_start_info_rows() -> Array:
	return [
		{
			"text": "SINGLE PLAYER   MULTIPLAYER",
			"position": Vector2(292.0, 382.0),
			"color": Color(0.22, 0.42, 0.78, 0.94),
			"pulse": false,
		},
		{
			"text": "PRESS START",
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
					open_character_select(CHARACTER_SELECT_CONTEXT_TIME_ATTACK_ZONE)
					return
				1:
					if not _boss_time_attack_unlocked:
						_title_notice_text = "BOSS TIME ATTACK LOCKED"
						return
					open_character_select(CHARACTER_SELECT_CONTEXT_TIME_ATTACK_BOSS)
					return
		TITLE_PHASE_TIME_ATTACK_LOBBY:
			match _time_attack_lobby_cursor:
				0:
					_begin_level_run(_selected_level_index, true)
					return
				1:
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
	_name_entry_menu_index = 0
	_name_entry_cursor_col = 0
	_name_entry_cursor_row = 0
	_name_entry_matrix_page_index = 0
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
			if _time_records_context == TIME_RECORDS_CONTEXT_OPTIONS and _time_records_view == TIME_RECORDS_VIEW_COURSES and not _time_records_boss_mode:
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
			var option_items := get_options_menu_items()
			var option_label := ""
			if _options_menu_index >= 0 and _options_menu_index < option_items.size():
				option_label = str(option_items[_options_menu_index])
			match option_label:
				"PLAYER DATA":
					_options_mode = OPTIONS_MODE_PLAYER_DATA
					_player_data_menu_index = 0
				"DIFFICULTY":
					_options_mode = OPTIONS_MODE_DIFFICULTY
				"TIME LIMIT":
					_options_mode = OPTIONS_MODE_TIME_LIMIT
				"LANGUAGE":
					_language_index_before_edit = _language_index
					_options_mode = OPTIONS_MODE_LANGUAGE
				"BUTTON CONFIG":
					_options_mode = OPTIONS_MODE_BUTTON_CONFIG
					_button_config_index = 0
					_button_bindings_before_edit = _button_bindings.duplicate()
				"SOUND TEST":
					_options_mode = OPTIONS_MODE_SOUND_TEST
					_sound_test_menu_index = 0
					_sound_test_state = SOUND_TEST_STATE_STOPPED
				"DELETE GAME DATA":
					_options_mode = OPTIONS_MODE_DELETE_CONFIRM
					_delete_confirm_index = 1
				"EXIT":
					_persist_frontend_state()
					open_title_screen_at_single_player_menu(0)
					return
		OPTIONS_MODE_PLAYER_DATA:
			match _player_data_menu_index:
				0:
					_options_mode = OPTIONS_MODE_NAME_ENTRY
					_name_entry_menu_index = 0
					_name_entry_cursor_col = 0
					_name_entry_cursor_row = 0
					_name_entry_matrix_page_index = 0
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
				_name_entry_menu_index = 0
				_name_entry_cursor_col = 0
				_name_entry_cursor_row = 0
				_name_entry_matrix_page_index = 0
				_options_mode = OPTIONS_MODE_NAME_ENTRY
				_status_text = "NAME ENTRY"
			else:
				_options_mode = OPTIONS_MODE_MAIN
				_options_menu_index = 3
		OPTIONS_MODE_BUTTON_CONFIG:
			match _button_config_index:
				0:
					_finalize_button_config_a_stage()
					update_save_menu_status()
					return
				1:
					_finalize_button_config_b_stage()
					update_save_menu_status()
					return
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
					_button_config_index = 0
				2:
					# B from the R stage returns directly to the A stage.
					_button_config_index = 0
			update_save_menu_status()
		OPTIONS_MODE_SOUND_TEST:
			if _sound_test_state == SOUND_TEST_STATE_PLAYING:
				_sound_test_state = SOUND_TEST_STATE_STOPPED
			else:
				_options_mode = OPTIONS_MODE_MAIN
				_options_menu_index = 5
			update_save_menu_status()
		OPTIONS_MODE_DIFFICULTY:
			_options_mode = OPTIONS_MODE_MAIN
			_options_menu_index = 1
			update_save_menu_status()
		OPTIONS_MODE_TIME_LIMIT:
			_options_mode = OPTIONS_MODE_MAIN
			_options_menu_index = 2
			update_save_menu_status()
		OPTIONS_MODE_DELETE_CONFIRM, OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			_options_mode = OPTIONS_MODE_MAIN
			_options_menu_index = _get_options_item_index("DELETE GAME DATA")
			update_save_menu_status()
		OPTIONS_MODE_TIME_RECORDS:
			if _time_records_context == TIME_RECORDS_CONTEXT_TIME_ATTACK:
				open_character_select(CHARACTER_SELECT_CONTEXT_TIME_ATTACK_BOSS if _time_records_boss_mode else CHARACTER_SELECT_CONTEXT_TIME_ATTACK_ZONE)
				_selected_character_index = _time_records_character_index
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

func clear_replay() -> void:
	if _game_state != GAME_STATE_CLEAR or not is_clear_input_ready():
		return
	if _run_from_time_attack:
		open_time_attack_lobby(_time_attack_boss_mode)


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
			"description": "STORY, STAGES AND SOLO PROGRESSION",
			"status": "READY",
			"selected": _title_menu_index == 0,
		},
		{
			"name": _language_text("MULTI PLAYER", "MEHRSPIELER", "MULTIJOUEUR", "MULTIJUGADOR", "MULTIGIOCATORE"),
			"description": "LINK RACES, BATTLES AND SHARED RESULTS",
			"status": "READY" if has_profile_name() else "NAME REQ",
			"selected": _title_menu_index == 1,
		},
	]

func get_play_mode_title_text() -> String:
	return _language_text("PLAY MODE", "SPIELMODUS", "MODE DE JEU", "MODO DE JUEGO", "MODALITA DI GIOCO")

func get_play_mode_prompt_text() -> String:
	if not _title_notice_text.is_empty():
		return _title_notice_text
	return "SELECT A PLAY STYLE"

func get_play_mode_detail_text() -> String:
	return get_title_prompt_text()

func get_play_mode_info_text() -> String:
	if _title_menu_index == 0:
		return "START THE SINGLE-PLAYER FRONT END"
	return "OPEN THE MULTIPLAYER MODE SELECT"

func get_play_mode_summary_text() -> String:
	if _title_menu_index == 0:
		return "SINGLE PLAYER\nPROFILE: %s\nSTART POINT: %s" % [get_profile_name_text(), get_selected_level_text()]
	return "MULTIPLAYER\nPROFILE: %s\nNAME STATUS: %s" % [get_profile_name_text(), "READY" if has_profile_name() else "REQUIRED"]

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
			"description": "BEGIN THE MAIN ADVENTURE",
			"status": "READY",
			"selected": _title_menu_index == 0,
		},
		{
			"name": _language_text("TIME ATTACK", "ZEITANGRIFF", "CONTRE LA MONTRE", "CONTRARRELOJ", "ATTACCO A TEMPO"),
			"description": "RACE FOR THE FASTEST CLEAR TIME",
			"status": "READY",
			"selected": _title_menu_index == 1,
		},
		{
			"name": _language_text("OPTIONS", "OPTIONEN", "OPTIONS", "OPCIONES", "OPZIONI"),
			"description": "ADJUST SAVE DATA AND SYSTEM SETTINGS",
			"status": "SETUP",
			"selected": _title_menu_index == 2,
		},
	]
	if is_tiny_chao_unlocked():
		rows.append({
			"name": _language_text("TINY CHAO GARDEN", "KLEINER CHAO-GARTEN", "MINI JARDIN CHAO", "JARDIN CHAO", "GIARDINO CHAO"),
			"description": "OPEN THE HANDHELD CHAO GARDEN LINK",
			"status": "READY",
			"selected": _title_menu_index == 3,
		})
	return rows

func get_single_player_title_text() -> String:
	return _language_text("SINGLE PLAYER", "EINZELSPIELER", "JOUEUR SOLO", "UN JUGADOR", "GIOCATORE SINGOLO")

func get_single_player_prompt_text() -> String:
	if not _title_notice_text.is_empty():
		return _title_notice_text
	return "SELECT A MODE"

func get_single_player_detail_text() -> String:
	return get_title_prompt_text()

func get_single_player_info_text() -> String:
	match _title_menu_index:
		0:
			return "START A STANDARD STORY RUN"
		1:
			return "REPLAY CLEARED STAGES FOR BEST TIMES"
		2:
			return "PROFILE, SAVE, SOUND, AND CONTROL SETTINGS"
		3:
			if is_tiny_chao_unlocked():
				return "DIRECT HANDOFF TO TINY CHAO GARDEN"
	return "SELECT A MODE"

func get_single_player_summary_title() -> String:
	match _title_menu_index:
		0:
			return "GAME START"
		1:
			return "TIME ATTACK"
		2:
			return "OPTIONS"
		3:
			if is_tiny_chao_unlocked():
				return "TINY CHAO GARDEN"
	return "SINGLE PLAYER"

func get_single_player_summary_text() -> String:
	match _title_menu_index:
		0:
			return "MAIN GAME\nCURRENT RUNNER: %s\nSTART POINT: %s" % [get_selected_character_name(), get_selected_level_text()]
		1:
			return "TIME ATTACK\nBOSS ATTACK: %s\nBEST MODE: SOLO" % ["UNLOCKED" if _boss_time_attack_unlocked else "LOCKED"]
		2:
			return "SAVE OPTIONS\nPROFILE: %s\nLANGUAGE: %s" % [get_profile_name_text(), get_language_text()]
		3:
			if is_tiny_chao_unlocked():
				return "TINY CHAO GARDEN\nSESSION ID: %s\nSTATUS: READY" % _tiny_chao_session_id
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
	return [
		{
			"name": "MULTI-PAK",
			"description": "2-4 PLAYERS USING ONE GAME PAK EACH",
			"status": "READY" if has_profile_name() else "NAME REQ",
			"selected": _title_menu_index == 0,
		},
		{
			"name": "SINGLE-PAK",
			"description": "HOST A DOWNLOAD MATCH FROM ONE GAME PAK",
			"status": "READY" if has_profile_name() else "NAME REQ",
			"selected": _title_menu_index == 1,
		},
	]

func get_multiplayer_mode_title_text() -> String:
	return _language_text("SELECT PAK MODE", "PAK-MODUS", "MODE PAK", "MODO PAK", "MODALITA PAK")

func get_multiplayer_mode_prompt_text() -> String:
	if not _title_notice_text.is_empty():
		return _title_notice_text
	return "CHOOSE A LINK STYLE"

func get_multiplayer_mode_summary_text() -> String:
	if _title_menu_index == 0:
		return "MODE\nMULTI-PAK\n\nPLAYERS\n2-4 LINKED SYSTEMS\n\nPROFILE\n%s" % get_profile_name_text()
	return "MODE\nSINGLE-PAK\n\nPLAYERS\n1 HOST + CLIENT DOWNLOADS\n\nPROFILE\n%s" % get_profile_name_text()

func get_multiplayer_mode_detail_text() -> String:
	if has_profile_name():
		return "%s SELECT   %s CONFIRM   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
	return "PROFILE NAME REQUIRED BEFORE LINK PLAY\n%s SELECT   %s CONFIRM   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]

func get_multiplayer_mode_info_text() -> String:
	if _title_menu_index == 0:
		return "ONE GAME PAK PER PLAYER.\nSTART A STANDARD LINK SESSION."
	return "THE HOST SENDS THE CLIENT PROGRAM.\nBEST FOR QUICK LOCAL MATCHES."

func get_multiplayer_mode_badge_text() -> String:
	return "LINK" if _title_menu_index == 0 else "DL"

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
			"name": "ZONE",
			"description": "CLEAR A ZONE AS FAST AS POSSIBLE",
			"status": "READY",
			"selected": _title_menu_index == 0,
		},
		{
			"name": "BOSS",
			"description": "DEFEAT A BOSS AS FAST AS POSSIBLE",
			"status": "READY" if _boss_time_attack_unlocked else "LOCKED",
			"selected": _title_menu_index == 1,
		},
	]

func get_time_attack_mode_title_text() -> String:
	return _language_text("TIME ATTACK", "ZEITANGRIFF", "CONTRE LA MONTRE", "CONTRARRELOJ", "ATTACCO A TEMPO")

func get_time_attack_mode_prompt_text() -> String:
	if not _title_notice_text.is_empty():
		return _title_notice_text
	return "SELECT ATTACK MODE"

func get_time_attack_mode_detail_text() -> String:
	return "CLEAR RECORDS AND BOSS CHALLENGES\n%s SELECT   %s CONFIRM   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]

func get_time_attack_mode_summary_text() -> String:
	match _title_menu_index:
		0:
			return "ZONE TIME ATTACK\nCOURSE: %s\nCHARACTER: %s" % [get_selected_level_text(), get_selected_character_name()]
		1:
			return "BOSS TIME ATTACK\nSTATUS: %s\nCHARACTER: %s" % ["UNLOCKED" if _boss_time_attack_unlocked else "LOCKED", get_selected_character_name()]
	return ""

func get_time_attack_mode_info_text() -> String:
	if _title_menu_index == 1:
		if _boss_time_attack_unlocked:
			return "DEFEAT THE BOSS AS FAST AS POSSIBLE"
		return "CAN'T PLAY THIS YET"
	return "CLEAR THE ZONE AS FAST AS POSSIBLE"

func get_tiny_chao_rows() -> Array:
	if _title_phase == TITLE_PHASE_TINY_CHAO_GARDEN_PLAY:
		var rows: Array = []
		for i in range(_tiny_chao_roster.size()):
			var chao: Dictionary = _tiny_chao_roster[i]
			rows.append({
				"name": str(chao.get("name", "CHAO")),
				"description": "MOOD %03d%%   CARE %d" % [int(chao.get("mood", 0)), int(chao.get("care", 0))],
				"status": "FRUIT %d" % _tiny_chao_fruit if i == _tiny_chao_selected_index else "READY",
				"selected": i == _tiny_chao_selected_index,
			})
		return rows
	if _title_phase == TITLE_PHASE_TINY_CHAO_SETUP:
		return [
			{
				"name": "ENTER GARDEN",
				"description": "PREPARE THE HANDOFF DATA",
				"status": "READY",
				"selected": _title_menu_index == 0,
			},
			{
				"name": "NEW SESSION",
				"description": "BUILD A FRESH LINK TOKEN",
				"status": _tiny_chao_session_id,
				"selected": _title_menu_index == 1,
			},
			{
				"name": "BACK",
				"description": "RETURN TO TINY CHAO GARDEN",
				"status": "READY",
				"selected": _title_menu_index == 2,
			},
		]
	return [
		{
			"name": "ENTER GARDEN",
			"description": "OPEN THE TINY CHAO GARDEN HANDOFF",
			"status": "READY",
			"selected": _title_menu_index == 0,
		},
		{
			"name": "BACK",
			"description": "RETURN TO SINGLE PLAYER",
			"status": "READY",
			"selected": _title_menu_index == 1,
		},
	]

func get_tiny_chao_title_text() -> String:
	if _title_phase == TITLE_PHASE_TINY_CHAO_SETUP:
		return "TINY CHAO GARDEN"
	return "TINY CHAO GARDEN"

func get_tiny_chao_prompt_text() -> String:
	var notice := get_title_notice_text()
	if not notice.is_empty():
		return notice
	if _title_phase == TITLE_PHASE_TINY_CHAO_GARDEN_PLAY:
		return _tiny_chao_action_text
	if _title_phase == TITLE_PHASE_TINY_CHAO_SETUP:
		return "PREPARE THE GARDEN HANDOFF"
	return "OPEN THE TINY CHAO GARDEN"

func get_tiny_chao_detail_text() -> String:
	if _title_phase == TITLE_PHASE_TINY_CHAO_GARDEN_PLAY:
		return "LEFT/RIGHT/UP/DOWN MOVE   %s CARE   %s EXIT" % [get_confirm_label(), get_secondary_label()]
	if _title_phase == TITLE_PHASE_TINY_CHAO_SETUP:
		return "PREPARE SCORE, LANGUAGE, AND SESSION DATA\n%s SELECT   %s CONFIRM   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
	return "THIS BRANCH DIRECTLY HANDS OFF TO TINY CHAO GARDEN\n%s SELECT   %s CONFIRM   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]

func get_tiny_chao_summary_text() -> String:
	if _title_phase == TITLE_PHASE_TINY_CHAO_GARDEN_PLAY:
		var selected_name := str(_tiny_chao_roster[_tiny_chao_selected_index].get("name", "CHAO")) if not _tiny_chao_roster.is_empty() else "CHAO"
		return "%s STATUS\nHUNGER: %d%%\nMOOD: %d%%\nCARE: %d\nFRUIT: %d" % [selected_name, _tiny_chao_hunger, _tiny_chao_mood, _tiny_chao_care_count, _tiny_chao_fruit]
	if _title_phase == TITLE_PHASE_TINY_CHAO_SETUP:
		return "HANDOFF READY\nTOKEN: %s\nPROFILE: %s" % [_tiny_chao_session_id, get_profile_name_text()]
	return "DIRECT BRANCH\nUNLOCKED: %s\nPROFILE: %s" % ["YES" if _tiny_chao_unlocked else "NO", get_profile_name_text()]

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
		"SCORE  %d" % get_total_ported_score(),
		"LANG   %s" % get_language_text(),
		"TOKEN  %s" % _tiny_chao_session_id,
		"MODE   %s" % ("HANDOFF" if setup_phase else "DIRECT"),
	]

func get_title_menu_index() -> int:
	return _title_menu_index

func get_title_notice_text() -> String:
	return _title_notice_text

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
			open_character_select(CHARACTER_SELECT_CONTEXT_MULTIPLAYER)
		else:
			open_multiplayer_outcome_return_phase(_multiplayer_outcome_return_phase, linked_notice)
	else:
		_multiplayer_link_ready = false
		open_title_screen_at_multiplayer_menu(_multiplayer_pak_mode, "COMMUNICATION ERROR")

func get_multiplayer_outcome_title() -> String:
	return "CONNECTION SUCCESS" if _multiplayer_outcome_type == 0 else "COMMUNICATION ERROR"

func get_multiplayer_outcome_prompt() -> String:
	if _multiplayer_outcome_type == 0:
		return "LET'S PLAY WITH %dP" % max(2, get_multiplayer_link_count())
	return "LINK COULD NOT BE MAINTAINED"

func get_multiplayer_outcome_detail() -> String:
	if _multiplayer_outcome_type == 0:
		return "SYSTEMS LINKED: %d/4   MODE: %s\n%s CONTINUE   %s SKIP" % [get_multiplayer_link_count(), get_multiplayer_pak_mode_name(), get_confirm_label(), get_secondary_label()]
	return "RETURNING TO MULTIPLAYER MODE SELECT\n%s CONTINUE   %s SKIP" % [get_confirm_label(), get_secondary_label()]

func get_multiplayer_outcome_summary_text() -> String:
	if _multiplayer_outcome_type == 0:
		return "STATUS\nLINK OK\n\nPLAYERS\n%d\n\nNEXT\nROOM READY" % get_multiplayer_link_count()
	return "STATUS\nERROR\n\nMODE\n%s\n\nNEXT\nRESET ROOM" % get_multiplayer_pak_mode_name()

func get_multiplayer_outcome_player_rows() -> Array:
	var rows: Array = []
	for i in range(_multiplayer_link_players.size()):
		var connected := bool(_multiplayer_link_connected[i])
		var character_name: String = str(_character_names[clampi(int(_multiplayer_player_characters[i]), 0, _character_names.size() - 1)])
		rows.append({
			"name": get_multiplayer_link_player_name(i),
			"status": ("HOST  %s" % character_name) if i == 0 else ("%s  LINK OK" % character_name if connected else "%s  OFFLINE" % character_name),
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
	return "COMMUNICATION" if _title_phase == TITLE_PHASE_MULTI_CONNECT else "SINGLE-PAK SYNC"

func get_multiplayer_comm_prompt() -> String:
	if not _title_notice_text.is_empty():
		return _title_notice_text
	if _title_phase == TITLE_PHASE_MULTI_CONNECT:
		if _multiplayer_pak_mode == 0:
			if _multiplayer_link_ready:
				return "PRESS START ON THE HOST TO BEGIN"
			if get_multiplayer_link_count() > 1:
				return "WAITING FOR THE HOST TO CONFIRM"
			return "WAITING FOR OTHER PLAYERS"
		if not is_singlepak_transfer_started():
			return "WAIT FOR CLIENT SYSTEMS TO JOIN"
		return "SENDING THE CLIENT PROGRAM"
	return "WAIT FOR CLIENT BOOT TO COMPLETE"

func get_multiplayer_comm_prompt_color() -> Color:
	if _title_phase == TITLE_PHASE_MULTI_CONNECT:
		return Color(0.88, 0.44, 0.18, 1.0)
	return Color(0.72, 0.28, 0.22, 1.0)

func get_multiplayer_comm_detail_text() -> String:
	if _title_phase == TITLE_PHASE_MULTI_CONNECT:
		var mode_name := get_multiplayer_pak_mode_name()
		if _multiplayer_pak_mode == 0:
			if _multiplayer_link_ready:
				return "MODE: %s   COURSE: %s\nROOM COMPLETE   %s CONFIRM TO START   %s BACK" % [mode_name, get_multiplayer_session_course_text(), get_confirm_label(), get_secondary_label()]
			return "MODE: %s   COURSE: %s\nBUILD THE LINK ROOM BEFORE STARTING\n%s SELECT   %s CONFIRM   %s BACK" % [mode_name, get_navigation_label(), get_confirm_label(), get_secondary_label()]
		if not is_singlepak_transfer_started():
			return "MODE: %s   COURSE: %s\nCLIENTS: %d   PRESS START AFTER THEY JOIN\n%s SELECT   %s CONFIRM   %s BACK" % [mode_name, get_multiplayer_session_course_text(), max(0, get_multiplayer_link_count() - 1), get_navigation_label(), get_confirm_label(), get_secondary_label()]
		return "MODE: %s   COURSE: %s\nCLIENTS: %d   DOWNLOAD: %d%%\nTRANSFER ACTIVE   %s BACK LOCKED" % [mode_name, get_multiplayer_session_course_text(), max(0, get_multiplayer_link_count() - 1), get_singlepak_download_progress(), get_secondary_label()]
	if is_singlepak_sync_ready():
		return "COURSE: %s   SYNC STEP: %d/3\nCLIENT BOOT COMPLETE   %s CONFIRM TO START   %s BACK" % [get_multiplayer_session_course_text(), get_singlepak_sync_step(), get_confirm_label(), get_secondary_label()]
	return "COURSE: %s   SYNC STEP: %d/3\nDOWNLOAD: %d%%   WAIT FOR CLIENT BOOT\n%s SELECT   %s CONFIRM   %s BACK LOCKED" % [get_multiplayer_session_course_text(), get_singlepak_sync_step(), get_singlepak_download_progress(), get_navigation_label(), get_confirm_label(), get_secondary_label()]

func get_multiplayer_comm_info_text() -> String:
	if _title_phase == TITLE_PHASE_MULTI_CONNECT:
		if _multiplayer_pak_mode == 0:
			return "FORM A MULTI-PAK ROOM FOR %s" % get_multiplayer_session_course_text()
		if not is_singlepak_transfer_started():
			return "WAIT FOR CLIENTS, THEN SEND THE MULTIBOOT PROGRAM" 
		return "TRANSFER THE CLIENT PROGRAM FOR %s" % get_multiplayer_session_course_text()
	return "WAIT FOR CLIENT BOOT AND FINAL SYNCHRONIZATION"

func get_multiplayer_comm_summary_text() -> String:
	if _title_phase == TITLE_PHASE_MULTI_CONNECT:
		if _multiplayer_pak_mode == 0:
			return "MODE\nMULTI-PAK\n\nPLAYERS\n%d/4 LINKED\n\nCOURSE\n%s" % [get_multiplayer_link_count(), get_selected_level_text()]
		return "MODE\nSINGLE-PAK\n\nCLIENTS\n%d READY\n\nSTATE\n%s" % [max(0, get_multiplayer_link_count() - 1), ("WAITING" if not is_singlepak_transfer_started() else "DOWNLOAD %d%%" % get_singlepak_download_progress())]
	return "SYNC STEP\n%d/3\n\nCOURSE\n%s\n\nSTATE\n%s" % [get_singlepak_sync_step(), get_selected_level_text(), "READY" if _singlepak_sync_step >= 3 else "BOOTING"]

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
	if _title_phase == TITLE_PHASE_MULTI_CONNECT:
		rows.append({
			"label": "CONNECT" if _multiplayer_pak_mode == 0 else "SCAN CLIENTS",
			"value": "%d OF 4 SYSTEMS PRESENT" % get_multiplayer_link_count() if _multiplayer_pak_mode == 0 else "%d CLIENT SYSTEMS DETECTED" % max(0, get_multiplayer_link_count() - 1),
			"status": "READY",
			"selected": _title_menu_index == 0,
		})
		rows.append({
			"label": "START MATCH" if _multiplayer_pak_mode == 0 and _multiplayer_link_ready else ("PRESS START" if _multiplayer_pak_mode == 0 else "START DOWNLOAD"),
			"value": "HOST MAY BEGIN THE MATCH" if _multiplayer_pak_mode == 0 and _multiplayer_link_ready else ("WAIT FOR THE ROOM TO FILL" if _multiplayer_pak_mode == 0 else ("PRESS START AFTER CLIENTS JOIN" if not is_singlepak_transfer_started() else "TRANSFER %d%% COMPLETE" % get_singlepak_download_progress())),
			"status": "READY" if (_multiplayer_link_ready or (_multiplayer_pak_mode == 1 and get_multiplayer_link_count() >= 2)) else "WAIT",
			"selected": _title_menu_index == 1,
		})
		rows.append({
			"label": "BACK",
			"value": "RETURN TO PAK MODE SELECT",
			"status": "READY" if _multiplayer_pak_mode == 0 or not is_singlepak_transfer_started() else "LOCKED",
			"selected": _title_menu_index == 2,
		})
		return rows
	rows.append({
		"label": "START MATCH" if is_singlepak_sync_ready() else "SYNC CLIENTS",
		"value": "CLIENTS FINISHED BOOTING" if is_singlepak_sync_ready() else "BOOT STATE %d OF 3" % get_singlepak_sync_step(),
		"status": "READY" if is_singlepak_sync_ready() else "WAIT",
		"selected": _title_menu_index == 0,
	})
	rows.append({
		"label": "RESULTS",
		"value": "OPEN THE POST-MATCH RESULT EXCHANGE",
		"status": "READY" if is_singlepak_sync_ready() else "LOCKED",
		"selected": _title_menu_index == 1,
	})
	rows.append({
		"label": "BACK",
		"value": "WAIT FOR CLIENT BOOT TO FINISH",
		"status": "LOCKED",
		"selected": _title_menu_index == 2,
	})
	return rows

func get_multiplayer_comm_player_rows() -> Array:
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
	var count := 0
	for connected in _multiplayer_link_connected:
		if bool(connected):
			count += 1
	return count

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
		"name": "START",
		"description": "BEGIN THE CURRENT TIME ATTACK RUN",
		"status": "READY",
		"selected": _time_attack_lobby_cursor == 0,
	})
	rows.append({
		"name": "CHARACTER",
		"description": "CHANGE THE ACTIVE RUNNER",
		"status": get_selected_character_name(),
		"selected": _time_attack_lobby_cursor == 1,
	})
	rows.append({
		"name": "COURSE" if not _time_attack_boss_mode else "BOSS COURSE",
		"description": "LEFT/RIGHT OR CONFIRM TO CHANGE COURSE",
		"status": get_selected_level_text(),
		"selected": _time_attack_lobby_cursor == 2,
	})
	rows.append({
		"name": "TITLE",
		"description": "RETURN TO THE TIME ATTACK MENU",
		"status": "BACK",
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
	return "BOSS TIME ATTACK" if _time_attack_boss_mode else "TIME ATTACK"

func get_time_attack_lobby_prompt() -> String:
	if not _title_notice_text.is_empty():
		return _title_notice_text
	return "TRY AGAIN"

func get_time_attack_lobby_detail() -> String:
	return "%s SELECT   %s CONFIRM   LEFT/RIGHT COURSE   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]

func get_time_attack_lobby_summary_text() -> String:
	return "CHARACTER\n%s\n\nCOURSE\n%s\n\nBEST\n%s" % [get_selected_character_name(), get_selected_level_text(), get_time_attack_lobby_record_text()]

func get_time_attack_lobby_character_text() -> String:
	return "CHARACTER\n%s" % get_selected_character_name()

func get_time_attack_lobby_course_text() -> String:
	return "COURSE\n%s\n%s" % [get_selected_level_text(), get_time_attack_lobby_course_badge_text()]

func get_time_attack_lobby_mode_text() -> String:
	return "MODE\n%s\n%s" % [("BOSS ATTACK" if _time_attack_boss_mode else "ZONE ATTACK"), get_time_attack_lobby_focus_text()]

func get_time_attack_lobby_record_text() -> String:
	var record_key := _get_time_attack_record_key(_selected_character_index, _selected_level_index, 0, _time_attack_boss_mode)
	var best_time := _get_time_attack_best_time(record_key)
	if best_time < 0.0:
		return "NO RECORD"
	return get_formatted_time(best_time)

func get_time_attack_lobby_course_badge_text() -> String:
	var course_index := _selected_level_index
	var zone_text := "FINAL ZONE" if course_index == _level_names.size() - 2 else ("TRUE AREA 53" if course_index == _level_names.size() - 1 else "ZONE %d" % [int(course_index / 2) + 1])
	if _time_attack_boss_mode:
		return "%s   BOSS" % zone_text
	return "%s   ACT %d" % [zone_text, (course_index % 2) + 1]

func get_time_attack_lobby_focus_text() -> String:
	match _time_attack_lobby_cursor:
		0:
			return "RUN READY"
		1:
			return "CHANGE RUNNER"
		2:
			return "CHANGE COURSE"
		3:
			return "BACK TO MENU"
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
		return "MULTIPLAYER COURSE"
	return "COURSE SELECT"

func get_course_select_prompt() -> String:
	if _is_multiplayer_course_select():
		if is_course_select_starting():
			return "LOCKING ROOM COURSE"
		if is_course_select_busy():
			return "SHIFTING ROOM COURSE"
		return "SELECT A VS COURSE"
	if is_course_select_starting():
		return "STARTING COURSE"
	if is_course_select_busy():
		return "LOCKING COURSE"
	return "SELECT A COURSE"

func get_course_select_detail() -> String:
	var notice := get_title_notice_text()
	if notice.is_empty():
		if _is_multiplayer_course_select():
			notice = "%s SELECT   %s LOCK   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
		else:
			notice = "%s SELECT   %s START   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
	return "%s\nCHARACTER: %s   MODE: %s" % [notice, get_selected_character_name(), get_course_select_type_label()]

func get_course_select_summary_text() -> String:
	if _is_multiplayer_course_select():
		return "ROOM COURSE\n%s\n\nPAK MODE\n%s\n\nRUNNER\n%s" % [get_course_select_banner_text(), get_multiplayer_pak_mode_name(), get_selected_character_name()]
	return "CURRENT COURSE\n%s\n\nRECORD\n%s\n\nCHARACTER\n%s" % [get_course_select_banner_text(), get_selected_level_description(), get_selected_character_name()]

func get_course_select_banner_text() -> String:
	if _is_multiplayer_course_select():
		return "%s VS" % get_selected_level_text()
	if _time_attack_boss_mode:
		return "%s BOSS" % get_selected_level_text()
	return get_selected_level_text()

func get_course_select_rows() -> Array:
	var rows: Array = []
	for index in range(_level_names.size()):
		rows.append({
			"name": get_level_name_by_index(index),
			"value": get_selected_level_description() if index == _selected_level_index else "BEST: %d" % get_level_best_score(index),
			"status": get_level_status(index),
			"selected": index == _selected_level_index,
		})
	return rows

func is_course_select_traveling() -> bool:
	return _course_select_travel_timer > 0.0

func is_course_select_settling() -> bool:
	return _course_select_settle_timer > 0.0

func is_course_select_unlocking() -> bool:
	return _course_select_unlock_timer > 0.0

func is_course_select_starting() -> bool:
	return _course_select_start_timer > 0.0

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
		return "FINAL"
	return "ZONE %d" % [_selected_level_index + 1]

func get_course_select_act_label() -> String:
	if _is_multiplayer_course_select():
		return "MATCH"
	if _time_attack_boss_mode:
		return "BOSS"
	if _selected_level_index >= _level_names.size() - 2:
		return "SPECIAL"
	return "ACT %d" % [(_selected_level_index % 2) + 1]

func get_course_select_type_label() -> String:
	if _is_multiplayer_course_select():
		return "MULTIPLAYER"
	return "BOSS ATTACK" if _time_attack_boss_mode else "ZONE ATTACK"

func get_course_select_emerald_rows() -> Array:
	var badges: Array = []
	var total: int = 7
	for i in range(total):
		# The original course screen reads each saved emerald bit, rather than
		# treating stage progression as a substitute for collection progress.
		var active := false
		if not _is_multiplayer_course_select():
			active = (_chaos_emerald_mask & (1 << i)) != 0
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
				"stat_text": "%s   LOCKED IN" % _character_names[character_index],
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
			"stat_text": "%s   RINGS %d   SCORE %d" % [_character_names[character_index], rings, score],
		})

func get_singlepak_results_items() -> Array:
	if _multiplayer_result_mode == MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION:
		return ["CONTINUE", "BACK TO LOBBY"]
	return ["REMATCH", "BACK TO MULTI PLAYER"]

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
		open_character_select(CHARACTER_SELECT_CONTEXT_MULTIPLAYER)
		return
	open_title_screen_and_skip_intro()

func get_multiplayer_results_title() -> String:
	if _multiplayer_result_mode == MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION:
		return "CHARACTERS SELECTED"
	return "MULTIPLAYER RESULTS"

func is_multiplayer_character_selection_results() -> bool:
	return _multiplayer_result_mode == MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION

func get_multiplayer_results_prompt() -> String:
	var seconds_left := ceili(get_singlepak_results_time_remaining())
	if _multiplayer_result_mode == MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION:
		if _multiplayer_result_snapshot.is_empty():
			return "CHARACTER ORDER LOCKED IN"
		return "READY: %s ON %s   NEXT IN %d" % [str(_multiplayer_result_snapshot[0]["character"]), get_multiplayer_session_course_text(), seconds_left]
	if _multiplayer_result_snapshot.is_empty():
		return "COLLECT RINGS SUMMARY"
	return "WINNER: %s   COURSE: %s   NEXT IN %d" % [str(_multiplayer_result_snapshot[0]["name"]), get_multiplayer_session_course_text(), seconds_left]

func get_multiplayer_results_detail() -> String:
	if _multiplayer_result_mode == MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION:
		return "AUTO ADVANCE TO COURSE SELECT   %s SKIP NOW" % [get_confirm_label()]
	return "AUTO ADVANCE TO PLAY AGAIN?   %s SKIP NOW" % [get_confirm_label()]

func get_multiplayer_results_summary_text() -> String:
	var mode_text := "COURSE COMPLETE" if _multiplayer_result_mode == MULTIPLAYER_RESULTS_MODE_COURSE_COMPLETE else "CHARACTER SELECTION"
	if _multiplayer_result_snapshot.is_empty():
		return "MODE\n%s\n\nPLAYERS\n0" % mode_text
	var winner: Dictionary = _multiplayer_result_snapshot[0]
	if _multiplayer_result_mode == MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION:
		return "MODE\n%s\n\nLEAD PICK\n%s\n\nNEXT STEP\n%s" % [
			mode_text,
			str(winner["character"]),
			"COURSE SELECT",
		]
	return "MODE\n%s\n\nWINNER\n%s\n\nNEXT STEP\nPLAY AGAIN?" % [mode_text, str(winner["name"])]

func get_multiplayer_results_badge_text() -> String:
	return "SEL" if _multiplayer_result_mode == MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION else "VS"

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
			"status": "SELECTED" if i == _singlepak_results_cursor else ("NEXT" if i == 0 else "RETURN"),
			"selected": i == _singlepak_results_cursor,
		})
	return rows

func get_multiplayer_lobby_items() -> Array:
	return ["YES", "NO"]

func get_multiplayer_lobby_cursor() -> int:
	return _multiplayer_lobby_cursor

func get_multiplayer_lobby_title() -> String:
	return "CONTINUE?"

func get_multiplayer_lobby_prompt() -> String:
	var notice := get_title_notice_text()
	if not notice.is_empty():
		return notice
	if _multiplayer_lobby_waiting:
		return "WAITING FOR ALL LINKED PLAYERS"
	if _multiplayer_lobby_cursor == 0:
		return "HOST WILL START ANOTHER MATCH ON %s" % get_multiplayer_session_course_text()
	return "HOST WILL CLOSE THE ROOM AFTER %s" % get_multiplayer_session_course_text()

func get_multiplayer_lobby_detail() -> String:
	if _multiplayer_lobby_waiting:
		return "COURSE: %s   SYSTEMS: %d/4   HOST: P1\nDECISION SENT   HOLD FOR LINKED PLAYERS" % [get_multiplayer_session_course_text(), get_multiplayer_link_count()]
	return "COURSE: %s   SYSTEMS: %d/4   HOST: P1\nLEFT/RIGHT CHOICE   %s CONFIRM   %s BACK" % [get_multiplayer_session_course_text(), get_multiplayer_link_count(), get_confirm_label(), get_secondary_label()]

func get_multiplayer_lobby_info_text() -> String:
	if _multiplayer_lobby_waiting:
		return "SYNCING THE HOST DECISION WITH EVERY LINKED SYSTEM"
	if _multiplayer_lobby_cursor == 0:
		return "SEND A CONTINUE VOTE TO EVERY LINKED SYSTEM"
	return "SEND AN EXIT VOTE AND RETURN TO RESULTS"

func get_multiplayer_lobby_summary_text() -> String:
	var partners: int = max(0, get_multiplayer_link_count() - 1)
	var choice := "YES" if _multiplayer_lobby_cursor == 0 else "NO"
	if _multiplayer_lobby_waiting:
		return "CHOICE\n%s\n\nSTATE\nWAITING\n\nPARTNERS\n%d" % [choice, partners]
	var next_step := "START REMATCH" if _multiplayer_lobby_cursor == 0 else "SHOW END RESULTS"
	return "CHOICE\n%s\n\nNEXT\n%s\n\nPARTNERS\n%d" % [choice, next_step, partners]

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
			"status": ("WAIT" if i == _multiplayer_lobby_cursor else "HOLD") if _multiplayer_lobby_waiting else ("REMATCH" if i == 0 else "RESULTS"),
			"selected": i == _multiplayer_lobby_cursor,
		})
	return rows

func get_multiplayer_lobby_player_rows() -> Array:
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
				status_text = "HOST  %s  SENDING %s%s" % [character_name, "REMATCH" if _multiplayer_lobby_cursor == 0 else "EXIT", rank_text]
			else:
				status_text = "HOST  %s  SELECTING%s" % [character_name, rank_text]
		elif connected:
			status_text = "%s  READY TO %s%s" % [character_name, "REMATCH" if _multiplayer_lobby_cursor == 0 else "EXIT", rank_text] if _multiplayer_lobby_waiting else "%s  LINK OK%s" % [character_name, rank_text]
		else:
			status_text = "%s  WAITING FOR LINK" % character_name
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
	var seed_value := (get_total_ported_score() + (_language_index + 1) * 137 + _selected_level_index * 29) % 10000
	_tiny_chao_session_id = "TCG-%04d" % [seed_value]

func get_singlepak_result_rows() -> Array:
	if _multiplayer_result_snapshot.is_empty():
		_prepare_multiplayer_results_snapshot(MULTIPLAYER_RESULTS_MODE_COURSE_COMPLETE)
	return _multiplayer_result_snapshot

func open_character_select(context: int = CHARACTER_SELECT_CONTEXT_GAME_START) -> void:
	_game_state = GAME_STATE_CHARACTER_SELECT
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
			"selected": character_index == _selected_character_index,
		})
	return rows

func get_character_select_summary_text() -> String:
	return "RUNNER\n%s\n\nSTYLE\n%s\n\nSTATE\n%s" % [
		get_selected_character_name(),
		get_selected_character_description(),
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
		return _title_notice_text
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
	var indices: Array = [0, 1, 2, 3]
	if is_character_select_character_available(4):
		indices.append(4)
	return indices

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
	return "TAP TO RESUME" if _is_touch_device() else "PRESS ENTER TO RESUME"

func get_pause_title_text() -> String:
	return "PAUSE"

func get_pause_prompt_text() -> String:
	return "STAGE SUSPENDED"

func get_pause_detail_text() -> String:
	if _run_from_time_attack or _run_from_multiplayer:
		return "%s SELECT   %s CONFIRM   %s RESUME" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]
	return "%s SELECT   %s CONFIRM   START RESUME" % [get_navigation_label(), get_confirm_label()]

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
			return "DELETE GAME DATA"
		OPTIONS_MODE_TIME_RECORDS:
			return _language_text("TIME RECORDS", "ZEITREKORDE", "RECORDS DE TEMPS", "RECORDS DE TIEMPO", "RECORD TEMPI")
		OPTIONS_MODE_MULTI_RECORDS:
			return _language_text("MULTI-PAK RECORDS", "MULTI-PAK REKORDE", "RECORDS MULTI-PAK", "RECORDS MULTI-PAK", "RECORD MULTI-PAK")
		OPTIONS_MODE_NAME_ENTRY:
			return _language_text("NAME ENTRY", "NAMEN EINGEBEN", "SAISIE DU NOM", "NOMBRE", "INSERISCI NOME")
	return "OPTIONS"

func get_options_screen_subtitle() -> String:
	if _save_reset_pending:
		return "SAVE DATA WILL BE ERASED"
	match _options_mode:
		OPTIONS_MODE_MAIN:
			return "GAME SETTINGS"
		OPTIONS_MODE_PLAYER_DATA:
			return "PROFILE AND RECORDS"
		OPTIONS_MODE_LANGUAGE:
			return "SELECT DISPLAY LANGUAGE"
		OPTIONS_MODE_BUTTON_CONFIG:
			return "ASSIGN ACTION BUTTONS"
		OPTIONS_MODE_SOUND_TEST:
			return "THE ORIGINAL JUKEBOX"
		OPTIONS_MODE_DIFFICULTY:
			return "SELECT DIFFICULTY"
		OPTIONS_MODE_TIME_LIMIT:
			return "TOGGLE TIME LIMIT"
		OPTIONS_MODE_DELETE_CONFIRM:
			return "DELETE ALL SAVE DATA?"
		OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			return "THIS CANNOT BE UNDONE"
		OPTIONS_MODE_TIME_RECORDS:
			return "BEST CLEAR TIMES"
		OPTIONS_MODE_MULTI_RECORDS:
			return "VERSUS RECORD SUMMARY"
		OPTIONS_MODE_NAME_ENTRY:
			return "EDIT PROFILE NAME"
	return "GAME SETTINGS"

func get_options_summary_text() -> String:
	if _save_reset_pending:
		return get_save_detail_text()
	match _options_mode:
		OPTIONS_MODE_MAIN:
			return "DIFFICULTY: %s   TIME LIMIT: %s   LANGUAGE: %s" % [
				get_difficulty_text(),
				"ON" if _time_limit_enabled else "OFF",
				get_language_text(),
			]
		OPTIONS_MODE_PLAYER_DATA:
			return "PROFILE: %s   SAVE SLOT: MAIN" % [get_profile_name_text()]
		OPTIONS_MODE_LANGUAGE:
			return "CURRENT LANGUAGE: %s" % get_language_text()
		OPTIONS_MODE_BUTTON_CONFIG:
			return "A: %s   B: %s   R: %s" % [_button_bindings[0], _button_bindings[1], _button_bindings[2]]
		OPTIONS_MODE_SOUND_TEST:
			return get_sound_test_summary_text().replace("\n", "   ")
		OPTIONS_MODE_DIFFICULTY:
			return "PROFILE: %s   CURRENT: %s" % [get_profile_name_text(), get_difficulty_text()]
		OPTIONS_MODE_TIME_LIMIT:
			return "PROFILE: %s   CURRENT: %s" % [get_profile_name_text(), "ON" if _time_limit_enabled else "OFF"]
		OPTIONS_MODE_DELETE_CONFIRM:
			return "PROFILE: %s   DELETE ALL PROGRESS?" % [get_profile_name_text()]
		OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			return "UNLOCKS, RECORDS, AND PROFILE SETTINGS WILL RESET"
		OPTIONS_MODE_TIME_RECORDS:
			return "VIEW PERSONAL BESTS FOR EACH CHARACTER"
		OPTIONS_MODE_MULTI_RECORDS:
			return "LOCAL MULTIPLAYER HISTORY"
		OPTIONS_MODE_NAME_ENTRY:
			return "CURRENT NAME: %s" % [get_profile_name_text()]
	return ""

func get_options_main_title_text() -> String:
	return "OPTIONS"

func get_options_main_prompt_text() -> String:
	return "SELECT AN OPTION"

func get_options_main_detail_text() -> String:
	return "%s SELECT   %s OPEN   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]

func get_player_data_title_text() -> String:
	return _language_text("PLAYER DATA", "SPIELERDATEN", "DONNEES JOUEUR", "DATOS DEL JUGADOR", "DATI GIOCATORE")

func get_player_data_prompt_text() -> String:
	return "SELECT PLAYER DATA"

func get_player_data_detail_text() -> String:
	return "%s SELECT   %s CONFIRM   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]

func get_player_data_header_text() -> String:
	return "PROFILE NAME  %s" % get_profile_name_text()

func get_player_data_slot_text() -> String:
	return "SAVE SLOT: MAIN"

func get_player_data_summary_text() -> String:
	var total_best := 0
	for score in _best_scores:
		total_best += int(score)
	return "PLAYER DATA\nLANGUAGE: %s\nBEST TOTAL: %d" % [get_language_text(), total_best]

func get_difficulty_title_text() -> String:
	return _language_text("DIFFICULTY", "SCHWIERIGKEIT", "DIFFICULTE", "DIFICULTAD", "DIFFICOLTA")

func get_difficulty_prompt_text() -> String:
	return "LEFT/RIGHT CHANGE, ENTER CONFIRM, X BACK"

func get_difficulty_summary_text() -> String:
	return "PROFILE\n%s\n\nCURRENT\n%s" % [get_profile_name_text(), get_difficulty_text()]

func get_difficulty_detail_text() -> String:
	return "LEFT/RIGHT = CHANGE   %s = CONFIRM   %s = BACK" % [get_confirm_label(), get_secondary_label()]

func get_difficulty_rows() -> Array:
	return [
		{
			"label": _language_text("NORMAL", "NORMAL", "NORMAL", "NORMAL", "NORMALE"),
			"status": "STANDARD RUN",
			"selected": _difficulty_index == 0,
		},
		{
			"label": _language_text("EASY", "EINFACH", "FACILE", "FACIL", "FACILE"),
			"status": "LOWER ENEMY PRESSURE",
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
	return "LEFT/RIGHT CHANGE, ENTER CONFIRM, X BACK"

func get_time_limit_summary_text() -> String:
	var value := _language_text("ON", "AN", "OUI", "SI", "SI") if _time_limit_enabled else _language_text("OFF", "AUS", "NON", "NO", "NO")
	return "PROFILE\n%s\n\nCURRENT\n%s" % [get_profile_name_text(), value]

func get_time_limit_detail_text() -> String:
	return "LEFT/RIGHT = CHANGE   %s = CONFIRM   %s = BACK" % [get_confirm_label(), get_secondary_label()]

func get_time_limit_rows() -> Array:
	return [
		{
			"label": _language_text("ON", "AN", "OUI", "SI", "SI"),
			"status": "CLASSIC COUNTDOWN",
			"selected": _time_limit_enabled,
		},
		{
			"label": _language_text("OFF", "AUS", "NON", "NO", "NO"),
			"status": "FREE RUN MODE",
			"selected": not _time_limit_enabled,
		},
	]

func get_time_limit_chrome_colors() -> Dictionary:
	return {
		"accent": Color(0.38, 0.82, 0.52, 1.0),
		"card": Color(0.88, 0.98, 0.90, 0.98),
	}

func get_delete_confirm_title_text() -> String:
	return "DELETE GAME DATA"

func get_delete_confirm_prompt_text() -> String:
	if _options_mode == OPTIONS_MODE_DELETE_CONFIRM_FINAL:
		return "LEFT/RIGHT CHOOSE, ENTER ERASE, X BACK"
	return "LEFT/RIGHT CHOOSE, ENTER CONTINUE, X BACK"

func get_delete_confirm_summary_text() -> String:
	if _options_mode == OPTIONS_MODE_DELETE_CONFIRM_FINAL:
		return "FINAL CHECK\nALL RECORDS RESET\n\nPROFILE\n%s" % [get_profile_name_text()]
	return "ERASE PROFILE\n%s\n\nUNLOCKS\n%02d CLEARED" % [get_profile_name_text(), _unlocked_level_index + 1]

func get_delete_confirm_detail_text() -> String:
	return "LEFT/RIGHT = CHOOSE   %s = CONFIRM   %s = BACK" % [get_confirm_label(), get_secondary_label()]

func get_delete_confirm_rows() -> Array:
	return [
		{
			"label": "YES",
			"status": "ERASE SAVE DATA",
			"selected": _delete_confirm_index == 0,
		},
		{
			"label": "NO",
			"status": "KEEP CURRENT DATA",
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
		return "MODE: %s\nCHARACTER: %s\nCOURSE: %s" % [("BOSS ATTACK" if _time_records_boss_mode else "ZONE ATTACK"), character_name, get_time_records_course_title_text()]
	if _time_records_view == TIME_RECORDS_VIEW_MODE_CHOICE:
		return "PROFILE: %s\nSELECT RECORD MODE\nCURRENT: %s" % [get_profile_name_text(), "BOSS" if _time_records_boss_mode else "ZONE"]
	return "CHARACTER: %s\nCOURSE: %s\nTYPE: %s" % [character_name, get_time_records_course_title_text(), "BOSS" if _time_records_boss_mode else "ACT"]

func get_time_records_title_text() -> String:
	return _language_text("TIME RECORDS", "ZEITREKORDE", "RECORDS DE TEMPS", "RECORDS DE TIEMPO", "RECORD TEMPI")

func get_time_records_prompt_text() -> String:
	if _time_records_context == TIME_RECORDS_CONTEXT_TIME_ATTACK:
		return "LEFT/RIGHT COURSE, ENTER START, X BACK"
	if _time_records_view == TIME_RECORDS_VIEW_MODE_CHOICE:
		return "LEFT/RIGHT MODE, ENTER OPEN, X BACK"
	return "UP/DOWN CHARACTER, LEFT/RIGHT COURSE, X BACK"

func get_time_records_detail_text() -> String:
	if _time_records_context == TIME_RECORDS_CONTEXT_TIME_ATTACK:
		return "LEFT/RIGHT = COURSE   %s = START   %s = BACK" % [get_confirm_label(), get_secondary_label()]
	if _time_records_view == TIME_RECORDS_VIEW_MODE_CHOICE:
		return "LEFT/RIGHT = MODE   %s = OPEN   %s = BACK" % [get_confirm_label(), get_secondary_label()]
	return "UP/DOWN = CHARACTER   LEFT/RIGHT = COURSE   %s = BACK" % [get_secondary_label()]

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
		return "MODE SELECT"
	var zone_number := _time_records_course_index + 1
	if _time_records_boss_mode:
		return "ZONE %d   BOSS" % zone_number
	return "ZONE %d   ACT %d" % [zone_number, _time_records_act_index + 1]

func get_time_records_course_subtitle_text() -> String:
	if _time_records_view == TIME_RECORDS_VIEW_MODE_CHOICE:
		return "CHOOSE ZONE OR BOSS RECORDS"
	var course_name := get_level_name_by_index(_get_time_records_level_index())
	if _time_records_boss_mode:
		return "%s BOSS ROUTE" % course_name
	return course_name

func get_multiplayer_records_summary_text() -> String:
	var totals := get_multiplayer_records_player_totals()
	return "PROFILE: %s\nVERSUS TOTALS\nW %02d  L %02d  D %02d" % [get_profile_name_text(), totals["wins"], totals["losses"], totals["draws"]]

func get_multiplayer_records_title_text() -> String:
	return _language_text("VS RECORDS", "VS-REKORDE", "RECORDS VS", "RECORDS VS", "RECORD VS")

func get_multiplayer_records_prompt_text() -> String:
	return "UP/DOWN SCROLL TABLE, X BACK"

func get_multiplayer_records_detail_text() -> String:
	return "UP/DOWN = SCROLL TABLE   %s = BACK" % [get_secondary_label()]

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

func get_name_entry_summary_text() -> String:
	if _is_name_entry_control_cursor():
		return "CONTROL\n%s\n\nNAME\n%s" % [get_name_entry_control_label(), get_profile_name_text()]
	return "LETTER %d ACTIVE\n%s\n\nCHARACTER\n%s" % [
		_name_entry_menu_index + 1,
		get_profile_name_text(),
		get_name_entry_selected_character(),
	]

func get_name_entry_detail_text() -> String:
	return "Q/E SLOT   %s PICK   %s DELETE   DEL CANCEL" % [get_confirm_label(), get_secondary_label()]

func get_name_entry_title_text() -> String:
	return _language_text("NAME ENTRY", "NAMEN EINGEBEN", "SAISIE DU NOM", "NOMBRE", "INSERISCI NOME")

func get_name_entry_prompt_text() -> String:
	return "UP/DOWN/LEFT/RIGHT MOVE   %s PICK   %s DELETE" % [get_confirm_label(), get_secondary_label()]

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
			return "BACK"
		NAME_ENTRY_CONTROL_ROW_FORWARD:
			return "FORWARD"
		NAME_ENTRY_CONTROL_ROW_END:
			return "END"
	return "BOARD"

func get_name_entry_control_rows() -> Array:
	return ["BACK", "FORWARD", "END"]

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
	return "CURRENT LANGUAGE\n%s\n\nSUPPORTED\n%d OPTIONS" % [get_language_text(), get_language_items().size()]

func get_language_title_text() -> String:
	return "LANGUAGE"

func get_language_prompt_text() -> String:
	return "SELECT A LANGUAGE"

func get_language_detail_text() -> String:
	return "%s CHANGE   %s ACCEPT   %s BACK" % [get_navigation_label(), get_confirm_label(), get_secondary_label()]

func get_language_chrome_colors() -> Dictionary:
	return {
		"accent": Color(0.24, 0.80, 0.96, 1.0),
		"card": Color(0.86, 0.94, 1.0, 0.98),
	}

func get_button_config_summary_text() -> String:
	return "SELECT EACH BUTTON AND ASSIGN AN ACTION\n\nA  %s\nB  %s\nR  %s" % [_button_bindings[0], _button_bindings[1], _button_bindings[2]]

func get_button_config_title_text() -> String:
	return _language_text("BUTTON CONFIG", "TASTENBELEGUNG", "CONFIG BOUTONS", "CONFIG BOTONES", "CONFIG TASTI")

func get_button_config_prompt_text() -> String:
	return "LEFT/RIGHT CHANGE, ENTER ADVANCE, X BACK, SELECT DEFAULTS"

func get_button_config_detail_text() -> String:
	return "EDITING %s   LEFT/RIGHT = CHANGE   %s = ADVANCE   %s = BACK" % [
		get_button_config_focus_label(),
		get_confirm_label(),
		get_secondary_label(),
	]

func get_button_config_chrome_colors() -> Dictionary:
	return {
		"accent": Color(0.92, 0.48, 0.20, 1.0),
		"card": Color(0.98, 0.90, 0.84, 0.98),
	}

func get_button_config_focus_label() -> String:
	var focus_labels := ["A BUTTON", "B BUTTON", "R BUTTON"]
	return focus_labels[clampi(_button_config_index, 0, focus_labels.size() - 1)]

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
	var action_order := _get_button_config_action_order()
	if _button_config_index < 0 or _button_config_index >= _button_bindings.size():
		return
	# The original R-shoulder stage is confirmation-only.
	if _button_config_index >= 2:
		return
	var current_action := str(_button_bindings[_button_config_index])
	var current_index := action_order.find(current_action)
	if current_index < 0:
		current_index = _button_config_index
	if _button_config_index == 0:
		current_index = wrapi(current_index + direction, 0, action_order.size())
		_button_bindings[0] = action_order[current_index]
		return
	var blocked_action := str(_button_bindings[_button_config_index - 1])
	for _step in range(action_order.size()):
		current_index = wrapi(current_index + direction, 0, action_order.size())
		var candidate := str(action_order[current_index])
		if candidate != blocked_action:
			_button_bindings[_button_config_index] = candidate
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
	var bonus_state := "ALL TRACKS" if _has_completed_sound_test_bonus() else "STANDARD LIST"
	return "TRACK NO.\n%02d\n\nMODE\n%s\n\nLIST\n%s" % [int(entry["number"]), get_sound_test_playback_label(), bonus_state]

func get_sound_test_title_text() -> String:
	return _language_text("SOUND TEST", "MUSIKTEST", "TEST SON", "PRUEBA DE SONIDO", "TEST AUDIO")

func get_sound_test_prompt_text() -> String:
	return "LEFT/RIGHT CHANGE 1, UP/DOWN CHANGE 10, ENTER PLAY, X STOP/BACK"

func get_sound_test_detail_text() -> String:
	return "LEFT/RIGHT = TRACK +/-1   UP/DOWN = TRACK +/-10   %s = PLAY   %s = %s" % [
		get_confirm_label(),
		get_secondary_label(),
		"STOP" if _sound_test_state == SOUND_TEST_STATE_PLAYING else "BACK",
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
		return "NOW PLAYING %02d %s" % [int(entry["number"]), str(entry["name"])]
	return "SELECT TRACK %02d" % int(entry["number"])

func get_sound_test_playback_label() -> String:
	if _sound_test_state == SOUND_TEST_STATE_PLAYING:
		return "PLAYING"
	return "STOPPED"

func is_sound_test_playing() -> bool:
	return _sound_test_state == SOUND_TEST_STATE_PLAYING

func _has_completed_sound_test_bonus() -> bool:
	return _unlocked_level_index >= _level_names.size() - 1

func get_options_active_items() -> Array:
	if _save_reset_pending:
		return ["CONFIRM RESET", "CANCEL"]
	match _options_mode:
		OPTIONS_MODE_MAIN:
			return get_options_display_items()
		OPTIONS_MODE_PLAYER_DATA:
			return get_player_data_menu_items()
		OPTIONS_MODE_LANGUAGE:
			return get_language_items()
		OPTIONS_MODE_BUTTON_CONFIG:
			return ["A BUTTON", "B BUTTON", "R BUTTON"]
		OPTIONS_MODE_SOUND_TEST:
			return ["TRACK"]
		OPTIONS_MODE_DIFFICULTY:
			return ["NORMAL", "EASY"]
		OPTIONS_MODE_TIME_LIMIT:
			return ["ON", "OFF"]
		OPTIONS_MODE_DELETE_CONFIRM, OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			return ["YES", "NO"]
		OPTIONS_MODE_TIME_RECORDS:
			if _time_records_view == TIME_RECORDS_VIEW_MODE_CHOICE:
				return ["ZONE", "BOSS"]
			return ["COURSE VIEW"]
		OPTIONS_MODE_MULTI_RECORDS:
			return ["RECORDS"]
		OPTIONS_MODE_NAME_ENTRY:
			return ["LETTER 1", "LETTER 2", "LETTER 3", "LETTER 4", "CONFIRM", "BACK"]
	return []

func get_options_item_meta(index: int) -> String:
	if _save_reset_pending:
		return "YES" if index == 0 else "NO"
	match _options_mode:
		OPTIONS_MODE_PLAYER_DATA:
			match index:
				0:
					return get_profile_name_text()
				1:
					return "BEST TIMES AND STATS"
				2:
					return "VERSUS RECORDS"
				3:
					return "RETURN TO OPTIONS"
		OPTIONS_MODE_MAIN:
			match index:
				0:
					return "OPEN PLAYER-DATA SUBMENU"
				1:
					return get_difficulty_text()
				2:
					return "ON" if _time_limit_enabled else "OFF"
				3:
					return get_language_text()
				4:
					return "EDIT ACTION BUTTONS"
				5:
					return "TRACK %02d" % [get_sound_test_track_number()]
				6:
					return "ERASE ALL PROGRESS"
				7:
					return "RETURN TO TITLE"
		OPTIONS_MODE_LANGUAGE:
			return "CURRENT" if index == _language_index else "AVAILABLE"
		OPTIONS_MODE_BUTTON_CONFIG:
			return _button_bindings[index] if index >= 0 and index < _button_bindings.size() else ""
		OPTIONS_MODE_SOUND_TEST:
			var entry := get_sound_test_current_entry()
			match index:
				0:
					return str(entry["name"])
				1:
					return "PLAY TRACK %02d" % [int(entry["number"])]
				2:
					return get_sound_test_playback_label()
				3:
					return "RETURN TO OPTIONS"
		OPTIONS_MODE_DIFFICULTY:
			if index == 0:
				return "STANDARD RUN"
			return "LOWER ENEMY PRESSURE"
		OPTIONS_MODE_TIME_LIMIT:
			if index == 0:
				return "CLASSIC COUNTDOWN"
			return "FREE RUN MODE"
		OPTIONS_MODE_DELETE_CONFIRM, OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			if index == 0:
				return "ERASE SAVE DATA"
			return "KEEP CURRENT DATA"
		OPTIONS_MODE_TIME_RECORDS:
			if index < _time_record_rows.size():
				return _time_record_rows[index][1]
			return "RETURN TO PLAYER DATA"
		OPTIONS_MODE_MULTI_RECORDS:
			return "BROWSE WINS, LOSSES, AND DRAWS"
		OPTIONS_MODE_NAME_ENTRY:
			if index < _player_profile_name.size():
				return _player_profile_name[index]
			if index == _player_profile_name.size():
				return get_profile_name_text()
			return "CANCEL EDIT"
	return ""

func get_options_item_status(index: int) -> String:
	if _save_reset_pending:
		return "READY"
	match _options_mode:
		OPTIONS_MODE_MAIN:
			return "READY"
		OPTIONS_MODE_PLAYER_DATA:
			return "PROFILE" if index == 0 else "READY"
		OPTIONS_MODE_LANGUAGE:
			return "SELECTED" if index == _language_index else "READY"
		OPTIONS_MODE_BUTTON_CONFIG:
			return "ACTIVE" if index == _button_config_index else "WAIT"
		OPTIONS_MODE_SOUND_TEST:
			match index:
				0:
					return "SCROLL"
				1:
					return "PLAYING" if _sound_test_state == SOUND_TEST_STATE_PLAYING else "READY"
				2:
					return "STOP" if _sound_test_state == SOUND_TEST_STATE_PLAYING else "READY"
			return "READY"
		OPTIONS_MODE_DIFFICULTY:
			return "READY"
		OPTIONS_MODE_TIME_LIMIT:
			return "READY"
		OPTIONS_MODE_DELETE_CONFIRM, OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			return "READY"
		OPTIONS_MODE_TIME_RECORDS:
			return "BEST"
		OPTIONS_MODE_MULTI_RECORDS:
			return "BROWSE"
		OPTIONS_MODE_NAME_ENTRY:
			if index < _player_profile_name.size():
				return "EDIT"
			return "READY"
	return "READY"

func get_time_record_rows() -> Array:
	if _time_records_view == TIME_RECORDS_VIEW_MODE_CHOICE:
		return get_time_records_mode_choice_rows()
	var rows: Array = []
	var course_times := _build_time_record_course_times()
	var record_level_index := _get_time_records_level_index()
	for i in range(course_times.size()):
		rows.append({
			"name": "RANK %d" % [i + 1],
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
	for i in range(_player_profile_name.size()):
		rows.append({
			"label": "LETTER %d" % [i + 1],
			"value": str(_player_profile_name[i]),
			"selected": i == _name_entry_menu_index,
		})
	rows.append({
		"label": "CONFIRM",
		"value": get_profile_name_text(),
		"selected": _name_entry_menu_index == _player_profile_name.size(),
	})
	rows.append({
		"label": "BACK",
		"value": "CANCEL EDIT",
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
	var level_limit := _unlocked_level_index
	if _time_records_context == TIME_RECORDS_CONTEXT_OPTIONS and not _character_unlocked_level_indices.is_empty():
		var character_index := clampi(_time_records_character_index, 0, _character_unlocked_level_indices.size() - 1)
		level_limit = int(_character_unlocked_level_indices[character_index])
	return mini(get_time_records_course_count(), maxi(1, (level_limit / 2) + 1))

func _get_time_records_max_act_for_course(_course_index: int) -> int:
	if _time_records_boss_mode:
		return 0
	var level_limit := _unlocked_level_index
	if _time_records_context == TIME_RECORDS_CONTEXT_OPTIONS and not _character_unlocked_level_indices.is_empty():
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
			"status": "CURRENT" if i == _language_index else "AVAILABLE",
			"selected": i == _language_index,
		})
	return rows

func get_button_config_rows() -> Array:
	var rows: Array = []
	rows.append({
		"label": "A BUTTON",
		"value": _button_bindings[0],
		"status": "ACTIVE" if _button_config_index == 0 else "WAIT",
		"selected": _button_config_index == 0,
	})
	rows.append({
		"label": "B BUTTON",
		"value": _button_bindings[1],
		"status": "ACTIVE" if _button_config_index == 1 else "WAIT",
		"selected": _button_config_index == 1,
	})
	rows.append({
		"label": "R BUTTON",
		"value": _button_bindings[2],
		"status": "ACTIVE" if _button_config_index == 2 else "WAIT",
		"selected": _button_config_index == 2,
	})
	return rows

func get_player_data_rows() -> Array:
	var rows: Array = []
	rows.append({
		"label": "NAME ENTRY",
		"value": get_profile_name_text(),
		"status": "PROFILE",
		"selected": _player_data_menu_index == 0,
	})
	rows.append({
		"label": "TIME RECORDS",
		"value": "BEST TIMES AND STATS",
		"status": "READY",
		"selected": _player_data_menu_index == 1,
	})
	rows.append({
		"label": "MULTI-PAK RECORDS",
		"value": "VERSUS HISTORY",
		"status": "READY",
		"selected": _player_data_menu_index == 2,
	})
	rows.append({
		"label": "BACK",
		"value": "RETURN TO OPTIONS",
		"status": "READY",
		"selected": _player_data_menu_index == 3,
	})
	return rows

func get_options_main_rows() -> Array:
	var rows: Array = []
	rows.append({
		"label": "PLAYER DATA",
		"value": "PROFILE / RECORDS",
		"status": "READY",
	})
	rows.append({
		"label": "DIFFICULTY",
		"value": get_difficulty_text(),
		"status": "OPEN",
	})
	rows.append({
		"label": "TIME LIMIT",
		"value": "ON" if _time_limit_enabled else "OFF",
		"status": "OPEN",
	})
	rows.append({
		"label": "LANGUAGE",
		"value": get_language_text(),
		"status": "READY",
	})
	rows.append({
		"label": "BUTTON CONFIG",
		"value": "EDIT BINDINGS",
		"status": "READY",
	})
	if _sound_test_unlocked:
		rows.append({
			"label": "SOUND TEST",
			"value": "TRACK %02d" % [get_sound_test_track_number()],
			"status": "READY",
		})
	rows.append({
		"label": "DELETE GAME DATA",
		"value": "ERASE PROGRESS",
		"status": "ERASE",
	})
	rows.append({
		"label": "EXIT",
		"value": "RETURN TO TITLE",
		"status": "READY",
	})
	return rows

func get_sound_test_rows() -> Array:
	var rows: Array = []
	var entry := get_sound_test_current_entry()
	rows.append({
		"label": "TRACK",
		"value": "NO. %02d" % [int(entry["number"])],
		"status": "SCROLL",
		"selected": true,
	})
	return rows

func get_sound_test_track_number() -> int:
	return int(get_sound_test_current_entry()["number"])

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
		return "LEFT/RIGHT = CHANGE   %s = SELECT   %s = BACK" % [get_confirm_label(), get_secondary_label()]
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
	if _selected_level_index >= 0 and _selected_level_index < _best_scores.size():
		return "BEST: %d" % _best_scores[_selected_level_index]
	return "BEST: 0"

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
		return "CLEARED"
	if level_index <= _unlocked_level_index:
		return "READY"
	return "LOCKED"

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
	if is_final_intro_screen():
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

func get_intro_prompt_text() -> String:
	if is_final_intro_screen():
		return "VANILLA RESCUED"
	if _run_from_multiplayer and _intro_timer > INTRO_COUNTDOWN_START:
		return "VERSUS START"
	if _intro_timer <= INTRO_GO_TIME:
		return "GO!"
	if _intro_timer <= INTRO_COUNTDOWN_START:
		return get_intro_countdown_text()
	return "READY!"

func get_intro_detail_text() -> String:
	if is_final_intro_screen():
		return "TRUE AREA 53   START TO SKIP   SONIC AWAKENS"
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

func is_race_start_message_visible() -> bool:
	return _game_state == GAME_STATE_PLAYING and _race_start_message_timer > 0.0

func get_race_start_message_progress() -> float:
	return clampf(_race_start_message_timer, 0.0, 1.0)

func get_clear_title_text() -> String:
	if _run_from_time_attack:
		return "TIME ATTACK"
	return "STAGE CLEAR"

func get_clear_prompt_text() -> String:
	if _run_from_time_attack:
		if not is_clear_input_ready():
			return "RESULT DISPLAY"
		return "%s  %s" % [get_clear_result_heading_text(), get_formatted_time(_clear_time_snapshot)]
	return "TIME: %s" % get_formatted_time(_clear_time_snapshot)

func get_clear_detail_text() -> String:
	if _run_from_time_attack:
		if not is_clear_input_ready():
			return "TIME ATTACK RESULT   PLEASE WAIT"
		var record_text := _get_time_attack_record_text()
		return "TIME: %s   RANK: %s\n%s\n%s = LOBBY" % [get_formatted_time(_clear_time_snapshot), _clear_rank_text, record_text, get_confirm_label()]
	if not is_clear_input_ready():
		return "BONUS COUNTING\n%s TO FINISH COUNT" % get_confirm_label()
	if _selected_level_index < _level_names.size() - 1:
		return "SCORE: %d   RANK: %s\nNEXT COURSE: %s" % [_clear_total_display_score, _clear_rank_text, _level_names[_selected_level_index + 1]]
	return "SCORE: %d   RANK: %s\nCOURSE COMPLETE" % [_clear_total_display_score, _clear_rank_text]

func get_clear_footer_text() -> String:
	if not is_clear_input_ready():
		if _run_from_time_attack:
			return "RESULT ANIMATION"
		return "%s = FAST COUNT" % get_confirm_label()
	if _run_from_time_attack:
		return "%s = LOBBY   AUTO RETURN IN 10 SEC" % get_confirm_label()
	return "AUTO COURSE SELECT"

func get_clear_result_heading_text() -> String:
	if not _run_from_time_attack:
		return "RESULT"
	return "NEW RECORD" if _clear_new_best_time else "RESULT"

func get_clear_result_badge_text() -> String:
	if _run_from_time_attack:
		return get_clear_time_attack_medal_text()
	return _clear_rank_text

func get_clear_time_attack_medal_text() -> String:
	match _clear_time_attack_record_rank:
		1:
			return "GOLD"
		2:
			return "SILVER"
		3:
			return "BRONZE"
		_:
			return "TRY"

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
				"label": "TIME",
				"value": get_formatted_time(_clear_time_snapshot),
			},
			{
				"label": "MEDAL",
				"value": get_clear_time_attack_medal_text(),
			},
			{
				"label": "BEST",
				"value": get_clear_time_attack_best_text(),
			},
			{
				"label": "RECORD",
				"value": get_clear_time_attack_record_status_text(),
			},
		]
	var rows: Array = [
		{
			"label": "TIME BONUS",
			"value": str(_clear_time_bonus_remaining),
		},
		{
			"label": "RING BONUS",
			"value": str(_clear_ring_bonus_remaining),
		},
	]
	if _selected_level_index < _level_names.size() - 2:
		rows.append({
			"label": "SP RING BONUS",
			"value": str(_clear_special_ring_bonus_remaining),
		})
	rows.append({
			"label": "TOTAL SCORE",
			"value": str(_clear_total_display_score),
	})
	return rows

func get_clear_stage_label() -> String:
	if _run_from_time_attack and _time_attack_boss_mode:
		return "%s BOSS" % get_level_name_by_index(_selected_level_index)
	if _selected_level_index >= 0 and _selected_level_index < _level_names.size():
		return _level_names[_selected_level_index]
	return "STAGE"

func _get_time_attack_record_text() -> String:
	if _clear_new_best_time:
		return "NEW RECORD"
	if _clear_rank_text == "A":
		return "GREAT RUN"
	if _clear_rank_text == "B":
		return "GOOD TIME"
	return "TRY AGAIN"

func get_clear_time_attack_record_status_text() -> String:
	if not _run_from_time_attack:
		return ""
	if _clear_new_best_time:
		return "RECORD UPDATED"
	if _clear_previous_best_time >= 0.0:
		return "BEST STANDS"
	return "FIRST CLEAR"

func get_clear_time_attack_best_text() -> String:
	if not _run_from_time_attack:
		return ""
	var best_time := _get_time_attack_best_time(_get_current_time_attack_record_key())
	if best_time >= 0.0:
		return get_formatted_time(best_time)
	return "NO DATA"

func get_game_over_title_text() -> String:
	return "TIME OVER" if _game_over_time_over else "GAME OVER"

func get_game_over_primary_word() -> String:
	return "TIME" if _game_over_time_over else "GAME"

func get_game_over_secondary_word() -> String:
	return "OVER"

func get_game_over_prompt_text() -> String:
	if _game_over_time_over:
		return "TIME LIMIT REACHED"
	if _run_from_time_attack:
		return "RETRY THE ATTACK"
	return "ALL LIVES LOST"

func get_game_over_detail_text() -> String:
	# The original Game Over task is an automatic cutscene; it does not expose
	# a confirm/cancel prompt while the destination timer is running.
	return ""

func get_game_over_status_text() -> String:
	if not is_game_over_input_ready():
		return ""
	if _run_from_time_attack:
		return "TIME ATTACK STANDBY"
	return "RESTARTING STAGE" if _game_over_time_over else "RETURNING TO TITLE"

func get_game_over_progress() -> float:
	var total_time: float = 3.6 if _run_from_time_attack else 4.6
	if total_time <= 0.0:
		return 1.0
	return clampf(1.0 - (_game_over_timer / total_time), 0.0, 1.0)

func get_game_over_slide_offset() -> float:
	var progress := get_game_over_progress()
	if _run_from_time_attack:
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
	return "GET THE CHAOS EMERALDS!"

func get_chaos_emeralds_prompt_text() -> String:
	return "ALL COURSES CLEARED"

func get_chaos_emeralds_detail_text() -> String:
	return "EGGMAN WON'T GET AWAY NEXT TIME\n%s CONTINUE   %s SKIP" % [get_confirm_label(), get_secondary_label()]

func get_chaos_emeralds_summary_text() -> String:
	return "EMERALDS\nALL FOUND\n\nPROFILE\n%s\n\nNEXT\nTITLE SCREEN" % get_profile_name_text()

func get_missing_emeralds_title_text() -> String:
	return "COLLECT ALL CHAOS EMERALDS"

func get_missing_emeralds_prompt_text() -> String:
	return "A NEW ADVENTURE AWAITS"

func get_missing_emeralds_detail_text() -> String:
	return "%s CONTINUE   %s SKIP" % [get_confirm_label(), get_secondary_label()]

func get_missing_emeralds_count() -> int:
	return get_chaos_emerald_count()

func get_chaos_emeralds_rows() -> Array:
	return [
		{"label": "GREEN", "active": true},
		{"label": "YELLOW", "active": true},
		{"label": "BLUE", "active": true},
		{"label": "RED", "active": true},
		{"label": "PURPLE", "active": true},
		{"label": "CYAN", "active": true},
		{"label": "WHITE", "active": true},
	]

func get_to_be_continued_title_text() -> String:
	return "TO BE CONTINUED"

func get_to_be_continued_prompt_text() -> String:
	return "NEXT STORY CHAPTER AHEAD"

func get_to_be_continued_detail_text() -> String:
	return "%s CONTINUE   %s SKIP" % [get_confirm_label(), get_secondary_label()]

func get_sega_logo_title_text() -> String:
	return "SEGA"

func get_sega_logo_prompt_text() -> String:
	return "PRESENTED BY SEGA"

func get_sega_logo_detail_text() -> String:
	return "%s SKIP" % get_confirm_label()

func get_sonic_team_logo_title_text() -> String:
	return "SONIC TEAM"

func get_sonic_team_logo_prompt_text() -> String:
	return "CREATED BY SONIC TEAM"

func get_sonic_team_logo_detail_text() -> String:
	return "%s SKIP   AUTO TITLE" % get_confirm_label()

func get_credits_title_text() -> String:
	return "SONIC ADVANCE 2   %s" % get_ending_variant_label()

func get_credits_page_text() -> String:
	var pages := [
		"CREDITS SLIDE 01\nSONIC ADVANCE 2",
		"CREDITS SLIDE 02\nSONIC TEAM",
		"CREDITS SLIDE 03\nORIGINAL GAME DESIGN",
		"CREDITS SLIDE 04\nPROGRAMMING",
		"CREDITS SLIDE 05\nART AND ANIMATION",
		"CREDITS SLIDE 06\nMUSIC AND SOUND",
		"CREDITS SLIDE 07\nSPECIAL THANKS",
		"CREDITS SLIDE 08\nSONIC TEAM",
		"CREDITS SLIDE 09\nCHARACTER ART",
		"CREDITS SLIDE 10\nSTAGE ART",
		"CREDITS SLIDE 11\nANIMATION",
		"CREDITS SLIDE 12\nPROGRAMMING",
		"CREDITS SLIDE 13\nTOOLS AND TECHNOLOGY",
		"CREDITS SLIDE 14\nMUSIC",
		"CREDITS SLIDE 15\nSOUND EFFECTS",
		"CREDITS SLIDE 16\nVOICE AND LOCALIZATION",
		"CREDITS SLIDE 17\nQUALITY ASSURANCE",
		"CREDITS SLIDE 18\nSPECIAL THANKS",
		"CREDITS SLIDE 19\nTHE SONIC COMMUNITY",
		"CREDITS SLIDE 20\nSAT-R DEVELOPMENT",
		"CREDITS SLIDE 21\nORIGINAL GAME DESIGN",
		"CREDITS SLIDE 22\nSONIC TEAM",
		"CREDITS SLIDE 23\nTHANK YOU",
		"CREDITS SLIDE 24\nSONIC ADVANCE 2",
		"CREDITS SLIDE 25\nSONIC ADVANCE RECLAIMED",
	]
	var page_text: String = str(pages[clampi(_credits_page, 0, pages.size() - 1)])
	if _ending_variant == ENDING_VARIANT_EXTRA and _credits_page == 0:
		return "EXTRA ENDING\n" + page_text
	if _ending_variant == ENDING_VARIANT_FINAL and _credits_page == 0:
		return "FINAL ENDING\n" + page_text
	return page_text

func get_credits_detail_text() -> String:
	return "%s NEXT   %s SKIP" % [get_confirm_label(), get_secondary_label()]

func get_credits_page_index() -> int:
	return _credits_page

func get_credits_page_count() -> int:
	return _credits_page_count

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
	_status_text = "SPECIAL STAGE PAUSED" if _special_stage_paused else "SPECIAL STAGE RUN"

func move_special_stage_pause_selection(direction: int) -> void:
	if not _special_stage_paused:
		return
	_special_stage_pause_cursor = clampi(_special_stage_pause_cursor + signi(direction), 0, 1)

func confirm_special_stage_pause_selection() -> void:
	if not _special_stage_paused:
		return
	if _special_stage_pause_cursor == 0:
		_special_stage_paused = false
		_status_text = "SPECIAL STAGE RUN"
	else:
		open_title_screen_and_skip_intro()

func get_special_stage_pause_text() -> String:
	var resume_prefix := "> " if _special_stage_pause_cursor == 0 else "  "
	var quit_prefix := "> " if _special_stage_pause_cursor == 1 else "  "
	return "PAUSED\n%sRESUME\n%sQUIT TO TITLE" % [resume_prefix, quit_prefix]

func is_special_stage_paused() -> bool:
	return _special_stage_paused

func is_special_stage_running_screen() -> bool:
	return _game_state == GAME_STATE_SPECIAL_STAGE and _special_stage_phase == 1

func get_special_stage_title_text() -> String:
	if _special_stage_phase == 0:
		return "SPECIAL STAGE"
	if _special_stage_phase == 1:
		return "SPECIAL STAGE RUN"
	return "SPECIAL STAGE RESULTS"

func get_special_stage_prompt_text() -> String:
	if _special_stage_paused:
		return "SPECIAL STAGE PAUSED"
	if _special_stage_phase == 0:
		return "CHAOS EMERALD CHALLENGE READY"
	if _special_stage_phase == 1:
		return "COLLECT RINGS   LANE %d / 3" % (_special_stage_lane + 1)
	if _special_stage_target_reached:
		return "TARGET REACHED   EMERALD %02d" % (_special_stage_emerald_index + 1)
	return "TARGET MISSED   TRY AGAIN"

func get_special_stage_detail_text() -> String:
	if _special_stage_paused:
		return "%s RESUME   %s RESUME" % [get_confirm_label(), get_secondary_label()]
	if _special_stage_phase == 0:
		return "7 SPECIAL RINGS FOUND\n%s ENTER   %s SKIP" % [get_confirm_label(), get_secondary_label()]
	if _special_stage_phase == 1:
		return "TIME %03d   RINGS %03d / %03d   %02d%% COMPLETE\nLEFT/RIGHT CHANGE LANES" % [ceili(_special_stage_timer), _special_stage_ring_count, _special_stage_run_target, int(_special_stage_progress * 100.0)]
	return "RINGS %03d   POINTS %05d\n%s CONTINUE   %s SKIP" % [_special_stage_ring_count, _special_stage_score, get_confirm_label(), get_secondary_label()]

func get_special_stage_emerald_index() -> int:
	return _special_stage_emerald_index

func is_special_stage_target_reached() -> bool:
	return _special_stage_target_reached

func get_special_stage_ring_count() -> int:
	return _special_stage_ring_count

func get_special_stage_timer() -> float:
	return _special_stage_timer

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
	return "SONIC TEAM   ALL RIGHTS RESERVED\n%s CONTINUE   %s SKIP" % [get_confirm_label(), get_secondary_label()]

func get_credits_end_title_text() -> String:
	return "SONIC ADVANCE 2\n%s" % get_ending_variant_label()

func get_credits_end_prompt_text() -> String:
	if _ending_variant == ENDING_VARIANT_EXTRA:
		return "TRUE AREA 53 COMPLETE"
	if _ending_variant == ENDING_VARIANT_FINAL:
		return "FINAL ZONE COMPLETE"
	return "CONGRATULATIONS" if get_chaos_emerald_count() >= 7 else "ADVENTURE COMPLETE"

func get_credits_end_detail_text() -> String:
	var emerald_text := "ALL CHAOS EMERALDS COLLECTED" if get_chaos_emerald_count() >= 7 else "CHAOS EMERALDS: %d/7" % get_chaos_emerald_count()
	return "%s\n%s\n%s CONTINUE   %s SKIP" % [get_ending_variant_label(), emerald_text, get_confirm_label(), get_secondary_label()]

func get_character_unlock_title_text() -> String:
	return "NEW CHARACTER"

func get_character_unlock_prompt_text() -> String:
	if _character_unlock_pending < 0:
		return "CHARACTER UNLOCKED"
	return "%s UNLOCKED" % _character_names[_character_unlock_pending]

func get_character_unlock_detail_text() -> String:
	if _character_unlock_pending < 0:
		return "%s CONTINUE   %s SKIP" % [get_confirm_label(), get_secondary_label()]
	var description: String = str(_character_descriptions[_character_unlock_pending])
	return "%s\n%s CONTINUE   %s SKIP" % [description, get_confirm_label(), get_secondary_label()]

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
		return _clear_input_lock_timer <= 0.0
	return _clear_counting_done and _clear_input_lock_timer <= 0.0

func is_time_attack_clear_screen() -> bool:
	return is_clear_screen() and _run_from_time_attack

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
		# stage_results.c grants the next ending stage when Final Zone is cleared.
		_unlocked_level_index = maxi(_unlocked_level_index, _level_names.size() - 1)
		_true_area_unlocked = true
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
	_unlocked_level_index = clampi(int(_character_unlocked_level_indices[active_character]), 0, _level_names.size() - 1)
	_selected_level_index = clampi(_selected_level_index, 0, _unlocked_level_index)

func _collect_chaos_emerald_for_clear() -> void:
	# This is called after the special-stage target is reached. Its ring total
	# is separate from the seven special rings collected in the course.
	var emerald_index := _get_selected_zone_index()
	_chaos_emerald_mask |= 1 << emerald_index
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
	var completed_count := 0
	for completed in _completed_character_routes:
		if bool(completed):
			completed_count += 1
	if completed_count >= 1:
		_tiny_chao_unlocked = true
	if completed_count >= 2:
		_sound_test_unlocked = true
	if completed_count >= 3:
		_boss_time_attack_unlocked = true
	if completed_count >= 4:
		_character_unlocked[4] = true
		_true_area_unlocked = true
	_save_save_data()

func get_chaos_emerald_count() -> int:
	var count := 0
	for i in range(7):
		if (_chaos_emerald_mask & (1 << i)) != 0:
			count += 1
	return count

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
	var sanitized: Array = []
	for i in range(defaults.size()):
		if i < source.size():
			var action_name := str(source[i]).strip_edges().to_upper()
			sanitized.append(action_name if not action_name.is_empty() else defaults[i])
		else:
			sanitized.append(defaults[i])
	return sanitized

func _sanitize_multiplayer_record_rows(raw_rows: Variant) -> Array:
	if raw_rows is not Array:
		return _get_default_multiplayer_record_rows()
	var source: Array = raw_rows
	var sanitized: Array = []
	for entry in source:
		if entry is not Dictionary:
			continue
		var row: Dictionary = entry
		var name_text := str(row.get("name", "PLAYER")).strip_edges().to_upper()
		sanitized.append({
			"name": name_text if not name_text.is_empty() else "PLAYER",
			"wins": maxi(0, int(row.get("wins", 0))),
			"losses": maxi(0, int(row.get("losses", 0))),
			"draws": maxi(0, int(row.get("draws", 0))),
		})
		if sanitized.size() >= 10:
			break
	if sanitized.is_empty():
		return _get_default_multiplayer_record_rows()
	return sanitized

func _sanitize_multiplayer_record_totals(raw_totals: Variant) -> Dictionary:
	if raw_totals is not Dictionary:
		return _get_default_multiplayer_record_totals()
	var totals: Dictionary = raw_totals
	return {
		"wins": maxi(0, int(totals.get("wins", 0))),
		"losses": maxi(0, int(totals.get("losses", 0))),
		"draws": maxi(0, int(totals.get("draws", 0))),
	}

func _insert_or_promote_multiplayer_record(name: String) -> int:
	var normalized_name := name.strip_edges().to_upper()
	if normalized_name.is_empty():
		normalized_name = "PLAYER"
	for i in range(_multi_record_rows.size()):
		var row: Dictionary = _multi_record_rows[i] as Dictionary
		if str(row.get("name", "")).to_upper() == normalized_name:
			if i > 0:
				var existing := row.duplicate(true)
				_multi_record_rows.remove_at(i)
				_multi_record_rows.insert(0, existing)
			return 0
	_multi_record_rows.insert(0, {
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

func _record_multiplayer_result(name: String, result_key: String) -> void:
	if name.strip_edges().is_empty():
		return
	var row_index := _insert_or_promote_multiplayer_record(name)
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
	_unlocked_level_index = 0
	_character_unlocked_level_indices = [0, 0, 0, 0, 0]
	_best_scores = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	_level_cleared_flags = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
	_time_attack_best_times = {}
	_time_attack_record_tables = {}
	_difficulty_index = 0
	_time_limit_enabled = true
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
	_character_unlocked = [true, false, false, false, false]
	_completed_character_routes = [false, false, false, false, false]
	_extra_ending_credits_played = false
	_tiny_chao_roster = _get_default_tiny_chao_roster()
	_true_area_unlocked = false
	if not FileAccess.file_exists(_save_path):
		return
	var file := FileAccess.open(_save_path, FileAccess.READ)
	if file == null:
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
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
	if parsed.has("selected_level_index"):
		_selected_level_index = clamp(int(parsed["selected_level_index"]), 0, _unlocked_level_index)
	if parsed.has("best_scores") and parsed["best_scores"] is Array:
		var scores: Array = parsed["best_scores"]
		for i in range(min(scores.size(), _best_scores.size())):
			_best_scores[i] = int(scores[i])
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
	if parsed.has("chaos_emerald_mask"):
		_chaos_emerald_mask = clampi(int(parsed["chaos_emerald_mask"]), 0, 127)
	_sync_active_character_level_progress()

func _save_save_data() -> void:
	var payload := {
		"unlocked_level_index": _unlocked_level_index,
		"character_unlocked_level_indices": _character_unlocked_level_indices,
		"selected_level_index": _selected_level_index,
		"best_scores": _best_scores,
		"level_cleared_flags": _level_cleared_flags,
		"time_attack_best_times": _time_attack_best_times,
		"time_attack_record_tables": _time_attack_record_tables,
		"tiny_chao_unlocked": _tiny_chao_unlocked,
		"tiny_chao_roster": _tiny_chao_roster,
		"true_area_unlocked": _true_area_unlocked,
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
	}
	var file := FileAccess.open(_save_path, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(JSON.stringify(payload))

func _reset_progress() -> void:
	_unlocked_level_index = 0
	_character_unlocked_level_indices = [0, 0, 0, 0, 0]
	_selected_level_index = 0
	_best_scores = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	_level_cleared_flags = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
	_time_attack_best_times = {}
	_time_attack_record_tables = {}
	_tiny_chao_unlocked = false
	_tiny_chao_roster = _get_default_tiny_chao_roster()
	_true_area_unlocked = false
	_difficulty_index = 0
	_time_limit_enabled = true
	_language_index = 1
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
	_save_reset_pending = false
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
