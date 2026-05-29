class_name Level
extends Node2D

const DEATH_DURATION_MS := 2500.0
const DEATH_MENU_THRESHOLD := 0.90

@export var music_player: AudioStreamPlayer

var _death_active := false
var _death_start_ms := 0

func _ready() -> void:
	SceneLoader.load_finished.connect(_on_scene_loaded)
	UISignalBus.player_died.connect(_on_player_died)

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
