extends Node2D

func _ready() -> void:
	SceneLoader.load_finished.connect(_on_scene_loaded)

func _on_scene_loaded() -> void:
	var ui = load(Constants.SCENE_PATHS.game_hud) as PackedScene
	var ui_instance = ui.instantiate()
	UISignalBus.add_level_ui.emit(ui_instance)
