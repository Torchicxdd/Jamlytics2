extends Control

func _ready() -> void:
	MenuManager.open_main_menu.connect(_on_main_menu_open)
	MenuManager.open_pause_menu.connect(_on_pause_menu_open)

func _on_menu_open(menu_type: MenuManager.ROOT_MENU_TYPE) -> void:
	if find_child("RootMenu") != null:
		return
	
	add_child(RootMenu.new_root_menu(menu_type))

func _on_main_menu_open() -> void:
	_on_menu_open(MenuManager.ROOT_MENU_TYPE.MAIN)

func _on_pause_menu_open() -> void:
	_on_menu_open(MenuManager.ROOT_MENU_TYPE.PAUSE)
