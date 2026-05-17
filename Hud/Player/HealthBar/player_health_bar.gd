class_name PlayerHealthBar
extends MarginContainer

@onready var health_bar = $TextureProgressBar

func _ready() -> void:
	UISignalBus.player_health_changed.connect(_on_player_health_changed)

func _on_player_health_changed(amount: float) -> void:
	health_bar.value = amount
