extends Control

@onready var remap_vbox = $MarginContainer/ScrollContainer/VBoxContainer
@onready var back_button = $BackButton

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	back_button.on_back_button_pressed_callable = MenuManager.on_menu_back_pressed.emit
	
	for action in InputMap.get_actions().filter(func(a): return not a.begins_with("ui_")):
		var rebind = preload(Constants.MENU_PATHS.input_rebind).instantiate()
		rebind.action = action
		remap_vbox.add_child(rebind)
	
	remap_vbox.get_child(0).controller_btn.grab_focus()

func _on_visibility_changed():
	if visible:
		remap_vbox.get_child(0).controller_btn.grab_focus()
