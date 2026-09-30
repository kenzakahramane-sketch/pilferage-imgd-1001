extends Area2D
func _on_body_entered(body) -> void:
	if not body.is_in_group("player"):
		return

	var current_scene = get_tree().current_scene.scene_file_path
	if current_scene == "res://scenes/level_2.tscn":
		Global.spawn_point = "FromLevel2"

	Global.current_level_path = "res://scenes/level_1.tscn"
	Global.save_game()
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
