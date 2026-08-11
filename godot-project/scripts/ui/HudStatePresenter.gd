# Presentation queries for gameplay state consumed by HUD.gd.
extends RefCounted
class_name HudStatePresenter

static func time_text(bridge: Object) -> String:
	# stage_ui.c clamps rendered digits even when the gameplay time limit is off.
	var display_time := minf(bridge.get_gameplay_runtime_state().elapsed_time, bridge.MAX_COURSE_TIME_SECONDS - 0.01)
	return bridge.get_formatted_time(display_time)

static func timer_warning(bridge: Object) -> bool:
	return (bridge.get_run_mode_state().from_time_attack or bridge.get_profile_state().time_limit_enabled) and bridge.get_gameplay_runtime_state().elapsed_time >= 580.0

static func special_ring_count(bridge: Object) -> int:
	return bridge.get_player_state().special_rings

static func special_ring_text(bridge: Object) -> String:
	return "%s  %d/7" % [bridge.language_text("SP RINGS", "SPEZIALRINGE", "ANNEAUX SP", "ANILLOS SP", "ANELLI SP"), special_ring_count(bridge)]

static func race_start_text(bridge: Object) -> String:
	return bridge.language_text("GO!", "LOS!", "GO!", "YA!", "VIA!")

static func boss_title_text(bridge: Object, health: int, max_health: int) -> String:
	return "%s  %02d/%02d" % [bridge.language_text("BOSS", "BOSS", "BOSS", "JEFE", "BOSS"), health, max_health]

static func boss_phase_text(bridge: Object, phase: String) -> String:
	return "%s  %s" % [bridge.language_text("PHASE", "PHASE", "PHASE", "FASE", "FASE"), phase]

static func multiplayer_start_flag_text(bridge: Object) -> String:
	return bridge.language_text("ST", "ST", "DEB", "INI", "AVV")

static func multiplayer_finish_flag_text(bridge: Object) -> String:
	return bridge.language_text("GOAL", "ZIEL", "BUT", "META", "TRAGUARDO")

static func powerup_text(bridge: Object) -> String:
	if bridge.get_player_ability_state().invincibility_timer > 0.0:
		return "%s %02d" % [bridge.language_text("INV", "UNV", "INV", "INV", "INV"), ceili(bridge.get_player_ability_state().invincibility_timer)]
	if bridge.get_gameplay_runtime_state().speed_up_timer > 0.0:
		return "%s %02d" % [bridge.language_text("SPEED", "TEMPO", "VITESSE", "VELOCIDAD", "VELOCITA"), ceili(bridge.get_gameplay_runtime_state().speed_up_timer)]
	if bridge.get_gameplay_runtime_state().magnetic_shielded:
		return bridge.language_text("MAGNETIC", "MAGNETISCH", "MAGNETIQUE", "MAGNETICO", "MAGNETICO")
	if bridge.get_player_state().shielded:
		return bridge.language_text("SHIELD", "SCHILD", "BOUCLIER", "ESCUDO", "SCUDO")
	return ""

static func shield_active(bridge: Object) -> bool:
	return bridge.get_player_state().shielded and not bridge.get_gameplay_runtime_state().magnetic_shielded and bridge.get_player_ability_state().invincibility_timer <= 0.0 and bridge.get_gameplay_runtime_state().speed_up_timer <= 0.0

static func magnetic_shielded(bridge: Object) -> bool:
	return bridge.get_gameplay_runtime_state().magnetic_shielded and bridge.get_player_state().shielded

static func invincible(bridge: Object) -> bool:
	return bridge.get_player_ability_state().invincibility_timer > 0.0

static func speed_up_active(bridge: Object) -> bool:
	return bridge.get_gameplay_runtime_state().speed_up_timer > 0.0

static func special_ring_visible(bridge: Object) -> bool:
	return not bridge.get_run_mode_state().from_multiplayer and not (bridge.get_run_mode_state().from_time_attack and bridge.get_time_attack_session_state().boss_mode)

static func titles(bridge: Object) -> Dictionary:
	if bridge.get_run_mode_state().from_multiplayer:
		return {
			"score": bridge.language_text("PTS", "PKT", "PTS", "PTS", "PTI"),
			"rings": bridge.language_text("RINGS", "RINGE", "ANNEAUX", "ANILLOS", "ANELLI"),
			"time": bridge.language_text("TIME", "ZEIT", "TEMPS", "TIEMPO", "TEMPO"),
			"lives": bridge.language_text("VS", "VS", "VS", "VS", "VS"),
		}
	return {
		"score": bridge.language_text("SCORE", "PUNKTE", "SCORE", "PUNTOS", "PUNTEGGIO"),
		"rings": bridge.language_text("RINGS", "RINGE", "ANNEAUX", "ANILLOS", "ANELLI"),
		"time": bridge.language_text("TIME", "ZEIT", "TEMPS", "TIEMPO", "TEMPO"),
		"lives": bridge.language_text("LIFE", "LEBEN", "VIE", "VIDA", "VITE"),
	}

static func character_short_name(character_variant: int) -> String:
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

static func chrome_colors(bridge: Object) -> Dictionary:
	if bridge.get_run_mode_state().from_multiplayer:
		return {
			"score_card": Color(0.32, 0.12, 0.10, 0.92), "rings_card": Color(0.44, 0.22, 0.06, 0.92),
			"lives_card": Color(0.24, 0.10, 0.18, 0.92), "timer_card": Color(0.30, 0.12, 0.20, 0.92),
			"status_card": Color(0.18, 0.08, 0.12, 0.90), "score_title": Color(1.0, 0.82, 0.52, 0.94),
			"rings_title": Color(1.0, 0.88, 0.44, 0.96), "time_title": Color(1.0, 0.82, 0.58, 0.94),
			"lives_title": Color(1.0, 0.74, 0.54, 0.94), "character": Color(1.0, 0.96, 0.88, 1.0),
			"text": Color(1.0, 0.96, 0.92, 1.0), "rings_value": Color(1.0, 0.92, 0.42, 1.0),
		}
	return {
		"score_card": Color(0.08, 0.16, 0.38, 0.92), "rings_card": Color(0.34, 0.18, 0.04, 0.92),
		"lives_card": Color(0.08, 0.14, 0.28, 0.92), "timer_card": Color(0.12, 0.18, 0.42, 0.92),
		"status_card": Color(0.08, 0.10, 0.18, 0.86), "score_title": Color(0.68, 0.86, 1.0, 0.94),
		"rings_title": Color(1.0, 0.84, 0.36, 0.96), "time_title": Color(0.74, 0.88, 1.0, 0.94),
		"lives_title": Color(0.72, 0.84, 1.0, 0.94), "character": Color(0.98, 0.98, 1.0, 1.0),
		"text": Color(0.96, 0.98, 1.0, 1.0), "rings_value": Color(1.0, 0.92, 0.42, 1.0),
	}

static func multiplayer_progress(bridge: Object, player_index: int) -> float:
	var multiplayer = bridge.get_multiplayer_frontend_state()
	if player_index == 0:
		var level_state: LevelState = bridge.get_level_state()
		var level_span: float = maxf(1.0, level_state.max_x - level_state.min_x)
		return clampf((bridge.get_player_state().world_x - level_state.min_x) / level_span, 0.0, 1.0)
	var rank_value: int = -1
	if player_index >= 0 and player_index < multiplayer.player_ranks.size():
		rank_value = int(multiplayer.player_ranks[player_index])
	var place_offset: float = float(maxi(0, rank_value))
	var host_progress: float = multiplayer_progress(bridge, 0)
	return clampf(host_progress + 0.08 - place_offset * 0.11, 0.0, 1.0)

static func multiplayer_rows(bridge: Object) -> Array:
	var multiplayer = bridge.get_multiplayer_frontend_state()
	var rows: Array = []
	if not bridge.get_run_mode_state().from_multiplayer:
		return rows
	var connected_indices: Array = []
	for i in range(multiplayer.link_connected.size()):
		if bool(multiplayer.link_connected[i]):
			connected_indices.append(i)
	connected_indices.sort_custom(func(a: Variant, b: Variant) -> bool:
		return multiplayer_progress(bridge, int(a)) > multiplayer_progress(bridge, int(b))
	)
	for place in range(connected_indices.size()):
		var player_index: int = int(connected_indices[place])
		var character_index := clampi(int(multiplayer.player_characters[player_index]), 0, bridge.get_character_names().size() - 1)
		var progress_value := multiplayer_progress(bridge, player_index)
		rows.append({
			"name": bridge.get_multiplayer_link_player_name(player_index),
			"character": str(bridge.get_character_names()[character_index]),
			"place": place + 1,
			"place_text": "P%d" % [place + 1],
			"progress": progress_value,
			"progress_text": "%02d%%" % [int(progress_value * 100.0)],
			"is_local": player_index == 0,
		})
	return rows

static func boss_state(bridge: Object) -> Dictionary:
	for entity_variant in bridge.get_level_state().entities:
		if not entity_variant is EntityState:
			continue
		var entity: EntityState = entity_variant as EntityState
		if entity.type != bridge.ENTITY_BOSS or not entity.active:
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
