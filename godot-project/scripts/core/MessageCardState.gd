class_name MessageCardState
extends RefCounted

## Owns transient timing and completion state for non-interactive message cards.

var chaos_emeralds_timer: float = 0.0
var chaos_emeralds_duration: float = 7.0
var chaos_emeralds_message_seen: bool = false
var missing_emeralds_timer: float = 0.0
var missing_emeralds_duration: float = 7.0
var to_be_continued_timer: float = 0.0
var to_be_continued_duration: float = 3.0
var sega_logo_timer: float = 0.0
var sega_logo_duration: float = 2.0
var sonic_team_timer: float = 0.0
var sonic_team_duration: float = 2.0

func reset_transient() -> void:
	chaos_emeralds_timer = 0.0
	missing_emeralds_timer = 0.0
	to_be_continued_timer = 0.0
	sega_logo_timer = 0.0
	sonic_team_timer = 0.0
