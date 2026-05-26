class_name Spawner
extends Node2D

const SPAWNER_SCENE: PackedScene = preload(Constants.SCENE_PATHS.spawner)

@export var pattern: Patterns
@export var bullet_scene: PackedScene
@export var bullet_sprite_frames: SpriteFrames
@export var bullet_scale: Vector2 = Vector2(1.0, 1.0)
@export var bullet_speed: float = 200.0
@export var bullet_count: int = 0
@export var shooting_start_delay: float = 0.0
@export var is_rotating: bool = false
@export var is_oscillating: bool = false
@export var rotation_speed: float = 2.0
@export var spawn_interval: float = 0.5
@export var arc_angle: float = 30.0

static func new_spawner(
	pattern: Patterns,
	bullet_scene: PackedScene,
	bullet_sprite_frames: SpriteFrames,
	bullet_scale: Vector2,
	bullet_speed: float,
	bullet_count: int,
	shooting_start_delay: float,
	is_rotating: bool,
	is_oscillating: bool,
	rotation_speed: float,
	spawn_interval: float,
	arc_angle: float
) -> Spawner:
	var spawner = SPAWNER_SCENE.instantiate() as Spawner
	spawner.pattern = pattern
	spawner.bullet_scene = bullet_scene
	spawner.bullet_sprite_frames = bullet_sprite_frames
	spawner.bullet_scale = bullet_scale
	spawner.bullet_speed = bullet_speed
	spawner.bullet_count = bullet_count
	spawner.shooting_start_delay = shooting_start_delay
	spawner.is_rotating = is_rotating
	spawner.is_oscillating = is_oscillating
	spawner.rotation_speed = rotation_speed
	spawner.spawn_interval = spawn_interval
	spawner.arc_angle = arc_angle
	return spawner


var is_enabled = false
var start_delay_finished = false
var start_delay_timer: float = 0.0
var _time: float = 0.0
var _rotation_time: float = 0.0
var _spiral_offset: float = 5.0

enum Patterns {
	SPIRAL,
	CONE
}

func _physics_process(delta: float) -> void:
	if not start_delay_finished:
		start_delay_timer += delta
		if start_delay_timer < shooting_start_delay:
			return
		start_delay_finished = true

	_time += delta
	_rotation_time += delta
	
	if is_rotating:
		rotation += rotation_speed * delta
	elif is_oscillating:
		rotation = PI + sin(_rotation_time * rotation_speed) * deg_to_rad(arc_angle / 2.0)
	else:
		rotation = PI

	match pattern:
		Patterns.SPIRAL:
			spiral(delta)
		Patterns.CONE:
			cone(delta)

func spawn_bullet_at_angle(angle_radians: float) -> void:
	var bullet: EnemyBullet = bullet_scene.instantiate()
	bullet.bullet_sprite_frames = bullet_sprite_frames
	get_tree().current_scene.get_node(Constants.MAIN_SCENE_NAMES.world).add_child(bullet)
	bullet.velocity_component.speed = bullet_speed
	bullet.scale = bullet_scale
	bullet.global_rotation = angle_radians
	bullet.global_position = global_position

func try_spawn() -> bool:
	if _time >= spawn_interval:
		_time = 0
		return true
	return false

func spiral(delta: float) -> void:
	if not try_spawn():
		return
	
	var angle_step: float = TAU / bullet_count
	for i in bullet_count:
		spawn_bullet_at_angle(global_rotation + _spiral_offset + angle_step * i)
	_spiral_offset += deg_to_rad(rotation_speed)

func cone(delta: float) -> void:
	if not try_spawn():
		return
	
	var center: float = global_rotation
	var half_arc: float = deg_to_rad(arc_angle / 2.0)

	spawn_bullet_at_angle(center)
	spawn_bullet_at_angle(center - half_arc)
	spawn_bullet_at_angle(center + half_arc)
