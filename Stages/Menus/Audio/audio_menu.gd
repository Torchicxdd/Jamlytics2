extends Control

@onready var back_button = $BackButton
@onready var master = $MarginContainer/VBoxContainer/Master
@onready var music = $MarginContainer/VBoxContainer/Music
@onready var sfx = $MarginContainer/VBoxContainer/SFX

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	back_button.on_back_button_pressed_callable = MenuManager.on_menu_back_pressed.emit
	
	master.slider.focus_mode = Control.FOCUS_ALL
	music.slider.focus_mode = Control.FOCUS_ALL
	sfx.slider.focus_mode = Control.FOCUS_ALL
	
func _on_visibility_changed():
	if visible:
		master.slider.grab_focus()
