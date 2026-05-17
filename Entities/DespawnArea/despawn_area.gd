extends Area2D

func _ready() -> void:
	body_exited.connect(_on_body_exited)
	
func _on_body_exited(body: Node) -> void:
	body.get_scene_
		
