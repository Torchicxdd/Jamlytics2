extends Control

@onready var levels = $VBoxContainer2/VBoxContainer/Levels
@onready var tutorial = $VBoxContainer2/VBoxContainer/Tutorial
@onready var audio = $VBoxContainer2/VBoxContainer/Audio
@onready var input_settings = $VBoxContainer2/VBoxContainer/InputSettings
@onready var exit = $VBoxContainer2/VBoxContainer/ExitGame

func _ready() -> void:
	levels.pressed.connect(_on_levels_pressed)
	tutorial.pressed.connect(_on_tutorial_pressed)
	audio.pressed.connect(_on_audio_pressed)
	input_settings.pressed.connect(_on_input_settings_pressed)
	exit.pressed.connect(_on_exit_pressed)

func _on_levels_pressed() -> void:
	MenuManager.open_levels_menu.emit(true)

func _on_tutorial_pressed() -> void:
	MenuManager.open_tutorial.emit()

func _on_audio_pressed() -> void:
	MenuManager.open_audio_settings.emit()

func _on_input_settings_pressed() -> void:
	MenuManager.open_input_settings.emit()

func _on_exit_pressed() -> void:
	get_tree().quit()
