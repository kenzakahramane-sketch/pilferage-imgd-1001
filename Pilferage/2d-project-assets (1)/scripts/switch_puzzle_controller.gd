extends Node2D
# Tracks the order its child SwitchLevers are pressed in. Solve by pressing
# them in "correct_order" (matching each lever's lever_id). Wrong order
# resets all levers after a short pause.

@export var puzzle_id: String = ""
@export var correct_order: Array[int] = [0, 1, 2]

var _pressed_order: Array[int] = []


func _ready() -> void:
	for child in get_children():
		if child.has_signal("activated"):
			child.activated.connect(_on_lever_activated)

	if Global.is_puzzle_solved(puzzle_id):
		for child in get_children():
			if child.has_method("reset"):
				child.set_process_unhandled_input(false)


func _on_lever_activated(lever_id: int) -> void:
	if Global.is_puzzle_solved(puzzle_id):
		return

	_pressed_order.append(lever_id)
	var i: int = _pressed_order.size() - 1

	if _pressed_order[i] != correct_order[i]:
		await get_tree().create_timer(0.4).timeout
		_reset_all()
		return

	if _pressed_order.size() == correct_order.size():
		Global.solve_puzzle(puzzle_id)


func _reset_all() -> void:
	_pressed_order.clear()
	for child in get_children():
		if child.has_method("reset"):
			child.reset()
