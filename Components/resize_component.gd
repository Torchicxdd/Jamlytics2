class_name ResizeComponent
extends Node

@export var scale: Vector2 = Vector2(1, 1):
	set(value):
		scale = value
		if is_node_ready():
			_apply()

var _baselines: Dictionary[Node2D, Vector2] = {}

func _ready() -> void:
	var parent: Node = get_parent()
	if parent == null:
		return
	for child in parent.get_children():
		if child == self:
			continue
		if child is RigidBody2D or child is CharacterBody2D:
			push_warning("ResizeComponent: skipping %s — scale its collision shape children instead." % child.name)
			continue
		if child is Node2D:
			var n: Node2D = child
			_baselines[n] = n.scale
	_apply()

func _apply() -> void:
	for node in _baselines:
		if not is_instance_valid(node):
			continue
		node.scale = scale
