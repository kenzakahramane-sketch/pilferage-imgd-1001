extends CanvasLayer
# AUTOLOAD objective_tracker.tscn (the scene, not just the script) as
# "ObjectiveTrackerUI" in Project Settings > Autoload.
#
# A lightweight quest log instead of a literal minimap - this is a small,
# mostly-linear world (a hub + two levels), so a running objective reads
# better than a map would. It's driven entirely by state that already
# exists (Global + DialogueManager), so adding a new lore beat or puzzle
# just means adding one more entry to STEPS below - no new state to track.

@onready var label: Label = %ObjectiveLabel
@onready var panel: Panel = $Panel

# Root node names of scenes where the tracker should actually show - it's an
# autoload, so without this it would also sit on top of the main menu,
# credits, options, etc. Level1 is deliberately left out: it's a sidescroller
# level, not the hub, and the hub quest text doesn't read correctly over it.
const GAMEPLAY_SCENES: Array[String] = ["Game", "level_2", "level_3"]

# Checked top to bottom - the first step whose "done" check fails is shown.
# "done" runs every refresh, so this list can grow freely.
var steps: Array[Dictionary] = [
	{
		"text": "Find someone in town who might know a story or two.",
		"done": func(): return DialogueManager.has_lore("cape_legend"),
	},
	{
		"text": "Search the sidescroller world for the Captain's Cape.",
		"done": func(): return Global.has_cape(),
	},
	{
		"text": "Someone out there is hiding something. Keep talking to folks.",
		"done": func(): return DialogueManager.has_lore("hidden_secret"),
	},
	{
		"text": "Find someone who's lived here a long, long time.",
		"done": func(): return DialogueManager.has_lore("turtle_wisdom"),
	},
	{
		"text": "There's an old lever somewhere in the eastern woods. Find it.",
		"done": func(): return Global.is_puzzle_solved("level2_lever"),
	},
	{
		"text": "Whatever was behind that gate is yours for the taking.",
		"done": func(): return Global.has_collected("relic_01"),
	},
]


func _ready() -> void:
	Global.inventory_changed.connect(_refresh)
	Global.puzzle_solved.connect(func(_id): _refresh())
	DialogueManager.lore_unlocked.connect(func(_id, _t, _txt): _refresh())
	_refresh()


func _process(_delta: float) -> void:
	var current := get_tree().current_scene
	panel.visible = current != null and GAMEPLAY_SCENES.has(current.name)


func _refresh() -> void:
	for step in steps:
		if not step["done"].call():
			label.text = "Objective: " + step["text"]
			return
	label.text = "Objective: You've uncovered everything... for now."
