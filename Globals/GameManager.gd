extends Node

var is_game_started: bool = false

var level_points: int = 0

func reset_level_points() -> void:
	level_points = 0

func add_points(amount: int) -> void:
	level_points += amount
	UISignalBus.increase_player_points.emit(amount)
