extends Node2D
@onready var music_1 = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.music == true:
		music_1.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	SceneTransition.change_scene("res://scenes/final_boss.tscn")
