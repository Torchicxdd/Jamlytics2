extends MarginContainer

var on_back_button_pressed_callable: Callable

func _ready() -> void:
	$Button.pressed.connect(_on_back_button_pressed)

func _on_back_button_pressed() -> void:
	on_back_button_pressed_callable.call()
