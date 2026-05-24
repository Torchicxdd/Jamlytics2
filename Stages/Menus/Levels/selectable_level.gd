class_name SelectableLevel
extends Button

const SELECTABLE_LEVEL_SCENE: PackedScene = preload(Constants.MENU_PATHS.selectable_level)

@export var level_config: LevelConfig

@onready var name_label = $HBoxContainer/Label
@onready var image = $HBoxContainer/TextureRect

static func new_selectable_level(level_config: LevelConfig) -> SelectableLevel:
	var new_instance: SelectableLevel = SELECTABLE_LEVEL_SCENE.instantiate()
	new_instance.level_config = level_config
	return new_instance

func _ready() -> void:
	focus_mode = Control.FOCUS_ALL
	pressed.connect(SceneLoader.load_scene.bind(level_config.level_path))
	
	name_label.text = level_config.level_name
	image.texture = level_config.level_image
