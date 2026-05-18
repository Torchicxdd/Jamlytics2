extends Node

signal on_menu_back_pressed()
signal open_main_menu()
signal open_pause_menu()
signal open_settings()
signal open_audio_settings()
signal open_controller_settings()
signal open_keyboard_settings()

enum ROOT_MENU_TYPE {
	MAIN,
	PAUSE
}

var menu_stack: Array[Control] = []

func open_menu(menu: Control):
	if menu_stack.size() > 0:
		menu_stack.back().hide()
	
	menu.show()
	menu_stack.push_back(menu)

func back():
	if menu_stack.size() <= 1:
		return
	
	var current = menu_stack.pop_back()
	current.hide()
	menu_stack.back().show()
