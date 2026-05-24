class_name CoverageHurtboxComponent
extends Area2D

@export var damage: int = 0

# Value between 0 and 1
signal covered()
signal grazing_changed(coverage: float, source: HurtboxComponent)

var _tracked: Array[HurtboxComponent] = []

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		_tracked.append(area as HurtboxComponent)

func _on_area_exited(area: Area2D) -> void:
	if area is HurtboxComponent:
		var source: HurtboxComponent = area
		if _tracked.has(source):
			_tracked.erase(source)

func _physics_process(_delta: float) -> void:
	for hurtbox in _tracked.duplicate():
		if not is_instance_valid(hurtbox):
			_tracked.erase(hurtbox)
			continue
		var coverage: float = _compute_coverage(hurtbox)
		if coverage >= 1.0:
			_tracked.erase(hurtbox)
			hurtbox.receive_damage(damage)
			covered.emit()
		else:
			grazing_changed.emit(coverage, hurtbox)

# This function assumes the self circle radius is bigger than the hurtbox
func _compute_coverage(hurtbox: HurtboxComponent) -> float:
	var self_circle_radius: float = _get_circle_radius(self )
	var hurtbox_circle_radius: float = _get_circle_radius(hurtbox)
	var dist: float = global_position.distance_to(hurtbox.global_position)

	if dist >= (self_circle_radius + hurtbox_circle_radius):
		return 0.0

	var overlapping_distance: float = dist + hurtbox_circle_radius
	if (overlapping_distance <= self_circle_radius):
		return 1.0
	
	var max_dist: float = self_circle_radius + hurtbox_circle_radius
	var min_dist: float = self_circle_radius - hurtbox_circle_radius
	
	# Remap the current distance to a 0.0 - 1.0 range inverse
	var coverage: float = remap(dist, max_dist, min_dist, 0.0, 1.0)
	return clamp(coverage, 0.0, 1.0)

func _get_circle_radius(area: Area2D) -> float:
	for c in area.get_children():
		if c is CollisionShape2D:
			var cs: CollisionShape2D = c as CollisionShape2D
			if cs.shape is CircleShape2D:
				return (cs.shape as CircleShape2D).radius * cs.global_scale.x
	return 0.0
