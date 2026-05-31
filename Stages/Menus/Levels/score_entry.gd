class_name ScoreEntry
extends HBoxContainer

signal selected(data: Dictionary)

@onready var score_label: Label = $ScoreLabel
@onready var date_label: Label = $DateLabel

var _data: Dictionary

func _ready() -> void:
	focus_mode = Control.FOCUS_ALL
	focus_entered.connect(func(): selected.emit(_data))

func setup(data: Dictionary) -> void:
	_data = data
	score_label.text = "%d PTS" % data.get("score", 0)
	var dt: Dictionary = Time.get_datetime_dict_from_unix_time(data.get("date_acquired", 0))
	date_label.text = "%02d/%02d/%04d" % [dt["day"], dt["month"], dt["year"]]
