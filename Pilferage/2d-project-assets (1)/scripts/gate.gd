extends StaticBody2D
# A generic obstacle that opens once a specific puzzle is solved. Works with
# ANY puzzle type (riddle, levers, future ones) since they all just call
# Global.solve_puzzle(puzzle_id) - the gate doesn't care how it was solved.
# Duplicate gate.tscn wherever you need a puzzle to block progress.

@export var puzzle_id: String = ""

@onready var collision: CollisionShape2D = %GateCollision
@onready var visual: ColorRect = %GateVisual


func _ready() -> void:
	Global.puzzle_solved.connect(_on_puzzle_solved)
	if Global.is_puzzle_solved(puzzle_id):
		_open(false)


func _on_puzzle_solved(id: String) -> void:
	if id == puzzle_id:
		_open(true)


func _open(animate: bool) -> void:
	collision.set_deferred("disabled", true)
	if animate:
		var tween := create_tween()
		tween.tween_property(visual, "modulate:a", 0.0, 0.6)
	else:
		visual.modulate.a = 0.0
