extends Node2D

const MOB_SCENE = preload("res://scenes/mob.tscn")
const STURDY_MOB_SCENE = preload("res://scenes/sturdy_mob.tscn")

var score := 0

func spawn_mob():
	# Sprint 3: occasionally spawn a tougher "Sturdy" enemy instead of a regular one
	var scene_to_spawn = MOB_SCENE
	if randf() < 0.25:
		scene_to_spawn = STURDY_MOB_SCENE

	var new_mob = scene_to_spawn.instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	new_mob.died.connect(_on_mob_died)
	add_child(new_mob)

func _on_mob_died():
	score += 1
	if has_node("%ScoreLabel"):
		%ScoreLabel.text = "Score: %d" % score

func _on_timer_timeout():
	spawn_mob()


func _on_player_health_depleted():
	%gameOver.visible = true
	get_tree().paused = true
