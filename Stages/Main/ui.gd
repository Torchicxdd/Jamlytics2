extends Control

func _ready() -> void:
	UISignalBus.add_level_ui.connect(_add_level_ui)
	MenuManager.open_main_menu.connect(_on_main_menu_open)
	MenuManager.open_pause_menu.connect(_on_pause_menu_open)
	MenuManager.open_levels_menu.connect(_on_levels_menu_open)

func _on_menu_open(menu_type: MenuManager.ROOT_MENU_TYPE) -> void:
	if find_child("RootMenu") != null:
		return
	
	add_child(RootMenu.new_root_menu(menu_type))

func _on_main_menu_open() -> void:
	_on_menu_open(MenuManager.ROOT_MENU_TYPE.MAIN)

func _on_pause_menu_open() -> void:
	_on_menu_open(MenuManager.ROOT_MENU_TYPE.PAUSE)

func _on_levels_menu_open() -> void:
	var level_scene = load(Constants.MENU_PATHS.levels_menu).instantiate()
	MenuManager.open_menu(level_scene)
	add_child(level_scene)

func _add_level_ui(control_node: Control) -> void:
	for child in get_children():
		child.queue_free()
	add_child(control_node)