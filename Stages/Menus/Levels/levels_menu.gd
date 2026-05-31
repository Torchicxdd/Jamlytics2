extends Control

const SCORE_ENTRY_SCENE: PackedScene = preload("res://Stages/Menus/Levels/ScoreEntry.tscn")

@onready var back_button = $MarginContainer/HBoxContainer/Control/BackButton
@onready var grid = $MarginContainer/HBoxContainer/VBoxContainer/GridContainer
@onready var scores_container: VBoxContainer = $MarginContainer/HBoxContainer/VBoxContainer/ScrollContainer/ScoresContainer
@onready var highscore_points: Label = $MarginContainer/HBoxContainer/VBoxContainer/Highscore/HighscorePoints
@onready var highscore_date: Label = $MarginContainer/HBoxContainer/VBoxContainer/Highscore/HighscoreDate
@onready var highscore_hbox: HBoxContainer = $MarginContainer/HBoxContainer/VBoxContainer/Highscore
@onready var screenshot: TextureRect = $MarginContainer/HBoxContainer/Control/MarginContainer/LevelScreenshot
#@onready var stats_panel: VBoxContainer = $MarginContainer/HBoxContainer/Control/MarginContainer/StatsPanel
#@onready var fury_label: Label = $MarginContainer/HBoxContainer/Control/MarginContainer/StatsPanel/FuryLabel
#@onready var poise_label: Label = $MarginContainer/HBoxContainer/Control/MarginContainer/StatsPanel/PoiseLabel
#@onready var flow_label: Label = $MarginContainer/HBoxContainer/Control/MarginContainer/StatsPanel/FlowLabel

var _highscore_entry: Dictionary = {}

func _ready() -> void:
	back_button.on_back_button_pressed_callable = _on_back_pressed
	highscore_hbox.focus_mode = Control.FOCUS_ALL
	highscore_hbox.focus_entered.connect(func(): _show_stats(_highscore_entry))

	for value in Constants.LEVEL_RESOURCE_PATHS.values():
		var instance: SelectableLevel = SelectableLevel.new_selectable_level(load(value))
		instance.focus_entered.connect(_on_level_focused.bind(instance.level_config))
		grid.add_child(instance)

func _on_level_focused(level_config: LevelConfig) -> void:
	#stats_panel.visible = false
	screenshot.texture = level_config.level_screenshot
	for child in scores_container.get_children():
		child.queue_free()

	var scores: Array = LevelManager.get_level_score(level_config.level_name)

	if scores.is_empty():
		highscore_points.text = "—"
		highscore_date.text = "—"
		var label := Label.new()
		label.text = "No score yet"
		scores_container.add_child(label)
		return

	scores.sort_custom(func(a, b): return a.get("score", 0) > b.get("score", 0))

	_highscore_entry = scores[0]
	highscore_points.text = "%d PTS" % _highscore_entry["score"]
	var dt: Dictionary = Time.get_datetime_dict_from_unix_time(_highscore_entry["date_acquired"])
	highscore_date.text = "%02d/%02d/%04d" % [dt["day"], dt["month"], dt["year"]]

	for i in range(1, scores.size()):
		var entry: ScoreEntry = SCORE_ENTRY_SCENE.instantiate()
		scores_container.add_child(entry)
		entry.selected.connect(_show_stats)
		entry.setup(scores[i])

func _show_stats(data: Dictionary) -> void:
	pass
	#stats_panel.visible = true
	#fury_label.text = "Fury: %d PTS" % data.get("fury", 0)
	#poise_label.text = "Poise: %d PTS" % data.get("poise", 0)
	#flow_label.text = "Flow: %d PTS" % data.get("flow", 0)

func _on_back_pressed() -> void:
	MenuManager.screen_fade_transition(func():
		MenuManager.open_main_menu.emit()
		MenuManager.menu_stack_remove_node(self)
		queue_free()
	)
