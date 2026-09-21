extends Node2D
# Plays once when "Start Game" is pressed, then transitions into the hub.
# Uses Diana's catBack.png / catFront.png - no extra art needed.

@onready var cat_sprite: Sprite2D = %CatSprite
@onready var narration_label: Label = %NarrationLabel
@onready var skip_hint: Label = %SkipHint

var cat_back := preload("res://assets/images/Hub Images/catBack.png")
var cat_front := preload("res://assets/images/Hub Images/catFront.png")

# Placeholder narration based on the team's plan-for-the-game doc - reword
# freely, this is just here so the sequence has something to show.
var narration_lines: Array[String] = [
	"After a long walk, you finally spot it: a little jazz bar at the edge of town.",
	"Inside, a cow behind the counter pours you a glass of milk... on the house.",
	"Before you can even say thanks, a bright light floods the room - and the cow is gone.",
	"You never did pay for that milk.",
	"Looks like you've got a debt to settle, and a cow to find.",
]

var _skipped := false


func _ready() -> void:
	narration_label.text = ""
	narration_label.modulate.a = 0.0
	skip_hint.text = "[Space] Skip"
	await _play_intro()


func _play_intro() -> void:
	cat_sprite.texture = cat_back
	var start_y := cat_sprite.position.y
	cat_sprite.position.y = start_y + 300

	var walk_in := create_tween()
	walk_in.tween_property(cat_sprite, "position:y", start_y, 1.5)
	await walk_in.finished
	if _skipped:
		return

	await get_tree().create_timer(0.5).timeout
	if _skipped:
		return

	# Cat turns around to face the player
	cat_sprite.texture = cat_front

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
	get_tree().change_scene_to_file("res://scenes/brotatoclone.tscn")
