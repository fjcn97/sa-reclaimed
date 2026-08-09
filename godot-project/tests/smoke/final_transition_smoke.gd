extends SceneTree

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge._selected_level_index = 14
	bridge._ending_variant = bridge.ENDING_VARIANT_FINAL
	bridge._chaos_emerald_masks = [0, 0, 0, 0, 0]
	bridge._completed_character_routes = [false, false, false, false, false]
	bridge._open_credits()
	if not bridge.is_credits_screen():
		push_error("FINAL_TRANSITION_FAILED credits=false")
		quit(1)
		return
	for _page in range(25):
		bridge._advance_credits_page()
	if not bridge.is_credits_end_screen():
		push_error("FINAL_TRANSITION_FAILED credits_end=false")
		quit(1)
		return
	bridge.advance_ui_timers(4.6)
	if not bridge.is_copyright_screen():
		push_error("FINAL_TRANSITION_FAILED copyright=false")
		quit(1)
		return
	bridge.advance_ui_timers(4.6)
	if not bridge.is_missing_emeralds_screen():
		push_error("FINAL_TRANSITION_FAILED missing_emeralds=false")
		quit(1)
		return
	bridge.advance_ui_timers(7.1)
	if not bridge.is_title_screen():
		push_error("FINAL_TRANSITION_FAILED title=false")
		quit(1)
		return
	print("FINAL_TRANSITION_CHECKS=6")
	quit(0)
