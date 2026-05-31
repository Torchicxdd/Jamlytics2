class_name MovementComponent
extends Node

@export var speed: float = 200.0
@export var focus_speed_multiplier: float = 0.5

func _ready() -> void:
	assert(owner is CharacterBody2D, "Movement Component must be a child of a CharacterBody2D.")

func _physics_process(_delta: float) -> void:
	var body: CharacterBody2D = owner
	var input_dir: Vector2 = _get_input_direction()
	var focus: float = 1.0
	if Input.is_action_pressed("focus"):
		focus = focus_speed_multiplier
	body.velocity = input_dir * speed * focus
	body.move_and_slide()

func _get_input_direction() -> Vector2:
	var digital := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if not digital.is_zero_approx():
		return digital
	for device in Input.get_connected_joypads():
		var analog := Vector2(
			Input.get_joy_axis(device, JOY_AXIS_LEFT_X),
			Input.get_joy_axis(device, JOY_AXIS_LEFT_Y)
		)
		if analog.length() > 0.2:
			return analog.normalized()
	return Vector2.ZERO
