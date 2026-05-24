class_name FormationConfig
extends Resource

@export var formation_type: FormationComponent.FormationType
@export var entry_style: FormationComponent.EntryStyle
@export var formation_center: Vector2
@export var enemy_count: int = 10
@export var enemy_spacing: float = 120.0
@export var enemies: Array[EnemyConfig]