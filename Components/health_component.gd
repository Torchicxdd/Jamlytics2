class_name HealthComponent
extends Node

signal damaged(amount: int)
signal healed(amount: int)
signal died()

@export var is_damageable: bool = true
@export var max_health: int = 10
var _health: int
var health: int:
	set(value):
		var old = _health
		_health = clamp(value, 0, max_health)
		var diff = _health - old
		if diff < 0:
			damaged.emit(-diff)
			if _health <= 0:
				died.emit()
		elif diff > 0:
			healed.emit(diff)
	get:
		return _health

func _ready() -> void:
	_health = max_health

func take_damage(amount: int) -> void:
	if is_damageable:
		health -= amount
	else:
		damaged.emit(0)

func heal(amount: int) -> void:
	health += amount
