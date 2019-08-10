extends StaticBody2D

func _ready() -> void:
	randomize()



func _on_RainArea_body_entered(body: PhysicsBody2D) -> void:
	if body is Cloud:
		#var expulsion_vector = (Vector2(0, body.global_position.y - 1))*(-1.5)
		#body.apply_impulse(Vector2(), expulsion_vector)
		#Start rain
		body.over_surface = true

func _on_RainArea_body_exited(body: PhysicsBody2D) -> void:
	if body is Cloud:
		#Cancel rain
		body.over_surface = false
