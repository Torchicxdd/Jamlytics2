class_name ShootingComponent
extends Node2D

@export var bullet: PackedScene
@export var bullet_scale: Vector2 = Vector2(1.0, 1.0)
@export var bullet_speed: float = 1000.0

func _process(_delta: float) -> void:
	if Input.is_action_pressed("primary_fire"):
		shoot()

func shoot() -> void:
	var instance: Bullet = bullet.instantiate()
	get_tree().current_scene.get_node(Constants.MAIN_SCENE_NAMES.world).add_child(instance)
	instance.resize_component.scale = bullet_scale
	instance.velocity_component.speed = bullet_speed

	instance.scale = bullet_scale
	instance.global_rotation = global_rotation
	instance.global_position = global_position
