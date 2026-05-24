class_name VelocityComponent
extends Node

@export var speed: float = 200.0

func _ready() -> void:
	assert(owner is CharacterBody2D or owner is RigidBody2D, "VelocityComponent must be on a CharacterBody2D or RigidBody2D.")
	
func _physics_process(delta: float) -> void:
	if owner is CharacterBody2D:
		var body: CharacterBody2D = owner
		var direction: Vector2 = Vector2.from_angle(body.global_rotation)
		body.velocity = direction * speed
		body.move_and_slide()
	elif owner is RigidBody2D:
		var body: RigidBody2D = owner
		var direction: Vector2 = Vector2.from_angle(body.global_rotation)
		body.linear_velocity = direction * speed
