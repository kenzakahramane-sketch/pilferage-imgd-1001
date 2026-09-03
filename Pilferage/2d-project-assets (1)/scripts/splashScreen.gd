extends Control
func _ready():
	await get_tree().create_timer(10.0).timeout # Wait 4 seconds
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
