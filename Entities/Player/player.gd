class_name Player
extends CharacterBody2D

const damage_taken_sfx = preload(Constants.AUDIO_STREAM_PATHS.player_damage_taken)

const texture_neutral = preload(Constants.PLAYER_TEXTURE_PATHS.neutral)
const texture_fury = preload(Constants.PLAYER_TEXTURE_PATHS.fury)
const texture_poise = preload(Constants.PLAYER_TEXTURE_PATHS.poise)
const texture_flow = preload(Constants.PLAYER_TEXTURE_PATHS.flow)
const texture_fury_poise = preload(Constants.PLAYER_TEXTURE_PATHS.fury_poise)
const texture_fury_flow = preload(Constants.PLAYER_TEXTURE_PATHS.fury_flow)
const texture_poise_flow = preload(Constants.PLAYER_TEXTURE_PATHS.poise_flow)

@export var player_config: PlayerConfig

@onready var player_sprite = $Sprite2D
@onready var health_component = $HealthComponent
@onready var shooting_component = $ShootingComponent
@onready var stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	player_config.player_health = health_component.health

	health_component.damaged.connect(_on_player_damaged)
	health_component.healed.connect(_on_player_healed)
	health_component.died.connect(_on_player_died)
	GameManager.powerups_activated.connect(_on_powerups_activated)
	GameManager.powerups_deactivated.connect(_on_powerups_deactivated)

func _on_player_damaged(amount: int) -> void:
	stream_player.stream = damage_taken_sfx
	stream_player.play()
	GameManager.reset_no_damage_streak()
	UISignalBus.player_health_changed.emit(health_component.health)

func _on_player_healed(amount: int) -> void:
	UISignalBus.player_health_changed.emit(health_component.health)
	
func _on_player_died() -> void:
	UISignalBus.player_health_changed.emit(health_component.health)
	UISignalBus.player_died.emit()

func _on_powerups_activated(powerups: Array[GameManager.Powerup]) -> void:
	_update_player_texture()

func _on_powerups_deactivated(powerups: Array[GameManager.Powerup]) -> void:
	_update_player_texture()

func _update_player_texture() -> void:
	var fury: bool = GameManager.powerup_states[GameManager.Powerup.FURY]["is_activated"]
	var poise: bool = GameManager.powerup_states[GameManager.Powerup.POISE]["is_activated"]
	var flow: bool = GameManager.powerup_states[GameManager.Powerup.FLOW]["is_activated"]

	if fury and poise and flow:
		pass
	elif fury and poise:
		player_sprite.texture = texture_fury_poise
	elif fury and flow:
		player_sprite.texture = texture_fury_flow
	elif poise and flow:
		player_sprite.texture = texture_poise_flow
	elif fury:
		player_sprite.texture = texture_fury
	elif poise:
		player_sprite.texture = texture_poise
	elif flow:
		player_sprite.texture = texture_flow
	else:
		player_sprite.texture = texture_neutral
