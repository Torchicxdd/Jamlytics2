extends Bullet

@onready var damage_component: DamageComponent = $DamageComponent

func _ready() -> void:
	damage_component.damaged.connect(_on_damaged)

func _on_damaged() -> void:
	queue_free()