extends RigidBody2D

enum SpawnerTypes {
	NORMAL,
	SPECIAL
}

@onready var normal_spawner: Spawner = $NormalSpawner
@onready var special_spawner: Spawner = $SpecialSpawner

func _ready() -> void:
	normal_spawner.is_enabled = false
	special_spawner.is_enabled = false

func toggle_spawner(spawner: SpawnerTypes, is_enabled: bool) -> void:
	match spawner:
		SpawnerTypes.NORMAL:
			normal_spawner.is_enabled = is_enabled
		SpawnerTypes.SPECIAL:
			special_spawner.is_enabled = is_enabled
