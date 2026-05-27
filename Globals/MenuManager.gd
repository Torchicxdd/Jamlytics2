extends Node

# Applicable to all signals
signal on_menu_back_pressed()

# Menu root signals/non-settings menus
signal open_main_menu()
signal open_levels_menu()

# Settings menus signals
signal open_audio_settings()
signal open_input_settings()

# Pause signals
signal resume_game()


enum ROOT_MENU_TYPE {
	MAIN,
	PAUSE,
	DEATH
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

func menu_stack_clear() -> void:
	menu_stack.clear()

func menu_stack_remove_node(node: Control) -> void:
	var position = menu_stack.find(node)
	if position != -1:
		menu_stack.remove_at(position)
