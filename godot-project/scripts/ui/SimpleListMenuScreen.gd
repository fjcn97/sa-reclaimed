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

func set_nodes_visible(nodes: Array, visible: bool) -> void:
	for node in nodes:
		if node:
			node.visible = visible

func hide_nodes(nodes: Array) -> void:
	set_nodes_visible(nodes, false)
