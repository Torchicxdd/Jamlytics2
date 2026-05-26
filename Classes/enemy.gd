class_name Enemy
extends RigidBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var despawn_over_time_component: DespawnOverTimeComponent = $DespawnOverTimeComponent
@onready var bullet_marker: Marker2D = $BulletMarker

var config: EnemyConfig

func configure(cfg: EnemyConfig) -> void:
	config = cfg
	health_component.health = cfg.health
	despawn_over_time_component.despawn_timer = cfg.despawn_timer
	despawn_over_time_component.despawn_duration = cfg.despawn_duration
	despawn_over_time_component.despawn_style = cfg.despawn_style