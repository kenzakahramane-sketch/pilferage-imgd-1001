extends Node2D

@onready var fade = $CanvasLayer/Fade
@onready var sound = $CanvasLayer/AudioStreamPlayer2D

func _ready():
	fade.color.a = 1.0
	sound.play()

	var fade_in = create_tween()
	fade_in.tween_property(fade, "color:a", 0.0, 1.0)

	await fade_in.finished
	await get_tree().create_timer(5.0).timeout

	var fade_out = create_tween()
	fade_out.tween_property(fade, "color:a", 1.0, 1.0)

	await fade_out.finished

	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
