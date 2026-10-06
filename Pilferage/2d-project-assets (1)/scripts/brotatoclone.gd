extends Node2D

const MOB_SCENE = preload("res://scenes/mob.tscn")
const STURDY_MOB_SCENE = preload("res://scenes/sturdy_mob.tscn")

var score := 0

func _ready():
	AudioManager.play_hub_music()
	print("HUB READY - spawn point: ", Global.spawn_point)

	if Global.spawn_point == "forest":
		print("MOVING TO FOREST")
		$hubCat.global_position = $Spawns/forest.global_position
		Global.spawn_point = ""

func _spawn_at_forest():
	print("SPAWNING AT FOREST")
	print($Spawns/forest.global_position)
	$hubCat.global_position = $Spawns/forest.global_position
	Global.spawn_point = ""
