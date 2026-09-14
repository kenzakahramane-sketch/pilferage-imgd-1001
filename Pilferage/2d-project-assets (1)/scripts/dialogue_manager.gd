extends Node
# AUTOLOAD this script as "DialogueManager" in Project Settings > Autoload.
# Handles both dialogue lines AND lore-unlock flags, since they share the
# same trigger (finishing a conversation with an NPC).

signal dialogue_started
signal dialogue_ended
signal line_shown(speaker: String, text: String)
signal lore_unlocked(lore_id: String, title: String, text: String)

var lore_flags: Dictionary = {}    # e.g. {"scoobaloo_cape": true}
var lore_entries: Dictionary = {}  # e.g. {"scoobaloo_cape": {"title": "...", "text": "..."}}

var _queue: Array[String] = []
var _speaker: String = ""
var _active: bool = false
var _current_npc = null


func is_active() -> bool:
	return _active


# lines: the dialogue lines to show, in order
# speaker: name shown above the dialogue box (can be "")
# npc: optional reference to the NPC node, so it gets notified when done
func start_dialogue(lines: Array[String], speaker: String = "", npc = null) -> void:
	if _active or lines.is_empty():
		return
	_queue = lines.duplicate()
	_speaker = speaker
	_current_npc = npc
	_active = true
	dialogue_started.emit()
	_show_next_line()


# Call this when the interact key is pressed while dialogue is active
func advance() -> void:
	if not _active:
		return
	_show_next_line()


func _show_next_line() -> void:
	if _queue.is_empty():
		_end_dialogue()
		return
	var line: String = _queue.pop_front()
	line_shown.emit(_speaker, line)


func _end_dialogue() -> void:
	_active = false
	var npc = _current_npc
	_current_npc = null
	dialogue_ended.emit()
	if npc and npc.has_method("_on_dialogue_finished"):
		npc._on_dialogue_finished()


# --- Lore unlocking ---

# title/text are optional - pass them once, the first time a lore_id is
# unlocked, so the Lore Journal has something to display.
func unlock_lore(lore_id: String, title: String = "", text: String = "") -> void:
	if lore_id == "" or lore_flags.get(lore_id, false):
		return
	lore_flags[lore_id] = true
	lore_entries[lore_id] = {"title": title, "text": text}
	lore_unlocked.emit(lore_id, title, text)


func has_lore(lore_id: String) -> bool:
	if lore_id == "":
		return false
	return lore_flags.get(lore_id, false)
