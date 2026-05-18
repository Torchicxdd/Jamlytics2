extends Control

@onready var levels = $ButtonsWrapper/VBoxContainer/Levels
@onready var settings = $ButtonsWrapper/VBoxContainer/Settings
@onready var exit = $ButtonsWrapper/VBoxContainer/ExitGame

func _ready() -> void:
	levels.pressed.connect(_on_levels_pressed)
	settings.pressed.connect(_on_settings_pressed)
	exit.pressed.connect(_on_exit_pressed)

func _on_levels_pressed() -> void:
	pass
	
func _on_settings_pressed() -> void:
	MenuManager.open_settings.emit()
	
func _on_exit_pressed() -> void:
	get_tree().quit()
