extends CollisionShape2D

func _on_entrance_body_entered(body: Node2D):
	if body.name == "hubCat":
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")
