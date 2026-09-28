extends CharacterBody2D
class_name Alien

@onready var wall_detect_ray: RayCast2D = $wallDetectRay
@onready var ledge_ray: RayCast2D = $ledgeDetectRay
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var cat: Node2D
const GRAVITY = 300.0
var speed = 30.0
var sees_Cat = false
var direction = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cat = get_tree().get_first_node_in_group("cat") as Node2D

func _physics_process(delta: float) -> void:
	_movement(delta)
	move_and_slide()
	
func _movement(delta) -> void:
	speed = 30
	if sees_Cat : # Go toward the cat if in range
		if cat.global_position.x > global_position.x:
			velocity.x = speed
			sprite.flip_h = true
		else :
			velocity.x = speed * -1
			sprite.flip_h = false
		if not ledge_ray.is_colliding() : #stop it from falling
			speed = 0
	else : # Normal Back and Forth Movement
		_update_direction()
		velocity.x = speed * direction
		_update_sprite()
	velocity.y += GRAVITY * delta
	
	
func _update_sprite():
	if direction == 1:
		sprite.flip_h = true
	else :
		sprite.flip_h = false

func _update_direction() -> void:
	if not wall_detect_ray.is_colliding() and ledge_ray.is_colliding():
		return
	
	print("Turn")
	direction *= -1
	# Flip wall ray
	var wall_direction_ray_pos : Vector2 = Vector2( #change vector direction
		wall_detect_ray.target_position.x * -1,
		wall_detect_ray.target_position.y
	) 
	wall_detect_ray.target_position = wall_direction_ray_pos
	# Change/Flip ledge ray pos
	var ledge_ray_pos : Vector2 = Vector2( #updates vector direction if ledge detected (no ground detected)
		ledge_ray.position.x * -1, 
		ledge_ray.position.y
	)
	ledge_ray.position = ledge_ray_pos

func _on_sight_entered(body: Node2D) -> void:
	if body == cat :
		sees_Cat = true

func _on_sight_exited(body: Node2D) -> void:
	if body == cat:
		sees_Cat = false
