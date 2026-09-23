extends Area2D
 
func _on_body_entered (body) -> void:
	get_tree().change_scene_to_file("res://scenes/brotatoclone.tscn")
