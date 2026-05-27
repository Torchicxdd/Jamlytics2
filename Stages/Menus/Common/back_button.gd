extends MarginContainer

@onready var back = $Button
var on_back_button_pressed_callable: Callable

func _ready() -> void:
	back.pressed.connect(_on_back_button_pressed)
	back.focus_mode = Control.FOCUS_ALL
	_update_button_icon()
	
	InputIconProvider.brand_changed.connect(_update_button_icon)

func _unhandled_input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	if event.is_action_pressed("ui_cancel"):
		_on_back_button_pressed()
		get_viewport().set_input_as_handled()

func _on_back_button_pressed() -> void:
	if on_back_button_pressed_callable.is_valid():
		on_back_button_pressed_callable.call()

func _update_button_icon() -> void:
	var tex = InputIconProvider.get_action_icon("ui_cancel")
	if tex != null:
		back.icon = tex
		back.expand_icon = true
		
