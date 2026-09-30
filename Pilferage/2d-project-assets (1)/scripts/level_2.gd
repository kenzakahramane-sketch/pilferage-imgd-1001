extends Node2D
@onready var music_1 = $AudioStreamPlayer
@onready var music_2 = $AudioStreamPlayer2
@onready var disappearing_bridge = $"TileMap/Disappearing bridge"
@onready var easy_tiles = $"TileMap/Easy tiles"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.music == true:
		music_1.play()
	disappearing_bridge.enabled = true
	if Global.easy_mode == true:
		easy_tiles.enabled = true
	else:
		easy_tiles.enabled = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	disappearing_bridge.enabled = false
	if music_1.is_playing():
		var time = music_1.get_playback_position()
		music_1.stop()
		music_2.play(time)
