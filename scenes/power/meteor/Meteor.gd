extends KinematicBody2D

export var speed : = 280

#Flag
var impacting = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not impacting:
		move_and_slide(Vector2.DOWN * speed)


func _on_GroundDetector_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("ground"):
		impacting = true
		$ImpactArea.monitoring = true
		$AnimationPlayer.play("meteor_impacting")
		$ImpactAudio.play()


func _on_ImpactArea_body_entered(body: PhysicsBody2D) -> void:
	if body is Warrior:
		if not body.power_impacted:
			body.power_impacted = true
