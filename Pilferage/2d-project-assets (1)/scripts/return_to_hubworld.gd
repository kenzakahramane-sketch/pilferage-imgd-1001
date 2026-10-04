extends Area2D

func _on_body_entered(body) -> void:
	print("Something entered: ", body.name)

	if body.name == "cat":
		Global.spawn_point = "forest"
		print("Spawn point: ", Global.spawn_point)
		SceneTransition.change_scene("res://scenes/brotatoclone.tscn")
