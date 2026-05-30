extends Node

signal brand_changed()

const _BASE := "res://themes/InputPromptsAssets/kenney_input-prompts_1.5/"
const _DEFAULT_BRAND := "PlayStation Series"

const _BRAND_FOLDERS: Dictionary = {
	"Xbox Series": "Xbox Series",
	"PlayStation Series": "PlayStation Series",
	"Nintendo Switch": "Nintendo Switch",
	"Nintendo Switch 2": "Nintendo Switch 2",
	"Steam Deck": "Steam Deck",
	"Steam Controller": "Steam Controller",
	"Generic": "Generic",
}

# Most-specific entries first to avoid substring false-matches (e.g. "Steam Deck" before "Steam")
const _BRAND_DETECTION: Array = [
	["Steam Deck", ["steam deck"]],
	["Steam Controller", ["steam controller"]],
	["Nintendo Switch 2", ["switch 2"]],
	["Nintendo Switch", ["nintendo switch", "joy-con", "pro controller"]],
	["Xbox Series", ["xbox", "xinput", "x360", "x-box"]],
	["PlayStation Series", ["playstation", "sony", "dualshock", "dualsense", "ps4", "ps5"]],
]

var _active_brand: String = _DEFAULT_BRAND
var _cache: Dictionary = {}
var _keyboard_map: Dictionary = {}
var _mouse_map: Dictionary = {}
var _button_maps: Dictionary = {}
var _axis_maps: Dictionary = {}

func _ready() -> void:
	_build_maps()
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	_detect_brand()

func _build_maps() -> void:
	_keyboard_map = {
		KEY_A: "keyboard_a", KEY_B: "keyboard_b", KEY_C: "keyboard_c", KEY_D: "keyboard_d",
		KEY_E: "keyboard_e", KEY_F: "keyboard_f", KEY_G: "keyboard_g", KEY_H: "keyboard_h",
		KEY_I: "keyboard_i", KEY_J: "keyboard_j", KEY_K: "keyboard_k", KEY_L: "keyboard_l",
		KEY_M: "keyboard_m", KEY_N: "keyboard_n", KEY_O: "keyboard_o", KEY_P: "keyboard_p",
		KEY_Q: "keyboard_q", KEY_R: "keyboard_r", KEY_S: "keyboard_s", KEY_T: "keyboard_t",
		KEY_U: "keyboard_u", KEY_V: "keyboard_v", KEY_W: "keyboard_w", KEY_X: "keyboard_x",
		KEY_Y: "keyboard_y", KEY_Z: "keyboard_z",
		KEY_0: "keyboard_0", KEY_1: "keyboard_1", KEY_2: "keyboard_2", KEY_3: "keyboard_3",
		KEY_4: "keyboard_4", KEY_5: "keyboard_5", KEY_6: "keyboard_6", KEY_7: "keyboard_7",
		KEY_8: "keyboard_8", KEY_9: "keyboard_9",
		KEY_F1: "keyboard_f1", KEY_F2: "keyboard_f2", KEY_F3: "keyboard_f3", KEY_F4: "keyboard_f4",
		KEY_F5: "keyboard_f5", KEY_F6: "keyboard_f6", KEY_F7: "keyboard_f7", KEY_F8: "keyboard_f8",
		KEY_F9: "keyboard_f9", KEY_F10: "keyboard_f10", KEY_F11: "keyboard_f11", KEY_F12: "keyboard_f12",
		KEY_ESCAPE: "keyboard_escape",
		KEY_TAB: "keyboard_tab",
		KEY_BACKSPACE: "keyboard_backspace",
		KEY_ENTER: "keyboard_enter",
		KEY_SPACE: "keyboard_space",
		KEY_SHIFT: "keyboard_shift",
		KEY_CTRL: "keyboard_ctrl",
		KEY_ALT: "keyboard_alt",
		KEY_META: "keyboard_win",
		KEY_DELETE: "keyboard_delete",
		KEY_INSERT: "keyboard_insert",
		KEY_HOME: "keyboard_home",
		KEY_END: "keyboard_end",
		KEY_PAGEUP: "keyboard_page_up",
		KEY_PAGEDOWN: "keyboard_page_down",
		KEY_UP: "keyboard_arrow_up",
		KEY_DOWN: "keyboard_arrow_down",
		KEY_LEFT: "keyboard_arrow_left",
		KEY_RIGHT: "keyboard_arrow_right",
		KEY_CAPSLOCK: "keyboard_capslock",
		KEY_NUMLOCK: "keyboard_numlock",
		KEY_SCROLLLOCK: "keyboard_scroll_lock",
		KEY_PAUSE: "keyboard_pause",
		KEY_MINUS: "keyboard_minus",
		KEY_EQUAL: "keyboard_equals",
		KEY_PLUS: "keyboard_plus",
		KEY_BRACKETLEFT: "keyboard_bracket_open",
		KEY_BRACKETRIGHT: "keyboard_bracket_close",
		KEY_BACKSLASH: "keyboard_slash_back",
		KEY_SEMICOLON: "keyboard_semicolon",
		KEY_APOSTROPHE: "keyboard_apostrophe",
		KEY_QUOTELEFT: "keyboard_tilde",
		KEY_COMMA: "keyboard_comma",
		KEY_PERIOD: "keyboard_period",
		KEY_SLASH: "keyboard_slash_forward",
		KEY_ASTERISK: "keyboard_asterisk",
		KEY_COLON: "keyboard_colon",
		KEY_EXCLAM: "keyboard_exclamation",
		KEY_QUESTION: "keyboard_question",
		KEY_QUOTEDBL: "keyboard_quote",
		KEY_UNDERSCORE: "keyboard_underscore",
		KEY_KP_ENTER: "keyboard_numpad_enter",
		KEY_KP_ADD: "keyboard_numpad_plus",
		KEY_KP_MULTIPLY: "keyboard_asterisk",
	}

	_mouse_map = {
		MOUSE_BUTTON_LEFT: "mouse_left",
		MOUSE_BUTTON_RIGHT: "mouse_right",
		MOUSE_BUTTON_MIDDLE: "mouse_scroll",
		MOUSE_BUTTON_WHEEL_UP: "mouse_scroll_up",
		MOUSE_BUTTON_WHEEL_DOWN: "mouse_scroll_down",
		MOUSE_BUTTON_XBUTTON1: "mouse_side_back",
		MOUSE_BUTTON_XBUTTON2: "mouse_side_forward",
	}

	_button_maps = {
		"Xbox Series": {
			JOY_BUTTON_A: "xbox_button_a",
			JOY_BUTTON_B: "xbox_button_b",
			JOY_BUTTON_X: "xbox_button_x",
			JOY_BUTTON_Y: "xbox_button_y",
			JOY_BUTTON_BACK: "xbox_button_back",
			JOY_BUTTON_GUIDE: "xbox_guide",
			JOY_BUTTON_START: "xbox_button_menu",
			JOY_BUTTON_LEFT_STICK: "xbox_ls",
			JOY_BUTTON_RIGHT_STICK: "xbox_rs",
			JOY_BUTTON_LEFT_SHOULDER: "xbox_lb",
			JOY_BUTTON_RIGHT_SHOULDER: "xbox_rb",
			JOY_BUTTON_DPAD_UP: "xbox_dpad_up",
			JOY_BUTTON_DPAD_DOWN: "xbox_dpad_down",
			JOY_BUTTON_DPAD_LEFT: "xbox_dpad_left",
			JOY_BUTTON_DPAD_RIGHT: "xbox_dpad_right",
		},
		"PlayStation Series": {
			JOY_BUTTON_A: "playstation_button_cross",
			JOY_BUTTON_B: "playstation_button_circle",
			JOY_BUTTON_X: "playstation_button_square",
			JOY_BUTTON_Y: "playstation_button_triangle",
			JOY_BUTTON_BACK: "playstation4_button_share",
			JOY_BUTTON_GUIDE: "playstation_button_analog",
			JOY_BUTTON_START: "playstation4_button_options",
			JOY_BUTTON_LEFT_STICK: "playstation_button_l3",
			JOY_BUTTON_RIGHT_STICK: "playstation_button_r3",
			JOY_BUTTON_LEFT_SHOULDER: "playstation_trigger_l1",
			JOY_BUTTON_RIGHT_SHOULDER: "playstation_trigger_r1",
			JOY_BUTTON_DPAD_UP: "playstation_dpad_up",
			JOY_BUTTON_DPAD_DOWN: "playstation_dpad_down",
			JOY_BUTTON_DPAD_LEFT: "playstation_dpad_left",
			JOY_BUTTON_DPAD_RIGHT: "playstation_dpad_right",
		},
		"Nintendo Switch": {
			JOY_BUTTON_A: "switch_button_b",
			JOY_BUTTON_B: "switch_button_a",
			JOY_BUTTON_X: "switch_button_y",
			JOY_BUTTON_Y: "switch_button_x",
			JOY_BUTTON_BACK: "switch_button_minus",
			JOY_BUTTON_GUIDE: "switch_button_home",
			JOY_BUTTON_START: "switch_button_plus",
			JOY_BUTTON_LEFT_STICK: "switch_stick_l_press",
			JOY_BUTTON_RIGHT_STICK: "switch_stick_r_press",
			JOY_BUTTON_LEFT_SHOULDER: "switch_button_l",
			JOY_BUTTON_RIGHT_SHOULDER: "switch_button_r",
			JOY_BUTTON_DPAD_UP: "switch_dpad_up",
			JOY_BUTTON_DPAD_DOWN: "switch_dpad_down",
			JOY_BUTTON_DPAD_LEFT: "switch_dpad_left",
			JOY_BUTTON_DPAD_RIGHT: "switch_dpad_right",
		},
		"Nintendo Switch 2": {
			JOY_BUTTON_A: "switch_button_b",
			JOY_BUTTON_B: "switch_button_a",
			JOY_BUTTON_X: "switch_button_y",
			JOY_BUTTON_Y: "switch_button_x",
			JOY_BUTTON_BACK: "switch_button_minus",
			JOY_BUTTON_GUIDE: "switch_button_home",
			JOY_BUTTON_START: "switch_button_plus",
			JOY_BUTTON_LEFT_STICK: "switch_stick_l_press",
			JOY_BUTTON_RIGHT_STICK: "switch_stick_r_press",
			JOY_BUTTON_LEFT_SHOULDER: "switch_button_l",
			JOY_BUTTON_RIGHT_SHOULDER: "switch_button_r",
			JOY_BUTTON_DPAD_UP: "switch_dpad_up",
			JOY_BUTTON_DPAD_DOWN: "switch_dpad_down",
			JOY_BUTTON_DPAD_LEFT: "switch_dpad_left",
			JOY_BUTTON_DPAD_RIGHT: "switch_dpad_right",
		},
		"Steam Deck": {
			JOY_BUTTON_A: "steamdeck_button_a",
			JOY_BUTTON_B: "steamdeck_button_b",
			JOY_BUTTON_X: "steamdeck_button_x",
			JOY_BUTTON_Y: "steamdeck_button_y",
			JOY_BUTTON_BACK: "steamdeck_button_view",
			JOY_BUTTON_GUIDE: "steamdeck_button_guide",
			JOY_BUTTON_START: "steamdeck_button_options",
			JOY_BUTTON_LEFT_STICK: "steamdeck_stick_l_press",
			JOY_BUTTON_RIGHT_STICK: "steamdeck_stick_r_press",
			JOY_BUTTON_LEFT_SHOULDER: "steamdeck_button_l1",
			JOY_BUTTON_RIGHT_SHOULDER: "steamdeck_button_r1",
			JOY_BUTTON_DPAD_UP: "steamdeck_dpad_up",
			JOY_BUTTON_DPAD_DOWN: "steamdeck_dpad_down",
			JOY_BUTTON_DPAD_LEFT: "steamdeck_dpad_left",
			JOY_BUTTON_DPAD_RIGHT: "steamdeck_dpad_right",
		},
		"Steam Controller": {
			JOY_BUTTON_A: "steam_button_a",
			JOY_BUTTON_B: "steam_button_b",
			JOY_BUTTON_X: "steam_button_x",
			JOY_BUTTON_Y: "steam_button_y",
			JOY_BUTTON_BACK: "steam_button_back_icon",
			JOY_BUTTON_GUIDE: "steam_button_start_icon",
			JOY_BUTTON_START: "steam_button_start_icon",
			JOY_BUTTON_LEFT_STICK: "steam_stick_l_press",
			JOY_BUTTON_LEFT_SHOULDER: "steam_lb",
			JOY_BUTTON_RIGHT_SHOULDER: "steam_rb",
			JOY_BUTTON_DPAD_UP: "steam_dpad_up",
			JOY_BUTTON_DPAD_DOWN: "steam_dpad_down",
			JOY_BUTTON_DPAD_LEFT: "steam_dpad_left",
			JOY_BUTTON_DPAD_RIGHT: "steam_dpad_right",
		},
		"Generic": {
			JOY_BUTTON_A: "generic_button_circle",
			JOY_BUTTON_B: "generic_button_circle",
			JOY_BUTTON_X: "generic_button_square",
			JOY_BUTTON_Y: "generic_button_square",
			JOY_BUTTON_LEFT_SHOULDER: "generic_button_trigger_a",
			JOY_BUTTON_RIGHT_SHOULDER: "generic_button_trigger_b",
			JOY_BUTTON_LEFT_STICK: "generic_stick_press",
			JOY_BUTTON_RIGHT_STICK: "generic_stick_press",
		},
	}

	_axis_maps = {
		"Xbox Series": {
			JOY_AXIS_LEFT_X: "xbox_stick_l", JOY_AXIS_LEFT_Y: "xbox_stick_l",
			JOY_AXIS_RIGHT_X: "xbox_stick_r", JOY_AXIS_RIGHT_Y: "xbox_stick_r",
			JOY_AXIS_TRIGGER_LEFT: "xbox_lt", JOY_AXIS_TRIGGER_RIGHT: "xbox_rt",
		},
		"PlayStation Series": {
			JOY_AXIS_LEFT_X: "playstation_stick_l", JOY_AXIS_LEFT_Y: "playstation_stick_l",
			JOY_AXIS_RIGHT_X: "playstation_stick_r", JOY_AXIS_RIGHT_Y: "playstation_stick_r",
			JOY_AXIS_TRIGGER_LEFT: "playstation_trigger_l2", JOY_AXIS_TRIGGER_RIGHT: "playstation_trigger_r2",
		},
		"Nintendo Switch": {
			JOY_AXIS_LEFT_X: "switch_stick_l", JOY_AXIS_LEFT_Y: "switch_stick_l",
			JOY_AXIS_RIGHT_X: "switch_stick_r", JOY_AXIS_RIGHT_Y: "switch_stick_r",
			JOY_AXIS_TRIGGER_LEFT: "switch_button_zl", JOY_AXIS_TRIGGER_RIGHT: "switch_button_zr",
		},
		"Nintendo Switch 2": {
			JOY_AXIS_LEFT_X: "switch_stick_l", JOY_AXIS_LEFT_Y: "switch_stick_l",
			JOY_AXIS_RIGHT_X: "switch_stick_r", JOY_AXIS_RIGHT_Y: "switch_stick_r",
			JOY_AXIS_TRIGGER_LEFT: "switch_button_zl", JOY_AXIS_TRIGGER_RIGHT: "switch_button_zr",
		},
		"Steam Deck": {
			JOY_AXIS_LEFT_X: "steamdeck_stick_l", JOY_AXIS_LEFT_Y: "steamdeck_stick_l",
			JOY_AXIS_RIGHT_X: "steamdeck_stick_r", JOY_AXIS_RIGHT_Y: "steamdeck_stick_r",
			JOY_AXIS_TRIGGER_LEFT: "steamdeck_button_l2", JOY_AXIS_TRIGGER_RIGHT: "steamdeck_button_r2",
		},
		"Steam Controller": {
			JOY_AXIS_LEFT_X: "steam_stick", JOY_AXIS_LEFT_Y: "steam_stick",
			JOY_AXIS_TRIGGER_LEFT: "steam_lt", JOY_AXIS_TRIGGER_RIGHT: "steam_rt",
		},
		"Generic": {
			JOY_AXIS_LEFT_X: "generic_stick", JOY_AXIS_LEFT_Y: "generic_stick",
			JOY_AXIS_RIGHT_X: "generic_stick", JOY_AXIS_RIGHT_Y: "generic_stick",
			JOY_AXIS_TRIGGER_LEFT: "generic_button_trigger_a", JOY_AXIS_TRIGGER_RIGHT: "generic_button_trigger_b",
		},
	}

func _on_joy_connection_changed(_device: int, _connected: bool) -> void:
	_detect_brand()

func _detect_brand() -> void:
	var joypads := Input.get_connected_joypads()
	var new_brand := _DEFAULT_BRAND
	if joypads.size() > 0:
		new_brand = _name_to_brand(Input.get_joy_name(joypads[0]))
	if new_brand != _active_brand:
		_active_brand = new_brand
		brand_changed.emit()

func _name_to_brand(joy_name: String) -> String:
	var lower := joy_name.to_lower()
	for entry in _BRAND_DETECTION:
		for match_str: String in entry[1]:
			if match_str in lower:
				return entry[0]
	return _DEFAULT_BRAND

func get_active_brand() -> String:
	return _active_brand

func get_keyboard_icon(event: InputEvent) -> Texture2D:
	var stem := ""
	if event is InputEventKey:
		stem = _keyboard_map.get(event.keycode, "")
		if stem.is_empty() and event.physical_keycode != KEY_NONE:
			stem = _keyboard_map.get(event.physical_keycode, "")
	elif event is InputEventMouseButton:
		stem = _mouse_map.get(event.button_index, "")
	if stem.is_empty():
		return null
	return _get_texture(stem, "Keyboard & Mouse")

func get_controller_icon(event: InputEvent) -> Texture2D:
	var stem := ""
	if event is InputEventJoypadButton:
		stem = _button_maps.get(_active_brand, {}).get(event.button_index, "")
		if stem.is_empty():
			stem = _button_maps.get(_DEFAULT_BRAND, {}).get(event.button_index, "")
	elif event is InputEventJoypadMotion:
		stem = _axis_maps.get(_active_brand, {}).get(event.axis, "")
		if stem.is_empty():
			stem = _axis_maps.get(_DEFAULT_BRAND, {}).get(event.axis, "")
	if stem.is_empty():
		return null
	var folder: String = _BRAND_FOLDERS.get(_active_brand, _DEFAULT_BRAND)
	return _get_texture(stem, folder)

func get_action_keyboard_icon(action: String) -> Texture2D:
	for event in InputMap.action_get_events(action):
		if event is InputEventKey or event is InputEventMouseButton:
			return get_keyboard_icon(event)
	return null

func get_action_controller_icon(action: String) -> Texture2D:
	for event in InputMap.action_get_events(action):
		if event is InputEventJoypadButton or event is InputEventJoypadMotion:
			return get_controller_icon(event)
	return null

func get_action_icon(action: String) -> Texture2D:
	if Input.get_connected_joypads().size() > 0:
		var tex = get_action_controller_icon(action)
		if tex != null:
			return tex
	return get_action_keyboard_icon(action)

func _get_texture(stem: String, folder: String) -> Texture2D:
	var path := _BASE + folder + "/Default/" + stem + ".png"
	if _cache.has(path):
		return _cache[path]
	if not ResourceLoader.exists(path):
		_cache[path] = null
		return null
	var tex := load(path) as Texture2D
	_cache[path] = tex
	return tex
