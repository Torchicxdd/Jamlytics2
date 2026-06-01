class_name Enemy
extends RigidBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var despawn_over_time_component: DespawnOverTimeComponent = $DespawnOverTimeComponent
@onready var bullet_marker: Marker2D = $BulletMarker
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var damage_flash_component: DamageFlashComponent = $DamageFlashComponent

var config: EnemyConfig

func configure(cfg: EnemyConfig) -> void:
	config = cfg
	health_component.health = cfg.health
	health_component.is_damageable = cfg.is_killable
	despawn_over_time_component.despawn_timer = cfg.despawn_timer
	despawn_over_time_component.despawn_duration = cfg.despawn_duration
	despawn_over_time_component.despawn_style = cfg.despawn_style

func _ready() -> void:
	health_component.damaged.connect(_on_enemy_damaged)

func _on_enemy_damaged(_amount: int) -> void:
	damage_flash_component.on_hit()
