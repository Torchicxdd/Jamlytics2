class_name EnemyBullet
extends Bullet

@onready var coverage_hurtbox_component: CoverageHurtboxComponent = $CoverageHurtboxComponent
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var bullet_sprite_frames: SpriteFrames

func _ready() -> void:
	animated_sprite.sprite_frames = bullet_sprite_frames
	animated_sprite.play("default")
	coverage_hurtbox_component.covered.connect(_on_covered)

func _on_covered() -> void:
	queue_free()
