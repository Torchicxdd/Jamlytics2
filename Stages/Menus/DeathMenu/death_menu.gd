extends Control

@onready var restart_button = $VBoxContainer/VBoxContainer/Restart
@onready var levels_button = $VBoxContainer/VBoxContainer/Levels
@onready var audio_button = $VBoxContainer/VBoxContainer/Audio
@onready var options_button = $VBoxContainer/VBoxContainer/Options
@onready var quit_button = $"VBoxContainer/VBoxContainer/Quit To Menu"

func _ready() -> void:
	restart_button.pressed.connect(_on_restart_pressed)
	levels_button.pressed.connect(_on_levels_pressed)
	audio_button.pressed.connect(_on_audio_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_restart_pressed() -> void:
	pass

func _on_levels_pressed() -> void:
	await SceneLoader.unload_scene()
	MenuManager.open_levels_menu.emit()

func _on_audio_pressed() -> void:
	MenuManager.open_audio_settings.emit()

func _on_options_pressed() -> void:
	MenuManager.open_input_settings.emit()

func _on_quit_pressed() -> void:
	await SceneLoader.unload_scene()
	MenuManager.open_main_menu.emit()
