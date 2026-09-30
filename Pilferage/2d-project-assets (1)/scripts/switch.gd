extends Area2D
# Generic puzzle switch/lever. Walk up, press interact, it solves puzzle_id -
# any gate.gd (or anything else) watching that same puzzle_id reacts.
# Duplicate switch.tscn and change puzzle_id/flavor text - no new script
# needed per puzzle.

@export var switch_name: String = "Lever"
@export var puzzle_id: String = ""
@export var flavor_lines: Array[String] = ["You pull the old lever..."]
@export var already_solved_lines: Array[String] = ["The lever's already been pulled."]

@onready var interact_hint: Label = %InteractHint

var _player_in_range: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	interact_hint.visible = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_range = true
		interact_hint.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_range = false
		interact_hint.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and not DialogueManager.is_active() and event.is_action_pressed("interact"):
		interact_hint.visible = false
		var lines: Array[String] = already_solved_lines if Global.is_puzzle_solved(puzzle_id) else flavor_lines
		DialogueManager.start_dialogue(lines, switch_name, self)
		get_viewport().set_input_as_handled()


func _on_dialogue_finished() -> void:
	Global.solve_puzzle(puzzle_id)
	if _player_in_range:
		interact_hint.visible = true
