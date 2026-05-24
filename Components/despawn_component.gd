class_name DespawnComponent
extends Node

@export var visible_on_screen_notifier: VisibleOnScreenNotifier2D

func _ready() -> void:
	assert(visible_on_screen_notifier != null, "DespawnComponent must have a VisibleOnScreenNotifier2D provided.")
	visible_on_screen_notifier.screen_exited.connect(_on_screen_exited)

func _on_screen_exited() -> void:
	owner.queue_free()
