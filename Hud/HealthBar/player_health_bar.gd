class_name PlayerHealthBar
extends MarginContainer

@export var player_config: PlayerConfig

@onready var health_bar = $TextureProgressBar

func _ready() -> void:
	health_bar.max_value = player_config.player_health
	health_bar.value = health_bar.max_value
	UISignalBus.player_health_changed.connect(_on_player_health_changed)

func _on_player_health_changed(amount: int) -> void:
	health_bar.value = amount
