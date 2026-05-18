class_name PlayerPoints
extends RichTextLabel

func _ready() -> void:
	UISignalBus.increase_player_points.connect(_on_increase_player_points)
	
func _on_increase_player_points(amount: int) -> void:
	text = "{amount} + PTS"
