extends Area2D

func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		Global.current_level_path = "res://scenes/level_2.tscn"
		Global.save_game()
		get_tree().change_scene_to_file("res://scenes/level_2.tscn")
