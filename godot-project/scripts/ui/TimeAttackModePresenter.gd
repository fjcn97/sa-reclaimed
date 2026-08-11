class_name TimeAttackModePresenter
extends RefCounted

static func rows(bridge: Object) -> Array:
	var title_navigation = bridge.get_title_navigation_state()
	return [
		{"name": bridge.language_text("ZONE", "ZONE", "ZONE", "ZONA", "ZONA"), "description": bridge.language_text("CLEAR A ZONE AS FAST AS POSSIBLE", "EINE ZONE SO SCHNELL WIE MOEGLICH ABSCHLIESSEN", "TERMINER UNE ZONE LE PLUS VITE POSSIBLE", "SUPERA UNA ZONA LO MAS RAPIDO POSIBLE", "COMPLETA UNA ZONA IL PIU VELOCE POSSIBILE"), "status": bridge.language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO"), "locked": false, "selected": title_navigation.menu_index == 0},
		{"name": bridge.language_text("BOSS", "BOSS", "BOSS", "JEFE", "BOSS"), "description": bridge.language_text("DEFEAT A BOSS AS FAST AS POSSIBLE", "EINEN BOSS SO SCHNELL WIE MOEGLICH BESIEGEN", "VAINCRE UN BOSS LE PLUS VITE POSSIBLE", "DERROTA AL JEFE LO MAS RAPIDO POSIBLE", "SCONFIGGI UN BOSS IL PIU VELOCE POSSIBILE"), "status": bridge.language_text("READY", "BEREIT", "PRET", "LISTO", "PRONTO") if bridge.is_boss_time_attack_unlocked() else bridge.language_text("LOCKED", "GESPERRT", "VERROUILLE", "BLOQUEADO", "BLOCCATO"), "locked": not bridge.is_boss_time_attack_unlocked(), "selected": title_navigation.menu_index == 1},
	]

static func title_text(bridge: Object) -> String:
	return bridge.language_text("TIME ATTACK", "ZEITANGRIFF", "CONTRE LA MONTRE", "CONTRARRELOJ", "ATTACCO A TEMPO")

static func prompt_text(bridge: Object) -> String:
	if not bridge.get_title_navigation_state().notice_text.is_empty():
		return bridge.get_title_notice_text()
	return bridge.language_text("SELECT ATTACK MODE", "ANGRIFFSMODUS WAEHLEN", "CHOISIR LE MODE D'ATTAQUE", "ELIGE MODO DE ATAQUE", "SCEGLI MODALITA ATTACCO")

static func detail_text(bridge: Object) -> String:
	return "%s\n%s SELECT   %s CONFIRM   %s BACK" % [bridge.language_text("CLEAR RECORDS AND BOSS CHALLENGES", "REKORDE UND BOSS-HERAUSFORDERUNGEN", "RECORDS ET DEFIS BOSS", "RECORDS Y RETOS DE JEFE", "RECORD E SFIDE BOSS"), bridge.get_navigation_label(), bridge.get_confirm_label(), bridge.get_secondary_label()]

static func summary_text(bridge: Object) -> String:
	match bridge.get_title_navigation_state().menu_index:
		0:
			return "%s\n%s: %s\n%s: %s" % [bridge.language_text("ZONE TIME ATTACK", "ZONEN-ZEITANGRIFF", "CONTRE-LA-MONTRE ZONE", "CONTRARRELOJ DE ZONA", "ATTACCO A TEMPO ZONA"), bridge.language_text("COURSE", "KURS", "PARCOURS", "FASE", "CORSO"), bridge.get_selected_level_text(), bridge.language_text("CHARACTER", "CHARAKTER", "PERSONNAGE", "PERSONAJE", "PERSONAGGIO"), bridge.get_selected_character_name()]
		1:
			return "%s\n%s: %s\n%s: %s" % [bridge.language_text("BOSS TIME ATTACK", "BOSS-ZEITANGRIFF", "CONTRE-LA-MONTRE BOSS", "CONTRARRELOJ DE JEFE", "ATTACCO A TEMPO BOSS"), bridge.language_text("STATUS", "STATUS", "STATUT", "ESTADO", "STATO"), bridge.language_text("UNLOCKED", "FREIGESCHALTET", "DEBLOQUE", "DESBLOQUEADO", "SBLOCCATO") if bridge.is_boss_time_attack_unlocked() else bridge.language_text("LOCKED", "GESPERRT", "VERROUILLE", "BLOQUEADO", "BLOCCATO"), bridge.language_text("CHARACTER", "CHARAKTER", "PERSONNAGE", "PERSONAJE", "PERSONAGGIO"), bridge.get_selected_character_name()]
	return ""

static func info_text(bridge: Object) -> String:
	if bridge.get_title_navigation_state().menu_index == 1:
		if bridge.is_boss_time_attack_unlocked():
			return bridge.language_text("DEFEAT THE BOSS AS FAST AS POSSIBLE", "BOSS SO SCHNELL WIE MOEGLICH BESIEGEN", "VAINCRE LE BOSS LE PLUS VITE POSSIBLE", "DERROTA AL JEFE LO MAS RAPIDO POSIBLE", "SCONFIGGI IL BOSS IL PIU VELOCE POSSIBILE")
		return bridge.language_text("CAN'T PLAY THIS YET", "NOCH NICHT SPIELBAR", "PAS ENCORE DISPONIBLE", "AUN NO DISPONIBLE", "NON ANCORA DISPONIBILE")
	return bridge.language_text("CLEAR THE ZONE AS FAST AS POSSIBLE", "DIE ZONE SO SCHNELL WIE MOEGLICH ABSCHLIESSEN", "TERMINER LA ZONE LE PLUS VITE POSSIBLE", "SUPERA LA ZONA LO MAS RAPIDO POSIBLE", "COMPLETA LA ZONA IL PIU VELOCE POSSIBILE")
