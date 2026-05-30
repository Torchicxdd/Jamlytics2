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
	GameManager.powerups_activated.connect(_on_powerups_activated)
	GameManager.powerups_deactivated.connect(_on_powerups_deactivated)

func _on_player_damaged(amount: int) -> void:
	GameManager.reset_no_damage_streak()
	UISignalBus.player_health_changed.emit(health_component.health)

func _on_player_healed(amount: int) -> void:
	UISignalBus.player_health_changed.emit(health_component.health)
	
func _on_player_died() -> void:
	UISignalBus.player_health_changed.emit(health_component.health)
	UISignalBus.player_died.emit()

func _on_powerups_activated(powerups: Array[GameManager.Powerup]) -> void:
	pass

func _on_powerups_deactivated(powerups: Array[GameManager.Powerup]) -> void:
	pass
