class_name HealthComponent
extends Node

signal damaged(amount: float)
signal healed(amount: float)
signal died()

@export var max_health = 10
var health: float

func _ready() -> void:
	health = max_health
	UISignalBus.player_max_health.emit(health)
	UISignalBus.player_health_changed.emit(health)
	
func take_damage(amount: float) -> void:
	health -= amount
	damaged.emit(amount)
	UISignalBus.player_health_changed.emit()
	if health <= 0:
		died.emit()
		
func heal(amount: float) -> void:
	var pre_heal_health = health
	health = minf(health + amount, max_health)
	healed.emit(health - pre_heal_health)
	UISignalBus.player_health_changed.emit()
