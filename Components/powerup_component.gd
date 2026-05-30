class_name PowerupComponent
extends Node

@export var shooting_component: ShootingComponent
@export var health_component: HealthComponent
@export var grazing_area: Area2D

var _base_graze_radius: float
const POISE_BOMB_RADIUS_MULTIPLIER: float = 10.0

func _ready() -> void:
	var shape := grazing_area.get_node("CollisionShape2D").shape as CircleShape2D
	_base_graze_radius = shape.radius
	GameManager.powerups_activated.connect(_on_powerups_activated)
	GameManager.powerups_deactivated.connect(_on_powerups_deactivated)

func _on_powerups_activated(powerups: Array[GameManager.Powerup]) -> void:
	for powerup in powerups:
		match powerup:
			GameManager.Powerup.FURY:
				shooting_component.add_shooting_type(ShootingComponent.SHOOTING_TYPE.SPREAD)
				shooting_component.bullet_spawned.connect(_on_bullet_spawned_fury)
			GameManager.Powerup.POISE:
				shooting_component.add_shooting_type(ShootingComponent.SHOOTING_TYPE.RADIAL)
				_clear_bullets_around_player()
			GameManager.Powerup.FLOW:
				shooting_component.add_shooting_type(ShootingComponent.SHOOTING_TYPE.BEAM)
				_set_graze_radius(_base_graze_radius * 1.5)

func _on_powerups_deactivated(powerups: Array[GameManager.Powerup]) -> void:
	for powerup in powerups:
		match powerup:
			GameManager.Powerup.FURY:
				shooting_component.remove_shooting_type(ShootingComponent.SHOOTING_TYPE.SPREAD)
				if shooting_component.bullet_spawned.is_connected(_on_bullet_spawned_fury):
					shooting_component.bullet_spawned.disconnect(_on_bullet_spawned_fury)
			GameManager.Powerup.POISE:
				shooting_component.remove_shooting_type(ShootingComponent.SHOOTING_TYPE.RADIAL)
			GameManager.Powerup.FLOW:
				shooting_component.remove_shooting_type(ShootingComponent.SHOOTING_TYPE.BEAM)
				_set_graze_radius(_base_graze_radius)

func _on_bullet_spawned_fury(spawned_bullet: Bullet) -> void:
	var dc := spawned_bullet.get_node_or_null("DamageComponent") as DamageComponent
	if dc:
		dc.damaged.connect(func(): health_component.heal(1))

func _clear_bullets_around_player() -> void:
	var space_state := grazing_area.get_world_2d().direct_space_state
	var query := PhysicsShapeQueryParameters2D.new()
	var shape := CircleShape2D.new()
	shape.radius = _base_graze_radius * POISE_BOMB_RADIUS_MULTIPLIER
	query.shape = shape
	query.transform = Transform2D(0, grazing_area.global_position)
	query.collision_mask = grazing_area.collision_mask
	query.collide_with_areas = true
	query.collide_with_bodies = false
	var results := space_state.intersect_shape(query, 256)
	for result in results:
		var collider = result["collider"]
		if collider is EnemyBullet:
			collider.queue_free()

func _set_graze_radius(radius: float) -> void:
	var shape := grazing_area.get_node("CollisionShape2D").shape as CircleShape2D
	shape.radius = radius
