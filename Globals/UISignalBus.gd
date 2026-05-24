extends Node

signal add_level_ui(control_node: Control)
signal player_health_changed(new_health: int)
signal player_died()
signal player_changed_mode()
signal increase_player_points(amount: int)
