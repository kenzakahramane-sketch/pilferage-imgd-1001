extends Node2D

const MOB_SCENE = preload("res://scenes/mob.tscn")
const STURDY_MOB_SCENE = preload("res://scenes/sturdy_mob.tscn")

var score := 0

func _ready():
	if Global.spawn_point == "forest":
		call_deferred("_spawn_at_forest")

func _spawn_at_forest():
	print("SPAWNING AT FOREST")
	print($Spawns/forest.global_position)
	$hubCat.global_position = $Spawns/forest.global_position
	Global.spawn_point = ""
