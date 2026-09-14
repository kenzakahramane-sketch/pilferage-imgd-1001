extends CharacterBody2D


const ACCELERATION = 10
const JUMP_VELOCITY = -250.0
const MAX_SPEED = 150
@onready var animated_sprite = $AnimatedSprite2D
@onready var hitbox = $CollisionShape2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		if abs (velocity.x) < 100:
			velocity.y = JUMP_VELOCITY
		else:
			velocity.y = JUMP_VELOCITY * sqrt((abs(velocity.x) / 100))

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction > 0:
		animated_sprite.flip_h = false
		hitbox.position.x = 11.25
	if direction < 0:
		animated_sprite.flip_h = true
		hitbox.position.x = 6.75
	if direction:
		velocity.x += direction * ACCELERATION
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
	if abs(velocity.x) > MAX_SPEED:
		if velocity.x > 0:
			velocity.x = MAX_SPEED
		if velocity.x < 0:
			velocity.x = -1 * MAX_SPEED
	move_and_slide()
	
		
