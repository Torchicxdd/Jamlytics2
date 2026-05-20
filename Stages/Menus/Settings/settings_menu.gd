extends Control

@onready var audio = $VBoxContainer/Audio
@onready var input_settings = $VBoxContainer/InputSettings
@onready var back = $BackButton

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	audio.pressed.connect(_on_audio_pressed)
	input_settings.pressed.connect(_on_keyboard_pressed)
	back.on_back_button_pressed_callable = MenuManager.on_menu_back_pressed.emit

	audio.focus_mode = Control.FOCUS_ALL
	input_settings.focus_mode = Control.FOCUS_ALL
	audio.grab_focus()

func _on_visibility_changed():
	if visible:
		audio.grab_focus()

func _on_audio_pressed() -> void:
	MenuManager.open_audio_settings.emit()

func _on_keyboard_pressed() -> void:
	MenuManager.open_input_settings.emit()
