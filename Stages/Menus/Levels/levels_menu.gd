extends Control

@onready var back_button = $BackButton
@onready var level_wrapper = $MarginContainer/ScrollContainer/VBoxContainer

func _ready() -> void:
	level_wrapper.get_child(0).grab_focus()
	back_button.on_back_button_pressed_callable = _on_back_pressed

func _on_back_pressed() -> void:
	MenuManager.open_main_menu.emit()
	queue_free()
