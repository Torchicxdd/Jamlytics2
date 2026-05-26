extends HBoxContainer

@onready var audio_name := $Name
@onready var value := $Value
@onready var slider := $MarginContainer/HSlider

@export_enum("Master", "Music", "SFX") var bus_name: String

func _ready() -> void:
	audio_name.text = str(bus_name)
	slider.value = SettingsManager.get_bus_volume(bus_name)
	value.text = str(int(slider.value))
	slider.value_changed.connect(_on_volume_changed)

func _on_volume_changed(new_value: float) -> void:
	SettingsManager.set_bus_volume(bus_name, new_value)
	value.text = str(int(new_value))
