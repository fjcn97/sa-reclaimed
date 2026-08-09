class_name SimpleListMenuScreen
extends ScreenBase

## Shared geometry and visibility primitives for the streamlined list menus.
## Individual screens provide their colors and presentation data while using a
## common layout contract.

const LIST_STAGE_RECT := Rect2(260.0, 212.0, 760.0, 330.0)
const LIST_ROW_X := 280.0
const LIST_ROW_WIDTH := 720.0
const LIST_LABEL_X := 306.0
const LIST_VALUE_X := 608.0
const LIST_VALUE_WIDTH := 366.0
const FOOTER_RECT := Rect2(118.0, 580.0, 1044.0, 102.0)

## Creates the invariant backdrop/header/panel layer used by streamlined
## menus. Screens retain ownership of their specific stages and cards.
func ensure_simple_list_chrome(colors: Dictionary, panel_rect: Rect2 = Rect2(118.0, 170.0, 1044.0, 400.0)) -> Dictionary:
	var backdrop := ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(colors.get("backdrop", Color(0.98, 0.99, 1.0, 1.0))))
	var hero_glow := ensure_rect("HeroGlow", Rect2(104.0, 96.0, 1072.0, 504.0), Color(colors.get("glow", Color(0.24, 0.78, 0.96, 0.10))))
	var header_plate := ensure_rect("HeaderPlate", Rect2(150.0, 68.0, 980.0, 82.0), Color(1.0, 1.0, 1.0, 0.98))
	var panel := ensure_rect("Panel", panel_rect, Color(colors.get("panel", Color(0.98, 1.0, 1.0, 0.99))))
	var accent := ensure_rect("AccentBar", Rect2(118.0, 150.0, 1044.0, 10.0), Color(colors.get("accent", Color(0.24, 0.78, 0.96, 0.96))))
	var prompt_band := ensure_rect("PromptBand", FOOTER_RECT, Color(colors.get("footer", Color(0.96, 0.99, 1.0, 0.99))))
	backdrop.z_index = -9
	hero_glow.z_index = -8
	header_plate.z_index = -7
	panel.z_index = -6
	accent.z_index = -5
	prompt_band.z_index = -1
	return {"backdrop": backdrop, "hero_glow": hero_glow, "header_plate": header_plate, "panel": panel, "accent": accent, "prompt_band": prompt_band}

func set_nodes_visible(nodes: Array, visible: bool) -> void:
	for node in nodes:
		if node:
			node.visible = visible

func hide_nodes(nodes: Array) -> void:
	set_nodes_visible(nodes, false)
