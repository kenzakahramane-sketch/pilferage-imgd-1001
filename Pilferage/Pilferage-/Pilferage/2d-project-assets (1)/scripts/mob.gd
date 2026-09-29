extends CharacterBody2D

signal died

@export var health := 3
@export var speed := 300.0

@onready var player  = get_node("/root/Game/Player")


func ready():
	%Slime.play_walk()

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()


func take_damage():
	health -= 1
	%Slime.play_hurt()
	
	if health <= 0:
		died.emit()
		queue_free()

		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
