extends Control

@onready var remap_vbox = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer2/InputVbox
@onready var back_button = $MarginContainer/HBoxContainer/Control/BackButton

func _ready() -> void:
	back_button.on_back_button_pressed_callable = MenuManager.on_menu_back_pressed.emit

	for action in InputMap.get_actions().filter(func(a): return not a.begins_with("ui_")):
		var rebind = preload(Constants.MENU_PATHS.input_rebind).instantiate()
		rebind.action = action
		remap_vbox.add_child(rebind)
