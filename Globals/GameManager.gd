extends Node

signal powerups_activated(powerups: Array[Powerup])
signal powerups_deactivated(powerups: Array[Powerup])

enum Powerup {
	FURY,
	POISE,
	FLOW
}

const POWERUP_MAX_VALUE = 10
var powerup_states: Dictionary[Powerup, Dictionary] = {
	Powerup.FURY: {"current_points": 0, "powerup_value": 0, "is_activated": false, "points_per_tick": 500, "timer": 0.0},
	Powerup.POISE: {"current_points": 0, "powerup_value": 0, "is_activated": false, "points_per_tick": 200, "timer": 0.0},
	Powerup.FLOW: {"current_points": 0, "powerup_value": 0, "is_activated": false, "points_per_tick": 100, "timer": 0.0},
}

const NO_DAMAGE_TICK_INTERVAL: float = 2
const NO_DAMAGE_BASE_POINTS: int = 75
var no_damage_timer: float = 0.0
var no_damage_multiplier: int = 1

const ABILITY_DRAIN_DURATION: float = 5.0

var current_level_config: LevelConfig
var is_game_started: bool = false
var is_world_paused: bool = false
var level_points: int = 0


func _process(delta: float) -> void:
	if not is_game_started or is_world_paused:
		return
	no_damage_timer += delta
	if no_damage_timer >= NO_DAMAGE_TICK_INTERVAL:
		no_damage_timer -= NO_DAMAGE_TICK_INTERVAL
		add_points(Powerup.FLOW, NO_DAMAGE_BASE_POINTS * no_damage_multiplier)
		no_damage_multiplier += 1
		UISignalBus.no_damage_multiplier_changed.emit(no_damage_multiplier)
	
	var deactivated: Array[Powerup] = []
	for powerup in powerup_states.keys():
		if not powerup_states[powerup]["is_activated"]:
			continue
		
		powerup_states[powerup]["timer"] -= delta
		var t = clampf(powerup_states[powerup]["timer"] / ABILITY_DRAIN_DURATION, 0.0, 1.0)
		var prev_value: float = powerup_states[powerup]["powerup_value"]
		var new_value = POWERUP_MAX_VALUE * t
		powerup_states[powerup]["powerup_value"] = new_value
		UISignalBus.powerup_change_value.emit(powerup, new_value - prev_value)
		if powerup_states[powerup]["timer"] <= 0.0:
			powerup_states[powerup]["is_activated"] = false
			powerup_states[powerup]["current_points"] = 0
			deactivated.append(powerup)
	if not deactivated.is_empty():
		powerups_deactivated.emit(deactivated)
		UISignalBus.powerups_deactivated.emit(deactivated)


func reset_no_damage_streak() -> void:
	no_damage_timer = 0.0
	no_damage_multiplier = 1
	UISignalBus.no_damage_multiplier_changed.emit(no_damage_multiplier)

func _input(event: InputEvent) -> void:
	if not is_game_started or is_world_paused:
		return
	
	var powerups: Array[Powerup] = []
	if event.is_action_pressed("fury_ability"):
		powerups.append(Powerup.FURY)
	elif event.is_action_pressed("poise_ability"):
		powerups.append(Powerup.POISE)
	elif event.is_action_pressed("flow_ability"):
		powerups.append(Powerup.FLOW)
	elif event.is_action_pressed("all_forms_ability"):
		powerups.append(Powerup.FURY)
		powerups.append(Powerup.POISE)
		powerups.append(Powerup.FLOW)
	
	if not powerups.is_empty():
		activate_abilities(powerups)

func reset_level_states() -> void:
	level_points = 0
	reset_no_damage_streak()
	for powerup in powerup_states.keys():
		reset_powerup_state(powerup)

func reset_powerup_state(powerup: Powerup) -> void:
	powerup_states[powerup]["current_points"] = 0
	powerup_states[powerup]["powerup_value"] = 0
	powerup_states[powerup]["is_activated"] = false

func add_points(powerup: Powerup, amount: int) -> void:
	if powerup_states[powerup]["is_activated"]:
		return
	
	level_points += amount
	powerup_states[powerup]["current_points"] += amount
	if powerup_states[powerup]["current_points"] / powerup_states[powerup]["points_per_tick"] > powerup_states[powerup]["powerup_value"]:
		add_tick_to_powerup(powerup, powerup_states[powerup]["current_points"] / powerup_states[powerup]["points_per_tick"] - powerup_states[powerup]["powerup_value"])
	UISignalBus.increase_player_points.emit(amount)

func add_tick_to_powerup(powerup: Powerup, ticks_amount: int) -> void:
	var previous_value = powerup_states[powerup]["powerup_value"]
	var value = powerup_states[powerup]["powerup_value"] + ticks_amount
	if value <= POWERUP_MAX_VALUE:
		powerup_states[powerup]["powerup_value"] = value
		UISignalBus.powerup_change_value.emit(powerup, value - previous_value)
	else:
		powerup_states[powerup]["powerup_value"] = POWERUP_MAX_VALUE
		UISignalBus.powerup_change_value.emit(powerup, POWERUP_MAX_VALUE - previous_value)
	
	if value == POWERUP_MAX_VALUE:
		UISignalBus.powerup_ready.emit(powerup)

func activate_abilities(powerups: Array[Powerup]) -> void:
	var activated_powerups: Array[Powerup] = []
	for powerup in powerups:
		if powerup_states[powerup]["powerup_value"] == POWERUP_MAX_VALUE:
			activated_powerups.append(powerup)
	if activated_powerups.is_empty():
		UISignalBus.unable_to_activate_powerups.emit(powerups)
		return
	start_ability_drain_timer(activated_powerups)
	powerups_activated.emit(activated_powerups)
	UISignalBus.powerups_activated.emit(activated_powerups)

func start_ability_drain_timer(powerups: Array[Powerup]) -> void:
	for powerup in powerups:
		powerup_states[powerup]["timer"] = ABILITY_DRAIN_DURATION
		powerup_states[powerup]["is_activated"] = true

func restart_level() -> void:
	reset_level_states()
	SceneLoader.load_scene(current_level_config.level_path)
	await SceneLoader.unload_scene()
	MenuManager.resume_game.emit()
