extends SceneTree

const SourceTilemapTextureImpl = preload("res://scripts/SourceTilemapTexture.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var credits := SourceTilemapTextureImpl.compose("credits_0")
	_check(credits != null, "credits source tilemap composes")
	if credits:
		_check(credits.get_width() == 240 and credits.get_height() == 160, "credits tilemap is 30x20")
	var notification := SourceTilemapTextureImpl.compose("collect_all_chaos_emeralds_en")
	_check(notification != null, "missing emerald source card composes")
	if notification:
		_check(notification.get_width() == 240 and notification.get_height() == 48, "notification tilemap is 30x6")
	for language in ["jp", "en", "de", "fr", "es", "it"]:
		_check(SourceTilemapTextureImpl.compose("collect_all_chaos_emeralds_%s" % language) != null, "localized notification %s composes" % language)
	var unlock := SourceTilemapTextureImpl.compose("unlocked_tiny_chao_garden_en")
	_check(unlock != null, "unlock source card composes")
	if unlock:
		_check(unlock.get_width() == 240 and unlock.get_height() == 56, "unlock tilemap is 30x7")
	_check(SourceTilemapTextureImpl.compose("credits_sa2_logo_en") != null, "credits end logo composes")
	_check(SourceTilemapTextureImpl.compose("storyframe_sonic_leaves_0") != null, "extra ending storyframe composes")
	_check(SourceTilemapTextureImpl.compose("intro_presented_by_sega") != null, "Sega intro card composes")
	_check(SourceTilemapTextureImpl.compose("intro_created_by_sonic_team") != null, "Sonic Team intro card composes")
	var title_logo := SourceTilemapTextureImpl.compose("sa2_logo_en", 26, 1)
	_check(title_logo != null, "English title logo composes")
	if title_logo:
		_check(title_logo.get_width() == 208 and title_logo.get_height() == 80, "title logo keeps original 26x10 grid")
	_check(SourceTilemapTextureImpl.compose("sa2_title_logo_jp", 26, 1) != null, "Japanese title logo composes")
	var title_background := SourceTilemapTextureImpl.compose("title_screen_bg", 32, 2)
	_check(title_background != null and title_background.get_width() == 256 and title_background.get_height() == 512, "title background composes at source dimensions")
	for final_source in ["cutscene_final_ending_fall_bg", "cutscene_final_ending_fall_clouds"]:
		var final_texture := SourceTilemapTextureImpl.compose(final_source, 32)
		_check(final_texture != null, "%s composes" % final_source)
		if final_texture:
			_check(final_texture.get_width() == 256 and final_texture.get_height() == 256, "%s keeps 32x32 source grid" % final_source)
	for special_index in range(1, 8):
		_check(SourceTilemapTextureImpl.compose("special_stage_%d_bg" % special_index, 32) != null, "special stage %d background composes" % special_index)
	for character in ["cream", "tails", "knuckles"]:
		for segment in range(4):
			_check(SourceTilemapTextureImpl.compose("storyframe_%s_unlock_%d" % [character, segment]) != null, "%s slide %d composes" % [character, segment])
			_check(SourceTilemapTextureImpl.compose("storyframe_%s_unlock_%d_dlg_en" % [character, segment]) != null, "%s dialogue %d composes" % [character, segment])
	print("SOURCE_TILEMAP_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("SOURCE_TILEMAP_FAIL: " + label)
