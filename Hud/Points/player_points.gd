class_name PlayerPoints
extends RichTextLabel

var points = 0

func _ready() -> void:
	points = GameManager.level_points
	UISignalBus.increase_player_points.connect(_on_increase_player_points)
	
func _on_increase_player_points(amount: int) -> void:
	points += amount
	text = str(points) + " PTS"
