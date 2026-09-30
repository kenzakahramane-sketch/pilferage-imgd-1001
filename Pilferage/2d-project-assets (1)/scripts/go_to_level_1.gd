extends Area2D

func _on_body_entered(body) -> void:
	var current_scene = get_tree().current_scene.scene_file_path
	
	if current_scene == "res://scenes/brotatoclone.tscn":
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")
	
	if current_scene == "res://scenes/level_2.tscn":
		Global.spawn_point = "FromLevel2"
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")
	
