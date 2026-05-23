class_name DamageComponent
extends Area2D

@export var damage: float = 0.0

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		area.receive_damage(damage)
