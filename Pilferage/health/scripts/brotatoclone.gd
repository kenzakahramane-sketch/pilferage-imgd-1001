extends Node2D

const MOB_SCENE = preload("res://scenes/mob.tscn")
const STURDY_MOB_SCENE = preload("res://scenes/sturdy_mob.tscn")

var score := 0

func _on_player_health_depleted():
	%gameOver.visible = true
	get_tree().paused = true
	
func _ready():
	if Global.spawn_point == "forest":
		$hubCat.global_position = $Spawns/forest.global_position
		Global.spawn_point = ""
