extends Button

var on_level_pressed: Callable
@export var level_name: String
@export var level_image: CompressedTexture2D

@onready var name_label = $HBoxContainer/Label
@onready var image = $HBoxContainer/TextureRect

func _ready() -> void:
	focus_mode = Control.FOCUS_ALL
	pressed.connect(on_level_pressed)
	
	name_label.text = level_name
	image.texture = level_image
