extends Node

@onready var menu_music = $MenuMusic
@onready var hub_music = $HubMusic
@onready var boss_music = $BossMusic
@onready var death_sound = $DeathSound

func _ready():
	if Global.music == true:
		menu_music.play()


func fade_out_menu_music():
	var tween = create_tween()
	tween.tween_property(menu_music, "volume_db", -40.0, 1.5)
	tween.finished.connect(stop_menu_music)


func stop_menu_music():
	menu_music.stop()
	menu_music.volume_db = 0.0


func play_hub_music():
	if not hub_music.playing and Global.music == true:
		hub_music.play()


func fade_out_hub_music():
	var tween = create_tween()
	tween.tween_property(hub_music, "volume_db", -40.0, 1.5)
	tween.finished.connect(stop_hub_music)


func stop_hub_music():
	hub_music.stop()
	hub_music.volume_db = 0.0
	
func play_boss_music():
	if not boss_music.playing:
		if Global.music == true:
			boss_music.play()
		
func play_menu_music():
	if not menu_music.playing:
		if Global.music == true:
			menu_music.play()
func play_death_sound():
	death_sound.play()
