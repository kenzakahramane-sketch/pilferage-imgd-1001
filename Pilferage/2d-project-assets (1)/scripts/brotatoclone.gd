extends Node2D

const MOB_SCENE = preload("res://scenes/mob.tscn")
const STURDY_MOB_SCENE = preload("res://scenes/sturdy_mob.tscn")

var score := 0

func _on_player_health_depleted():
	%gameOver.visible = true
	get_tree().paused = true

func _ready():
	print("[hub debug] spawn_point=", Global.spawn_point, " hubCat starts at ", $hubCat.global_position, " go_to_level_1 trigger at ", $go_to_level_1.global_position)
	if Global.spawn_point == "forest":
		call_deferred("_spawn_at_forest")

func _spawn_at_forest():
	print("SPAWNING AT FOREST")
	print($Spawns/forest.global_position)
	$hubCat.global_position = $Spawns/forest.global_position
	Global.spawn_point = ""
	print("[hub debug] repositioned hubCat to forest spawn: ", $hubCat.global_position)
