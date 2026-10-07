extends Control

# Called when the node enters the scene tree
# NOTE: StartGame/Credits/Versions/Options/Quit signals are wired in
# main_menu.tscn's own [connection] blocks, not here - connecting them again
# in code caused "already connected" errors on every _ready().
func _ready():
	# Only show "Continue" once there's actually a save to continue from.
	$Options/Continue.visible = Global.has_save()
	if Global.music == true:
		AudioManager.play_menu_music()


# Continue button action - loads saved progress and jumps straight back in.
func _on_continue_pressed():
	await AudioManager.fade_out_menu_music()
	if Global.load_game():
		get_tree().change_scene_to_file(Global.current_level_path)
	else:
		get_tree().change_scene_to_file("res://scenes/opening_animation.tscn")


# Start button action - always begins a fresh save.
func _on_startgame_pressed():
	await AudioManager.fade_out_menu_music()
	Global.delete_save()
	Global.reset_state()
	# Play the opening animation first, which transitions into the hub itself
	get_tree().change_scene_to_file("res://scenes/opening_animation.tscn")


# Credits button action
func _on_credits_pressed():
	# Change to an options scene or open a popup
	get_tree().change_scene_to_file("res://scenes/credits.tscn")


# Version History button action
func _on_versions_pressed():
	# Change to an options scene or open a popup
	get_tree().change_scene_to_file("res://scenes/version_history.tscn")


# Quit button action
func _on_quit_pressed():
	get_tree().quit()

# TEMPORARY BUTTON FOR TESTING
func _on_dev_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")


# TEMPORARY BUTTON FOR TESTING - jumps straight to both minigames, no level geometry
func _on_dev_minigames_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/minigame_test.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options.tscn")


# TEMPORARY BUTTON FOR TESTING - jumps straight to level 3
func _on_to_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_3.tscn")


# TEMPORARY BUTTON FOR TESTING - previews the ending cinematic directly
func _on_dev_ending_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ending_animation.tscn")
