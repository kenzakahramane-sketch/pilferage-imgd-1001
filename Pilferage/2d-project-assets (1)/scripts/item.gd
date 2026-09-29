extends Area2D
# Generic pickup item. Duplicate item.tscn once per item and set the
# Inspector fields below - no new script needed per item, per the Sprint 4
# checklist ("make 1 scene/item and change its texture/ID so they are unique").

@export var item_id: String = ""       # must be unique per item across the whole game
@export var item_name: String = "Item"
@export var item_texture: Texture2D

## Optional: makes picking this item up grant a Lore Journal entry, same idea
## as the lore fields on npc.gd. Leave blank if this item is just an item.
@export var lore_id_to_unlock: String = ""
@export var lore_title: String = ""
@export var lore_journal_text: String = ""

@onready var sprite: Sprite2D = %ItemSprite


func _ready() -> void:
	if item_id == "":
		push_warning("Item at %s is missing an item_id - it won't persist correctly." % str(get_path()))

	# If this item was already picked up before (e.g. player left the level
	# and came back), don't let it spawn in again.
	if Global.has_collected(item_id):
		queue_free()
		return

	if item_texture:
		sprite.texture = item_texture

	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.add_item(item_id, item_name, item_texture)
		if lore_id_to_unlock != "":
			DialogueManager.unlock_lore(lore_id_to_unlock, lore_title, lore_journal_text)
		# Deferred: freeing a CollisionObject mid-physics-callback isn't allowed
		call_deferred("queue_free")
