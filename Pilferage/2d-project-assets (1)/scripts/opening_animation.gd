extends Node2D
# Plays once when "Start Game" is pressed, then transitions into the hub.
# Uses the jazz bar background art and the "idle"/"run" animations sliced
# from pilferage-cat-sheet-v1.1 (see the SpriteFrames built into this
# scene) instead of the old static catBack.png/catFront.png swap.

@onready var cat_sprite: AnimatedSprite2D = %CatSprite
@onready var narration_label: Label = %NarrationLabel
@onready var skip_hint: Label = %SkipHint

# Placeholder narration based on the team's plan-for-the-game doc - reword
# freely, this is just here so the sequence has something to show.
var narration_lines: Array[String] = [
	"After a long walk, you finally spot it: a little jazz bar at the edge of town.",
	"Inside, a cow behind the counter pours you a glass of milk... $5.",
	"Before you can even say thanks, a bright light floods the room - and the cow is gone.",
	"You never did pay for that milk.",
	"Looks like you've got a debt to settle, and a cow to find.",
]

var _skipped := false
var _fade_overlay: ColorRect


func _ready() -> void:
	narration_label.text = ""
	narration_label.modulate.a = 0.0
	skip_hint.text = "[Space] Skip"

	# Fade in from black - the old flat ColorRect background didn't need
	# this, but cutting straight to the new bar art looks jarring.
	_fade_overlay = ColorRect.new()
	_fade_overlay.color = Color(0, 0, 0, 1)
	_fade_overlay.anchor_right = 1.0
	_fade_overlay.anchor_bottom = 1.0
	_fade_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_fade_overlay)
	var screen_fade_in := create_tween()
	screen_fade_in.tween_property(_fade_overlay, "color:a", 0.0, 1.0)

	await _play_intro()


func _play_intro() -> void:
	# Walk in from off-screen left to a resting spot near the bar, running.
	cat_sprite.animation = "run"
	cat_sprite.play()
	cat_sprite.flip_h = false

	var start_x := cat_sprite.position.x
	cat_sprite.position.x = -150.0

	var walk_in := create_tween()
	walk_in.tween_property(cat_sprite, "position:x", start_x, 1.5)
	await walk_in.finished
	if _skipped:
		return

	await get_tree().create_timer(0.3).timeout
	if _skipped:
		return

	# Settle into idle once it's reached its spot at the bar.
	cat_sprite.animation = "idle"
	cat_sprite.play()

	for line in narration_lines:
		if _skipped:
			return
		await _show_line(line)

	if _skipped:
		return
	await get_tree().create_timer(0.75).timeout
	_go_to_hub()


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
	_go_to_hub()


func _go_to_hub() -> void:
	SceneTransition.change_scene("res://scenes/brotatoclone.tscn")
