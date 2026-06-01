class_name DamageFlashComponent
extends Node

const _shader = preload("res://Classes/damage_flash.gdshader")

@export var sprite: AnimatedSprite2D
@export var flash_duration: float = 0.2
@export var shake_strength: float = 6.0
@export var shake_rotation: float = 8.0
@export var shake_duration: float = 0.03

var _material: ShaderMaterial
var _shake_tween: Tween
var _origin_pos: Vector2
var _origin_rot: float

func _ready() -> void:
	_material = ShaderMaterial.new()
	_material.shader = _shader
	sprite.material = _material
	_origin_pos = sprite.position
	_origin_rot = sprite.rotation_degrees

func on_hit() -> void:
	_flash()
	_shake()

func _flash() -> void:
	_material.set_shader_parameter("flash_amount", 0.5)
	var tween := create_tween()
	tween.tween_method(
		func(v: float): _material.set_shader_parameter("flash_amount", v),
		0.5, 0.0, flash_duration
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

func _shake() -> void:
	if _shake_tween:
		_shake_tween.kill()
	sprite.position = _origin_pos
	sprite.rotation_degrees = _origin_rot
	var s := shake_strength
	var r := shake_rotation
	var d := shake_duration
	_shake_tween = create_tween().set_parallel(false)
	_shake_tween.tween_property(sprite, "position", _origin_pos + Vector2(s, 0), d).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	_shake_tween.parallel().tween_property(sprite, "rotation_degrees", _origin_rot - r, d).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	_shake_tween.tween_property(sprite, "position", _origin_pos + Vector2(-s * 0.75, 0), d).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	_shake_tween.parallel().tween_property(sprite, "rotation_degrees", _origin_rot + r * 0.75, d).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	_shake_tween.tween_property(sprite, "position", _origin_pos, d * 0.8).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	_shake_tween.parallel().tween_property(sprite, "rotation_degrees", _origin_rot, d * 0.8).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
