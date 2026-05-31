extends Node

const SETTINGS_PATH: String = "user://settings.tres"

var settings: SettingsConfig

func _ready() -> void:
	_load_or_create()
	_apply_audio()
	_apply_inputs()

func _load_or_create() -> void:
	if ResourceLoader.exists(SETTINGS_PATH):
		settings = ResourceLoader.load(SETTINGS_PATH, "SettingsConfig", ResourceLoader.CACHE_MODE_IGNORE) as SettingsConfig

	if settings == null:
		settings = SettingsConfig.new()

func get_bus_volume(bus_name: String) -> float:
	match bus_name:
		"Master": return settings.master_volume
		"Music": return settings.music_volume
		"SFX": return settings.sfx_volume
	return 100.0

func set_bus_volume(bus_name: String, volume: float) -> void:
	match bus_name:
		"Master": settings.master_volume = volume
		"Music": settings.music_volume = volume
		"SFX": settings.sfx_volume = volume

	_apply_bus_volume(bus_name, volume)
	save()

func save_input(action: String) -> void:
	settings.input_overrides[action] = InputMap.action_get_events(action).duplicate()
	save()

func save() -> void:
	ResourceSaver.save(settings, SETTINGS_PATH)

func _apply_audio() -> void:
	_apply_bus_volume("Master", settings.master_volume)
	_apply_bus_volume("Music", settings.music_volume)
	_apply_bus_volume("SFX", settings.sfx_volume)

func _apply_bus_volume(bus_name: String, volume: float) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx < 0:
		return
	if volume <= 0:
		AudioServer.set_bus_mute(idx, true)
	else:
		AudioServer.set_bus_mute(idx, false)
		AudioServer.set_bus_volume_db(idx, linear_to_db(volume / 100.0))

func _apply_inputs() -> void:
	for action in settings.input_overrides.keys():
		if not InputMap.has_action(action):
			continue
		for event in InputMap.action_get_events(action).duplicate():
			InputMap.action_erase_event(action, event)
		for event in settings.input_overrides[action]:
			InputMap.action_add_event(action, event)
