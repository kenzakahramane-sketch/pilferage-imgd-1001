extends Area2D
class_name HitBox
@onready var hurt_timer = $"../Hurt Timer"
var touching_alien = false
func _on_body_entered(body: Node2D) -> void:
	if body is Alien:
		touching_alien = true


func _on_body_exited(body: Node2D) -> void:
	if body is Alien:
		touching_alien = false
		
func _physics_process(delta: float) -> void:
	if touching_alien == true and hurt_timer.is_stopped():
		hurt_timer.start()
		owner.hit()
