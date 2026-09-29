extends Area2D
# One lever in a switch-sequence puzzle. Duplicate this a few times under a
# switch_puzzle_controller and give each one a distinct lever_id.

signal activated(lever_id: int)

@export var lever_id: int = 0

@onready var gem: ColorRect = %Gem
@onready var interact_hint: Label = %InteractHint

var _player_in_range := false
var _is_activated := false

var _off_color := Color(0.6, 0.1, 0.1, 1)
var _on_color := Color(0.25, 0.9, 0.35, 1)


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	interact_hint.visible = false
	gem.color = _off_color


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_range = true
		if not _is_activated:
			interact_hint.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_range = false
		interact_hint.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and not _is_activated and event.is_action_pressed("interact"):
		_is_activated = true
		interact_hint.visible = false
		gem.color = _on_color
		activated.emit(lever_id)


# Called by the controller when the sequence is entered wrong
func reset() -> void:
	_is_activated = false
	gem.color = _off_color
	if _player_in_range:
		interact_hint.visible = true
