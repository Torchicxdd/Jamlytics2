extends Control

@export var dev1_url: String = "https://torchicxdd.itch.io"
@export var dev1_icon: Texture2D

@export var dev2_url: String = "https://x.com/ekb9816"
@export var dev2_icon: Texture2D

@export var dev3_url: String = "https://www.youtube.com/@jeunptolar"
@export var dev3_url_2: String = "https://soundcloud.com/jeunptolar"
@export var dev3_icon: Texture2D

@onready var dev1_btn: TextureButton = $VBoxContainer/Dev1Row/Control/Dev1Icon
@onready var dev2_btn: TextureButton = $VBoxContainer/Dev2Row/Control/Dev2Icon
@onready var dev3_btn: TextureButton = $VBoxContainer/Dev3Row/Control/Dev3Icon
@onready var dev3_btn_2: TextureButton = $VBoxContainer/Dev3Row/Control/Dev3Icon2
@onready var back_button = $MarginContainer/Control/BackButton

func _ready() -> void:
	if dev1_icon:
		dev1_btn.texture_normal = dev1_icon
	if dev2_icon:
		dev2_btn.texture_normal = dev2_icon
	if dev3_icon:
		dev3_btn.texture_normal = dev3_icon

	dev1_btn.pressed.connect(func(): OS.shell_open(dev1_url))
	dev2_btn.pressed.connect(func(): OS.shell_open(dev2_url))
	dev3_btn.pressed.connect(func(): OS.shell_open(dev3_url))
	dev3_btn_2.pressed.connect(func(): OS.shell_open(dev3_url_2))

	back_button.on_back_button_pressed_callable = MenuManager.on_menu_back_pressed.emit
