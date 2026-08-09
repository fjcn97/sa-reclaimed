extends CanvasLayer

@export var controller_path: NodePath = NodePath("../PlayerController")
@export var gameplay_layer_path: NodePath = NodePath("GameplayControls")
@export var menu_layer_path: NodePath = NodePath("MenuControls")

var _controller: Node = null
var _gameplay_layer: Control = null
var _menu_layer: Control = null
var _left_button: BaseButton = null
var _right_button: BaseButton = null
var _jump_button: BaseButton = null
var _action_button: BaseButton = null
var _pause_button: BaseButton = null
var _menu_left_button: BaseButton = null
var _menu_right_button: BaseButton = null
var _menu_up_button: BaseButton = null
var _menu_down_button: BaseButton = null
var _menu_confirm_button: BaseButton = null
var _menu_back_button: BaseButton = null
var _touch_controls_visible: bool = false

func _ready() -> void:
	set_process(true)
	visible = false
	_controller = get_node_or_null(controller_path)
	_gameplay_layer = get_node_or_null(gameplay_layer_path)
	_menu_layer = get_node_or_null(menu_layer_path)
	_left_button = get_node_or_null("GameplayControls/LeftButton")
	_right_button = get_node_or_null("GameplayControls/RightButton")
	_jump_button = get_node_or_null("GameplayControls/JumpButton")
	_action_button = get_node_or_null("GameplayControls/ActionButton")
	_pause_button = get_node_or_null("GameplayControls/PauseButton")
	_menu_left_button = get_node_or_null("MenuControls/MenuLeftButton")
	_menu_right_button = get_node_or_null("MenuControls/MenuRightButton")
	_menu_up_button = get_node_or_null("MenuControls/MenuUpButton")
	_menu_down_button = get_node_or_null("MenuControls/MenuDownButton")
	_menu_confirm_button = get_node_or_null("MenuControls/MenuConfirmButton")
	_menu_back_button = get_node_or_null("MenuControls/MenuBackButton")
	_connect_hold_button(_left_button, CoreBridge.DPAD_LEFT)
	_connect_hold_button(_right_button, CoreBridge.DPAD_RIGHT)
	_connect_hold_button(_jump_button, CoreBridge.A_BUTTON)
	_connect_hold_button(_action_button, CoreBridge.B_BUTTON)
	_connect_tap_button(_pause_button, CoreBridge.START_BUTTON)
	_connect_tap_button(_menu_left_button, CoreBridge.DPAD_LEFT)
	_connect_tap_button(_menu_right_button, CoreBridge.DPAD_RIGHT)
	_connect_tap_button(_menu_up_button, CoreBridge.DPAD_UP)
	_connect_tap_button(_menu_down_button, CoreBridge.DPAD_DOWN)
	_connect_tap_button(_menu_confirm_button, CoreBridge.A_BUTTON)
	_connect_tap_button(_menu_back_button, CoreBridge.B_BUTTON)
	_disable_keyboard_focus()
	_refresh_touch_ui_state()

func _disable_keyboard_focus() -> void:
	for button in [_left_button, _right_button, _jump_button, _action_button, _pause_button, _menu_left_button, _menu_right_button, _menu_up_button, _menu_down_button, _menu_confirm_button, _menu_back_button]:
		if button:
			button.focus_mode = Control.FOCUS_NONE

func _process(_delta: float) -> void:
	_refresh_touch_ui_state()

func _connect_hold_button(button: BaseButton, bit: int) -> void:
	if button == null:
		return
	button.button_down.connect(_on_hold_button_down.bind(bit))
	button.button_up.connect(_on_hold_button_up.bind(bit))

func _connect_tap_button(button: BaseButton, bit: int) -> void:
	if button == null:
		return
	button.pressed.connect(_on_tap_button.bind(bit))

func _on_hold_button_down(bit: int) -> void:
	if _controller and _controller.has_method("set_touch_button_pressed"):
		_controller.set_touch_button_pressed(bit, true)

func _on_hold_button_up(bit: int) -> void:
	if _controller and _controller.has_method("set_touch_button_pressed"):
		_controller.set_touch_button_pressed(bit, false)

func _on_tap_button(bit: int) -> void:
	if _controller and _controller.has_method("tap_touch_button"):
		_controller.tap_touch_button(bit)

func _update_visibility() -> void:
	if not _touch_controls_visible:
		if _gameplay_layer:
			_gameplay_layer.visible = false
			_gameplay_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
		if _menu_layer:
			_menu_layer.visible = false
			_menu_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_clear_touch_input()
		return
	var gameplay_visible: bool = CoreBridge.should_show_touch_gameplay_controls()
	if _gameplay_layer:
		_gameplay_layer.visible = gameplay_visible
		_gameplay_layer.mouse_filter = Control.MOUSE_FILTER_STOP if gameplay_visible else Control.MOUSE_FILTER_IGNORE
	if _menu_layer:
		var menu_visible := CoreBridge.should_show_touch_menu_controls()
		_menu_layer.visible = menu_visible
		_menu_layer.mouse_filter = Control.MOUSE_FILTER_STOP if menu_visible else Control.MOUSE_FILTER_IGNORE
	var horizontal_visible := CoreBridge.should_show_touch_menu_horizontal_controls()
	if _menu_left_button:
		_menu_left_button.visible = horizontal_visible
	if _menu_right_button:
		_menu_right_button.visible = horizontal_visible
	if not gameplay_visible:
		_clear_touch_input()

func _update_labels() -> void:
	var labels := CoreBridge.get_touch_menu_labels()
	if _menu_left_button:
		_menu_left_button.text = str(labels.get("left", "Left"))
	if _menu_right_button:
		_menu_right_button.text = str(labels.get("right", "Right"))
	if _menu_confirm_button:
		_menu_confirm_button.text = str(labels.get("confirm", "OK"))
	if _menu_back_button:
		_menu_back_button.text = str(labels.get("back", "Back"))
	if _menu_up_button:
		_menu_up_button.text = str(labels.get("up", "Up"))
	if _menu_down_button:
		_menu_down_button.text = str(labels.get("down", "Down"))

func _refresh_touch_ui_state() -> void:
	_touch_controls_visible = CoreBridge.should_show_touch_controls()
	visible = _touch_controls_visible
	_update_visibility()
	_update_labels()

func _clear_touch_input() -> void:
	if _controller and _controller.has_method("clear_touch_input"):
		_controller.clear_touch_input()
