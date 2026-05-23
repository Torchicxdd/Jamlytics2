class_name SelectableLevel
extends Button

const SELECTABLE_LEVEL_SCENE: PackedScene = preload(Constants.MENU_PATHS.selectable_level)

@export var level_script: Level
@export var level_name: String
@export var level_image: String

@onready var name_label = $HBoxContainer/Label
@onready var image = $HBoxContainer/TextureRect

static func new_selectable_level(level: Level) -> SelectableLevel:
	var new_instance: SelectableLevel = SELECTABLE_LEVEL_SCENE.instantiate()
	new_instance.level_script = level
	new_instance.level_name = level.level_name
	new_instance.level_image = level.level_image_path
	return new_instance

func _ready() -> void:
	focus_mode = Control.FOCUS_ALL
	pressed.connect(level_script.load_level)
	
	name_label.text = level_name
	image.texture = load(level_image) as Texture2D
