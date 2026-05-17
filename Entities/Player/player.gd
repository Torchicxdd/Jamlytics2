class_name Player
extends CharacterBody2D

@onready var health_component = $HealthComponent

func _ready() -> void:
	health_component.damaged.connect(_on_player_damaged)
	health_component.healed.connect(_on_player_healed)
	health_component.died.connect(_on_player_died)
	
func _on_player_damaged(amount: float) -> void:
	UISignalBus.player_health_changed.emit(health_component.health)

func _on_player_healed(amount: float) -> void:
	UISignalBus.player_health_changed.emit(health_component.health)
	
func _on_player_died(amount: float) -> void:
	UISignalBus.player_health_changed.emit(health_component.health)
	UISignalBus.player_died.emit()
