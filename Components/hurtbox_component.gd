class_name HurtboxComponent
extends Area2D

@export var health_component: HealthComponent

func _ready() -> void:
	assert(health_component != null, "HurtboxComponent must have a HealthComponent provided.")
	
func receive_damage(damage: int) -> void:
	health_component.take_damage(damage)
