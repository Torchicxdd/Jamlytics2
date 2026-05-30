extends TextureProgressBar

@export var powerup: GameManager.Powerup

var _tween: Tween

func _ready() -> void:
	max_value = GameManager.POWERUP_MAX_VALUE
	UISignalBus.powerups_activated.connect(_on_powerups_activated)
	UISignalBus.powerups_deactivated.connect(_on_powerups_deactivated)
	UISignalBus.powerup_change_value.connect(_on_powerup_value_changed)

func _on_powerups_activated(powerups: Array[GameManager.Powerup]) -> void:
	var index = powerups.find(powerup)
	if index == -1:
		return
	
	# Do something to show activated

func _on_powerups_deactivated(powerups: Array[GameManager.Powerup]) -> void:
	var index = powerups.find(powerup)
	if index == -1:
		return
	
	# Do something to show deactivated

func _on_powerup_value_changed(powerup: GameManager.Powerup, amount: float) -> void:
	if self.powerup != powerup:
		return

	if amount > 0:
		if _tween:
			_tween.kill()
		_tween = create_tween()
		_tween.tween_property(self, "value", value + amount, 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	else:
		value += amount
