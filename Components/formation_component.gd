class_name FormationComponent
extends Node2D

enum FormationType {
	V_SHAPE,
	GRID,
	ARC,
	DIAGONAL_LINE,
	PINCER
}

enum EntryStyle {
	FROM_TOP,
	FROM_RIGHT,
	FROM_TOP_AND_BOTTOM,
	FROM_BOTTOM
}

func spawn_formation(
	config: FormationConfig
) -> void:
	var positions = get_formation_positions(config.formation_type, config.enemy_count, config.enemy_spacing)
	for i in range(positions.size()):
		var enemy: Enemy = config.enemies[i].enemy_scene.instantiate()
		get_parent().add_child(enemy)
		enemy.configure(config.enemies[i])
		var spawner = Spawner.new_spawner(
			config.enemies[i].pattern,
			config.enemies[i].bullet_scene,
			config.enemies[i].bullet_sprite_frames,
			config.enemies[i].bullet_scale,
			config.enemies[i].bullet_speed,
			config.enemies[i].bullet_count,
			config.enemies[i].shooting_start_delay,
			config.enemies[i].is_rotating,
			config.enemies[i].is_oscillating,
			config.enemies[i].rotation_speed,
			config.enemies[i].spawn_interval,
			config.enemies[i].arc_angle
		)
		enemy.add_child(spawner)
		spawner.global_position = enemy.bullet_marker.global_position
		var target = config.formation_center + positions[i]
		enemy.global_position = _get_entry_position(target, config.entry_style, i)
		_tween_enemy_in(enemy, target)

func get_formation_positions(type: FormationType, count: int, spacing: float) -> Array[Vector2]:
	match type:
		FormationType.V_SHAPE:
			return _v_shape(count, spacing)
		FormationType.GRID:
			return _grid(count, spacing)
		FormationType.ARC:
			return _arc(count, spacing)
		FormationType.DIAGONAL_LINE:
			return _diagonal_line(count, spacing)
		FormationType.PINCER:
			return _pincer(count, spacing)
	return []

# V pointing leftward (toward player), tip at front-left, wings trailing right
func _v_shape(count: int, spacing: float) -> Array[Vector2]:
	var positions: Array[Vector2] = []
	var half = count / 2
	for i in range(count):
		var offset = i - half
		positions.append(Vector2((abs(offset) - half) * spacing * 0.6, offset * spacing))
	return positions

# Rectangular grid, centered on formation_center
func _grid(count: int, spacing: float) -> Array[Vector2]:
	var positions: Array[Vector2] = []
	var cols = ceili(sqrt(count))
	var rows = ceili(float(count) / cols)
	var start_x = - (cols - 1) * spacing / 2.0
	var start_y = - (rows - 1) * spacing / 2.0
	for i in range(count):
		var col = i % cols
		var row = i / cols
		positions.append(Vector2(start_x + col * spacing, start_y + row * spacing))
	return positions

# "(" arc opening to the right, bulging leftward toward player
func _arc(count: int, spacing: float) -> Array[Vector2]:
	var positions: Array[Vector2] = []
	var angle_step = PI / max(count - 1, 1)
	var radius = spacing * count / PI
	for i in range(count):
		var angle = angle_step * i - PI / 2.0 # -PI/2 to PI/2
		positions.append(Vector2(-cos(angle) * radius * 0.4, sin(angle) * radius))
	return positions

# Diagonal line from upper-right (back) to lower-left (front)
func _diagonal_line(count: int, spacing: float) -> Array[Vector2]:
	var positions: Array[Vector2] = []
	var half = (count - 1) / 2.0
	for i in range(count):
		var t = i - half
		positions.append(Vector2(-t * spacing * 0.5, t * spacing))
	return positions

# Two wings converging leftward: wide at back-right, narrow at front-left
func _pincer(count: int, spacing: float) -> Array[Vector2]:
	var positions: Array[Vector2] = []
	var half_count = count / 2
	for i in range(half_count):
		# Upper wing
		positions.append(Vector2(-i * spacing * 0.5, - (half_count - i) * spacing))
		# Lower wing
		positions.append(Vector2(-i * spacing * 0.5, (half_count - i) * spacing))
	return positions

func _get_entry_position(target: Vector2, entry: EntryStyle, index: int = 0) -> Vector2:
	match entry:
		EntryStyle.FROM_TOP:
			return Vector2(target.x, -50)
		EntryStyle.FROM_RIGHT:
			return Vector2(get_viewport().get_visible_rect().size.x + 50, target.y)
		EntryStyle.FROM_BOTTOM:
			return Vector2(target.x, get_viewport().get_visible_rect().size.y + 50)
		EntryStyle.FROM_TOP_AND_BOTTOM:
			if index % 2 == 0:
				return Vector2(target.x, -50)
			else:
				return Vector2(target.x, get_viewport().get_visible_rect().size.y + 50)
	return target

func _tween_enemy_in(enemy: Node2D, target: Vector2) -> void:
	var tween = create_tween()
	tween.tween_property(enemy, "global_position", target, 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
