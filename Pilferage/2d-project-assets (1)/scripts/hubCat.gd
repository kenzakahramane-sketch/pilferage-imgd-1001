extends CharacterBody2D

var health = 100.0

@onready var animated_sprite = $AnimatedSprite2D2

func _ready():
	$AnimatedSprite2D.visible = false
	$AnimatedSprite2D2.visible = true

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	var speed = 600

	if Input.is_action_pressed("hubSprint"):
		speed = 1000

	velocity = direction * speed

	if velocity.length() > 0:

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

		if velocity.x > 0:
			animated_sprite.flip_h = false
		elif velocity.x < 0:
			animated_sprite.flip_h = true

	else:
		animated_sprite.play("idleCool")

	move_and_slide()
