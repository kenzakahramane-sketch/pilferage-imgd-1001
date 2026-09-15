extends CharacterBody2D


const ACCELERATION = 6
const JUMP_VELOCITY = -250.0
const MAX_SPEED = 150
@onready var animated_sprite = $AnimatedSprite2D
@onready var hitbox = $CollisionShape2D
@onready var particles = $CPUParticles2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		animated_sprite.play("jumpCool")
		if abs (velocity.x) < 100:
			velocity.y = JUMP_VELOCITY
		else:
			velocity.y = JUMP_VELOCITY + JUMP_VELOCITY * 0.15 * ((abs(velocity.x) / 100))

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
			velocity.x = move_toward(velocity.x, MAX_SPEED, ACCELERATION)
		if velocity.x < 0:
			velocity.x = move_toward(velocity.x, -1 * MAX_SPEED, ACCELERATION)
	move_and_slide()
	if is_on_floor():
		if velocity.x == 0:
			animated_sprite.play("idleCool")
			particles.emitting = false
		else:
			if abs(velocity.x) >= 150:
				animated_sprite.play("sprintCool")
				particles.emitting = true
			else:
				animated_sprite.play("runCool")
				particles.emitting = false
	else:
		if velocity.y > 0:
			animated_sprite.play("fallCool")
			particles.emitting = false
		
		
