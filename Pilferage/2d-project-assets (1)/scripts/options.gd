extends Control
@onready var simplified_control_button = $"Options buttons/Simplified controls setting"
@onready var music_button = $"Options buttons/Music button"
@onready var easy_mode_button = $"Options buttons/Easy mode button"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.simplified_controls == true:
		simplified_control_button.text = "ON"
	else:
		simplified_control_button.text = "OFF"
	if Global.music == true:
		music_button.text = "ON"
	else:
		music_button.text = "OFF"
	if Global.easy_mode == true:
		easy_mode_button.text = "ON"
	else:
		easy_mode_button.text = "OFF"

func _on_simplified_controls_setting_pressed() -> void:
	if Global.simplified_controls == true:
		Global.simplified_controls = false
	else:
		Global.simplified_controls = true
	if Global.simplified_controls == true:
		simplified_control_button.text = "ON"
	else:
		simplified_control_button.text = "OFF"


func _on_music_button_pressed() -> void:
	if Global.music == true:
		Global.music = false
	else:
		Global.music = true
	if Global.music == true:
		music_button.text = "ON"
	else:
		music_button.text = "OFF"

func _on_return_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_easy_mode_button_pressed() -> void:
	if Global.easy_mode == true:
		Global.easy_mode = false
	else:
		Global.easy_mode = true
	if Global.easy_mode == true:
		easy_mode_button.text = "ON"
	else:
		easy_mode_button.text = "OFF"
