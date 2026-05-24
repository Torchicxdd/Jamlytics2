class_name ShootingComponent
extends Node2D

enum SHOOTING_TYPE {
	STRAIGHT,
	SPREAD
}

@export var bullet: PackedScene
@export var bullet_scale: Vector2 = Vector2(1.0, 1.0)
@export var bullet_speed: float = 1000.0
@export var bullet_count: int = 2
@export var bullet_starting_positions: Array[Marker2D]
@export var shooting_delay: float = 0.1
@export var shooting_type: SHOOTING_TYPE = SHOOTING_TYPE.STRAIGHT
@export var spread_angle: float = 45.0

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
	for i in bullet_count:
		var instance: Bullet = bullet.instantiate()
		get_tree().current_scene.get_node(Constants.MAIN_SCENE_NAMES.world).add_child(instance)
		instance.velocity_component.speed = bullet_speed

		instance.scale = bullet_scale

		match shooting_type:
			SHOOTING_TYPE.STRAIGHT:
				instance.global_rotation = global_rotation
				instance.global_position = bullet_starting_positions[i].global_position
			SHOOTING_TYPE.SPREAD:
				var angle_step = deg_to_rad(spread_angle) / (bullet_count - 1)
				var start_angle = global_rotation - deg_to_rad(spread_angle) / 2
				instance.global_rotation = start_angle + i * angle_step
				instance.global_position = global_position
