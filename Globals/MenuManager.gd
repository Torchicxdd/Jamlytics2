extends Node

# Applicable to all signals
signal on_menu_back_pressed()

# Menu root signals/non-settings menus
signal open_main_menu()
signal open_levels_menu(is_faded: bool)
signal open_death_menu()
signal open_end_game_menu()

# Settings menus signals
signal open_audio_settings()
signal open_input_settings()

# Pause signals
signal resume_game()
signal game_resumed()


enum ROOT_MENU_TYPE {
	MAIN,
	PAUSE,
	DEATH
}

const FADE_DURATION: float = 0.15
const SCREEN_FADE_DURATION: float = 0.5

var _is_transitioning: bool = false
var menu_stack: Array[Control] = []

func open_menu(menu: Control, is_fade: bool = true):
	if menu_stack.size() > 0:
		var prev: Control = menu_stack.back()
		if is_fade:
			_fade_out(prev, func(): prev.hide())
		else:
			prev.hide()
	
	menu_stack.push_back(menu)
	if is_fade:
		menu.modulate.a = 0.0
		menu.show()
		_fade_in(menu)
	else:
		menu.modulate.a = 1.0
		menu.show()

func back(is_fade: bool = true):
	if menu_stack.size() <= 1:
		return

	var current: Control = menu_stack.pop_back()
	var prev: Control = menu_stack.back()
	if is_fade:
		prev.modulate.a = 0.0
		prev.show()
		_fade_out(current, func(): current.hide())
		_fade_in(prev)
	else:
		current.hide()
		prev.modulate.a = 1.0
		prev.show()

func _fade_in(menu: Control) -> void:
	var tween: Tween = menu.create_tween()
	tween.tween_property(menu, "modulate:a", 1.0, FADE_DURATION)

func _fade_out(menu: Control, on_complete: Callable = Callable()) -> void:
	var tween: Tween = menu.create_tween()
	tween.tween_property(menu, "modulate:a", 0.0, FADE_DURATION)
	if on_complete.is_valid():
		tween.tween_callback(on_complete)

func menu_stack_clear() -> void:
	menu_stack.clear()

func menu_stack_remove_node(node: Control) -> void:
	var position = menu_stack.find(node)
	if position != -1:
		menu_stack.remove_at(position)

func screen_fade_transition(callable: Callable) -> void:
	if _is_transitioning:
		return
	_is_transitioning = true

	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100

	var rect = ColorRect.new()
	rect.color = Color(0.0, 0.0, 0.0, 0.0)
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	canvas_layer.add_child(rect)
	get_tree().root.add_child(canvas_layer)

	var tween = canvas_layer.create_tween()
	tween.tween_property(rect, "color:a", 1.0, SCREEN_FADE_DURATION)
	tween.tween_callback(callable)
	tween.tween_property(rect, "color:a", 0.0, SCREEN_FADE_DURATION)
	tween.tween_callback(func():
		_is_transitioning = false
		canvas_layer.queue_free()
	)
