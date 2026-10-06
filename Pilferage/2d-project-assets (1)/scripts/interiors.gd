extends Node2D

@onready var music: AudioStreamPlayer = $Music

func _ready():
	if Global.music == true:
		music.play()
		
func _on_exit_door_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("to hub")
		Global.spawn_point = "barExitSpawn"
		SceneTransition.change_scene("res://scenes/brotatoclone.tscn")
	
