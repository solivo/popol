extends RigidBody2D

class_name Cloud

var wind_direction = Vector2(-1,0)
export var WATER_AMOUNT := 5
var water_left 
var near_clouds = 0 setget change_near_clouds

signal rained

#Flags
var over_surface = false setget change_over_surface #Is true if the cloud is over the cloud border

func _ready() -> void:
	water_left = WATER_AMOUNT

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	#Wind direction
	apply_central_impulse(wind_direction)

func change_over_surface(value):
	over_surface = value
	if value and near_clouds >= 2:
		start_rain()
	else:
		stop_rain()

func change_near_clouds(value):
	near_clouds = value
	if near_clouds >= 2 and over_surface:
		start_rain()

func _on_WaterDurationTimer_timeout() -> void:
	if water_left > 0:
		emit_signal("rained")
		water_left -= 1
		if water_left < 2:
			#Change sprite
			$AnimatedSprite.play("normal_cloud")
	else:
		$AnimatedSprite.play("empty_cloud")
		$CPUParticles2D.emitting = false

#Delete the node
func _on_AnimatedSprite_animation_finished() -> void:
	if $AnimatedSprite.animation == "empty_cloud":
		queue_free()


func _on_CloudsDetection_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("cloud"):
		self.near_clouds += 1


func _on_CloudsDetection_body_exited(body: PhysicsBody2D) -> void:
	if body.is_in_group("cloud"):
		self.near_clouds -= 1


func start_rain():
	$WaterDurationTimer.start()
	$CPUParticles2D.emitting = true

func stop_rain():
	$WaterDurationTimer.stop()
	$CPUParticles2D.emitting = false


func _on_PlantsDetection_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("corn_plant"):
		connect("rained", body, "add_water")


func _on_PlantsDetection_body_exited(body: PhysicsBody2D) -> void:
	if body.is_in_group("corn_plant"):
		disconnect("rained", body, "add_water")
