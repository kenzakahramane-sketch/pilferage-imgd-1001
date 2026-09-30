extends Area2D

func _on_body_entered(body) -> void:
	if body.name == "cat":
		print("RETURNING TO HUB")
		Global.spawn_point = "forest"
		print("Spawn point: ", Global.spawn_point)
		get_tree().change_scene_to_file("res://scenes/brotatoclone.tscn")
