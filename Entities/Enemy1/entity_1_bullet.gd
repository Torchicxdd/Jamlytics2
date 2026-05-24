extends Bullet

@onready var coverage_hurtbox_component: CoverageHurtboxComponent = $CoverageHurtboxComponent

func _ready() -> void:
	coverage_hurtbox_component.covered.connect(_on_covered)

func _on_covered() -> void:
	queue_free()