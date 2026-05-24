class_name MovementComponent
extends Node

@export var speed: float = 200.0
@export var focus_speed_multiplier: float = 0.5

func _ready() -> void:
	assert(owner is CharacterBody2D, "Movement Component must be a child of a CharacterBody2D.")

func _physics_process(delta: float) -> void:
	var body: CharacterBody2D = owner
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
 
	if input_dir.length() > 1.0:
		input_dir = input_dir.normalized()
 
	var focus: float = 1.0
	if (Input.is_action_pressed("focus")):
		focus = focus_speed_multiplier
	body.velocity = input_dir * speed * focus
	body.move_and_slide()
