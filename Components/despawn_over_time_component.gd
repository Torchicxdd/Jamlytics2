class_name DespawnOverTimeComponent
extends Node

enum DespawnStyle {
	FROM_TOP,
	FROM_BOTTOM,
	FROM_RIGHT
}

@export var despawn_timer: float = 10.0
@export var despawn_duration: float = 1.0
@export var despawn_style: DespawnStyle
@export var visible_on_screen_notifier: VisibleOnScreenNotifier2D

var _timer: float = 0.0

func _ready() -> void:
	visible_on_screen_notifier.screen_exited.connect(_on_screen_exited)

func _process(delta: float) -> void:
	_timer += delta
	if _timer >= despawn_timer:
		_despawn()

func _on_screen_exited() -> void:
	owner.queue_free()

func _despawn() -> void:
	var tween = create_tween()
	var screen = get_viewport().get_visible_rect().size
	match despawn_style:
		DespawnStyle.FROM_TOP:
			tween.tween_property(owner, "global_position:y", -screen.y, despawn_duration)
		DespawnStyle.FROM_BOTTOM:
			tween.tween_property(owner, "global_position:y", screen.y, despawn_duration)
		DespawnStyle.FROM_RIGHT:
			tween.tween_property(owner, "global_position:x", screen.x, despawn_duration)
