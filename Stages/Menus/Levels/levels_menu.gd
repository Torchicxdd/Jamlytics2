extends Control

@onready var back_button = $BackButton

func _ready() -> void:
	back_button.on_back_button_pressed_callable = _on_back_pressed

func _on_back_pressed() -> void:
	MenuManager.open_main_menu.emit()
	queue_free()
