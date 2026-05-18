class_name PlayerCurrentMode
extends MarginContainer

func _ready() -> void:
	UISignalBus.player_changed_mode.connect(_on_player_changed_mode)
	
func _on_player_changed_mode() -> void:
	pass
