@tool
extends Node2D

@export var song: AudioStream:
	set(value):
		song = value
		queue_redraw()

@export var speed: int = 100:
	set(value):
		speed = value
		queue_redraw()

@export var background: Texture2D:
	set(value):
		background = value
		queue_redraw()

func _draw() -> void:
	if not Engine.is_editor_hint():
		return
	if song == null or background == null or speed <= 0:
		return

	var length := song.get_length()
	var total_distance := speed * length
	var w := background.get_width()
	var h := background.get_height()
	var num := int(ceil(total_distance / float(w)))

	for i in range(num):
		var pos := Vector2(w * i, 0)
		draw_texture(background, pos, Color(1, 1, 1, 0.5))
		draw_line(pos, pos + Vector2(0, h), Color(1, 1, 0, 0.8), 2.0)

	draw_line(Vector2(total_distance, -20), Vector2(total_distance, h + 20), Color.RED, 4.0)
