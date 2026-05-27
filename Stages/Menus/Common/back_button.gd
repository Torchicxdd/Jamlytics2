extends MarginContainer

var on_back_button_pressed_callable: Callable

func _ready() -> void:
	$Button.pressed.connect(_on_back_button_pressed)
	$Button.focus_mode = Control.FOCUS_ALL

func _unhandled_input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	if event.is_action_pressed("ui_cancel"):
		_on_back_button_pressed()
		get_viewport().set_input_as_handled()

func _on_back_button_pressed() -> void:
	if on_back_button_pressed_callable.is_valid():
		on_back_button_pressed_callable.call()
