extends Area2D
# Reusable for ANY townsfolk (pig, dog, squirrel, alligator, etc).
# Drag npc.tscn into your hub scene once per character, then just change
# the Inspector fields below - no new script needed per NPC.

@export var npc_name: String = "Townsfolk"
@export var dialogue_lines: Array[String] = ["..."]

## Optional: set this to give the NPC a one-time bonus line + a lore flag
## the first time you talk to them (leave blank if this NPC has no lore).
@export var lore_id_to_unlock: String = ""
@export var one_time_lore_lines: Array[String] = []
@export var lore_title: String = ""       # shown in the Lore Journal
@export var lore_journal_text: String = ""  # shown in the Lore Journal

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
		_start_talking()
		get_viewport().set_input_as_handled()


func _start_talking() -> void:
	interact_hint.visible = false
	var lines: Array[String] = dialogue_lines.duplicate()
	if lore_id_to_unlock != "" and not DialogueManager.has_lore(lore_id_to_unlock) and one_time_lore_lines.size() > 0:
		lines.append_array(one_time_lore_lines)
	DialogueManager.start_dialogue(lines, npc_name, self)


func _on_dialogue_finished() -> void:
	if lore_id_to_unlock != "":
		DialogueManager.unlock_lore(lore_id_to_unlock, lore_title, lore_journal_text)
	if _player_in_range:
		interact_hint.visible = true
