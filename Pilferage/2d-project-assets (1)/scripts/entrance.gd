extends CollisionShape2D

func _on_entrance_body_entered(body: Node2D):
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")
