extends CanvasLayer
# AUTOLOAD riddle_ui.tscn (the scene, not just the script) as "RiddleUI" in
# Project Settings > Autoload.

@onready var panel: Panel = %RiddlePanel
@onready var question_label: Label = %QuestionLabel
@onready var choices_container: VBoxContainer = %ChoicesContainer
@onready var feedback_label: Label = %FeedbackLabel

var _correct_index := -1
var _puzzle_id := ""
var _active := false


func is_active() -> bool:
	return _active


func start_riddle(question: String, choices: Array[String], correct_index: int, puzzle_id: String) -> void:
	if _active:
		return
	_active = true
	_correct_index = correct_index
	_puzzle_id = puzzle_id

	question_label.text = question
	feedback_label.text = ""

	for child in choices_container.get_children():
		child.queue_free()
	for i in choices.size():
		var btn := Button.new()
		btn.text = choices[i]
		btn.pressed.connect(_on_choice_pressed.bind(i))
		choices_container.add_child(btn)

	panel.visible = true


func _on_choice_pressed(index: int) -> void:
	if index == _correct_index:
		feedback_label.text = "Correct!"
		Global.solve_puzzle(_puzzle_id)
		await get_tree().create_timer(1.0).timeout
		_close()
	else:
		feedback_label.text = "Not quite - try again."


func _close() -> void:
	_active = false
	panel.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if _active and event.is_action_pressed("ui_cancel"):
		_close()
