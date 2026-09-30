extends Node2D
@onready var music_1 = $AudioStreamPlayer
@onready var music_2 = $AudioStreamPlayer2
@onready var tutorial_wall_push = $Labels/Label3
@onready var tutorial_wall_jump = $Labels/Label4
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.music == true:
		music_1.play()
	spawnpoint()
	if Global.simplified_controls == false:
		tutorial_wall_push.text = "Press the spacebar
when against a wall
to push yourself off
the wall and give
yourself a burst of
speed."
		tutorial_wall_jump.text = "If you preform a
wall push while
pressing the jump
button, you can do
a wall jump."
	else:
		tutorial_wall_push.text = "To push yourself off
a wall to get a
burst of speed, stay
against a wall for a
period of time, then
press the opposite
direction of the wall."
		tutorial_wall_jump.text = "If you press jump and
are against a wall,
you can press the
opposite direction of
the wall to wall jump."
func _on_area_2d_body_entered(body: Node2D) -> void:
	if music_1.is_playing():
		var time = music_1.get_playback_position()
		music_1.stop()
		music_2.play(time)


func _on_return_to_hubworld_body_entered(body) -> void:
	if body.name == "cat":
		call_deferred("_return_to_hub")
	
func spawnpoint():
	if Global.spawn_point == "FromLevel2":
		$cat.global_position = $FromLevel2.global_position

		var camera = $cat/Camera2D
		camera.reset_smoothing()

		Global.spawn_point = ""
func _return_to_hub():
	Global.spawn_point = "forest"
	get_tree().change_scene_to_file("res://scenes/brotatoclone.tscn")
