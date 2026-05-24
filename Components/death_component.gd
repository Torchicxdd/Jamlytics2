class_name DeathComponent
extends Node

@export var health_component: HealthComponent

func _ready() -> void:
	health_component.died.connect(_on_death)

func _on_death() -> void:
	get_parent().queue_free()