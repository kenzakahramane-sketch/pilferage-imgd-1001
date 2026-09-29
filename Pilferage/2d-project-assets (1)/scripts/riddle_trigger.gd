extends Area2D
# Reusable riddle trigger. Duplicate riddle_trigger.tscn and set the
# Inspector fields below - no new script needed per riddle.

@export var puzzle_id: String = ""      # must be unique across the whole game
@export var question: String = "What has to be broken before you can use it?"
@export var choices: Array[String] = ["A promise", "An egg", "A window", "A record"]
@export var correct_index: int = 1

@onready var interact_hint: Label = %InteractHint

var _player_in_range := false


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	interact_hint.visible = false
	if Global.is_puzzle_solved(puzzle_id):
		interact_hint.text = "[solved]"


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_range = true
		interact_hint.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_range = false
		interact_hint.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and not RiddleUI.is_active() and event.is_action_pressed("interact"):
		RiddleUI.start_riddle(question, choices, correct_index, puzzle_id)
