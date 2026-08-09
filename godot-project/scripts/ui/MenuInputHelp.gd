class_name MenuInputHelp
extends RefCounted

## Shared desktop/touch menu guidance. Keeping this wording in one place
## prevents a screen from advertising a different key than its input route.

static func select_confirm(bridge: Object) -> String:
	return "%s %s   %s %s   ESC %s" % [bridge.get_navigation_label(), bridge._language_text("TO SELECT", "ZUM AUSWAEHLEN", "POUR SELECTIONNER", "PARA SELECCIONAR", "PER SELEZIONARE"), bridge.get_confirm_label(), bridge._language_text("TO CONFIRM", "ZUM BESTAETIGEN", "POUR CONFIRMER", "PARA CONFIRMAR", "PER CONFERMARE"), bridge._language_text("TO GO BACK", "ZURUECK", "POUR RETOURNER", "PARA VOLVER", "PER TORNARE")]

static func language_preview(bridge: Object) -> String:
	return "%s %s   %s %s   ESC %s" % [bridge._language_text("UP/DOWN", "HOCH/RUNTER", "HAUT/BAS", "ARRIBA/ABAJO", "SU/GIU"), bridge._language_text("TO CHANGE", "ZUM AENDERN", "POUR CHANGER", "PARA CAMBIAR", "PER CAMBIARE"), bridge.get_confirm_label(), bridge._language_text("TO CONFIRM", "ZUM BESTAETIGEN", "POUR CONFIRMER", "PARA CONFIRMAR", "PER CONFERMARE"), bridge._language_text("TO GO BACK", "ZURUECK", "POUR RETOURNER", "PARA VOLVER", "PER TORNARE")]

static func choose_confirm(bridge: Object) -> String:
	return "%s %s   %s %s   ESC %s" % [bridge._language_text("UP/DOWN", "HOCH/RUNTER", "HAUT/BAS", "ARRIBA/ABAJO", "SU/GIU"), bridge._language_text("TO CHOOSE", "ZUM WAEHLEN", "POUR CHOISIR", "PARA ELEGIR", "PER SCEGLIERE"), bridge.get_confirm_label(), bridge._language_text("TO CONFIRM", "ZUM BESTAETIGEN", "POUR CONFIRMER", "PARA CONFIRMAR", "PER CONFERMARE"), bridge._language_text("TO GO BACK", "ZURUECK", "POUR RETOURNER", "PARA VOLVER", "PER TORNARE")]

static func horizontal_select(bridge: Object, action: String) -> String:
	return "%s %s   %s %s   ESC %s" % [bridge._language_text("LEFT/RIGHT", "LINKS/RECHTS", "GAUCHE/DROITE", "IZQ/DER", "SINISTRA/DESTRA"), bridge._language_text("TO SELECT", "ZUM AUSWAEHLEN", "POUR SELECTIONNER", "PARA SELECCIONAR", "PER SELEZIONARE"), bridge.get_confirm_label(), action, bridge._language_text("TO GO BACK", "ZURUECK", "POUR RETOURNER", "PARA VOLVER", "PER TORNARE")]

static func records_course_start(bridge: Object) -> String:
	return horizontal_select(bridge, bridge._language_text("TO START", "ZUM STARTEN", "POUR DEMARRER", "PARA INICIAR", "PER AVVIARE"))

static func records_mode_open(bridge: Object) -> String:
	return horizontal_select(bridge, bridge._language_text("TO OPEN", "ZUM OEFFNEN", "POUR OUVRIR", "PARA ABRIR", "PER APRIRE"))

static func records_character_course(bridge: Object) -> String:
	return "%s %s   %s %s   ESC %s" % [bridge._language_text("UP/DOWN", "HOCH/RUNTER", "HAUT/BAS", "ARRIBA/ABAJO", "SU/GIU"), bridge._language_text("TO SELECT CHARACTER", "CHARAKTER WAEHLEN", "CHOISIR PERSONNAGE", "ELEGIR PERSONAJE", "SCEGLI PERSONAGGIO"), bridge._language_text("LEFT/RIGHT", "LINKS/RECHTS", "GAUCHE/DROITE", "IZQ/DER", "SINISTRA/DESTRA"), bridge._language_text("TO SELECT COURSE", "KURS WAEHLEN", "POUR CHOISIR PARCOURS", "PARA ELEGIR FASE", "PER SCEGLIERE CORSO"), bridge._language_text("TO GO BACK", "ZURUECK", "POUR RETOURNER", "PARA VOLVER", "PER TORNARE")]

static func scroll_back(bridge: Object) -> String:
	return "%s %s   ESC %s" % [bridge._language_text("UP/DOWN", "HOCH/RUNTER", "HAUT/BAS", "ARRIBA/ABAJO", "SU/GIU"), bridge._language_text("TO SCROLL", "ZUM BLATTERN", "POUR DEFILER", "PARA DESPLAZAR", "PER SCORRERE"), bridge._language_text("TO GO BACK", "ZURUECK", "POUR RETOURNER", "PARA VOLVER", "PER TORNARE")]

static func horizontal_switch(bridge: Object) -> String:
	return "%s %s   %s %s   ESC %s" % [bridge._language_text("LEFT/RIGHT", "LINKS/RECHTS", "GAUCHE/DROITE", "IZQ/DER", "SINISTRA/DESTRA"), bridge._language_text("TO SWITCH", "ZUM WECHSELN", "POUR CHANGER", "PARA CAMBIAR", "PER CAMBIARE"), bridge.get_confirm_label(), bridge._language_text("TO CONFIRM", "ZUM BESTAETIGEN", "POUR CONFIRMER", "PARA CONFIRMAR", "PER CONFERMARE"), bridge._language_text("TO GO BACK", "ZURUECK", "POUR RETOURNER", "PARA VOLVER", "PER TORNARE")]

static func confirm_back(bridge: Object) -> String:
	return "%s %s   ESC %s" % [bridge.get_confirm_label(), bridge._language_text("TO CONFIRM", "ZUM BESTAETIGEN", "POUR CONFIRMER", "PARA CONFIRMAR", "PER CONFERMARE"), bridge._language_text("TO GO BACK", "ZURUECK", "POUR RETOURNER", "PARA VOLVER", "PER TORNARE")]
