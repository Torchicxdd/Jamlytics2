class_name SelectableLevel
extends TextureButton

const SELECTABLE_LEVEL_SCENE: PackedScene = preload(Constants.MENU_PATHS.selectable_level)

@export var level_config: LevelConfig

static func new_selectable_level(level_config: LevelConfig) -> SelectableLevel:
	var new_instance: SelectableLevel = SELECTABLE_LEVEL_SCENE.instantiate()
	new_instance.level_config = level_config
	return new_instance

func _ready() -> void:
	focus_mode = Control.FOCUS_ALL
	
	if not level_config.level_path.is_empty():
		pressed.connect(SceneLoader.load_scene.bind(level_config.level_path))
	
	texture_normal = level_config.level_normal_image
	texture_focused = level_config.level_focused_image
	texture_hover = level_config.level_focused_image
