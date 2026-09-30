extends Node2D
# Dev-only scene: both minigames side by side with no level geometry to
# fight against. Press Esc to jump back to the main menu.

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
