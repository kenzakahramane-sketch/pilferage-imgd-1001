extends Node2D
@onready var music_1 = $AudioStreamPlayer
@onready var music_2 = $AudioStreamPlayer2
@onready var disappearing_bridge = $"TileMap/Disappearing bridge"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.music == true:
		music_1.play()
	disappearing_bridge.enabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	disappearing_bridge.enabled = false
	if music_1.is_playing():
		var time = music_1.get_playback_position()
		music_1.stop()
		music_2.play(time)
