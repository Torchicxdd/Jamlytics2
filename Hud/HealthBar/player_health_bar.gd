class_name PlayerHealthBar
extends MarginContainer

@onready var health_bar = $TextureProgressBar

func _ready() -> void:
	UISignalBus.player_health_changed.connect(_on_player_health_changed)
	UISignalBus.player_max_health.connect(_on_player_max_health)

func _on_player_max_health(amount: float) -> void:
	health_bar.max_value = amount

func _on_player_health_changed(amount: float) -> void:
	health_bar.value = amount
