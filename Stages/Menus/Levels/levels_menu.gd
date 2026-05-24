extends Control

@onready var back_button = $BackButton
@onready var level_wrapper = $MarginContainer/ScrollContainer/VBoxContainer

func _ready() -> void:
	back_button.on_back_button_pressed_callable = _on_back_pressed

	var levels_configs: Dictionary = Constants.LEVEL_RESOURCE_PATHS
	var index = 0
	for value in levels_configs.values():
		var instance = SelectableLevel.new_selectable_level(load(value))
		level_wrapper.add_child(instance)
		if index == 0:
			instance.grab_focus()
		index += 1

func _on_back_pressed() -> void:
	MenuManager.open_main_menu.emit()
	queue_free()
