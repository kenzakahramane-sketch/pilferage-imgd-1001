extends Control

@onready var image1 = $frame1
@onready var image2 = $frame2
@onready var image3 = $frame3
@onready var thanks_screen = $ThanksScreen
@onready var fade = $Fade
@onready var music = $EndGameMusic

func _ready():
	music.play()
	end_sequence()

func end_sequence():
	# Start completely black
	fade.modulate.a = 1.0
	
	# Everything else starts invisible
	image1.modulate.a = 0.0
	image2.modulate.a = 0.0
	image3.modulate.a = 0.0
	thanks_screen.modulate.a = 0.0
	
	# Stay black for a moment
	await get_tree().create_timer(3.0).timeout
	
	# BLACK -> IMAGE 1
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(fade, "modulate:a", 0.0, 2.0)
	tween.tween_property(image1, "modulate:a", 1.0, 2.0)
	await tween.finished
	
	# Show Image 1
	await get_tree().create_timer(6.0).timeout
	
	# IMAGE 1 -> IMAGE 2
	var tween2 = create_tween()
	tween2.set_parallel(true)
	tween2.tween_property(image1, "modulate:a", 0.0, 2.5)
	tween2.tween_property(image2, "modulate:a", 1.0, 2.5)
	await tween2.finished
	
	# Show Image 2
	await get_tree().create_timer(6.0).timeout
	
	# IMAGE 2 -> IMAGE 3
	var tween3 = create_tween()
	tween3.set_parallel(true)
	tween3.tween_property(image2, "modulate:a", 0.0, 2.5)
	tween3.tween_property(image3, "modulate:a", 1.0, 2.5)
	await tween3.finished
	
	# Show Image 3
	await get_tree().create_timer(6.0).timeout
	
	# IMAGE 3 -> BLACK
	var tween4 = create_tween()
	tween4.set_parallel(true)
	tween4.tween_property(image3, "modulate:a", 0.0, 2.5)
	tween4.tween_property(fade, "modulate:a", 1.0, 2.5)
	await tween4.finished
	
	# BLACK -> THANKS FOR PLAYING
	var tween5 = create_tween()
	tween5.set_parallel(true)
	tween5.tween_property(fade, "modulate:a", 0.0, 1.5)
	tween5.tween_property(thanks_screen, "modulate:a", 1.0, 1.5)
	await tween5.finished
	
	# Stay on the thank-you screen until Space is pressed
	await wait_for_space()

	# THANKS SCREEN -> BLACK
	var tween6 = create_tween()
	tween6.set_parallel(true)
	tween6.tween_property(thanks_screen, "modulate:a", 0.0, 1.5)
	tween6.tween_property(fade, "modulate:a", 1.0, 1.5)
	await tween6.finished

	# Give the black screen a moment
	await get_tree().create_timer(0.5).timeout

	# Return to main menu
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func wait_for_space():
	while true:
		if Input.is_key_pressed(KEY_SPACE):
			return
		
		await get_tree().process_frame


func fade_in(node, duration):
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 1.0, duration)
	await tween.finished


func fade_out(node, duration):
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 0.0, duration)
	await tween.finished
