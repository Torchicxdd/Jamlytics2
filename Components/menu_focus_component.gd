class_name MenuFocusComponent
extends Node

const menu_navigation_sfx = preload(Constants.AUDIO_STREAM_PATHS.menu_navigation)

const JOYPAD_SKIP_GROUP := "menu_joypad_skip"
const _JOY_AXIS_DEADZONE := 0.5

@export var focusables: Array[Control] = []
@export var default_focusable: Control

var _menu: Control
var _using_mouse: bool = false
var _using_joypad: bool = false
var _last_focused: Control
var _suppress_focus_sound: bool = false

func _ready() -> void:
	_menu = get_parent() as Control
	if _menu == null:
		push_warning("MenuFocusComponent: parent must be a Control.")
		return

	_menu.visibility_changed.connect(_on_visibility_changed)
	_setup.call_deferred()

func _setup() -> void:
	if focusables.is_empty():
		_collect_focusables(_menu)

	if default_focusable == null and not focusables.is_empty():
		default_focusable = focusables[0]

	_last_focused = default_focusable

	for control in focusables:
		control.mouse_entered.connect(_on_focusable_hovered.bind(control))
		control.mouse_exited.connect(control.release_focus)
		control.focus_entered.connect(_on_focusable_focused.bind(control))

	if _menu.is_visible_in_tree():
		var target := _pick_focus_target()
		if target:
			_suppress_focus_sound = true
			target.grab_focus.call_deferred()

func _collect_focusables(node: Node) -> void:
	for child in node.get_children():
		if child is Control and (child as Control).focus_mode != Control.FOCUS_NONE:
			focusables.append(child as Control)
		_collect_focusables(child)

func _on_focusable_hovered(control: Control) -> void:
	control.grab_focus()

func _on_focusable_focused(control: Control) -> void:
	_last_focused = control
	if _suppress_focus_sound:
		_suppress_focus_sound = false
		return
	AudioManager.play_sfx(menu_navigation_sfx, false)

func _input(event: InputEvent) -> void:
	if _menu == null or not _menu.is_visible_in_tree():
		return

	if _is_mouse_input(event):
		if not _using_mouse:
			_using_mouse = true
			var focused := get_viewport().gui_get_focus_owner()
			if focused and focused in focusables:
				if not focused.get_global_rect().has_point(_menu.get_global_mouse_position()):
					focused.release_focus()
	elif _is_keyboard_input(event):
		_using_mouse = false
		_set_joypad_mode(false)
		_restore_focus_if_needed(event)
	elif _is_joypad_input(event):
		_using_mouse = false
		_set_joypad_mode(true)
		_restore_focus_if_needed(event)

func _restore_focus_if_needed(event: InputEvent = null) -> void:
	if get_viewport().gui_get_focus_owner() == null:
		var target := _pick_focus_target()
		if target:
			_suppress_focus_sound = true
			target.grab_focus()
			if event == null or not event.is_action("ui_cancel"):
				get_viewport().set_input_as_handled()

func _pick_focus_target() -> Control:
	var candidate := _last_focused if _last_focused else default_focusable
	if candidate and _using_joypad and candidate.is_in_group(JOYPAD_SKIP_GROUP):
		for c in focusables:
			if not c.is_in_group(JOYPAD_SKIP_GROUP):
				return c
	return candidate

func _set_joypad_mode(value: bool) -> void:
	if _using_joypad == value:
		return
	_using_joypad = value
	for control in focusables:
		if control.is_in_group(JOYPAD_SKIP_GROUP):
			control.focus_mode = Control.FOCUS_CLICK if _using_joypad else Control.FOCUS_ALL

func _is_mouse_input(event: InputEvent) -> bool:
	return event is InputEventMouseMotion or event is InputEventMouseButton

func _is_keyboard_input(event: InputEvent) -> bool:
	return event is InputEventKey and event.pressed

func _is_joypad_input(event: InputEvent) -> bool:
	if event is InputEventJoypadButton and event.pressed:
		return true
	if event is InputEventJoypadMotion and absf(event.axis_value) > _JOY_AXIS_DEADZONE:
		return true
	return false

func _on_visibility_changed() -> void:
	if _menu.visible and not _using_mouse:
		var target := _pick_focus_target()
		if target:
			_suppress_focus_sound = true
			target.grab_focus()
