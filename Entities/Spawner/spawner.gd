class_name Spawner
extends Node2D

const SPAWNER_SCENE: PackedScene = preload(Constants.SCENE_PATHS.spawner)

@export var pattern: Patterns
@export var bullet_scene: PackedScene
@export var bullet_scale: Vector2 = Vector2(1.0, 1.0)
@export var bullet_speed: float = 200.0
@export var shooting_start_delay: float = 0.0
@export var rotation_speed: float = 2.0
@export var spawn_interval: float = 0.5

static func new_spawner(
	pattern: Patterns,
	bullet_scene: PackedScene,
	bullet_scale: Vector2,
	bullet_speed: float,
	shooting_start_delay: float,
	rotation_speed: float,
	spawn_interval: float
) -> Spawner:
	var spawner = SPAWNER_SCENE.instantiate() as Spawner
	spawner.pattern = pattern
	spawner.bullet_scene = bullet_scene
	spawner.bullet_scale = bullet_scale
	spawner.shooting_start_delay = shooting_start_delay
	spawner.rotation_speed = rotation_speed
	spawner.spawn_interval = spawn_interval
	return spawner


var is_enabled = false
var start_delay_finished = false
var start_delay_timer: float = 0.0
var _time: float = 0.0

enum Patterns {
	SPIRAL
}

func _physics_process(delta: float) -> void:
	if not start_delay_finished:
		start_delay_timer += delta
		if start_delay_timer < shooting_start_delay:
			return
		start_delay_finished = true

	_time += delta

	if _time >= spawn_interval:
		_time = 0
		spawn_bullet()
	
	match pattern:
		Patterns.SPIRAL:
			spiral(delta)

func spawn_bullet() -> void:
	var bullet: Bullet = bullet_scene.instantiate()
	
	get_tree().current_scene.get_node(Constants.MAIN_SCENE_NAMES.world).add_child(bullet)
	bullet.velocity_component.speed = bullet_speed

	bullet.scale = bullet_scale
	bullet.global_rotation = global_rotation
	bullet.global_position = global_position
	

func spiral(delta: float) -> void:
	rotation += 1.0 * rotation_speed * delta
