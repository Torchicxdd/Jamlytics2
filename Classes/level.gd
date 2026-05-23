class_name Level
extends Resource

var ui_path: String
var level_path: String
var level_name: String
var level_image_path: String

func load_level() -> void:
	SceneLoader.load_scene(level_path)
