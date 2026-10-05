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
	# Smooth crossfade into the second track instead of a hard cut - see
	# level_1.gd's _on_area_2d_body_entered for the same pattern.
	if music_1.is_playing():
		var time = music_1.get_playback_position()
		music_2.volume_db = -40.0
		music_2.play(time)
		var crossfade := create_tween()
		crossfade.set_parallel(true)
		crossfade.tween_property(music_1, "volume_db", -40.0, 0.5)
		crossfade.tween_property(music_2, "volume_db", 0.0, 0.5)
		await crossfade.finished
		music_1.stop()
