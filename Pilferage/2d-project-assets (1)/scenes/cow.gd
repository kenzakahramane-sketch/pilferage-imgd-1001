extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print("COW DETECTED: ", body.name)

	if body.name == "cat":
		print("Going to ending...")
		get_tree().change_scene_to_file("res://win_screen.tscn")
