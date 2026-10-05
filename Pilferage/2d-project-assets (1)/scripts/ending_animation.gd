extends Node2D
# Plays after the final boss is beaten, then rolls into the credits.
# Mirrors opening_animation.gd's structure (fade in, narration lines, fade
# out) so the two cinematics feel like a matched pair.
#
# PLACEHOLDER NARRATION: Ryan's "Written ending" task owns the actual
# story beats here - swap narration_lines for the real text once that's
# written. This file is the delivery mechanism, not the final words.
# Not yet wired up to anything: there's no boss room/trigger scene calling
# this yet (that's Ryan's "Boss Room" task) - once that exists, have it
# call SceneTransition.change_scene("res://scenes/ending_animation.tscn").

@onready var cat_sprite: Sprite2D = %CatSprite
@onready var narration_label: Label = %NarrationLabel
@onready var skip_hint: Label = %SkipHint
@onready var fade_overlay: ColorRect = %FadeOverlay
@onready var music: AudioStreamPlayer = $Music

var cat_front := preload("res://assets/images/Hub Images/catFront.png")

# PLACEHOLDER - replace with Ryan's written ending.
var narration_lines: Array[String] = [
	"The light fades, and the bar is quiet again.",
	"The cow sets down an empty glass and smiles.",
	"\"Debt's settled,\" she says. \"Go on home, now.\"",
	"You step back out into the night, lighter than when you came in.",
]

var _skipped := false


func _ready() -> void:
	narration_label.text = ""
	narration_label.modulate.a = 0.0
	skip_hint.text = "[Space] Skip"
	cat_sprite.texture = cat_front
	if not Global.music:
		music.stop()
	else:
		music.play()
	await _play_ending()


func _play_ending() -> void:
	var screen_fade_in := create_tween()
	screen_fade_in.tween_property(fade_overlay, "color:a", 0.0, 1.0)
	await get_tree().create_timer(0.75).timeout
	if _skipped:
		return

	for line in narration_lines:
		if _skipped:
			return
		await _show_line(line)

	if _skipped:
		return
	await get_tree().create_timer(0.75).timeout
	_go_to_credits()


func _show_line(line: String) -> void:
	narration_label.text = line
	var fade_in := create_tween()
	fade_in.tween_property(narration_label, "modulate:a", 1.0, 0.4)
	await fade_in.finished

	await get_tree().create_timer(2.0).timeout
	if _skipped:
		return

	var fade_out := create_tween()
	fade_out.tween_property(narration_label, "modulate:a", 0.0, 0.3)
	await fade_out.finished


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select"):
		_skip()


func _skip() -> void:
	if _skipped:
		return
	_skipped = true
	_go_to_credits()


func _go_to_credits() -> void:
	# NOT using SceneTransition.change_scene() here - see the matching
	# comment in opening_animation.gd's _go_to_hub(). It waits forever for a
	# node named "cat"/"hubCat" that doesn't exist in this scene, so this
	# fades its own overlay to black and changes scenes directly instead.
	var fade_out := create_tween()
	fade_out.set_parallel(true)
	fade_out.tween_property(fade_overlay, "color:a", 1.0, 0.5)
	fade_out.tween_property(music, "volume_db", -40.0, 0.5)
	await fade_out.finished
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
