extends Area2D

@onready var shoot_timer = $shootTime

var shots_in_burst = 0
var first_shot = true

const BURST_SIZE = 3
const BURST_DELAY = 0.15
const REST_DELAY = 2.0
const START_DELAY = 2.0

func _ready():
	shoot_timer.wait_time = START_DELAY
	shoot_timer.start()
	
func _physics_process(delta):
	var enemies_in_range = get_overlapping_bodies()
	
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		var target_position = target_enemy.global_position
		
		# Aim slightly behind the cat's current movement
		target_position -= target_enemy.velocity * 0.2
		
		# Don't allow the gun to aim upward
		if target_position.y < global_position.y:
			target_position.y = global_position.y
		
		look_at(target_position)

func shoot():
	const BULLET = preload("res://scenes/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %shootingPoint.global_position
	new_bullet.global_rotation = %shootingPoint.global_rotation
	%shootingPoint.add_child(new_bullet)




func _on_shoot_time_timeout():
	if get_overlapping_bodies().size() > 0:
		if shots_in_burst < BURST_SIZE:
			shoot()
			shots_in_burst += 1
			
			shoot_timer.wait_time = BURST_DELAY
			shoot_timer.start()
		else:
			shots_in_burst = 0
			
			shoot_timer.wait_time = REST_DELAY
			shoot_timer.start()
