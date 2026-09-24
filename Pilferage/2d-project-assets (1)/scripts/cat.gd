extends CharacterBody2D

class_name Cat

signal healthChanged

var wall_cling = 0
const ACCELERATION = 2.5
const JUMP_VELOCITY = -250.0
const MAX_SPEED = 150
var wall_charge = 0
const wall_charge_time = 45
var isHurt = false

@export var max_health = 25
@onready var current_health = max_health 

@onready var animated_sprite = $AnimatedSprite2D
@onready var hitbox = $movement_box
@onready var detect_left = $RayCastLeft
@onready var detect_right = $RayCastRight
@onready var detect_down = $RayCastDown
@onready var audio_grass = $"Grass sound effect"
@onready var coyote_timer = $"Coyote timer"
@onready var jump_buffer_timer = $"Jump buffer timer"
@onready var push_timer = $"Push Timer"
@onready var hit_flash_ani: AnimationPlayer = $hit_flash_ani


func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("test_key"):
		hit()
	
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
	if wall_charge > wall_charge_time || !push_timer.is_stopped():
			animated_sprite.play("pushCool")
	else:
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
			else:
				if velocity.y < 0:
					animated_sprite.play("jumpCool")
	# The push mechanic. Push against a wall to perform a wall push, wall pushes done while pressing jump will become a wall jump.
	if Input.is_action_just_pressed("Push"):
		push_timer.start()
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
		wall_charge += 1
	else:
		if detect_right.is_colliding():
			wall_cling = -50
			wall_charge += 1
		else:
			wall_cling = 0
			wall_charge = 0
	if velocity.x > 10 + wall_cling:
		animated_sprite.flip_h = false
		hitbox.position.x = 11.25
		detect_down.position.x = 11.25
	if velocity.x < -10 + wall_cling:
		animated_sprite.flip_h = true
		hitbox.position.x = 6.75
		detect_down.position.x = 6.75
	if Global.simplified_controls == true and abs(velocity.x) < 50 and Input.is_action_pressed("move_up") and !is_on_floor() and ((detect_right.is_colliding() and animated_sprite.flip_h == false and direction < 0) or (detect_left.is_colliding() and animated_sprite.flip_h == true and direction > 0)):
			push_timer.start()
			velocity.y = JUMP_VELOCITY
			velocity.x = MAX_SPEED * 1.25 * direction
	if Global.simplified_controls == true and direction and wall_charge > wall_charge_time and abs(velocity.x) < 50:
		push_timer.start()
		if (animated_sprite.flip_h == false and direction < 0) or (animated_sprite.flip_h == true and direction > 0):
			velocity.x = MAX_SPEED * 1.75 * direction



func hit():
	current_health -= 5
	if (current_health <= 0):
		die()
	hit_flash_ani.play("hit_flash")
	isHurt = true
	healthChanged.emit()
	
	
func die():
	get_tree().reload_current_scene()
