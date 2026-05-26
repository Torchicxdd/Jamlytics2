extends Control

@onready var levels = $VBoxContainer2/VBoxContainer/Levels
@onready var settings = $VBoxContainer2/VBoxContainer/Settings
@onready var exit = $VBoxContainer2/VBoxContainer/ExitGame

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	levels.pressed.connect(_on_levels_pressed)
	settings.pressed.connect(_on_settings_pressed)
	exit.pressed.connect(_on_exit_pressed)
	
	levels.focus_mode = Control.FOCUS_ALL
	settings.focus_mode = Control.FOCUS_ALL
	exit.focus_mode = Control.FOCUS_ALL
	levels.grab_focus()

func _on_visibility_changed():
	if visible:
		levels.grab_focus()

func _on_levels_pressed() -> void:
	MenuManager.open_levels_menu.emit()
	
func _on_settings_pressed() -> void:
	MenuManager.open_settings.emit()
	
func _on_exit_pressed() -> void:
	get_tree().quit()
