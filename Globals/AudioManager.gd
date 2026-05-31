extends Node

const POOL_SIZE := 8

var _pool: Array[AudioStreamPlayer] = []
var _pool_index: int = 0

func _ready() -> void:
	for i in POOL_SIZE:
		var player := AudioStreamPlayer.new()
		player.bus = "SFX"
		add_child(player)
		_pool.append(player)

func play_sfx(stream: AudioStream, use_multiple_pools: bool = true) -> void:
	if stream == null:
		return
	_pool[_pool_index].stream = stream
	_pool[_pool_index].play()
	if use_multiple_pools:
		_pool_index = (_pool_index + 1) % POOL_SIZE
	else:
		_pool_index = (_pool_index) % POOL_SIZE
