extends HBoxContainer

enum InputTypes {
	KEYANDM,
	CONTROLLER
}

@export var action: String = ""

@onready var action_name = $ActionName
@onready var keyboard_btn = $KeyboardInput
@onready var controller_btn = $ControllerInput

var listening = false
var listening_device = null
var ignore_next_click = false

func _ready() -> void:
	action_name.text = action.capitalize()
	_update_keyboard_display()
	_update_controller_display()

	keyboard_btn.focus_mode = Control.FOCUS_ALL
	controller_btn.focus_mode = Control.FOCUS_ALL
	keyboard_btn.add_to_group(MenuFocusComponent.JOYPAD_SKIP_GROUP)

	keyboard_btn.pressed.connect(_on_keyboard_btn_pressed)
	controller_btn.pressed.connect(_on_controller_btn_pressed)
	InputIconProvider.brand_changed.connect(_update_controller_display)
	
func get_keyboard_event_name() -> String:
	for event in InputMap.action_get_events(action):
		if event is InputEventKey:
			return event.as_text()
		elif event is InputEventMouseButton:
			return "Mouse %d" % event.button_index
	return "Not Set"

func get_controller_event_name() -> String:
	for event in InputMap.action_get_events(action):
		if event is InputEventJoypadButton:
			return "Button %d" % event.button_index
		elif event is InputEventJoypadMotion:
			return "Axis %d" % event.axis
	return "Not Set"

func _get_keyboard_event() -> InputEvent:
	for event in InputMap.action_get_events(action):
		if event is InputEventKey or event is InputEventMouseButton:
			return event
	return null

func _get_controller_event() -> InputEvent:
	for event in InputMap.action_get_events(action):
		if event is InputEventJoypadButton or event is InputEventJoypadMotion:
			return event
	return null

func _update_keyboard_display() -> void:
	if listening and listening_device == InputTypes.KEYANDM:
		keyboard_btn.icon = null
		keyboard_btn.expand_icon = false
		keyboard_btn.text = "Esc..."
		return
	var event = _get_keyboard_event()
	if event == null:
		keyboard_btn.icon = null
		keyboard_btn.expand_icon = false
		keyboard_btn.text = "Not Set"
		return
	var tex = InputIconProvider.get_keyboard_icon(event)
	if tex != null:
		keyboard_btn.icon = tex
		keyboard_btn.expand_icon = true
		keyboard_btn.text = ""
	else:
		keyboard_btn.icon = null
		keyboard_btn.expand_icon = false
		keyboard_btn.text = get_keyboard_event_name()

func _update_controller_display() -> void:
	if listening and listening_device == InputTypes.CONTROLLER:
		controller_btn.icon = null
		controller_btn.expand_icon = false
		controller_btn.text = "Press a button..."
		return
	var event = _get_controller_event()
	if event == null:
		controller_btn.icon = null
		controller_btn.expand_icon = false
		controller_btn.text = "Not Set"
		return
	var tex = InputIconProvider.get_controller_icon(event)
	if tex != null:
		controller_btn.icon = tex
		controller_btn.expand_icon = true
		controller_btn.text = ""
	else:
		controller_btn.icon = null
		controller_btn.expand_icon = false
		controller_btn.text = get_controller_event_name()

func _on_keyboard_btn_pressed() -> void:
	listening = true
	listening_device = InputTypes.KEYANDM
	_update_keyboard_display()
	ignore_next_click = true

func _on_controller_btn_pressed() -> void:
	listening = true
	listening_device = InputTypes.CONTROLLER
	_update_controller_display()
	ignore_next_click = true

func _input(event: InputEvent) -> void:
	if not listening:
		return
		
	get_viewport().set_input_as_handled()

	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		_cancel()
		return

	if ignore_next_click:
		ignore_next_click = false
		keyboard_btn.disabled = true
		controller_btn.disabled = true
		return

	if listening_device == InputTypes.KEYANDM and (event is InputEventKey or event is InputEventMouseButton):
		_remap(event)
	elif listening_device == InputTypes.CONTROLLER and (event is InputEventJoypadButton or event is InputEventJoypadMotion):
		_remap(event)

func _cancel() -> void:
	listening = false
	listening_device = null
	_update_keyboard_display()
	_update_controller_display()
	keyboard_btn.disabled = false
	controller_btn.disabled = false

func _remap(event: InputEvent) -> void:
	if listening_device == InputTypes.KEYANDM:
		for old_event in InputMap.action_get_events(action).duplicate():
			if old_event is InputEventKey or old_event is InputEventMouseButton:
				InputMap.action_erase_event(action, old_event)
	elif listening_device == InputTypes.CONTROLLER:
		for old_event in InputMap.action_get_events(action).duplicate():
			if old_event is InputEventJoypadButton or old_event is InputEventJoypadMotion:
				InputMap.action_erase_event(action, old_event)
	
	InputMap.action_add_event(action, event)

	SettingsManager.save_input(action)

	listening = false
	listening_device = null
	_update_keyboard_display()
	_update_controller_display()
	keyboard_btn.disabled = false
	controller_btn.disabled = false
	get_viewport().set_input_as_handled()
