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
