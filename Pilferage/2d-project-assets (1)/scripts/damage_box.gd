extends Area2D
class_name HitBox
@onready var hurt_timer = $"../Hurt Timer"
var hurt = false
func _on_body_entered(body: Node2D) -> void:
	if body is Alien:
		hurt = true


func _on_body_exited(body: Node2D) -> void:
	if body is Alien:
		hurt = false
func _physics_process(delta: float) -> void:
	if hurt == true and hurt_timer.is_stopped():
		hurt_timer.start()
		owner.hit()
