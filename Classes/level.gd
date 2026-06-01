class_name Level
extends Node2D

const DEATH_DURATION_MS := 2500.0
const DEATH_MENU_THRESHOLD := 0.90

@export var music_player: AudioStreamPlayer

var _death_active := false
var _death_start_ms := 0

func _ready() -> void:
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	SceneLoader.load_finished.connect(_on_scene_loaded)
	UISignalBus.player_died.connect(_on_player_died)
	music_player.finished.connect(_on_music_player_finished)
	MenuManager.game_paused.connect(_on_game_paused)
	MenuManager.game_resumed.connect(_on_game_resumed)

func _on_scene_loaded() -> void:
	GameManager.is_game_started = true
	var ui = load(Constants.SCENE_PATHS.game_hud) as PackedScene
	var ui_instance = ui.instantiate()
	UISignalBus.add_level_ui.emit(ui_instance)

func _on_player_died() -> void:
	_death_active = true
	_death_start_ms = Time.get_ticks_msec()

func _process(_delta: float) -> void:
	if not _death_active:
		return

	var elapsed := (Time.get_ticks_msec() - _death_start_ms) as float
	var t := minf(elapsed / DEATH_DURATION_MS, 1.0)

	Engine.time_scale = 1.0 - t

	if music_player:
		music_player.pitch_scale = 1.0 - t

	if t >= DEATH_MENU_THRESHOLD:
		_death_active = false
		if music_player:
			music_player.stop()
		Engine.time_scale = 1.0
		MenuManager.open_death_menu.emit()

func _on_game_paused() -> void:
	music_player.stream_paused = true

func _on_game_resumed() -> void:
	music_player.stream_paused = false

func _on_music_player_finished() -> void:
	var score_data: Dictionary = {
		"score": GameManager.level_points,
		"fury": GameManager.powerup_states[GameManager.Powerup.FURY]["current_points"],
		"poise": GameManager.powerup_states[GameManager.Powerup.POISE]["current_points"],
		"flow": GameManager.powerup_states[GameManager.Powerup.FLOW]["current_points"],
		"date_acquired": int(Time.get_unix_time_from_system())
	}
	LevelManager.save_level_score(GameManager.current_level_config.level_name, score_data)
	MenuManager.open_end_game_menu.emit()
