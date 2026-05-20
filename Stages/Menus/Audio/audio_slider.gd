extends HBoxContainer

@onready var audio_name := $Name
@onready var value := $Value
@onready var slider := $MarginContainer/HSlider

@export_enum("Master", "Music", "SFX") var bus_name: String
var bus_index: int = -1

func _ready() -> void:
	slider.value_changed.connect(_on_volume_changed)
	bus_index = AudioServer.get_bus_index(bus_name)
	audio_name.text = str(bus_name)
	slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index)) * 100.0

func _on_volume_changed(value: float) -> void:
	if value == 0:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		var db = linear_to_db(value / 100.0)
		AudioServer.set_bus_volume_db(bus_index, db)
		
	self.value.text = str(int(value))
