extends CharacterBody2D
var wall_cling = 0
const ACCELERATION = 2
const JUMP_VELOCITY = -250.0
const MAX_SPEED = 150
@onready var animated_sprite = $AnimatedSprite2D
@onready var hitbox = $CollisionShape2D
@onready var detect_left = $RayCastLeft
@onready var detect_right = $RayCastRight
@onready var detect_down = $RayCastDown
@onready var audio_grass = $"Grass sound effect"
@onready var coyote_timer = $"Coyote timer"
@onready var jump_buffer_timer = $"Jump buffer timer"
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
	if velocity.y >= 0 and ((!jump_buffer_timer.is_stopped() and is_on_floor()) or Input.is_action_just_pressed("jump")) and (is_on_floor() or !coyote_timer.is_stopped()):
		animated_sprite.play("jumpCool")
		velocity.y = JUMP_VELOCITY + JUMP_VELOCITY * 0.15 * (abs(velocity.x) / 100)
		

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
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
	var was_on_floor = is_on_floor()
	move_and_slide()
	#jump buffer and coyote time so input timing is less strict
	if Input.is_action_just_pressed("jump") and !is_on_floor():
		jump_buffer_timer.start()
	if was_on_floor && !is_on_floor():
		coyote_timer.start()
	# Detects collision for things.
	# Different animations are played based on the current state of your movement.
	if is_on_floor() || !coyote_timer.is_stopped():
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
	if detect_left.is_colliding():
		wall_cling = 50
	else:
		if detect_right.is_colliding():
			wall_cling = -50
		else:
			wall_cling = 0
	if velocity.x > 0 + wall_cling:
		animated_sprite.flip_h = false
		hitbox.position.x = 11.25
		detect_down.position.x = 11.25
	if velocity.x < 0 + wall_cling:
		animated_sprite.flip_h = true
		hitbox.position.x = 6.75
		detect_down.position.x = 6.75
