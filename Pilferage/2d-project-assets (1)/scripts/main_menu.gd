extends Control

# Called when the node enters the scene tree
func _ready():
	# Connect button signals
	$Options/StartGame.pressed.connect(_on_startgame_pressed)
	$Options/Credits.pressed.connect(_on_credits_pressed)
	$Options/Versions.pressed.connect(_on_versions_pressed)
	$Options/Quit.pressed.connect(_on_quit_pressed)

# Start button action
func _on_startgame_pressed():
	# Change to your game scene
	get_tree().change_scene_to_file("res://scenes/brotatoclone.tscn")
	
	
# Credits button action
func _on_credits_pressed():
	# Change to an options scene or open a popup
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
	

# Version History button action
func _on_versions_pressed():
	# Change to an options scene or open a popup
	get_tree().change_scene_to_file("res://scenes/Options.tscn")


# Quit button action
func _on_quit_pressed():
	get_tree().quit()
