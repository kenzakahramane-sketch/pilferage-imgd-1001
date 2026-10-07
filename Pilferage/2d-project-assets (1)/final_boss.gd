extends CharacterBody2D

var boss_health = 3

@onready var boss_sprite = $BossSprite
@onready var head_hitbox = $HeadHitbox
@onready var ghost_sprite = $Ghost
@onready var death_sound = $DeathSound
@onready var boss_music = $BossMusic
var knockback_strength = 600.0

func _ready():
	AudioManager.menu_music.stop()
	AudioManager.hub_music.stop()
	if Global.music == true:
		boss_music.play()

	print("Starting boss health: ", boss_health)
	head_hitbox.body_entered.connect(_on_head_hitbox_body_entered)
	print("Starting boss health: ", boss_health)
	head_hitbox.body_entered.connect(_on_head_hitbox_body_entered)


func _on_head_hitbox_body_entered(body):
	print("Detected body: ", body.name)

	if body.name == "cat" and boss_health > 0:
		boss_health -= 1
		print("Boss health: ", boss_health)

		var direction = sign(body.global_position.x - global_position.x)

		body.velocity = Vector2(
			direction * knockback_strength,
			-150
		)

		if boss_health <= 0:
			on_death()

func on_death():
	boss_health = 0
	
	boss_sprite.visible = false
	
	ghost_sprite.visible = true
	ghost_sprite.modulate.a = 1.0
	
	death_sound.play()
	
	var music_tween = create_tween()
	music_tween.tween_property(boss_music, "volume_db", -40.0, 2.0)
	
	var ghost_tween = create_tween()
	ghost_tween.tween_property(ghost_sprite, "modulate:a", 0.0, 2.0)
	
	# Let the guns fire for a tiny bit after death
	await get_tree().create_timer(0.5).timeout
	
	$BlasterL.set_physics_process(false)
	$BlasterR.set_physics_process(false)
	
	for y in range(-8, -5):
		$"../Environment".erase_cell(0, Vector2i(4, y))
		$"../Environment".erase_cell(0, Vector2i(8, y))
	
	await death_sound.finished
	queue_free()
	
	
	
