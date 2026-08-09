class_name EndingPresentationPresenter
extends RefCounted

## Presentation queries for story interstitials, logos, and credits pages.

static func to_be_continued_title(bridge: Object) -> String:
	return bridge._language_text("TO BE CONTINUED", "FORTSETZUNG FOLGT", "A SUIVRE", "CONTINUARA", "CONTINUA")

static func to_be_continued_prompt(bridge: Object) -> String:
	return bridge._language_text("NEXT STORY CHAPTER AHEAD", "NAECHSTES STORY-KAPITEL FOLGT", "PROCHAIN CHAPITRE A VENIR", "SIGUIENTE CAPITULO DE HISTORIA", "PROSSIMO CAPITOLO DELLA STORIA")

static func to_be_continued_detail(bridge: Object) -> String:
	return bridge._language_text("%s CONTINUE   %s SKIP", "%s WEITER   %s UEBERSPRINGEN", "%s CONTINUER   %s PASSER", "%s CONTINUAR   %s OMITIR", "%s CONTINUA   %s SALTA") % [bridge.get_confirm_label(), bridge.get_secondary_label()]

static func sega_prompt(bridge: Object) -> String:
	return bridge._language_text("PRESENTED BY SEGA", "PRAESENTIERT VON SEGA", "PRESENTE PAR SEGA", "PRESENTADO POR SEGA", "PRESENTATO DA SEGA")

static func sega_detail(bridge: Object) -> String:
	return bridge._language_text("%s SKIP", "%s UEBERSPRINGEN", "%s PASSER", "%s OMITIR", "%s SALTA") % bridge.get_confirm_label()

static func sonic_team_prompt(bridge: Object) -> String:
	return bridge._language_text("CREATED BY SONIC TEAM", "ERSTELLT VON SONIC TEAM", "CREE PAR SONIC TEAM", "CREADO POR SONIC TEAM", "CREATO DA SONIC TEAM")

static func sonic_team_detail(bridge: Object) -> String:
	return bridge._language_text("%s SKIP   AUTO TITLE", "%s UEBERSPRINGEN   AUTO-TITEL", "%s PASSER   TITRE AUTO", "%s OMITIR   TITULO AUTO", "%s SALTA   TITOLO AUTO") % bridge.get_confirm_label()

static func credits_title(bridge: Object) -> String:
	return "SONIC ADVANCE 2   %s" % bridge.get_ending_variant_label()

static func credits_page_text(bridge: Object) -> String:
	var page_text: String = bridge._language_text("SOURCE TILEMAP %s", "QUELL-TILEMAP %s", "TILEMAP SOURCE %s", "TILEMAP FUENTE %s", "TILEMAP SORGENTE %s") % bridge.get_credits_source_tilemap()
	if bridge._ending_variant == bridge.ENDING_VARIANT_EXTRA and bridge._credits_page == 0:
		return bridge._language_text("EXTRA ENDING", "EXTRA-ENDE", "FIN EXTRA", "FINAL EXTRA", "FINALE EXTRA") + "\n" + page_text
	if bridge._ending_variant == bridge.ENDING_VARIANT_FINAL and bridge._credits_page == 0:
		return bridge._language_text("FINAL ENDING", "FINALES ENDE", "FINALE", "FINAL", "FINALE") + "\n" + page_text
	return page_text

static func credits_source_tilemap(bridge: Object) -> String:
	var tiles: Array = bridge.CREDITS_CATALOG.source_tiles()
	return tiles[clampi(bridge._credits_page, 0, tiles.size() - 1)]

static func credits_source_group_text(bridge: Object) -> String:
	return bridge._language_text("SOURCE GROUP %d / %d", "QUELLGRUPPE %d / %d", "GROUPE SOURCE %d / %d", "GRUPO FUENTE %d / %d", "GRUPPO SORGENTE %d / %d") % [bridge.get_credits_slide_group() + 1, bridge.CREDITS_CATALOG.slide_groups().size()]

static func credits_detail(bridge: Object) -> String:
	return bridge._language_text("AUTO ADVANCE   START SKIP", "AUTO-WEITER   START UEBERSPRINGEN", "AVANCE AUTO   START PASSER", "AVANCE AUTO   START OMITIR", "AVANZAMENTO AUTO   START SALTA")

static func credits_page_index_text(bridge: Object) -> String:
	return bridge._language_text("PAGE %02d / %02d", "SEITE %02d / %02d", "PAGE %02d / %02d", "PAGINA %02d / %02d", "PAGINA %02d / %02d") % [bridge._credits_page + 1, bridge._credits_page_count]
