extends CollisionShape2D

func _on_to_hub_body_entered(body: Node2D):
	if body.name == "cat":
		Global.spawn_point = "forest"
		call_deferred("_change_to_hub")

func _change_to_hub():
	get_tree().change_scene_to_file("res://scenes/brotatoclone.tscn")
