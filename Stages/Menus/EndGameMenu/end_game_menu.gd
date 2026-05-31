class_name EndGameMenu
extends Control

@onready var level_backgroud: TextureRect = $LevelBackground
@onready var top_score_label: Label = $VBoxContainer/TopScoreLabel
@onready var current_score_label: Label = $VBoxContainer/CurrentScoreLabel
@onready var fury: Label = $VBoxContainer/HBoxContainer/Fury
@onready var poise: Label = $VBoxContainer/HBoxContainer/Poise
@onready var flow: Label = $VBoxContainer/HBoxContainer/Flow

func _ready() -> void:
	var level_name: String = GameManager.current_level_config.level_name
	var scores: Array = LevelManager.get_level_score(level_name)

	var top_score: int = 0
	for entry in scores:
		if entry.get("score", 0) > top_score:
			top_score = entry.get("score", 0)

	if top_score >= GameManager.level_points:
		top_score_label.text = "Top Score: %d" % top_score
	else:
		top_score_label.text = "New High Score"
	
	level_backgroud.texture = GameManager.current_level_config.level_screenshot
	current_score_label.text = "%d PTS" % GameManager.level_points
	fury.text = "Fury: %d PTS" % GameManager.powerup_states[GameManager.Powerup.FURY]["current_points"]
	poise.text = "Poise: %d PTS" % GameManager.powerup_states[GameManager.Powerup.POISE]["current_points"]
	flow.text = "Flow: %d PTS" % GameManager.powerup_states[GameManager.Powerup.FLOW]["current_points"]
