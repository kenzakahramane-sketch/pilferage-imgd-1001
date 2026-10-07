extends Area2D

func _on_body_entered(body):
	if body.name == "hubCat":
		AudioManager.stop_hub_music()
		get_tree().change_scene_to_file("res://scenes/interiors.tscn")
