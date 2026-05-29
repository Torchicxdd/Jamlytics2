extends Control

@onready var back_button = $MarginContainer/HBoxContainer/Control/BackButton
@onready var grid = $MarginContainer/HBoxContainer/VBoxContainer/GridContainer

func _ready() -> void:
	back_button.on_back_button_pressed_callable = _on_back_pressed

	for value in Constants.LEVEL_RESOURCE_PATHS.values():
		var instance = SelectableLevel.new_selectable_level(load(value))
		grid.add_child(instance)

func _on_back_pressed() -> void:
	MenuManager.screen_fade_transition(func():
		MenuManager.open_main_menu.emit()
		MenuManager.menu_stack_remove_node(self)
		queue_free()
	)
