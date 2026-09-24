extends Node2D
@onready var music_1 = $AudioStreamPlayer
@onready var music_2 = $AudioStreamPlayer2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.music == true:
		music_1.play()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if music_1.is_playing():
		var time = music_1.get_playback_position()
		music_1.stop()
		music_2.play(time)


func _on_return_to_hubworld_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/brotatoclone.tscn")
