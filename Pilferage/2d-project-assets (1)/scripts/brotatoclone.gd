extends Node2D
class_name HubCat

const MOB_SCENE = preload("res://scenes/mob.tscn")
const STURDY_MOB_SCENE = preload("res://scenes/sturdy_mob.tscn")

@onready var music = $Music

var score := 0

func _ready():
	Global.on_grass = true
	AudioManager.play_hub_music()
	print("HUB READY - spawn point: ", Global.spawn_point)

	# The hub had no music at all before this - everywhere else in the game
	# respects the music setting, so this should too.
	if Global.music == true:
		music.play()

	if Global.spawn_point == "forest":
		print("MOVING TO FOREST")
		$hubCat.global_position = $Spawns/forest.global_position
		Global.spawn_point = ""

	if Global.spawn_point == "barExitSpawn" :
		$hubCat.global_position = $Spawns/barExitSpawn.global_position
		Global.spawn_point = ""
		
func _spawn_at_forest():
	print("SPAWNING AT FOREST")
	print($Spawns/forest.global_position)
	$hubCat.global_position = $Spawns/forest.global_position
	Global.spawn_point = ""


func _on_bar_door_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") :
		SceneTransition.change_scene("res://scenes/interiors.tscn")
