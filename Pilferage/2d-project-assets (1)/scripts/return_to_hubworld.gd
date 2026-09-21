extends Area2D
 
func _on_body_entered (body) -> void:
	Global.spawn_point = "forest"
	get_tree().change_scene_to_file("res://scenes/brotatoclone.tscn")
<<<<<<< Updated upstream


func _on_area_entered(area: Area2D) -> void:
	Global.spawn_point = "forest"
	get_tree().change_scene_to_file("res://scenes/brotatoclone.tscn")
=======
>>>>>>> Stashed changes
