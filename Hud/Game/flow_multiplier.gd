extends Label

func _ready() -> void:
	UISignalBus.no_damage_multiplier_changed.connect(_on_multiplier_changed)

func _on_multiplier_changed(value: int) -> void:
	text = "x" + str(value)
