extends Control

@onready var back_button = $BackButton
@onready var level_wrapper = $MarginContainer/ScrollContainer/VBoxContainer

func _ready() -> void:
	back_button.on_back_button_pressed_callable = _on_back_pressed

	var levels = Global.LEVELS_RESOURCE
	for i in range(levels.size()):
		var instance = SelectableLevel.new_selectable_level(levels[i].new())
		level_wrapper.add_child(instance)
		if i == 0:
			instance.grab_focus()

func _on_back_pressed() -> void:
	MenuManager.open_main_menu.emit()
	queue_free()
