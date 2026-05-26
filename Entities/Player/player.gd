class_name Player
extends CharacterBody2D

@export var player_config: PlayerConfig

@onready var health_component = $HealthComponent
@onready var shooting_component = $ShootingComponent

func _ready() -> void:
	player_config.player_health = health_component.health
	
	health_component.damaged.connect(_on_player_damaged)
	health_component.healed.connect(_on_player_healed)
	health_component.died.connect(_on_player_died)

func _on_player_damaged(amount: int) -> void:
	UISignalBus.player_health_changed.emit(health_component.health)

func _on_player_healed(amount: int) -> void:
	UISignalBus.player_health_changed.emit(health_component.health)
	
func _on_player_died(amount: int) -> void:
	UISignalBus.player_health_changed.emit(health_component.health)
	UISignalBus.player_died.emit()
