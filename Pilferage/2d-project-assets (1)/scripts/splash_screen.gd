extends Control

func _ready():
	var tweenPrime = create_tween()
	tweenPrime.tween_property($Fade, "modulate:a", 0.0, 4.0)
	tweenPrime.finished.connect(_go_to_menu)
func _go_to_menu():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
