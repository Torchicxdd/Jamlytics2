extends Node

signal add_level_ui(control_node: Control)
signal player_health_changed(new_health: int)
signal player_changed_mode()
signal increase_player_points(amount: int)
signal player_died()
signal powerup_change_value(powerup: GameManager.Powerup, change: float)
signal powerup_ready(powerup: GameManager.Powerup)
signal powerups_activated(powerups: Array[GameManager.Powerup])
signal powerups_deactivated(powerups: Array[GameManager.Powerup])
signal unable_to_activate_powerups(powerups: Array[GameManager.Powerup])
