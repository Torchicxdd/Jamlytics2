class_name RootMenu
extends Control

const ROOT_MENU_SCENE: PackedScene = preload(Constants.MENU_PATHS.root_menu)

var root_menu_type: MenuManager.ROOT_MENU_TYPE
@onready var main_background = $main_background
@onready var pause_background = $pause_background
@onready var death_background = $death_background
@onready var menu_wrapper = $menu_wrapper
@onready var audio_menu = $menu_wrapper/AudioMenu
@onready var input_menu = $menu_wrapper/InputMenu

var current_menu: Control

static func new_root_menu(menu_type: MenuManager.ROOT_MENU_TYPE) -> RootMenu:
	var new_root_menu: RootMenu = ROOT_MENU_SCENE.instantiate()
	new_root_menu.root_menu_type = menu_type
	return new_root_menu

func _ready() -> void:
	MenuManager.on_menu_back_pressed.connect(_on_menu_back_pressed)
	MenuManager.open_audio_settings.connect(_on_open_audio_settings)
	MenuManager.open_input_settings.connect(_on_open_input_settings)
	
	match root_menu_type:
		MenuManager.ROOT_MENU_TYPE.MAIN:
			main_background.show()
			pause_background.hide()
			death_background.hide()
			var main_menu_scene = load(Constants.MENU_PATHS.main_menu)
			var main_menu = main_menu_scene.instantiate()
			menu_wrapper.add_child(main_menu)
			MenuManager.open_menu(main_menu)
			current_menu = main_menu
		MenuManager.ROOT_MENU_TYPE.PAUSE:
			main_background.hide()
			pause_background.show()
			death_background.hide()
			var pause_menu_scene = load(Constants.MENU_PATHS.pause_menu)
			var pause_menu = pause_menu_scene.instantiate()
			menu_wrapper.add_child(pause_menu)
			MenuManager.open_menu(pause_menu)
			current_menu = pause_menu
			MenuManager.game_resumed.connect(_on_game_resumed)
		MenuManager.ROOT_MENU_TYPE.DEATH:
			main_background.hide()
			pause_background.hide()
			death_background.show()
			var death_menu_scene = load(Constants.MENU_PATHS.death_menu)
			var death_menu = death_menu_scene.instantiate()
			menu_wrapper.add_child(death_menu)
			MenuManager.open_menu(death_menu)
			current_menu = death_menu
			MenuManager.game_resumed.connect(_on_game_resumed)

func _on_game_resumed() -> void:
	MenuManager.menu_stack_remove_node(current_menu)
	queue_free()

func _on_menu_back_pressed() -> void:
	MenuManager.back()

func _on_open_audio_settings():
	MenuManager.open_menu(audio_menu)

func _on_open_input_settings():
	MenuManager.open_menu(input_menu)
