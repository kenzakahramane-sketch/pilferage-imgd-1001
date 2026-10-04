extends Node

var lives = 9
#@onready var deathNoise = $deathNoise
var spawn_point = ""
var simplified_controls = true
var music = true
var easy_mode = false
signal inventory_changed

var inventory: Array[Dictionary] = []       # [{"id":..., "name":..., "texture":...}]
var collected_item_ids: Array[String] = []  # permanently picked up, so items never respawn

signal puzzle_solved(puzzle_id: String)
var solved_puzzles: Array[String] = []       # persists which puzzles are already done

# Item ids that should make the cat visually wear the cape (see cat.gd).
# Both the real Level 2 cape and the hub test copy count, so testing works.
const CAPE_ITEM_IDS: Array[String] = ["cape_01", "cape_hub_test"]

# --- Save / load ---
# Add a line here whenever a new pickup item scene is made, so a save file
# can rebuild the inventory bar's art without re-touching every item scene.
const ITEM_TEXTURE_PATHS := {
	"flower_01": "res://assets/images/Items/flower.png",
	"mushroom_01": "res://assets/images/Items/mushroom.png",
	"carrot_01": "res://assets/images/Items/carrot.png",
	"cape_01": "res://assets/images/Items/cape.png",
	"cape_hub_test": "res://assets/images/Items/cape.png",
	"relic_01": "res://assets/images/Items/relic.png",
}
const ITEM_NAMES := {
	"flower_01": "Flower",
	"mushroom_01": "Mushroom",
	"carrot_01": "Carrot",
	"cape_01": "Captain's Cape",
	"cape_hub_test": "Captain's Cape",
	"relic_01": "Sealed Relic",
}

const SAVE_PATH := "user://savegame.json"

# Which scene "Continue" should jump back into. Scene-transition scripts
# (go_to_level_1.gd, go_to_level_2.gd, go_to_level_3.gd, return_to_hubworld.gd)
# update this right before changing scenes.
var current_level_path: String = "res://scenes/brotatoclone.tscn"


func has_collected(item_id: String) -> bool:
	return collected_item_ids.has(item_id)


func has_item(item_id: String) -> bool:
	for entry in inventory:
		if entry["id"] == item_id:
			return true
	return false


func has_cape() -> bool:
	for id in CAPE_ITEM_IDS:
		if has_collected(id):
			return true
	return false


# Called by an item's pickup script when the player touches it
func add_item(item_id: String, item_name: String, texture: Texture2D) -> void:
	if item_id == "" or has_collected(item_id):
		return
	collected_item_ids.append(item_id)
	inventory.append({"id": item_id, "name": item_name, "texture": texture})
	inventory_changed.emit()
	save_game()


# Call this when an item actually gets used (e.g. given to an NPC, used in a
# puzzle). Returns true if the item was found and removed.
func use_item(item_id: String) -> bool:
	for i in inventory.size():
		if inventory[i]["id"] == item_id:
			inventory.remove_at(i)
			inventory_changed.emit()
			save_game()
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
	save_game()


# --- Save / load ---

func save_game() -> void:
	var data := {
	"collected_item_ids": collected_item_ids,
	"solved_puzzles": solved_puzzles,
	"lore_flags": DialogueManager.lore_flags,
	"lore_entries": DialogueManager.lore_entries,
	"current_level_path": current_level_path,
	"spawn_point": spawn_point,
	"lives": lives,
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)


# Returns true if a save was actually found and loaded.
func load_game() -> bool:
	
	if not has_save():
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return false
	var text := file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		return false
		

	collected_item_ids = []
	inventory = []
	for id in parsed.get("collected_item_ids", []):
		collected_item_ids.append(id)
		if ITEM_TEXTURE_PATHS.has(id):
			inventory.append({
				"id": id,
				"name": ITEM_NAMES.get(id, id),
				"texture": load(ITEM_TEXTURE_PATHS[id]),
			})
	inventory_changed.emit()

	solved_puzzles = []
	for pid in parsed.get("solved_puzzles", []):
		solved_puzzles.append(pid)

	DialogueManager.lore_flags = parsed.get("lore_flags", {})
	DialogueManager.lore_entries = parsed.get("lore_entries", {})

	lives = parsed.get("lives", 9)
	current_level_path = parsed.get("current_level_path", "res://scenes/brotatoclone.tscn")
	spawn_point = parsed.get("spawn_point", "")
	return true


func delete_save() -> void:
	if has_save():
		DirAccess.remove_absolute(SAVE_PATH)


# Wipes in-memory progress so a "New Game" doesn't carry over a previous
# playthrough's items/lore/puzzles (the autoloads otherwise stay alive for
# the whole time the game is open).
func reset_state() -> void:
	inventory = []
	collected_item_ids = []
	solved_puzzles = []
	spawn_point = ""
	current_level_path = "res://scenes/brotatoclone.tscn"
	lives = 9
	DialogueManager.lore_flags = {}
	DialogueManager.lore_entries = {}
	inventory_changed.emit()
#func play_death_sound():
	#$deathNoise.play()

func _input(Exit):
	if Exit.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
