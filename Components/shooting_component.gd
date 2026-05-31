class_name ShootingComponent
extends Node2D

enum SHOOTING_TYPE {
	STRAIGHT,
	SPREAD,
	RADIAL,
	BEAM
}

@onready var stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var bullet: PackedScene
@export var bullet_scale: Vector2 = Vector2(1.0, 1.0)
@export var bullet_speed: float = 1000.0
@export var bullet_count: int = 2
@export var bullet_starting_positions: Array[Marker2D]
@export var shooting_delay: float = 0.1
@export var spread_angle: float = 45.0

signal bullet_spawned(spawned_bullet: Bullet)

var active_types: Array[SHOOTING_TYPE] = [SHOOTING_TYPE.STRAIGHT]
var _timer: float = 0.0

func _process(_delta: float) -> void:
	if Input.is_action_pressed("primary_fire"):
		_timer -= _delta
		if _timer <= 0.0:
			shoot()
			_timer = shooting_delay
	if Input.is_action_just_released("primary_fire"):
		_timer = 0.0

func shoot() -> void:
	for type in active_types:
		_shoot_type(type)

func _shoot_type(type: SHOOTING_TYPE) -> void:
	stream_player.play()
	match type:
		SHOOTING_TYPE.STRAIGHT:
			for i in bullet_count:
				var instance: Bullet = bullet.instantiate()
				_add_bullet_to_scene(instance)
				instance.velocity_component.speed = bullet_speed
				instance.scale = bullet_scale
				instance.global_rotation = global_rotation
				instance.global_position = bullet_starting_positions[i].global_position
				bullet_spawned.emit(instance)
		SHOOTING_TYPE.SPREAD:
			for i in bullet_count:
				var instance: Bullet = bullet.instantiate()
				_add_bullet_to_scene(instance)
				instance.velocity_component.speed = bullet_speed
				instance.scale = bullet_scale
				var angle_step = deg_to_rad(spread_angle) / (bullet_count - 1)
				var start_angle = global_rotation - deg_to_rad(spread_angle) / 2
				instance.global_rotation = start_angle + i * angle_step
				instance.global_position = global_position
				bullet_spawned.emit(instance)
		SHOOTING_TYPE.RADIAL:
			for i in 16:
				var instance: Bullet = bullet.instantiate()
				_add_bullet_to_scene(instance)
				instance.velocity_component.speed = bullet_speed
				instance.scale = bullet_scale
				instance.global_rotation = (2.0 * PI / 16.0) * i
				instance.global_position = global_position
				bullet_spawned.emit(instance)
		SHOOTING_TYPE.BEAM:
			var instance: Bullet = bullet.instantiate()
			_add_bullet_to_scene(instance)
			instance.velocity_component.speed = bullet_speed * 2.0
			instance.scale = bullet_scale * 3.0
			instance.global_rotation = global_rotation
			instance.global_position = global_position
			bullet_spawned.emit(instance)

func _add_bullet_to_scene(instance: Bullet) -> void:
	get_tree().current_scene.get_node(Constants.MAIN_SCENE_NAMES.world).add_child(instance)

func add_shooting_type(type: SHOOTING_TYPE) -> void:
	if type not in active_types:
		active_types.append(type)

func remove_shooting_type(type: SHOOTING_TYPE) -> void:
	active_types.erase(type)
