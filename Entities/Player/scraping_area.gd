extends Area2D

const SCRAPING_POINTS_INTERVAL: float = 0.05
const SCRAPING_POINTS_PER_INTERVAL: int = 100

var _bullets: Dictionary[Area2D, float]

func _ready() -> void:
	area_entered.connect(_on_scraping_entered)
	area_exited.connect(_on_scraping_exited)

func _process(delta: float) -> void:
	for bullet in _bullets.keys():
		_bullets[bullet] += delta
		if _bullets[bullet] >= SCRAPING_POINTS_INTERVAL:
			_bullets[bullet] = 0.0
			GameManager.add_points(SCRAPING_POINTS_PER_INTERVAL)

func _on_scraping_entered(area: Area2D) -> void:
	if area is EnemyBullet:
		_bullets[area] = 0.0

func _on_scraping_exited(area: Area2D) -> void:
	if area is EnemyBullet:
		_bullets.erase(area)
