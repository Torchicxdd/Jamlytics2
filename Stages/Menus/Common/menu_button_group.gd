extends VBoxContainer

@export var show_continue: bool = true
@export var show_restart: bool = true
@export var show_levels: bool = true
@export var show_audio: bool = true
@export var show_options: bool = true
@export var show_quit: bool = true

@onready var continue_button: Button = $Continue
@onready var restart_button: Button = $Restart
@onready var levels_button: Button = $Levels
@onready var audio_button: Button = $Audio
@onready var options_button: Button = $Options
@onready var quit_button: Button = $"Quit To Menu"

func _ready() -> void:
	_apply_toggle(continue_button, show_continue)
	_apply_toggle(restart_button, show_restart)
	_apply_toggle(levels_button, show_levels)
	_apply_toggle(audio_button, show_audio)
	_apply_toggle(options_button, show_options)
	_apply_toggle(quit_button, show_quit)

	continue_button.pressed.connect(_on_continue_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	levels_button.pressed.connect(_on_levels_pressed)
	audio_button.pressed.connect(_on_audio_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _apply_toggle(button: Button, shown: bool) -> void:
	button.visible = shown
	if not shown:
		button.focus_mode = Control.FOCUS_NONE

func _on_continue_pressed() -> void:
	MenuManager.resume_game.emit()

func _on_restart_pressed() -> void:
	GameManager.restart_level()

func _on_levels_pressed() -> void:
	await SceneLoader.unload_scene()
	MenuManager.open_levels_menu.emit(false)

func _on_audio_pressed() -> void:
	MenuManager.open_audio_settings.emit()

func _on_options_pressed() -> void:
	MenuManager.open_input_settings.emit()

func _on_quit_pressed() -> void:
	await SceneLoader.unload_scene()
	MenuManager.open_main_menu.emit()
