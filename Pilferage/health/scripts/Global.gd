extends Node

var spawn_point = ""
var simplified_controls = true
var music = true
signal inventory_changed

var inventory: Array[Dictionary] = []       # [{"id":..., "name":..., "texture":...}]
var collected_item_ids: Array[String] = []  # permanently picked up, so items never respawn


func has_collected(item_id: String) -> bool:
	return collected_item_ids.has(item_id)


func has_item(item_id: String) -> bool:
	for entry in inventory:
		if entry["id"] == item_id:
			return true
	return false


# Called by an item's pickup script when the player touches it
func add_item(item_id: String, item_name: String, texture: Texture2D) -> void:
	if item_id == "" or has_collected(item_id):
		return
	collected_item_ids.append(item_id)
	inventory.append({"id": item_id, "name": item_name, "texture": texture})
	inventory_changed.emit()


# Call this when an item actually gets used (e.g. given to an NPC, used in a
# puzzle). Returns true if the item was found and removed.
func use_item(item_id: String) -> bool:
	for i in inventory.size():
		if inventory[i]["id"] == item_id:
			inventory.remove_at(i)
			inventory_changed.emit()
			return true
	return false
