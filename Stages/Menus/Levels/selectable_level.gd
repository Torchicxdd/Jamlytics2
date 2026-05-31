class_name SelectableLevel
extends TextureButton

const level_enter_sfx = preload(Constants.AUDIO_STREAM_PATHS.level_enter)
const SELECTABLE_LEVEL_SCENE: PackedScene = preload(Constants.MENU_PATHS.selectable_level)

@export var level_config: LevelConfig

static func new_selectable_level(level_config: LevelConfig) -> SelectableLevel:
	var new_instance: SelectableLevel = SELECTABLE_LEVEL_SCENE.instantiate()
	new_instance.level_config = level_config
	return new_instance

func _ready() -> void:
	focus_mode = Control.FOCUS_ALL

	if not level_config.level_path.is_empty():
		var on_level_click = func() -> void:
			AudioManager.play_sfx(level_enter_sfx)
			GameManager.current_level_config = level_config
			SceneLoader.load_scene(level_config.level_path)

		pressed.connect(on_level_click)

	texture_normal = level_config.level_normal_image
	texture_focused = level_config.level_focused_image
	texture_hover = level_config.level_focused_image

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not has_focus():
			grab_focus()
			get_viewport().set_input_as_handled()
