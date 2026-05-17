extends Node

var _pools := {}

func add_to_pool(scene: PackedScene, node: Node) -> void:
	node.get_parent().remove_child(node)
	_pools[scene].append(node)
	node.set_process(false)
	node.set_physics_process(false)
	if node is CanvasItem:
		node.hide()

func pull_from_pool(scene: PackedScene) -> Node:
	if not _pools.has(scene):
		_pools[scene] = []
	
	var pool: Array = _pools[scene]
	var node: Node
	if pool.is_empty():
		node = scene.instantiate()
	else:
		node = pool.pop_back()
		
	node.set_process(true)
	node.set_physics_process(true)
	if node is CanvasItem:
		node.show()
	return node
