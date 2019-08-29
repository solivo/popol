extends StaticBody2D

func _ready() -> void:
	randomize()



func _on_RainArea_body_entered(body: PhysicsBody2D) -> void:
	if body is Cloud:
		#Start rain
		body.over_surface = true

func _on_RainArea_body_exited(body: PhysicsBody2D) -> void:
	if body is Cloud:
		#Cancel rain
		body.over_surface = false
