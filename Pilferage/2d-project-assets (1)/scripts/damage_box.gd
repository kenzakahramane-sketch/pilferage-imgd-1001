extends Area2D
class_name HitBox
var hurt = false
@onready var hurt_timer = $"../Hurt Timer"
func _on_body_entered(body: Node2D) -> void:
	if body is Alien:
		hurt = true
	if body is Laser: 
		hurt = true
func _on_body_exited(body: Node2D) -> void:
	if body is Alien:
		hurt = false
	if body is Laser:
		hurt = false
func _process(delta: float) -> void:
	if hurt == true and hurt_timer.is_stopped():
		hurt_timer.start()
		owner.hit()
