extends CanvasLayer
# AUTOLOAD item_bar.tscn (the scene, not just the script) as "ItemBarUI" in
# Project Settings > Autoload, so it persists and updates across every scene.

const SLOT_SIZE := 56

var slot_normal := preload("res://assets/images/UI/slot_normal.png")
var slot_hover := preload("res://assets/images/UI/slot_hover.png")
var slot_pressed := preload("res://assets/images/UI/slot_pressed.png")

@onready var slots_container: HBoxContainer = %SlotsContainer


func _ready() -> void:
	Global.inventory_changed.connect(_refresh)
	_refresh()


func _refresh() -> void:
	for child in slots_container.get_children():
		child.queue_free()

	for entry in Global.inventory:
		var slot_button := TextureButton.new()
		slot_button.custom_minimum_size = Vector2(SLOT_SIZE, SLOT_SIZE)
		slot_button.ignore_texture_size = true
		slot_button.stretch_mode = TextureButton.STRETCH_SCALE
		slot_button.texture_normal = slot_normal
		slot_button.texture_hover = slot_hover
		slot_button.texture_pressed = slot_pressed
		slot_button.tooltip_text = entry["name"]
		slot_button.pressed.connect(_on_slot_pressed.bind(entry["id"]))

		var icon := TextureRect.new()
		icon.texture = entry["texture"]
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		icon.set_anchors_preset(Control.PRESET_FULL_RECT)
		icon.offset_left = 10
		icon.offset_top = 10
		icon.offset_right = -10
		icon.offset_bottom = -10
		slot_button.add_child(icon)

		slots_container.add_child(slot_button)


func _on_slot_pressed(item_id: String) -> void:
	# Placeholder: pressing a slot does nothing on its own yet. Whatever
	# system wants to consume an item (an NPC that needs it, a puzzle) should
	# check Global.has_item(item_id) and call Global.use_item(item_id) itself
	# once its own condition is met.
	pass
