class_name PlayerHealthBar
extends TextureProgressBar

@export var player_config: PlayerConfig

func _ready() -> void:
	max_value = player_config.player_health
	value = max_value
	UISignalBus.player_health_changed.connect(_on_player_health_changed)

func _on_player_health_changed(amount: int) -> void:
	value = amount
