extends RigidBody2D

enum SpawnerTypes {
	NORMAL,
	SPECIAL
}

@onready var normal_spawner: Spawner = $NormalSpawner
@onready var special_spawner: Spawner = $SpecialSpawner
@onready var health_component: HealthComponent = $HealthComponent
@onready var damage_flash_component: DamageFlashComponent = $DamageFlashComponent

func _ready() -> void:
	normal_spawner.is_enabled = false
	special_spawner.is_enabled = false
	health_component.damaged.connect(_on_damaged)

func _on_damaged(_amount: int) -> void:
	damage_flash_component.on_hit()

func toggle_spawner(spawner: SpawnerTypes, is_enabled: bool) -> void:
	match spawner:
		SpawnerTypes.NORMAL:
			normal_spawner.is_enabled = is_enabled
		SpawnerTypes.SPECIAL:
			special_spawner.is_enabled = is_enabled
