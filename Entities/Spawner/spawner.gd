class_name Spawner
extends Node2D

@export var pattern: Patterns
@export var bullet_scene: PackedScene
@export var rotation_speed = 2
@export var spawn_interval := 0.5

var is_enabled = false
var _time := 0.0

enum Patterns {
	SPIRAL
}

func _physics_process(delta: float) -> void:
	_time += delta
	
	if _time >= spawn_interval:
		_time = 0
		spawn_bullet()
	
	match pattern:
		Patterns.SPIRAL:
			spiral(delta)

func spawn_bullet() -> void:
	var bullet := bullet_scene.instantiate()
	if bullet is not Node2D:
		return
	
	bullet.global_rotation = global_rotation
	bullet.global_position = global_position
	get_tree().current_scene.add_child(bullet)
	

func spiral(delta: float) -> void:
	rotation += 1.0 * rotation_speed * delta
	
