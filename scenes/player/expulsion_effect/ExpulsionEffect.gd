extends Area2D

export var EXPULSION_FORCE :int = 5

func _ready() -> void:
	$AnimationPlayer.play("clicking")


func _on_ExpulsionEffect_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("cloud"):
		var impulse_vector := (body.global_position - global_position) * EXPULSION_FORCE
		body.apply_impulse(Vector2(), impulse_vector)
