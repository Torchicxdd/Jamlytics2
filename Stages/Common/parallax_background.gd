extends Node2D

@onready var visible_node: Sprite2D = $VisibleBackground
@onready var near_node: Sprite2D = $NearBackground
@onready var far_node: Sprite2D = $FarBackground

@export var visible_background: Texture2D
@export var near_background: Texture2D
@export var far_background: Texture2D

@export var is_enabled := false
@export var speed: int = 100

var _scroll: float = 0.0

func _ready() -> void:
	visible_node.texture = visible_background
	near_node.texture = near_background
	far_node.texture = far_background
	_update_positions()

func _update_positions() -> void:
	var w: int = visible_node.texture.get_width()
	var offset := fmod(_scroll, w)
	visible_node.position.x = -offset
	near_node.position.x = w - offset
	far_node.position.x = w * 2 - offset

func _process(delta: float) -> void:
	if not is_enabled:
		return
	_scroll += speed * delta
	_update_positions()
