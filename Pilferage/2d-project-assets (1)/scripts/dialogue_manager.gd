extends Node
# AUTOLOAD this script as "DialogueManager" in Project Settings > Autoload.
# Handles both dialogue lines AND lore-unlock flags, since they share the
# same trigger (finishing a conversation with an NPC).

signal dialogue_started
signal dialogue_ended
signal line_shown(speaker: String, text: String, portrait: Texture2D)
signal lore_unlocked(lore_id: String, title: String, text: String)

var lore_flags: Dictionary = {}    # e.g. {"scoobaloo_cape": true}
var lore_entries: Dictionary = {}  # e.g. {"scoobaloo_cape": {"title": "...", "text": "..."}}

var _lines: Array[String] = []
var _line_portraits: Array = []       # optional, parallel to _lines - per-line expression override
var _default_portrait: Texture2D = null
var _index: int = 0
var _speaker: String = ""
var _active: bool = false
var _current_npc = null


func is_active() -> bool:
	return _active


# lines: the dialogue lines to show, in order
# speaker: name shown above the dialogue box (can be "")
# npc: optional reference to the NPC node, so it gets notified when done
# default_portrait: shown for every line unless overridden below (optional)
# line_portraits: same length as lines - a specific expression per line
#   (leave an entry null to fall back to default_portrait for that line)
func start_dialogue(lines: Array[String], speaker: String = "", npc = null, default_portrait: Texture2D = null, line_portraits: Array = []) -> void:
	if _active or lines.is_empty():
		return
	_lines = lines.duplicate()
	_line_portraits = line_portraits.duplicate()
	_default_portrait = default_portrait
	_index = 0
	_speaker = speaker
	_current_npc = npc
	_active = true
	dialogue_started.emit()
	_show_current_line()


# Call this when the interact key is pressed while dialogue is active
func advance() -> void:
	if not _active:
		return
	_index += 1
	_show_current_line()


func _show_current_line() -> void:
	if _index >= _lines.size():
		_end_dialogue()
		return
	var line: String = _lines[_index]
	var portrait: Texture2D = _default_portrait
	if _index < _line_portraits.size() and _line_portraits[_index] != null:
		portrait = _line_portraits[_index]
	line_shown.emit(_speaker, line, portrait)


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
