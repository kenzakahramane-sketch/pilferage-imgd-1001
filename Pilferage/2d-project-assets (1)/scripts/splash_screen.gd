extends Control

func _ready():
	var tween = create_tween()
	tween.tween_property($Fade, "modulate:a", 0.0, 3.9)
	tween.finished.connect(_go_to_menu)

func _go_to_menu():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
