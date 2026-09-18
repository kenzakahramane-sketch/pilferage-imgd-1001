extends CharacterBody2D


const ACCELERATION = 2
const JUMP_VELOCITY = -250.0
const MAX_SPEED = 150
@onready var animated_sprite = $AnimatedSprite2D
@onready var hitbox = $CollisionShape2D
@onready var detect_left = $RayCastLeft
@onready var detect_right = $RayCastRight
func _physics_process(delta: float) -> void:
	# Add the gravity. When moving against a wall, you will fall down slower
	if not is_on_floor():
		if detect_right.is_colliding() and velocity.y > 0 and animated_sprite.flip_h == false or detect_left.is_colliding() and velocity.y > 0 and animated_sprite.flip_h == true:
			velocity += get_gravity() * delta / 20
			if velocity.y > 75:
				velocity.y = 75
		else:
			velocity += get_gravity() * delta

	# Handle jump, jumps higher if you build up speed.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		animated_sprite.play("jumpCool")
		velocity.y = JUMP_VELOCITY + JUMP_VELOCITY * 0.15 * (abs(velocity.x) / 100)

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction > 0:
		animated_sprite.flip_h = false
		hitbox.position.x = 11.25
	if direction < 0:
		animated_sprite.flip_h = true
		hitbox.position.x = 6.75
	if direction:
		if direction * velocity.x >= 0:
			velocity.x += direction * ACCELERATION
		else:
			velocity.x = move_toward(velocity.x, 0, ACCELERATION * 3)
			velocity.x += direction * ACCELERATION
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION * 2)
	if abs(velocity.x) > MAX_SPEED:
		if velocity.x > 0:
			velocity.x = move_toward(velocity.x, MAX_SPEED, ACCELERATION * 1.5)
		if velocity.x < 0:
			velocity.x = move_toward(velocity.x, -1 * MAX_SPEED, ACCELERATION * 1.5)
	move_and_slide()
	# Detects collision for dangerous things.
	
	# Different animations are played based on the current state of your movement.
	if is_on_floor():
		if velocity.x == 0:
			animated_sprite.play("idleCool")
		else:
			if abs(velocity.x) >= MAX_SPEED:
				animated_sprite.play("sprintCool")
			else:
				animated_sprite.play("runCool")
	else:
		if velocity.y > 0:
			animated_sprite.play("fallCool")
	# The push mechanic. Push against a wall to perform a wall push, wall pushes done while pressing jump will become a wall jump.
	if Input.is_action_just_pressed("Push"):
		if detect_right.is_colliding() and animated_sprite.flip_h == false:
			if Input.is_action_pressed("move_up"):
				animated_sprite.play("jumpCool")
				velocity.y = JUMP_VELOCITY
				velocity.x = MAX_SPEED * -1.25
			else:
				velocity.x = MAX_SPEED * -1.75
		else:
			if detect_left.is_colliding() and animated_sprite.flip_h == true:
				if Input.is_action_pressed("move_up"):
					animated_sprite.play("jumpCool")
					velocity.y = JUMP_VELOCITY
					velocity.x = MAX_SPEED * 1.25
				else:
					velocity.x = MAX_SPEED * 1.75
	
		
		
