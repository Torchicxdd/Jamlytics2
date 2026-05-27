extends Control

@export var world: Node2D
var world_paused: bool = false

func _ready() -> void:
	UISignalBus.add_level_ui.connect(_add_level_ui)
	MenuManager.resume_game.connect(_on_resume_game)
	MenuManager.open_main_menu.connect(_on_main_menu_open)
	MenuManager.open_levels_menu.connect(_on_levels_menu_open)

func _on_menu_open(menu_type: MenuManager.ROOT_MENU_TYPE) -> void:
	var existing = find_child("RootMenu")
	if existing != null:
		existing.queue_free()
		MenuManager.menu_stack_clear()
	add_child(RootMenu.new_root_menu(menu_type))

func _on_main_menu_open() -> void:
	_unpause_world()
	GameManager.is_game_started = false
	_on_menu_open(MenuManager.ROOT_MENU_TYPE.MAIN)

func _on_levels_menu_open() -> void:
	_unpause_world()
	GameManager.is_game_started = false
	MenuManager.menu_stack_clear()
	var level_scene = load(Constants.MENU_PATHS.levels_menu).instantiate()
	MenuManager.open_menu(level_scene)
	add_child(level_scene)

func _on_resume_game() -> void:
	_unpause_world()

func _unpause_world() -> void:
	if world_paused:
		world_paused = false
		_set_process_mode_recursive(world, Node.PROCESS_MODE_INHERIT)

func _add_level_ui(control_node: Control) -> void:
	for child in get_children():
		child.queue_free()
	MenuManager.menu_stack_clear()
	add_child(control_node)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if not GameManager.is_game_started:
			return

		world_paused = !world_paused
		var mode = Node.PROCESS_MODE_DISABLED if world_paused else Node.PROCESS_MODE_INHERIT
		_set_process_mode_recursive(world, mode)

		if world_paused:
			_on_menu_open(MenuManager.ROOT_MENU_TYPE.PAUSE)

func _set_process_mode_recursive(node: Node, mode: ProcessMode) -> void:
	node.process_mode = mode

	for child in node.get_children():
		_set_process_mode_recursive(child, mode)
