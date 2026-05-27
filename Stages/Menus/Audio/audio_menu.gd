extends Control

@onready var back_button = $MarginContainer/HBoxContainer/Control/BackButton

func _ready() -> void:
	back_button.on_back_button_pressed_callable = MenuManager.on_menu_back_pressed.emit
