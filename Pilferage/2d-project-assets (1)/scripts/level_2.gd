extends Node2D
@onready var music_1 = $AudioStreamPlayer
@onready var music_2 = $AudioStreamPlayer2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.music == true:
		music_1.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
