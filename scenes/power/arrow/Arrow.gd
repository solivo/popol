extends KinematicBody2D

export var speed : = 500

#Flag
var impacting = false
func _ready() -> void:
	$ThrowArrowAudio.play()
	look_at(get_global_mouse_position())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not impacting:
		move_local_x( delta * speed)


func _on_GroundDetector_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("ground"):
		impacting = true
		$ImpactArea.monitoring = true
		$AnimationPlayer.play("arrow_impacting")
		$ImpactAudio.play()


func _on_ImpactArea_body_entered(body: PhysicsBody2D) -> void:
	if body is Warrior:
		body.power_impacted = true
		pass


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
