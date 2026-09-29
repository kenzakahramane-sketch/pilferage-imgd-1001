extends Node

var spawn_point = ""
var simplified_controls = true
var music = true
signal inventory_changed

var inventory: Array[Dictionary] = []       # [{"id":..., "name":..., "texture":...}]
var collected_item_ids: Array[String] = []  # permanently picked up, so items never respawn

signal puzzle_solved(puzzle_id: String)
var solved_puzzles: Array[String] = []       # persists which puzzles are already done


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


# --- Puzzles ---

func is_puzzle_solved(puzzle_id: String) -> bool:
	return solved_puzzles.has(puzzle_id)


# Any puzzle type calls this once solved. Any Gate watching this puzzle_id
# will open automatically.
func solve_puzzle(puzzle_id: String) -> void:
	if puzzle_id == "" or is_puzzle_solved(puzzle_id):
		return
	solved_puzzles.append(puzzle_id)
	puzzle_solved.emit(puzzle_id)
