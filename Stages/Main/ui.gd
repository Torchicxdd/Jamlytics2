extends Control

@export var world: Node2D

func _ready() -> void:
	UISignalBus.add_level_ui.connect(_add_level_ui)
	MenuManager.resume_game.connect(_on_resume_game)
	MenuManager.open_main_menu.connect(_on_main_menu_open)
	MenuManager.open_levels_menu.connect(_on_levels_menu_open)
	MenuManager.open_death_menu.connect(_on_death_menu_open)
	MenuManager.open_end_game_menu.connect(_on_end_game_menu_open)

func _on_menu_open(menu_type: MenuManager.ROOT_MENU_TYPE) -> void:
	if menu_type != MenuManager.ROOT_MENU_TYPE.MAIN:
		var existing = find_child("RootMenu")
		if existing != null:
			existing.queue_free()
			MenuManager.menu_stack_clear()
	else:
		for child in get_children():
			child.queue_free()
	add_child(RootMenu.new_root_menu(menu_type))

func _on_main_menu_open() -> void:
	_unpause_world()
	GameManager.is_game_started = false
	_on_menu_open(MenuManager.ROOT_MENU_TYPE.MAIN)

func _on_levels_menu_open(is_faded: bool) -> void:
	var open_levels = func():
		for child in get_children():
			child.queue_free()
		_unpause_world()
		GameManager.reset_level_states()
		MenuManager.menu_stack_clear()
		var level_scene = load(Constants.MENU_PATHS.levels_menu).instantiate()
		MenuManager.open_menu(level_scene, false)
		add_child(level_scene)

	if is_faded:
		MenuManager.screen_fade_transition(open_levels)
	else:
		open_levels.call()

func _on_death_menu_open() -> void:
	_toggle_pause_world(true, MenuManager.ROOT_MENU_TYPE.DEATH)

func _on_end_game_menu_open() -> void:
	MenuManager.screen_fade_transition(func():
		for child in get_children():
			child.queue_free()
		_toggle_pause_world(true)
		MenuManager.menu_stack_clear()
		var end_game_scene = load(Constants.MENU_PATHS.end_game_menu).instantiate()
		MenuManager.open_menu(end_game_scene, false)
		add_child(end_game_scene)
	)

func _unpause_world() -> void:
	if GameManager.is_world_paused:
		GameManager.is_world_paused = false
		_set_process_mode_recursive(world, Node.PROCESS_MODE_INHERIT)

func _add_level_ui(control_node: Control) -> void:
	for child in get_children():
		child.queue_free()
	MenuManager.menu_stack_clear()
	add_child(control_node)

func _on_resume_game() -> void:
	_unpause_world()
	MenuManager.game_resumed.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if not GameManager.is_game_started:
			return

		_toggle_pause_world(!GameManager.is_world_paused, MenuManager.ROOT_MENU_TYPE.PAUSE)

func _toggle_pause_world(is_paused: bool, root_menu_type = null) -> void:
	GameManager.is_world_paused = is_paused
	var mode = Node.PROCESS_MODE_DISABLED if GameManager.is_world_paused else Node.PROCESS_MODE_INHERIT
	_set_process_mode_recursive(world, mode)
	if not GameManager.is_world_paused:
		_on_resume_game()
	else:
		MenuManager.game_paused.emit()
		if root_menu_type != null:
			_on_menu_open(root_menu_type)

func _set_process_mode_recursive(node: Node, mode: ProcessMode) -> void:
	if node.process_mode == Node.PROCESS_MODE_ALWAYS:
		return
	node.process_mode = mode

	for child in node.get_children():
		_set_process_mode_recursive(child, mode)
