extends Bullet

@onready var damage_component: DamageComponent = $DamageComponent
@export var base_point_increase: int = 100

func _ready() -> void:
	damage_component.damaged.connect(_on_damaged)

func _on_damaged() -> void:
	GameManager.add_points(base_point_increase)
	queue_free()
