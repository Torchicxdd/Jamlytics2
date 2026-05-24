@tool
extends AnimationPlayer

@export var music: AudioStream:
	set(value):
		music = value
		if music:
			_sync_all_animations()

func _sync_all_animations() -> void:
	for anim_name in get_animation_list():
		get_animation(anim_name).length = music.get_length()