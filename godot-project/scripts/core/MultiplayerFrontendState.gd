class_name MultiplayerFrontendState
extends RefCounted

## Mutable state for multiplayer title, connection, transfer and result flows.
## The dedicated lobby model owns lobby-specific rows and outcomes.
var return_to_multiplayer_after_name_entry: bool = false
var return_to_title_after_new_profile: bool = false
var creating_new_profile: bool = false
var return_to_multiplayer_menu_index: int = 0
var name_entry_snapshot: Array = []
var pak_mode: int = 0
var link_players: Array = ["YOU", "P2", "P3", "P4"]
var link_connected: Array = [true, false, false, false]
var player_characters: Array = [0, 1, 2, 3]
var player_ranks: Array = [0, 1, 2, 3]
var link_ready: bool = false
var disconnect_timer: float = 0.0
var download_progress: int = 0
var download_timer: float = 0.0
var sync_step: int = 0
var result_mode: int = 1
var result_snapshot: Array = []
var results_cursor: int = 0
var results_timer: float = 0.0
var results_character_duration: float = 1.0
var results_course_duration: float = 5.0
