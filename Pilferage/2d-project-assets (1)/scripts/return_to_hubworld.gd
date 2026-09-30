extends Area2D

func _on_body_entered (body) -> void:
	if body.is_in_group("player"):
		Global.spawn_point = "forest"
		Global.current_level_path = "res://scenes/brotatoclone.tscn"
		Global.save_game()
		get_tree().change_scene_to_file("res://scenes/brotatoclone.tscn")
