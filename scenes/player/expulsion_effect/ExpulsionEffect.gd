extends Area2D
var ExpulsionWaves = preload("res://scenes/expulsion_waves/ExpulsionWaves.tscn")

export var EXPULSION_FORCE :int = 5

func _ready() -> void:
#	$AnimationPlayer.play("clicking")
	pass


func _on_ExpulsionEffect_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("cloud"):
		var impulse_vector := (body.global_position - global_position) * EXPULSION_FORCE
		body.apply_impulse(Vector2(), impulse_vector)
		body.create_expulsion_waves(global_position)

func _on_LifeTimer_timeout() -> void:
	queue_free()
