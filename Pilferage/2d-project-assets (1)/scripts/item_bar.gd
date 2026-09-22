extends CanvasLayer
# AUTOLOAD item_bar.tscn (the scene, not just the script) as "ItemBarUI" in
# Project Settings > Autoload, so it persists and updates across every scene.

const SLOT_SIZE := 64

@onready var slots_container: HBoxContainer = %SlotsContainer


func _ready() -> void:
	Global.inventory_changed.connect(_refresh)
	_refresh()


func _refresh() -> void:
	for child in slots_container.get_children():
		child.queue_free()

	for entry in Global.inventory:
		var slot := TextureButton.new()
		slot.custom_minimum_size = Vector2(SLOT_SIZE, SLOT_SIZE)
		slot.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		slot.texture_normal = entry["texture"]
		slot.tooltip_text = entry["name"]
		slot.pressed.connect(_on_slot_pressed.bind(entry["id"]))
		slots_container.add_child(slot)


func _on_slot_pressed(item_id: String) -> void:
	# Placeholder: pressing a slot does nothing on its own yet. Whatever
	# system wants to consume an item (an NPC that needs it, a puzzle) should
	# check Global.has_item(item_id) and call Global.use_item(item_id) itself
	# once its own condition is met.
	pass
