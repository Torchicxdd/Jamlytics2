extends Node

func _ready() -> void:
	MenuManager.open_main_menu.emit()
