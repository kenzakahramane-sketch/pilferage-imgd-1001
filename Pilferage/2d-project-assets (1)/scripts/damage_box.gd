extends Area2D
class_name HitBox

func _on_body_entered(body: Node2D) -> void:
	if body is Alien:
		owner.hit()
