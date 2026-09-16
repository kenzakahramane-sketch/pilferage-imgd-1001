extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -250.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
<<<<<<< Updated upstream
=======
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
	# The push mechanic
	if Input.is_action_just_pressed("Push"):
		if detect_right.is_colliding():
			if Input.is_action_pressed("move_up"):
				print("push")
				animated_sprite.play("pushCool") #Changed this from jump to push but it doesn't play
				velocity.y = JUMP_VELOCITY
				velocity.x = MAX_SPEED * -1.25
			else:
				velocity.x = MAX_SPEED * -1.75
		else:
			if detect_left.is_colliding():
				if Input.is_action_pressed("move_up"):
					animated_sprite.play("pushCool") #Changed this from jump to push but it doesn't play 
					velocity.y = JUMP_VELOCITY
					velocity.x = MAX_SPEED * 1.25
				else:
					velocity.x = MAX_SPEED * 1.75
	
		
		
>>>>>>> Stashed changes
