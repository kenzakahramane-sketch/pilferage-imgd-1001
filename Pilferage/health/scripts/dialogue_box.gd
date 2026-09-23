extends CanvasLayer
# AUTOLOAD dialogue_box.tscn (not just this script) as "DialogueBoxUI" in
# Project Settings > Autoload, so it persists across every scene.

@onready var panel: Panel = %DialoguePanel
@onready var speaker_label: Label = %SpeakerName
@onready var text_label: Label = %DialogueText
@onready var portrait: TextureRect = %CharacterPortrait


func _ready() -> void:
	panel.visible = false
	DialogueManager.dialogue_started.connect(_on_started)
	DialogueManager.dialogue_ended.connect(_on_ended)
	DialogueManager.line_shown.connect(_on_line_shown)


func _on_started() -> void:
	panel.visible = true


func _on_ended() -> void:
	panel.visible = false


func _on_line_shown(speaker: String, text: String) -> void:
		speaker_label.text = speaker
		speaker_label.visible = speaker != ""
		text_label.text = text

		portrait.texture = preload("res://assets/images/NPCs/Sq.png")
		portrait.visible = true


func _unhandled_input(event: InputEvent) -> void:
	if DialogueManager.is_active() and event.is_action_pressed("interact"):
		DialogueManager.advance()
		get_viewport().set_input_as_handled()

const PORTRAITS = {
	"NPCName": preload("res://assets/images/NPCs/Sq.png"),
}
