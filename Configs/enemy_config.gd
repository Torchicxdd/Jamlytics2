class_name EnemyConfig
extends Resource

@export var enemy_scene: PackedScene
@export var health: int
@export var despawn_timer: float
@export var despawn_duration: float
@export var despawn_style: DespawnOverTimeComponent.DespawnStyle

@export var pattern: Spawner.Patterns
@export var bullet_scene: PackedScene
@export var bullet_sprite_frames: SpriteFrames
@export var bullet_scale: Vector2 = Vector2(1.0, 1.0)
@export var bullet_speed: float = 200.0
@export var bullet_count: int = 0
@export var shooting_start_delay: float = 0
@export var is_rotating: bool = false
@export var is_oscillating: bool = false
@export var rotation_speed: float = 2.0
@export var spawn_interval: float = 0.5
@export_range(-360, 360) var arc_angle: float = 30.0
