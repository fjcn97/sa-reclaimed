class_name SaveOptionsInputRouter
extends RefCounted

const COMMAND_POLICY := preload("res://scripts/core/SaveOptionsCommandPolicy.gd")

## The frame-input entry point deliberately shares the same command policy as
## direct keyboard events.  Translation is the only responsibility of callers.
static func handle(bridge: Object, frame_input: int) -> bool:
	return COMMAND_POLICY.execute_frame(bridge, frame_input)
