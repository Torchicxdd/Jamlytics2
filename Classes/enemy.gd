class_name Enemy
extends RigidBody2D

const damage_flash_shader = preload("res://Classes/damage_flash.gdshader")

@onready var health_component: HealthComponent = $HealthComponent
@onready var despawn_over_time_component: DespawnOverTimeComponent = $DespawnOverTimeComponent
@onready var bullet_marker: Marker2D = $BulletMarker
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var shake_strength: float = 6.0
@export var shake_rotation: float = 8.0
@export var shake_duration: float = 0.03
@export var flash_duration: float = 0.2

var config: EnemyConfig
var _flash_material: ShaderMaterial
var _shake_tween: Tween
var _sprite_origin_pos: Vector2
var _sprite_origin_rot: float

func configure(cfg: EnemyConfig) -> void:
	config = cfg
	health_component.health = cfg.health
	health_component.is_damageable = cfg.is_killable
	despawn_over_time_component.despawn_timer = cfg.despawn_timer
	despawn_over_time_component.despawn_duration = cfg.despawn_duration
	despawn_over_time_component.despawn_style = cfg.despawn_style

func _ready() -> void:
	health_component.damaged.connect(_on_enemy_damaged)
	_flash_material = ShaderMaterial.new()
	_flash_material.shader = damage_flash_shader
	sprite.material = _flash_material
	_sprite_origin_pos = sprite.position
	_sprite_origin_rot = sprite.rotation_degrees

func _on_enemy_damaged(_amount: int) -> void:
	_shake_sprite()
	_flash_white()

func _flash_white() -> void:
	_flash_material.set_shader_parameter("flash_amount", 1.0)
	var tween := create_tween()
	tween.tween_method(
		func(v: float): _flash_material.set_shader_parameter("flash_amount", v),
		1.0, 0.0, flash_duration
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

func _shake_sprite() -> void:
	if _shake_tween:
		_shake_tween.kill()
	sprite.position = _sprite_origin_pos
	sprite.rotation_degrees = _sprite_origin_rot
	var s := shake_strength
	var r := shake_rotation
	var d := shake_duration
	_shake_tween = create_tween().set_parallel(false)
	_shake_tween.tween_property(sprite, "position", _sprite_origin_pos + Vector2(s, 0), d).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	_shake_tween.parallel().tween_property(sprite, "rotation_degrees", _sprite_origin_rot - r, d).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	_shake_tween.tween_property(sprite, "position", _sprite_origin_pos + Vector2(-s * 0.75, 0), d).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	_shake_tween.parallel().tween_property(sprite, "rotation_degrees", _sprite_origin_rot + r * 0.75, d).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	_shake_tween.tween_property(sprite, "position", _sprite_origin_pos, d * 0.8).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	_shake_tween.parallel().tween_property(sprite, "rotation_degrees", _sprite_origin_rot, d * 0.8).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
