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
	keyboard_btn.text = get_keyboard_event_name()
	controller_btn.text = get_controller_event_name()
	
	keyboard_btn.focus_mode = Control.FOCUS_CLICK
	controller_btn.focus_mode = Control.FOCUS_ALL
	
	keyboard_btn.pressed.connect(_on_keyboard_btn_pressed)
	controller_btn.pressed.connect(_on_controller_btn_pressed)
	
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

func _on_keyboard_btn_pressed() -> void:
	print("pressed")
	listening = true
	listening_device = InputTypes.KEYANDM
	keyboard_btn.text = "Press a key..."
	ignore_next_click = true

func _on_controller_btn_pressed() -> void:
	listening = true
	listening_device = InputTypes.CONTROLLER
	controller_btn.text = "Press a button..."
	ignore_next_click = true

func _input(event: InputEvent) -> void:
	if not listening:
		return
		
	get_viewport().set_input_as_handled()
		
	if ignore_next_click:
		ignore_next_click = false
		keyboard_btn.disabled = true
		controller_btn.disabled = true
		return
	
	if listening_device == InputTypes.KEYANDM and (event is InputEventKey or event is InputEventMouseButton):
		_remap(event)
	elif listening_device == InputTypes.CONTROLLER and (event is InputEventJoypadButton or event is InputEventJoypadMotion):
		_remap(event)

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
	
	keyboard_btn.text = get_keyboard_event_name()
	controller_btn.text = get_controller_event_name()

	listening = false
	listening_device = null
	keyboard_btn.disabled = false
	controller_btn.disabled = false
	get_viewport().set_input_as_handled()
