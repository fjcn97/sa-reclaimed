class_name CreditsState
extends RefCounted

## Owns credits page progression and the post-credits story-card timing.

var timer: float = 0.0
var page: int = 0
var page_duration: float = 2.5
var page_count: int = 25
var end_timer: float = 0.0
var end_duration: float = 4.5
var end_story_frame: int = 0
var end_story_timer: float = 0.0
var end_show_missing_emeralds: bool = false

func reset() -> void:
	timer = 0.0
	page = 0
	end_timer = 0.0
	end_story_frame = 0
	end_story_timer = 0.0
	end_show_missing_emeralds = false
