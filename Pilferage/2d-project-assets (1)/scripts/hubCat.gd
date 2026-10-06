extends CharacterBody2D

var health = 100.0

@onready var animated_sprite = $AnimatedSprite2D2
@onready var walk_sound = $Walking


func _ready():
	$AnimatedSprite2D.visible = false
	$AnimatedSprite2D2.visible = true
	walk_sound.play()


func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	var speed = 120

	if Input.is_action_pressed("hubSprint"):
		speed = 160

	velocity = direction * speed

	if velocity.length() > 0:

		# WALKING SOUND
		if not walk_sound.playing:
			walk_sound.play()

		if Input.is_action_pressed("hubSprint"):
			walk_sound.pitch_scale = 1.4
		else:
			walk_sound.pitch_scale = 1.0


		# ANIMATION
		if velocity.y < 0:
			animated_sprite.play("backCool")
			animated_sprite.frame = 0
			animated_sprite.stop()

		elif velocity.y > 0:
			animated_sprite.play("frontCool")
			animated_sprite.frame = 0
			animated_sprite.stop()

		elif Input.is_action_pressed("hubSprint"):
			animated_sprite.play("sprintCool")

		else:
			animated_sprite.play("runCool")


		# LEFT / RIGHT
		if velocity.x > 0:
			animated_sprite.flip_h = false
		elif velocity.x < 0:
			animated_sprite.flip_h = true

	else:
		walk_sound.pitch_scale = 1.0
		walk_sound.stop()
		animated_sprite.play("idleCool")

	# MOVE THE PLAYER
	move_and_slide()
