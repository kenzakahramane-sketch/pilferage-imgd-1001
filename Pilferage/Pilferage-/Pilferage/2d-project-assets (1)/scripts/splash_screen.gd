extends Control

func _ready():
	var tweenPrime = create_tween()
	var tweenSec = create_tween()
	tweenPrime.tween_property($background, "modulate:a", 0.0, 4.0)
	tweenSec.tween_property($background/logo, "modulate:a", 0.0, 6.0)
	tweenPrime.finished.connect(_go_to_menu)
func _go_to_menu():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
