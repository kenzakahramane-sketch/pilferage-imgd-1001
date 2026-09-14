extends CanvasLayer
# AUTOLOAD lore_journal.tscn (the scene, not just the script) as
# "LoreJournalUI" in Project Settings > Autoload.
# Press the "journal" input action to open/close it.

@onready var panel: Panel = %JournalPanel
@onready var entries_container: VBoxContainer = %EntriesContainer
@onready var empty_label: Label = %EmptyLabel


func _ready() -> void:
	panel.visible = false
	DialogueManager.lore_unlocked.connect(_on_lore_unlocked)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("journal") and not DialogueManager.is_active():
		panel.visible = not panel.visible
		if panel.visible:
			_refresh()
		get_viewport().set_input_as_handled()


func _on_lore_unlocked(_lore_id: String, _title: String, _text: String) -> void:
	if panel.visible:
		_refresh()


func _refresh() -> void:
	for child in entries_container.get_children():
		child.queue_free()

	var entries: Dictionary = DialogueManager.lore_entries
	empty_label.visible = entries.is_empty()

	for lore_id in entries.keys():
		var entry: Dictionary = entries[lore_id]
		var title: String = entry.get("title", "")
		var text: String = entry.get("text", "")
		if title == "" and text == "":
			continue

		var title_label := Label.new()
		title_label.text = title if title != "" else lore_id
		title_label.add_theme_font_size_override("font_size", 22)
		entries_container.add_child(title_label)

		if text != "":
			var text_label := Label.new()
			text_label.text = text
			text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			text_label.add_theme_font_size_override("font_size", 16)
			entries_container.add_child(text_label)

		var spacer := Control.new()
		spacer.custom_minimum_size = Vector2(0, 16)
		entries_container.add_child(spacer)
