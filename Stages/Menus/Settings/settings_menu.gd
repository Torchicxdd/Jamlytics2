extends Control

@onready var audio = $VBoxContainer/Audio
@onready var controller = $VBoxContainer/Controller
@onready var keyboard = $VBoxContainer/Keyboard
@onready var back = $BackButton

func _ready() -> void:
	audio.pressed.connect(_on_audio_pressed)
	controller.pressed.connect(_on_controller_pressed)
	keyboard.pressed.connect(_on_keyboard_pressed)
	back.on_back_button_pressed_callable = MenuManager.on_menu_back_pressed.emit

func _on_audio_pressed() -> void:
	MenuManager.open_audio_settings.emit()

func _on_controller_pressed() -> void:
	MenuManager.open_controller_settings.emit()

func _on_keyboard_pressed() -> void:
	MenuManager.open_keyboard_settings.emit()
