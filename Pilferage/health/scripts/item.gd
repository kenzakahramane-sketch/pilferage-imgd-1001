extends Area2D
# Generic pickup item. Duplicate item.tscn once per item and set the
# Inspector fields below - no new script needed per item, per the Sprint 4
# checklist ("make 1 scene/item and change its texture/ID so they are unique").

@export var item_id: String = ""       # must be unique per item across the whole game
@export var item_name: String = "Item"
@export var item_texture: Texture2D

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

	print("[item debug] ", item_name, " ready at global_position=", global_position, " collision_layer=", collision_layer, " collision_mask=", collision_mask, " monitoring=", monitoring)
	var players = get_tree().get_nodes_in_group("player")
	print("[item debug] nodes in 'player' group: ", players)
	for p in players:
		print("[item debug]   -> ", p.name, " at ", p.global_position, " collision_layer=", p.collision_layer)


func _process(_delta: float) -> void:
	for p in get_tree().get_nodes_in_group("player"):
		var d: float = global_position.distance_to(p.global_position)
		if int(Engine.get_frames_drawn()) % 30 == 0:
			print("[item debug] ", item_name, " distance to ", p.name, " = ", d)


func _on_body_entered(body: Node2D) -> void:
	print("[item debug] something entered: ", body.name, " groups: ", body.get_groups())
	if body.is_in_group("player"):
		print("[item debug] player confirmed, adding item: ", item_name)
		Global.add_item(item_id, item_name, item_texture)
		# Deferred: freeing a CollisionObject mid-physics-callback isn't allowed
		call_deferred("queue_free")
